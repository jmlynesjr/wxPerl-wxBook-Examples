#! /home/pete/CitrusPerl/perl/bin/perl
#
# AngularMeter.pl
# This script draws a simulated round panel meter.
#
#
# Written in wxPerl. Tested on Citrus Perl 5.16 with wxWidgets 2.8.x.
# Ported by: James M. Lynes. Jr.
# Last Modified Date: January 20, 2013
#
# Adapted from AngularMeter.cpp by Marco Cavallini
# based in part(mostly) on the work of
# the KWIC project (http://www.koansoftware.com/kwic/index.htm).
# Referenced on pg 596 of the "Wx Book" -
# "Cross-Platform GUI Programming with wxWidgets", Smart, Hock, & Csomor
#
# Added limit checking with green/red zones - Normal/Hi-limit
#   could reverse colors to alarm on a low limit if needed.
# Added animation - ***Needle follows left/right mouse movement***
# Added Meter identification label
# Could add mouse click event to capture value at that point
#   and use the meter as an input device.
#
use 5.010;
use strict;
use warnings;
use Wx qw(:everything :allclasses);
use Wx::Event qw( EVT_PAINT EVT_SIZE EVT_MOTION);
use Math::Trig;
#
# Configuration Data ------------------------------------------------------------------
#
my $MeterWidth = 350;					# Define the meter size
my $MeterHeight = $MeterWidth;				# Must be square to look right

my $ScaledVal = 0;
my $RealVal = 0;

my $Tick = 9;						# Number of tic marks
my $Sec = 2;						# Number of sections - green/red

my $RangeStart = 0;					# Define Meter Span - Min
my $RangeEnd = 100;					#                   - Max
my $AlarmLimit = 65;					# Alarm Limit
my $AngleStart = -20;					# East is 0 degrees, + is CCW
my $AngleEnd = 200;

my @SectorColours = (wxGREEN, wxRED);			# Only using two sections
my $BackColour = wxLIGHT_GREY;
my $NeedleColour = wxBLACK;
my $BorderColour = wxBLUE;

my $PI = 4.0*atan(1.0);
my $Font = Wx::Font->new(10, wxFONTFAMILY_SWISS, wxNORMAL, wxNORMAL);
my $DrawCurrent = 1;					# Turn on/off value displayed as text
my $Label = "Process Temperature - degC";		# Label Meter at bottom of display
my $ramp = 25;						# Initial value/needle position
my $lastpos = 0;					# Last mouse position
#
# Main Application -----------------------------------------------------------------------
#
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1, "Simulated Round Panel Meter",
			   wxDefaultPosition, [$MeterWidth, $MeterHeight]);
