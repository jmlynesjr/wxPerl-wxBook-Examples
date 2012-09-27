#!/usr/bin/perl

# CppTrial-pg210.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 210 - Busy Info Box
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_MOTION);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg210.pl',
		           wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button presses
my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
	$frame->SetStatusBar($statusBar);
	my @widths = (250, 100, -1);
	$statusBar->SetFieldsCount($#widths+1);
	$statusBar->SetStatusWidths(@widths);
	$statusBar->SetStatusText("Ready", 0);

#	&myStdDialogs($frame);
	EVT_MOTION($frame, \&myStdDialogs);

$frame->Show;
$app->MainLoop;
		
# Example specific code
sub myStdDialogs {
	my ( $self, $event ) = @_;

	$self->Wx::LogStatus ("Display Busy Info Box");
	
	Wx::Window::Disable($self);
	
	my $info = Wx::BusyInfo->new("Counting, please wait...");	#bug - not displaying text in box
	
	Wx::Sleep(1);
	
	Wx::Window::Enable($self);
	$self->Wx::LogStatus ("Removed Busy Info Box");
	
}
