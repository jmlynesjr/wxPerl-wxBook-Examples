#!/usr/bin/perl

# CppTrial-pg159A.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 159A - Filling arbitrary areas - Extends pg 135 example 
# C++ Example from pg 135 - Drawing on Windows with wxPaintDC
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg159A.pl',
		           wxDefaultPosition, wxDefaultSize);
EVT_PAINT($frame,\&OnPaint);
$frame->Show;
$app->MainLoop;

# Example Specific code
sub OnPaint {
	my ( $self, $event) = @_;

		my $dc = Wx::PaintDC->new($self);
		
		my $pen = Wx::Pen->new(wxRED,5,wxSOLID);
		$dc->SetPen($pen);
		my $brush=Wx::Brush->new(wxGREEN,wxSOLID);
		$dc->SetBrush($brush);
		
		$dc->DrawRectangle(0, 0, 400, 450);
		$dc->DrawRectangle(20, 20, 100, 100);
		$dc->DrawRectangle(200, 200, 100, 100);
		$dc->DrawRectangle(20, 300, 100, 100);		    # 4 Rects filled green

#		wxFLOOD_SURFACE - Fill area of given color		
		$dc->SetBrush(wxBLACK_BRUSH);
		$dc->FloodFill(250, 250, wxGREEN, wxFLOOD_SURFACE); # Center Rect filled black

#		wxFLOOD_BORDER  - Fill area within given color border		
		$dc->SetBrush(wxCYAN_BRUSH);
		$dc->FloodFill(100, 350, wxRED, wxFLOOD_BORDER);    # Bottom Rect filled cyan
		
		$dc->SetBrush(wxBLUE_BRUSH);
		$dc->FloodFill(6, 6, wxRED, wxFLOOD_BORDER);        # Large Rect filled blue
		
}
