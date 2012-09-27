#!/usr/bin/perl

# CppTrial-pg157.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 157 - Drawing Bitmaps - Extends pg 150 example
# C++ Example from pg 150 - Drawing Text -    Extends pg 135 example
# C++ Example from pg 135 - Drawing on Windows with wxPaintDC
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
Wx::InitAllImageHandlers();
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg157.pl',
		           wxDefaultPosition, wxDefaultSize);
EVT_PAINT($frame,\&OnPaint);
$frame->Show;
$app->MainLoop;

# Example specific code
sub OnPaint {
	my ( $self, $event) = @_;

		my $dc = Wx::PaintDC->new($self);
		
		my $pen = Wx::Pen->new(wxBLACK,1,wxSOLID);
		$dc->SetPen($pen);
		my $brush=Wx::Brush->new(wxRED,wxSOLID);
		$dc->SetBrush($brush);
		
		my $font = Wx::Font->new(10, wxFONTFAMILY_ROMAN, wxNORMAL, wxNORMAL);
		$dc->SetFont($font);
		$dc->SetBackgroundMode(wxTRANSPARENT);
		$dc->SetTextForeground(wxBLACK);
		$dc->SetTextBackground(wxWHITE);
		
		my $msg = "Some text will appear mixed in the image's shadow...";
		my $bmp = Wx::Bitmap->new("padre_logo_64x64.png", wxBITMAP_TYPE_PNG);

		my $y = 75;
		for (0..9) {
			$y += $dc->GetCharHeight() +5;
			$dc->DrawText($msg, 10, $y);
		}
		
		$dc->DrawBitmap($bmp, 150, 175, 1);
		return;
		
}
