#!/usr/bin/perl

# CppTrial-pg135.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
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
		           'CppTrial-pg135.pl',
		           wxDefaultPosition, wxDefaultSize,);
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

		$dc->DrawRectangle($x,$y,$w,$h);     # Centered on the window, try resizing...
}

