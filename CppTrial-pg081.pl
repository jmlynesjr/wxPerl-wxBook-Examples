#!/usr/bin/perl

# CppTrial-pg081.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 81 - Splitter Window Example
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);


# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg081.pl',
		           wxDefaultPosition, wxDefaultSize);
SplitterWindow($frame);
$frame->Show;
$app->MainLoop;

# Example specific code
sub SplitterWindow {
	my ( $self ) = @_;
	
	my $splitterWindow = Wx::SplitterWindow->new($self, -1,
			     Wx::Point->new(0, 0), Wx::Size->new(400, 400),
			     wxSP_3D);
			     
	my $leftWindow = Wx::ScrolledWindow->new($splitterWindow);
	$leftWindow->SetScrollbars(20, 20, 50, 50);
	$leftWindow->SetBackgroundColour(wxRED);
	$leftWindow->Show(1);
	
	my $rightWindow = Wx::ScrolledWindow->new($splitterWindow);
	$rightWindow->SetScrollbars(20, 20, 50, 50);
	$rightWindow->SetBackgroundColour(wxCYAN);
	$rightWindow->Show(0);						# Right Window is Hidden
	
	$splitterWindow->Initialize($leftWindow);	
}
