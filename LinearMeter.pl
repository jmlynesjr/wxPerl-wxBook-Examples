#! /home/pete/CitrusPerl/perl/bin/perl
#
# LinearMeter.pl
# This script draws a simulated linear panel meter.
# Meter can be configured to be verticle or horizontal
#
# Move mouse up/down to change the displayed value on verticle meter
# (or        left/right if reconfigured for horizontal meter)
#
# Written in wxPerl. Tested on Citrus Perl 5.16 with wxWidgets 2.8.x.
# Ported by: James M. Lynes. Jr.
# Last Modified Date: January 21, 2013
#
# Adapted from LinearMeter.cpp by Marco Cavallini
# based in part(mostly) on the work of
# the KWIC project (http://www.koansoftware.com/kwic/index.htm).
# Referenced on pg 596 of the "Wx Book" -
# "Cross-Platform GUI Programming with wxWidgets", Smart, Hock, & Csomor
#
# Added high-limit/alarm processing- red/green color change
# Added animation
# Added label display at bottom of meter
# Set an initial value, high-limit, and tic array
#
#
use 5.010;
use strict;
use warnings;
use Wx qw(:everything :allclasses);
use Wx::Event qw( EVT_PAINT EVT_ERASE_BACKGROUND EVT_MOTION );
#
# Configuration Data ------------------------------------------------------------------
#
my $MeterHeight = 400;					# Swap these for horizontal display
my $MeterWidth = 100;
my $ActiveBar = wxGREEN;
my $PassiveBar = wxWHITE;
my $ValueColour = wxBLACK;
my $BorderColour = wxBLUE;
my $LimitColour = wxBLACK;
my $AlarmLimitColour = wxRED;
my $TagsColour = wxBLACK;

my $ScaledValue = 0;
my $RealVal = 0;
my $Limit = 75;						# High-Limit setpoint
my @TagsVal;
my $TagsNum = 0;
my $StartTag = 0;
my $NumTags = 10;
my $IncTag = 10;
my $Max = 100;						# Span
my $Min = 0;
my $ramp = 45;						# Initial value displayed
my $lastpos = 0;					# Last mouse position

my $DirHorizFlag = 0;					# 0-Verticle, 1-Horizontal
my $ShowCurrent = 1;
my $ShowLimits = 0;
my $ShowLabel = 1;
my $Font = Wx::Font->new(10, wxFONTFAMILY_SWISS, wxNORMAL, wxNORMAL);
my $Label = "Temp degC";
#
# Main Application -----------------------------------------------------------------------
#
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1, "",
			   [600,200], [$MeterWidth, $MeterHeight]);
