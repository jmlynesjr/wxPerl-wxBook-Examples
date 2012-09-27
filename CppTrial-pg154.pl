#!/usr/bin/perl

# CppTrial-pg154.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 154 - Drawing multiple lines - Extends pg 135 example
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
		           'CppTrial-pg154.pl',
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
		
		my @points;
		my $x=0;
		my $y=0;
		
		for my $i(0..9) {
		
		my $pt1=Wx::Point->new($x,$y);
		my $pt2=Wx::Point->new($x+100,$y);
		push(@points, $pt1, $pt2);
		
#		print "$i-> $x, $y / ", $x+100, ",", $y, "\n";
		$dc->DrawLine($pt1->x, $pt1->y, $pt2->x, $pt2->y);
		
		$x=$x + 10;
		$y=$y + 20;
		}
		
#		print "@points\n";

		my $offsetx = 100;
		my $offsety = 250;
		$dc->DrawLines(\@points, $offsetx, $offsety);
}



