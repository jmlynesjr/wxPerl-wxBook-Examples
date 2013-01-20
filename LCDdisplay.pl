#! /home/pete/CitrusPerl/perl/bin/perl
#
# LCDdisplay.pl
# This script draws a simulated seven segment LCD Display.
# Segments are drawn as 4 or 6 sided polygons
# The colon(:) is drawn as 2 ellipses and takes up a character space
# The decimal(.) is drawn as 1 ellipse and does not take a character space
# A leading decimal(.) must be prefaced by a 0 as 0.1234
# For demo purposes the value to be displayed is stored in %wxGlobals{mValue}
#
# Written in wxPerl. Tested on Citrus Perl 5.16 with wxWidgets 2.8.x.
# Ported by: James M. Lynes. Jr.
# Last Modified Date: January 19, 2013
#
# Adapted from LCDWindow.cpp by Marco Cavallini
# based in part(mostly) on the work of
# the KWIC project (http://www.koansoftware.com/kwic/index.htm).
# Referenced on pg 596 of the "Wx Book" -
# "Cross-Platform GUI Programming with wxWidgets", Smart, Hock, & Csomor
#
#
use 5.010;							# Using Given/When
use strict;
use warnings;
use Wx qw(:everything :allclasses);
use Wx::Event qw( EVT_PAINT EVT_SIZE );

my %wxGlobals = (						# Configuration Data
		 mSegmentLen         => 40,
		 mSegmentWidth       => 10,
		 mSpace              => 5,
		 mNumberDigits       => 6,			# width of mValue including . or :
		 mValue		     => "12.045",		# Default string to be displayed
		 LCD_Number_Segments => 8,			# Segment 7 is the decimal point
		 mLightColour        => sub{Wx::Colour->new(0, 255, 0)},	# Bright green
		 mGrayColour         => sub{Wx::Colour->new(0, 64, 0)},		# Dim green
		 mDefaultColour      => sub{Wx::Colour->new(0, 0, 0)},		# Black
);

my %wxDigitData = (						# Actual string to be displayed
		value		     => "",
		decimal		     => 0,			# 1=true turns on the decimal point for digit
);

my %ctbl = (							# Map character to segments -
		0		     => 0x3F,			# Not defined in the 7-segment "abcdefg" format
		1		     => 0x14,
		2		     => 0x6D,			#    ***0***         Bit Numbers -654 3210
		3		     => 0x75,			#   *       *
		4		     => 0x56,			#   1       2
		5		     => 0x73,			#   *       *
		6		     => 0x7B,			#    ***6***
		7		     => 0x15,			#   *       *
		8		     => 0x7F,			#   3       4
		9		     => 0x77,			#   *       *
		A		     => 0x5F,			#    ***5*** 7
		B		     => 0x7A,
		C		     => 0x2B,
		D		     => 0x7C,
		E		     => 0x6B,
		F		     => 0x4B,
		'-'		     => 0x40,
		'_'		     => 0x20,
		'^'		     => 0x47,			# code for degree symbol
		'='		     => 0x61,			# code for undefined symbol
		' '		     => 0x00,			# code for a space
);								# Other options could be added

#
# Main Application -----------------------------------------------------------------------
#
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1, "Simulated 7-segment LCD Display",
			   wxDefaultPosition, [400,150]);