SetValue($ramp);					# Initial value/needle position
EVT_PAINT( $frame, \&onPaint );
EVT_SIZE( $frame, \&onSize );
EVT_MOTION( $frame, \&onMotion );
$frame->Show;
$app->MainLoop;
#
# Dismiss a size event
#
sub onSize{
    my($self, $event) = @_;
    $event->Skip();
}
sub onMotion {						# Change the setpoint value and redraw
    my($self, $event) = @_;
    my $x = $event->GetPosition->x;			# Current mouse position
    if($x > $lastpos) {$ramp += 1; $lastpos = $x}	# Mouse right, increment needle
    if($x < $lastpos) {$ramp -= 1; $lastpos = $x}	# Mouse left, decrement needle
    if($ramp >= $RangeEnd) {$ramp = $RangeEnd;}		# Clamp to max range
    if($ramp <= $RangeStart) {$ramp = $RangeStart;}	# Clamp to min range
    SetValue($ramp);
    $self->Refresh;
    $self->Update;
}
#
# Paint the simulated LCD Display ----------------------------------------------------------
#
sub onPaint {
    my($self, $event) = @_;
    my $dc = Wx::PaintDC->new($self);
    my( $w, $h) = $dc->GetSizeWH();
    my $memdc = Wx::MemoryDC->new();
    $memdc->SelectObject(Wx::Bitmap->new($MeterWidth, $MeterHeight));
    my $brush = Wx::Brush->new($BackColour, wxSOLID);
    $memdc->SetBackground($brush);
    $memdc->SetBrush($brush);
    $memdc->Clear();
    my $pen = Wx::Pen->new($BorderColour, 2, wxSOLID);
    $memdc->SetPen($pen);
    $memdc->DrawRectangle(0, 0, $w, $h);
    DrawSectors($memdc);
    if($Tick > 0) {DrawTicks($memdc);}
    DrawNeedle($memdc);
    if($DrawCurrent) {					# Display current value as text
        my $valuetext = sprintf("%d", $RealVal);
        my @te = $memdc->GetTextExtent($valuetext);
        my $x = ($w-$te[0])/2;
        $memdc->SetFont($Font);
        $memdc->DrawText($valuetext, $x, ($h/2)+20);
    }
    DrawLabel($memdc);
    $dc->Blit(0, 0, $w, $h, $memdc, 0, 0);
}
sub DrawNeedle {
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $pen = Wx::Pen->new($NeedleColour, 1, wxSOLID);
    $dc->SetPen($pen);
    my $brush = Wx::Brush->new($NeedleColour, wxSOLID);
    $dc->SetBrush($brush);
    my $val = ($ScaledVal + $AngleStart) * $PI/180;
    my $dyi = sin($val-90)*2;
    my $dxi = cos($val-90)*2;
    my @points;
    $points[0] = Wx::Point->new($w/2-$dxi, $h/2-$dyi);
    $dxi = cos($val) * ($h/2-4);
    $dyi = sin($val) * ($h/2-4);
    $points[2] = Wx::Point->new($w/2-$dxi, $h/2-$dyi);
    $dxi = cos($val+90)*2;
    $dyi = sin($val+90)*2;
    $points[4] = Wx::Point->new($w/2-$dxi, $h/2-$dyi);
    $points[5] = $points[0];
    $val = ($ScaledVal + $AngleStart + 1) * $PI/180;
    $dxi = cos($val) * ($h/2-10);
    $dyi = sin($val) * ($h/2-10);
    $points[3] = Wx::Point->new($w/2-$dxi, $h/2-$dyi); 
    $val = ($ScaledVal + $AngleStart - 1) * $PI/180;
    $dxi = cos($val) * ($h/2-10);
    $dyi = sin($val) * ($h/2-10);
    $points[1] = Wx::Point->new($w/2-$dxi, $h/2-$dyi);
    $dc->DrawPolygon(\@points, 0, 0, wxODDEVEN_RULE); 
    $brush = Wx::Brush->new(wxWHITE, wxSOLID);			# Draw white dot at base of needle
    $dc->SetBrush($brush);
    $dc->DrawCircle($w/2, $h/2, 4);  
}
sub DrawSectors {
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $pen = Wx::Pen->new(wxBLACK, 1, wxSOLID);
    $dc->SetPen($pen);
    my $starc = $AngleStart;
    my $endarc = $starc + (($AngleEnd - $AngleStart) * ($AlarmLimit/$RangeEnd));
    my $ctr = 0;
    while($ctr < $Sec) {
          my $brush = Wx::Brush->new($SectorColours[$ctr], wxSOLID);
          $dc->SetBrush($brush);
          $dc->DrawEllipticArc(0, 0, $w, $h, 180-$endarc, 180-$starc);
          $starc = $endarc;
          $endarc = $AngleEnd;
          $ctr++;
    }
    my $val = $AngleStart * $PI / 180;
    my $dx = cos($val) * $h/2;
    my $dy = sin($val) * $h/2;
    $dc->DrawLine($w/2, $h/2, $w/2-$dx, $h/2-$dy);
    $val = $AngleEnd * $PI / 180;
    $dx = cos($val) * $h/2;
    $dy = sin($val) * $h/2;
    $dc->DrawLine($w/2, $h/2, $w/2-$dx, $h/2-$dy);
}
sub DrawTicks {
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $interval = ($AngleEnd - $AngleStart) / ($Tick +1);
    my $valint = $interval + $AngleStart;
    my $ctr = 0;
    while($ctr < $Tick) {
        my $val = $valint * $PI/180;
        my $dx = cos($val) * $h/2;
        my $dy = sin($val) * $h/2;
        my $tx = cos($val) * (($h/2)-10);
        my $ty = sin($val) * (($h/2)-10);
        $dc->DrawLine($w/2-$tx, $h/2-$ty, $w/2-$dx, $h/2-$dy);
        my $DeltaRange = $RangeEnd - $RangeStart;
        my $DeltaAngle = $AngleEnd - $AngleStart;
        my $Coeff = $DeltaAngle / $DeltaRange;
        my $rightval = (($valint - $AngleStart) / $Coeff) + $RangeStart;
        my $string = sprintf("%d", $rightval+.5);
        my($tew, $teh, $dct, $ext) = $dc->GetTextExtent($string);
        $val = ($valint - 4) * $PI/180;
        $tx = cos($val) * (($h/2)-12);
        $ty = sin($val) * (($h/2)-12);
        $dc->SetFont($Font);
        $dc->DrawRotatedText($string, $w/2-$tx, $h/2-$ty, 90-$valint);
        $valint = $valint + $interval;
        $ctr++;
    }
}
sub SetValue {							# Scale the value for display
    my($Value) = @_;
    my $DeltaRange = $RangeEnd - $RangeStart;
    my $RangeZero = $DeltaRange - $RangeStart;
    my $DeltaAngle = $AngleEnd - $AngleStart;
    my $Coeff = $DeltaAngle / $DeltaRange;
    $ScaledVal = ($Value - $RangeStart) * $Coeff;
    $RealVal = $Value;
}
sub DrawLabel {							# Draw a label at bottom of meter
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my @te = $dc->GetTextExtent($Label);
    my $x = ($w-$te[0])/2;
    $dc->DrawText($Label, $x, $h-25);
}
