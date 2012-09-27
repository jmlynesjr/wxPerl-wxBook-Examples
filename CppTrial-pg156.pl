#!/usr/bin/perl

# CppTrial-pg156.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 156 - Drawing Splines  - Extends pg 155 example
# C++ Example from pg 155 - Drawing polygons - Extends pg 154 example
# C++ Example from pg 154 - Drawing single & multiple lines - Extends pg 135 example
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
		           'CppTrial-pg156.pl',
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
		my $brush=Wx::Brush->new(wxRED,wxCROSSDIAG_HATCH);
		$dc->SetBrush($brush);
		
		my @pts;
		my $pts0=Wx::Point->new(10, 100);
		my $pts1=Wx::Point->new(200, 200);
		my $pts2=Wx::Point->new(50, 230);
		push(@pts, $pts0, $pts1, $pts2);
		$dc->DrawSpline(\@pts);
		
		my @points;	
		my $pt0=Wx::Point->new(100, 60);
		my $pt1=Wx::Point->new(60, 150);
		my $pt2=Wx::Point->new(160,100);
		my $pt3=Wx::Point->new(40, 100);
		my $pt4=Wx::Point->new(140, 150);
		push(@points, $pt0, $pt1, $pt2, $pt3, $pt4);
		$dc->DrawSpline(\@points);
}