EVT_PAINT( $frame, \&onPaint );
EVT_ERASE_BACKGROUND( $frame, \&onEraseBackground );
EVT_MOTION( $frame, \&onMotion );
$frame->Show;
$app->MainLoop;
#
# Dismiss an erase background event -----------------------------------------------------
#
sub onEraseBackground {
    my($self, $event) = @_;
    $event->Skip();
}
#
# Paint the simulated LCD Display ----------------------------------------------------------
#
sub onPaint {
    my($self, $event) = @_;
    my $dc = Wx::PaintDC->new($self);
    my $memdc = Wx::MemoryDC->new();
    $memdc->SelectObject(Wx::Bitmap->new($MeterWidth, $MeterHeight));
    my($w, $h) = $memdc->GetSizeWH();
    my $brush = Wx::Brush->new($PassiveBar, wxSOLID);
    $memdc->SetBackground($brush);
    $memdc->Clear();
    SetUp($memdc);						# Set the initial value and tic marks
    my $pen = Wx::Pen->new($BorderColour, 2, wxSOLID);
    $memdc->SetPen($pen);
    $memdc->DrawRectangle(0, 0, $w, $h);
    $pen = Wx::Pen->new($BorderColour, 2, wxSOLID);
    $memdc->SetPen($pen);
    $brush = Wx::Brush->new($ActiveBar, wxSOLID);
    if($RealVal > $Limit) {$brush = Wx::Brush->new($AlarmLimitColour, wxSOLID)}
    $memdc->SetBrush($brush);
    my $yPoint;
    my $rectHeight;
    if($DirHorizFlag) {						# Horizontal Orientation
        $memdc->DrawRectangle(1, 1, $ScaledValue, $h-2);
    }
    else {							# Verticle Orientation
        $yPoint = $h - $ScaledValue;
        if($ScaledValue == 0) {
            $rectHeight = $ScaledValue;
        }
        else {
            if($RealVal == $Max) {
               $rectHeight = $ScaledValue;
               $yPoint -= 1;
            }
            else {
                $rectHeight = $ScaledValue - 1;
            }
        $memdc->DrawRectangle(1, $yPoint, $w-2, $rectHeight);
       }
    }
    if($ShowCurrent) {DrawCurrent($memdc)}
    if($ShowLimits) {DrawLimits($memdc)}
    if($TagsNum > 0) {DrawTags($memdc)}
    if($ShowLabel) {DrawLabel($memdc)}
    $dc->Blit(0, 0, $w, $h, $memdc, 0, 0);
}
sub onMotion {						# Change the setpoint value and redraw
    my($self, $event) = @_;
    my $y = $event->GetPosition->y;			# Current mouse position, swap to (x) for horz
    if($y > $lastpos) {$ramp -= 1; $lastpos = $y}	# Mouse down, decrement needle, swap (x/+=)for horz
    if($y < $lastpos) {$ramp += 1; $lastpos = $y}	# Mouse up, increment needle, swap(x/-=) for horz
    if($ramp >= $Max) {$ramp = $Max;}			# Clamp to max range
    if($ramp <= $Min) {$ramp = $Min;}			# Clamp to min range
    $self->Refresh;
    $self->Update;
}
sub SetUp {						# Set and update the displayed value
    my($dc) = @_;
    SetValue($dc, $ramp);
    if($TagsNum == 0) {					# Build tic marks 1st time through
        for($StartTag..$NumTags) {			# Quick and dirty
            AddTag($_ * $IncTag);
        }
    }
} 
sub DrawCurrent {					# Draw the current value as text
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $valuetext = sprintf("%d", $RealVal);
    my ($tw, $th) = $dc->GetTextExtent($valuetext);
    $dc->SetTextForeground($ValueColour);
    $dc->DrawText($valuetext, $w/2-$tw/2, $h/2-$th/2);    
}
sub DrawLimits {					# Draw Min and Max as text
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    $dc->SetFont($Font);
    $dc->SetTextForeground($LimitColour);
    if($DirHorizFlag) {
        my $valuetext = sprintf("%d", $Min);
        my ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, 5, $h/2-$th/2);
        $valuetext = sprintf("%d", $Max);
        ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, $w-$tw-5, $h/2-$th/2);
    }
    else {
        my $valuetext = sprintf("%d", $Min);
        my ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, $w/2-$tw/2, $h-$th-5);
        $valuetext = sprintf("%d", $Max);
        ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, $w/2-$tw/2, 5);
    }     
}
sub DrawTags {						# Draw tic marks and labels
    my($dc, $Value) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $tcoeff;
    if($DirHorizFlag) {
        $tcoeff = ($w-2)/($Max-$Min);
    }
    else {
        $tcoeff = ($h-2)/($Max-$Min);
    }
    my $pen = Wx::Pen->new($TagsColour, 1, wxSOLID);
    $dc->SetPen($pen);
    my $brush = Wx::Brush->new($TagsColour, wxSOLID);
    $dc->SetBrush($brush);
    $dc->SetTextForeground($TagsColour);
    my $tag = 0;
    while($tag < $TagsNum) {
        my $scalval = ($TagsVal[$tag]-$Min) * $tcoeff;
        my $textvalue = sprintf("%d", $TagsVal[$tag]);
        if($DirHorizFlag) {
            $dc->DrawLine($scalval+1, $h-2, $scalval+1, $h-10);
            my($tw, $th) = $dc->GetTextExtent($textvalue);
            $dc->DrawText($textvalue, $scalval+1-($tw/2), $h-10-$th);
        }
        else {
            $dc->DrawLine($w-2, $h-$scalval+1, $w-10, $h-$scalval);
            my($tw, $th) = $dc->GetTextExtent($textvalue);
            $dc->DrawText($textvalue, $w-10-$tw, $h-$scalval-($th/2));
        }
    $tag++;
    }  
}
sub AddTag {						# Add a tic mark to array
    my($val) = @_;
    push(@TagsVal, $val);
    $TagsNum = @TagsVal;    
}
sub SetValue {						# Scale the value for display
    my($dc, $Value) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $coeff;
    if($DirHorizFlag) {
        $coeff = ($w-2)/($Max-$Min);
    }
    else {
        $coeff = ($h-2)/($Max-$Min);
    }
    $ScaledValue = (($Value-$Min) * $coeff);
    $RealVal = $Value;
}
sub DrawLabel {						# Draw a label at bottom of meter
    my($dc) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my @te = $dc->GetTextExtent($Label);
    my $x = ($w-$te[0])/2;
    $dc->DrawText($Label, $x, $h-20);
}
