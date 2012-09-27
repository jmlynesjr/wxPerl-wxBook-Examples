#!/usr/bin/perl

# CppTrial-pg211.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 211 - Application Tips Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_MOTION);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg211.pl',
		           wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button presses
my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
$frame->SetStatusBar($statusBar);
my @widths = (250, 100, -1);
$statusBar->SetFieldsCount($#widths+1);
$statusBar->SetStatusWidths(@widths);
$statusBar->SetStatusText("Ready", 0);

myStdDialogs($frame);

$frame->Show;
$app->MainLoop;

# Example specific code
sub myStdDialogs {
	my ( $self) = @_;

#	Display an Application Tip Dialog Box
#	Tips are stored in the file "tips.txt", one tip per line
#	Randomly select the first tip to be displayed
#	Return a flag that can be used to control display of tips in the future
	
	my $index = int( rand(9) );
	my $tipProvider = Wx::CreateFileTipProvider("tips.txt", $index);
	my $showAtStartup = Wx::ShowTip($self, $tipProvider, 1);

}
