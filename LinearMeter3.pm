# LinearMeter3.pm - Linear Meter Object
#
# Last modified by James M. Lynes, Jr - January 30,2013
#
# Creates a Linear Panel Meter
# Can be drawn vertical or horizontal
# Modified LinearMeter.pl into an object that can be used to create multiple meters
# Adapted from LinearMeter.cpp by Marco Cavallini
# based in part(mostly) on the work of
# the KWIC project (http://www.koansoftware.com/kwic/index.htm).
# Referenced on pg 596 of the "Wx Book" -
# "Cross-Platform GUI Programming with wxWidgets", Smart, Hock, & Csomor
#
# Added high-limit/alarm processing- red/green color change
# Added label display between the bottom of the meter and the bottom of the panel
# Set an initial value, high-limit, and tic array
# Added DrawLimitBar to draw a tic mark at the current limit value
# Deleted drawing the 1st and last tags to reduce crowding of the display
# Added a "Selected" flag
# Driver program implements mouse events for limit modification
#   and timer event to drive the animation.
#
# To-Do: Rework meter so that a wider border can be drawn. PANEL(BORDER(METER))
#        Currently the border draws on top of the meter space.

package LinearMeter;
use strict;
use warnings;
use Wx qw(:everything);
use Data::Dumper;
#
# Define the meter object hash ------------------------------------------------
#
sub new {
    my $self                  = {};
    $self->{METERHEIGHT}      = 300;					# Swap these for horizontal display
    $self->{METERWIDTH}       = 100;
    $self->{ACTIVEBAR}        = wxGREEN;
    $self->{PASSIVEBAR}       = wxWHITE;
    $self->{VALUECOLOUR}      = wxBLACK;
    $self->{BORDERCOLOUR}     = wxBLUE;
    $self->{LIMITCOLOUR}      = wxBLACK;
    $self->{ALARMLIMITCOLOUR} = wxRED;
    $self->{TAGSCOLOUR}       = wxBLACK;
    $self->{SCALEDVALUE}      = 0;
    $self->{REALVAL}          = 0;
    $self->{LIMIT}            = 75;					# High-Limit setpoint
    $self->{TAGSVAL}          = [];
    $self->{TAGSNUM}          = 0;
    $self->{STARTTAG}         = 0;
    $self->{NUMTAGS}          = 10;
    $self->{INCTAG}           = 10;
    $self->{MAX}              = 100;					# Span
    $self->{MIN}              = 0;
    $self->{INITIALVALUE}     = 0;					# Initial value displayed
    $self->{LASTPOS}          = 0;					# Last mouse position
    $self->{DIRHORIZFLAG}     = 0;					# 0-Verticle, 1-Horizontal
    $self->{SHOWCURRENT}      = 1;
    $self->{SHOWLIMITS}       = 1;
    $self->{SHOWLABEL}        = 1;
    $self->{FONT}             = Wx::Font->new(8, wxFONTFAMILY_SWISS, wxNORMAL, wxNORMAL);
    $self->{LABEL}            = "";
    $self->{SELECTED}	      = 0;
    bless($self);
    return $self;
}
#
# Draw the Linear Meter ----------------------------------------------------------
#
sub Draw {
    my($class, $panel, $Meter) = @_;
    my $dc = Wx::PaintDC->new($panel);
    my $memdc = Wx::MemoryDC->new();
    $memdc->SelectObject(Wx::Bitmap->new($Meter->MeterWidth(), $Meter->MeterHeight()));
    my($w, $h) = $memdc->GetSizeWH();
    my $brush = Wx::Brush->new($Meter->PassiveBar(), wxSOLID);
    $memdc->SetBackground($brush);
    $memdc->Clear();
    SetUp($memdc, $Meter);						# Set the initial value and tic marks
    my $pen = Wx::Pen->new($Meter->BorderColour(), 3, wxSOLID);
    $memdc->SetPen($pen);
    $memdc->DrawRectangle(0, 0, $w, $h);
    $pen = Wx::Pen->new($Meter->BorderColour(), 3, wxSOLID);
    $memdc->SetPen($pen);
    $brush = Wx::Brush->new($Meter->ActiveBar(), wxSOLID);
    if($Meter->RealVal() > $Meter->Limit()) {$brush = Wx::Brush->new($Meter->AlarmLimitColour(), wxSOLID)}
    $memdc->SetBrush($brush);
    my $yPoint;
    my $rectHeight;
    if($Meter->DirHorizFlag()) {					# Horizontal Orientation
        $memdc->DrawRectangle(1, 1, $Meter->ScaledValue(), $h-2);
    }
    else {								# Verticle Orientation
        $yPoint = $h - $Meter->ScaledValue();
        if($Meter->ScaledValue() == 0) {
            $rectHeight = $Meter->ScaledValue();
        }
        else {
            if($Meter->RealVal() == $Meter->Max()) {
               $rectHeight = $Meter->ScaledValue();
               $yPoint -= 1;
            }
            else {
                $rectHeight = $Meter->ScaledValue() - 1;
            }
        $memdc->DrawRectangle(1, $yPoint, $w-2, $rectHeight);
       }
    }
    if($Meter->ShowCurrent()) {DrawCurrent($memdc, $Meter)}
    if($Meter->ShowLimits()) {DrawLimits($memdc, $Meter)}
    if($Meter->TagsNum() > 0) {DrawTags($memdc, $Meter)}
    $dc->Blit(0, 0, $w, $h, $memdc, 0, 0);			# Keep blit above DrawLabel call
    if($Meter->ShowLabel()) {DrawLabel($dc, $Meter)}		# <----
}
sub SetUp {							# Set and update the displayed value
    my($dc, $Meter) = @_;
    SetValue($dc, $Meter->InitialValue(), $Meter);

    if($Meter->TagsNum() == 0) {				# Build tic marks 1st time through
        for($Meter->StartTag()..$Meter->NumTags()) {		# Quick and dirty
            AddTag($_ * $Meter->IncTag(), $Meter);
        }
    }
} 
sub DrawCurrent {						# Draw the current value as text
    my($dc, $Meter) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $valuetext = sprintf("%d", $Meter->RealVal());
    my ($tw, $th) = $dc->GetTextExtent($valuetext);
    $dc->SetTextForeground($Meter->ValueColour());
    $dc->SetFont($Meter->Font());
    $dc->DrawText($valuetext, $w/2-$tw/2, $h/2-$th/2);    
}
sub DrawLimits {						# Draw Min and Max as text
    my($dc, $Meter) = @_;
    my($w, $h) = $dc->GetSizeWH();
    $dc->SetFont($Meter->Font());
    $dc->SetTextForeground($Meter->LimitColour());
    if($Meter->DirHorizFlag()) {
        my $valuetext = sprintf("%d", $Meter->Min());
        my ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, 5, $h/2-$th/2);
        $valuetext = sprintf("%d", $Meter->Max());
        ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, $w-$tw-5, $h/2-$th/2);
    }
    else {
        my $valuetext = sprintf("%d", $Meter->Min());
        my ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, $w/2-$tw/2, $h-$th-5);
        $valuetext = sprintf("%d", $Meter->Max());
        ($tw, $th) = $dc->GetTextExtent($valuetext);
        $dc->DrawText($valuetext, $w/2-$tw/2, 5);
    }     
}
sub DrawTags {							# Draw tic marks and labels
    my($dc, $Meter) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $tcoeff;
    if($Meter->DirHorizFlag()) {
        $tcoeff = ($w-2)/($Meter->Max()-$Meter->Min());
    }
    else {
        $tcoeff = ($h-2)/($Meter->Max()-$Meter->Min());
    }
    my $pen = Wx::Pen->new($Meter->TagsColour(), 1, wxSOLID);
    $dc->SetPen($pen);
    my $brush = Wx::Brush->new($Meter->TagsColour(), wxSOLID);
    $dc->SetBrush($brush);
    $dc->SetTextForeground($Meter->TagsColour());
    my $tag = 1;
    while($tag < ($Meter->TagsNum()-1)) {
        my $scalval = (${$Meter->TagsVal()}[$tag]-$Meter->Min()) * $tcoeff;
        my $textvalue = sprintf("%d", ${$Meter->TagsVal()}[$tag]);
        if($Meter->DirHorizFlag()) {
            $dc->DrawLine($scalval+1, $h-2, $scalval+1, $h-10);
            my($tw, $th) = $dc->GetTextExtent($textvalue);
            $dc->DrawText($textvalue, $scalval+1-($tw/2), $h-10-$th);
        }
        else {
            $dc->DrawLine($w-2, $h-$scalval-1, $w-10, $h-$scalval-1);
            my($tw, $th) = $dc->GetTextExtent($textvalue);
            $dc->DrawText($textvalue, $w-10-$tw, $h-$scalval-($th/2));
        }
    $tag++;
    }
    DrawLimitBar($dc, $Meter);  
}
sub DrawLimitBar {					# Draw small bar at limit setting
    my($dc, $Meter) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $tcoeff;
    if($Meter->DirHorizFlag()) {
        $tcoeff = ($w-2)/($Meter->Max()-$Meter->Min());
    }
    else {
        $tcoeff = ($h-2)/($Meter->Max()-$Meter->Min());
    }

    my $pen = Wx::Pen->new(Wx::Colour->new("orange"), 3, wxSOLID);
    $dc->SetPen($pen);
    my $brush = Wx::Brush->new($Meter->TagsColour(), wxSOLID);
    $dc->SetBrush($brush);
    $dc->SetTextForeground($Meter->TagsColour());

    my $scalval = ($Meter->Limit()-$Meter->Min()) * $tcoeff;
    if($Meter->DirHorizFlag()) {
        $dc->DrawLine($scalval+1, $h-2, $scalval+1, $h-20);
    }
    else {
        $dc->DrawLine($w-2, $h-$scalval, $w-20, $h-$scalval);
    }  
}
sub AddTag {						# Add a tic mark to array
    my($val, $Meter) = @_;
    push(@{$Meter->TagsVal()}, $val);
    $Meter->TagsNum($#{$Meter->TagsVal()}+1);    
}
sub SetValue {						# Scale the value for display
    my($dc, $Value, $Meter) = @_;
    my($w, $h) = $dc->GetSizeWH();
    my $coeff;
    if($Meter->DirHorizFlag()) {
        $coeff = ($w-2)/($Meter->Max()-$Meter->Min());
    }
    else {
        $coeff = ($h-2)/($Meter->Max()-$Meter->Min());
    }
    $Meter->ScaledValue(($Value-$Meter->Min()) * $coeff);
    $Meter->RealVal($Value);
}
sub DrawLabel {						# Draw a label at bottom of meter
    my($dc, $Meter) = @_;
    my $memdc = Wx::MemoryDC->new();
    $memdc->SelectObject(Wx::Bitmap->new($Meter->MeterWidth(), 40));
    my($w, $h) = $memdc->GetSizeWH();
    my $brush = Wx::Brush->new(wxLIGHT_GREY, wxSOLID);
    $memdc->SetBackground($brush);
    my $pen = Wx::Pen->new($Meter->TagsColour(), 1, wxSOLID);
    $memdc->SetPen($pen);
    $memdc->SetTextForeground($Meter->TagsColour());
    $memdc->SetFont($Meter->Font());
    $memdc->Clear();
    my @te = $memdc->GetTextExtent($Meter->Label());
    my $x = (($w-$te[0])/2)-5;
    $memdc->DrawText($Meter->Label(), $x, 5);
    $dc->Blit(0, $Meter->MeterHeight(), $w, $Meter->MeterHeight()+40,  $memdc, 0, 0);
}
#
# Object Accessors - Hand coded method ---------------------------------------------
# Replace with Class::Accessor in the future
#
sub MeterHeight {
    my $self = shift;
    if(@_) { $self->{METERHEIGHT} = shift }
    return $self->{METERHEIGHT};
}
sub MeterWidth {
    my $self = shift;
    if(@_) { $self->{METERWIDTH} = shift }
    return $self->{METERWIDTH};
}
sub ActiveBar {
    my $self = shift;
    if(@_) { $self->{ACTIVEBAR} = shift }
    return $self->{ACTIVEBAR};
}
sub PassiveBar {
    my $self = shift;
    if(@_) { $self->{PASSIVEBAR} = shift }
    return $self->{PASSIVEBAR};
}
sub ValueColour {
    my $self = shift;
    if(@_) { $self->{VALUECOLOUR} = shift }
    return $self->{VALUECOLOUR};
}
sub BorderColour {
    my $self = shift;
    if(@_) { $self->{BORDERCOLOUR} = shift }
    return $self->{BORDERCOLOUR};
}
sub LimitColour {
    my $self = shift;
    if(@_) { $self->{LIMITCOLOUR} = shift }
    return $self->{LIMITCOLOUR};
}
sub AlarmLimitColour {
    my $self = shift;
    if(@_) { $self->{ALARMLIMITCOLOUR} = shift }
    return $self->{ALARMLIMITCOLOUR};
}
sub TagsColour {
    my $self = shift;
    if(@_) { $self->{TAGSCOLOUR} = shift }
    return $self->{TAGSCOLOUR};
}
sub ScaledValue {
    my $self = shift;
    if(@_) { $self->{SCALEDVALUE} = shift }
    return $self->{SCALEDVALUE};
}
sub RealVal {
    my $self = shift;
    if(@_) { $self->{REALVAL} = shift }
    return $self->{REALVAL};
}
sub Limit {
    my $self = shift;
    if(@_) { $self->{LIMIT} = shift }
    return $self->{LIMIT};
}
sub TagsVal {
    my $self = shift;
    if(@_) { $self->{TAGSVAL} = @_ }
    return $self->{TAGSVAL};
}
sub TagsNum {
    my $self = shift;
    if(@_) { $self->{TAGSNUM} = shift }
    return $self->{TAGSNUM};
}
sub StartTag {
    my $self = shift;
    if(@_) { $self->{STARTTAG} = shift }
    return $self->{STARTTAG};
}
sub NumTags {
    my $self = shift;
    if(@_) { $self->{NUMTAGS} = shift }
    return $self->{NUMTAGS};
}
sub IncTag {
    my $self = shift;
    if(@_) { $self->{INCTAG} = shift }
    return $self->{INCTAG};
}
sub Max {
    my $self = shift;
    if(@_) { $self->{MAX} = shift }
    return $self->{MAX};
}
sub Min {
    my $self = shift;
    if(@_) { $self->{MIN} = shift }
    return $self->{MIN};
}
sub InitialValue {
    my $self = shift;
    if(@_) { $self->{INITIALVALUE} = shift }
    return $self->{INITIALVALUE};
}
sub lastpos {
    my $self = shift;
    if(@_) { $self->{LASTPOS} = shift }
    return $self->{LASTPOS};
}
sub DirHorizFlag {
    my $self = shift;
    if(@_) { $self->{DIRHORIZFLAG} = shift }
    return $self->{DIRHORIZFLAG};
}
sub ShowCurrent {
    my $self = shift;
    if(@_) { $self->{SHOWCURRENT} = shift }
    return $self->{SHOWCURRENT};
}
sub ShowLimits {
    my $self = shift;
    if(@_) { $self->{SHOWLIMITS} = shift }
    return $self->{SHOWLIMITS};
}
sub ShowLabel {
    my $self = shift;
    if(@_) { $self->{SHOWLABEL} = shift }
    return $self->{SHOWLABEL};
}
sub Font {
    my $self = shift;
    if(@_) { $self->{FONT} = shift }
    return $self->{FONT};
}
sub Label {
    my $self = shift;
    if(@_) { $self->{LABEL} = shift }
    return $self->{LABEL};
}
sub Selected {
    my $self = shift;
    if(@_) { $self->{SELECTED} = shift }
    return $self->{SELECTED};
}
1;
