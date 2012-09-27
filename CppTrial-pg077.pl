#!/usr/bin/perl

# CppTrial-pg077.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 77 - Scrolled Window Example
# Ported to wxPerl by James M. Lynes Jr. - Last Modfied 9/23/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg077.pl',
		           wxDefaultPosition, wxDefaultSize);
scrolledWindow($frame);
$frame->Show;
$app->MainLoop;

# Example specific code
sub scrolledWindow {
	my ( $self ) = @_;
	
	my $scrolledWindow = Wx::ScrolledWindow->new($self, wxID_ANY,
			     Wx::Point->new(0, 0), Wx::Size->new(400, 400),
			     wxVSCROLL | wxHSCROLL);
	
	my $pixelsPerUnitX = 10;
	my $pixelsPerUnitY = 10;
	my $noUnitsX = 1000;
	my $noUnitsY = 1000;
			     
	$scrolledWindow->SetScrollbars($pixelsPerUnitX, $pixelsPerUnitY,
			 $noUnitsX, $noUnitsY);
}