$frame->SetBackgroundColour($wxGlobals{mDefaultColour}->());
EVT_PAINT( $frame, \&onPaint );
EVT_SIZE( $frame, \&onSize );
$frame->Show;
$app->MainLoop;
#
# Dismiss a size event
#
sub onSize{
    my($self, $event) = @_;
    $event->Skip();
}
#
# Paint the simulated LCD Display ----------------------------------------------------------
#
sub onPaint{
    my($self, $event) = @_;
    my $disp = Wx::PaintDC->new($self);				# Create paint device context
    my( $dw, $dh) = $disp->GetSizeWH();				# Calculate display scaling
    my $bw = GetBitmapWidth();
    my $bh = GetBitmapHeight();
    my $xs = $dw/$bw;
    my $ys = $dh/$bh;
    my $as = $xs > $ys ? $ys : $xs;
    $disp->SetUserScale($as, $as);
    $disp->SetDeviceOrigin((($dw-$bw*$as)/2), (($dh-$bh*$as)/2));
    DoDrawing($disp);						# Paint the display
}
sub DoDrawing{
    my($dc) = @_;
    my @cbuf = reverse(split(//,$wxGlobals{mValue}));		# Process one character at a time
    my $cbuflen = @cbuf;
    if($cbuflen > $wxGlobals{mNumberDigits}) {			# Truncate string to max display width
        $cbuflen = $wxGlobals{mNumberDigits};
    }
    my $ctr = 0;
    my $seg = 0;
    while($ctr < $cbuflen) {
        if($cbuf[$ctr] ne '.') {				# Skip decimal point, not drawn as a character
            $wxDigitData{value} = $cbuf[$ctr];
            $wxDigitData{decimal} = 0;
	    if($cbuf[$ctr-1] eq '.') {$wxDigitData{decimal} = 1;} # Turn on decimal point for this digit
            DrawDigit($dc, $seg);
            $seg++;
        }
        $ctr++
    }
}
sub DrawDigit{
    my($dc, $digit) = @_;
    my $value = $wxDigitData{value};
    my $dec = Decode($value);
    if($value eq ':') {						# Draw a colon(:)
        DrawTwoDots($dc, $digit);
    }
    else{
        my $ctr = 0;
        while($ctr < $wxGlobals{LCD_Number_Segments}-1) {
            DrawSegment($dc, $digit, $ctr, ($dec>>$ctr)&1);
            $ctr++;
        }
        DrawSegment($dc, $digit, 7, $wxDigitData{decimal});	# Draw the decimal point
    }
}
sub DrawTwoDots{						# Draws a colon(:)
    my($dc, $digit) = @_;
    my $sl = $wxGlobals{mSegmentLen};
    my $sw = $wxGlobals{mSegmentWidth};
    my $sp = $wxGlobals{mSpace};
    my $x = DigitX($digit);
    my $y = DigitY($digit);
    $x += ($sl/2)-$sw;
    $y += ($sl/2)-$sw;
    my $brushOn = Wx::Brush->new($wxGlobals{mLightColour}->(), wxSOLID);
    $dc->SetBrush($brushOn);
    $dc->SetPen(Wx::Pen->new($frame->GetBackgroundColour(), 1, wxSOLID));
    $dc->DrawEllipse($x, $y, $sw*2, $sw*2);
    $y += $sl;
    $dc->DrawEllipse($x, $y, $sw*2, $sw*2);
}
sub DrawSegment{
    my($dc, $digit, $segment, $state) = @_;
    my $sl = $wxGlobals{mSegmentLen};
    my $sw = $wxGlobals{mSegmentWidth};
    my $x = DigitX($digit);
    my $y = DigitY($digit);
    my $brushOn = Wx::Brush->new($wxGlobals{mLightColour}->(), wxSOLID);
    my $brushOff = Wx::Brush->new($wxGlobals{mGrayColour}->(), wxSOLID);
    if($state) {						# bit set for On segment
        $dc->SetBrush($brushOn);				# Bright color for On segment
    }
    else {							# bit cleared for Off segment
        $dc->SetBrush($brushOff);				# Dim color for Off segment
    }
    $dc->SetPen(Wx::Pen->new($frame->GetBackgroundColour(), 1, wxSOLID));
    my @points;							# Verticies for 4 sided segments
    my @p6;							# Verticies for the 6 sided segment
    given($segment) {
        when(0) {
                  $points[0] = Wx::Point->new($x, $y);
                  $points[1] = Wx::Point->new($x+$sl, $y);
                  $points[2] = Wx::Point->new($x+$sl-$sw, $y+$sw);
                  $points[3] = Wx::Point->new($x+$sw, $y+$sw);
         }
        when(1) {
                  $points[0] = Wx::Point->new($x, $y);
                  $points[1] = Wx::Point->new($x, $y+$sl);
                  $points[2] = Wx::Point->new($x+$sw, $y+$sl-$sw/2);
                  $points[3] = Wx::Point->new($x+$sw, $y+$sw);
         }
        when(2) {
                  $x += $sl-$sw;
                  $points[0] = Wx::Point->new($x,$y+$sw);
                  $points[1] = Wx::Point->new($x+$sw, $y);
                  $points[2] = Wx::Point->new($x+$sw, $y+$sl);
                  $points[3] = Wx::Point->new($x, $y+$sl-$sw/2);
         }
        when(3) {
                  $y += $sl;
                  $points[0] = Wx::Point->new($x, $y);
                  $points[1] = Wx::Point->new($x, $y+$sl);
                  $points[2] = Wx::Point->new($x+$sw, $y+$sl-$sw);
                  $points[3] = Wx::Point->new($x+$sw, $y+$sw-$sw/2);
         }
        when(4) {
                  $x += $sl-$sw;
                  $y += $sl;
                  $points[0] = Wx::Point->new($x, $y+$sw/2);
                  $points[1] = Wx::Point->new($x+$sw, $y);
                  $points[2] = Wx::Point->new($x+$sw, $y+$sl);
                  $points[3] = Wx::Point->new($x, $y+$sl-$sw);
         }
        when(5) {
                  $y += 2*$sl-$sw;
                  $points[0] = Wx::Point->new($x+$sw, $y);
                  $points[1] = Wx::Point->new($x+$sl-$sw, $y);
                  $points[2] = Wx::Point->new($x+$sl, $y+$sw);
                  $points[3] = Wx::Point->new($x, $y+$sw);
         }
        when(6) {
                  $y += $sl-$sw/2;
                  $p6[0] = Wx::Point->new($x, $y+$sw/2);
                  $p6[1] = Wx::Point->new($x+$sw, $y);
                  $p6[2] = Wx::Point->new($x+$sl-$sw, $y);
                  $p6[3] = Wx::Point->new($x+$sl, $y+$sw/2);
                  $p6[4] = Wx::Point->new($x+$sl-$sw, $y+$sw);
                  $p6[5] = Wx::Point->new($x+$sw, $y+$sw);
        }
        default {}
    }
    if($segment < 6) {						# Draw the 4 sided segments(0-5)
       $dc->DrawPolygon(\@points, 0, 0);
    }
    elsif($segment == 6) {					# Draw the 6 sided segment(6)
        $dc->DrawPolygon(\@p6, 0, 0);
    }
    else {							# Draw the decimal point(7)
        $y += 2*$sl;
        $x += $sl;
        $dc->DrawEllipse($x+1, $y-$sw, $sw, $sw);
    }
}
sub Decode { $ctbl{$_[0]} // $ctbl{'='}}			# Table lookup
								# for character translation

#
# Support subs ----------------------------------------------------------------------------
#
sub GetDigitWidth{
    return $wxGlobals{mSegmentLen} + $wxGlobals{mSegmentWidth} + $wxGlobals{mSpace};
}
sub GetDigitHeight{
    return ($wxGlobals{mSegmentLen}*2) + ($wxGlobals{mSpace}*2);
}
sub GetBitmapWidth{
    return ($wxGlobals{mNumberDigits}*GetDigitWidth()) + $wxGlobals{mSpace};
}
sub GetBitmapHeight{
    return GetDigitHeight();
}
sub DigitX{
    my($digit) = @_;
    return GetBitmapWidth()-(($digit+1)*GetDigitWidth());
}
sub DigitY{
    my($digit) = @_;
    return $wxGlobals{mSpace};
}
sub SetNumberDigits{
    my $ndigits = @_;
    $wxGlobals{mNumberDigits} = $ndigits;
}
sub SetValue{
    my $value = @_;
    $wxGlobals{mValue} = $value;
}
sub GetValue{
    return $wxGlobals{mValue};
}
sub GetNumberDigits{
    return $wxGlobals{mNumberDigits};
}
sub SetLightColour{
    my($ref) = @_;
    $wxGlobals{mLightColour} = $ref;
}
sub SetGrayColour{
    my($ref) = @_;
    $wxGlobals{mGrayColour} = $ref;
}
sub GetLightColour{
    return $wxGlobals{mLightColour};
}
sub GetGrayColour{
    return $wxGlobals{mGrayColour};
}
sub GetDigitsNeeded{
    my($string) = @_;
    $string =~ s/\.//g;
    return strlen($string);
}
