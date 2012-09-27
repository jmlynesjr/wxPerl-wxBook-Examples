#!/usr/bin/perl

# CppTrial-pg065.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 65 - MDI Child Frame Example
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;

use Wx qw(:everything);
use Wx::MDI;

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new( undef, -1,
		            'CppTrial-pg065.pl',
		            wxDefaultPosition, wxDefaultSize );
mdiChildFrame($frame);
$frame->Show;
$app->MainLoop;

# Example specific code
sub mdiChildFrame {
	my ( $self ) = @_;
	
	my $ID_MYFRAME =  1;
	my $ID_MYCHILD1 = 2;
	my $ID_MYCHILD2 = 3;
	my $ID_MYCHILD3 = 4;
	my $ID_MYCHILD4 = 5;
	
	my $parentFrame = Wx::MDIParentFrame->new($self, $ID_MYFRAME, "MDI Parent Window");
	
	my $childFrame1 = Wx::MDIChildFrame->new($parentFrame, $ID_MYCHILD1, "Child 1");
	my $childFrame2 = Wx::MDIChildFrame->new($parentFrame, $ID_MYCHILD2, "Child 2");
	my $childFrame3 = Wx::MDIChildFrame->new($parentFrame, $ID_MYCHILD3, "Child 3");
	my $childFrame4 = Wx::MDIChildFrame->new($parentFrame, $ID_MYCHILD4, "Child 4");
				
	$childFrame1->Show(1);
	$childFrame2->Show(1);
	$childFrame3->Show(1);
	$childFrame4->Show(1);
	$parentFrame->Show(1);
		
}
