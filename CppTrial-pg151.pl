#!/usr/bin/perl

# CppTrial-pg151.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 151 - Drawing Text Rotated - Extends pg 150 & 135 examples
# C++ Example from pg 150 - Drawing Text - Extends pg 135 example
# C++ Example from pg 135 - Drawing on Windows with wxPaintDC
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg151.pl',
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
		
		my $sz=$self->GetClientSize();
		my $szx=$sz->x;
		my $szy=$sz->y;
		
		my $w=100;
		my $h=50;
		my $x=($szx - $w)/2;
		my $y=($szy - $h)/2;

		$dc->DrawRectangle($x,$y,$w,$h);            # Centered on frame
		my $pt1=Wx::Point->new(160,275);
		CppDrawText($dc, "Test Text", $pt1);        # Fixed position		
		my $pt2=Wx::Point->new(200,375);
		CppDrawRotatedText($dc, "Test Text", $pt2); # Fixed position
}

sub CppDrawText {
		my ( $dc, $text, $pt) = @_;
		
		my $font = Wx::Font->new(12, wxFONTFAMILY_ROMAN, wxNORMAL, wxBOLD);
		$dc->SetFont($font);
		$dc->SetBackgroundMode(wxTRANSPARENT);
		$dc->SetTextForeground(wxBLACK);
		$dc->SetTextBackground(wxWHITE);
		$dc->DrawText($text,$pt->x, $pt->y);
		return;
		
}

sub CppDrawRotatedText {
		my ( $dc, $text, $pt) = @_;
		
		my $font = Wx::Font->new(12, wxFONTFAMILY_ROMAN, wxNORMAL, wxNORMAL);
		$dc->SetFont($font);
		$dc->SetBackgroundMode(wxTRANSPARENT);
		$dc->SetTextForeground(wxGREEN);
		$dc->SetTextBackground(wxWHITE);
		for (my $angle=0; $angle<360; $angle +=45) {
			$dc->DrawRotatedText($text,$pt->x, $pt->y, $angle);
		}
		return;
		
}
