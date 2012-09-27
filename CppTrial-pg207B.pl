#!/usr/bin/perl

# CppTrial-pg207B.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 207(B) - Message Box Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg207B.pl',
	   	           wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button presses
my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
$frame->SetStatusBar($statusBar);
my @widths = (200, 100, -1);
$statusBar->SetFieldsCount($#widths+1);
$statusBar->SetStatusWidths(@widths);
$statusBar->SetStatusText("Ready", 0);

myStdDialogs($frame);

$frame->Show;
$app->MainLoop;

# Example Specific code
sub myStdDialogs {
	my ( $self ) = @_;

	my $stdDialog = Wx::MessageBox("Message Box Text", 
			"Message Box Caption", wxNO_DEFAULT | wxOK | wxYES_NO | 
			wxCANCEL | wxICON_INFORMATION, $self);

#	Note: Wx::MessageBox returns different button IDs from Wx::MessageDialog - pg207A
	
	given ($stdDialog) {
			when ([wxYES])		{$self->Wx::LogStatus ("You pressed:  \"Yes\" ")}
			when ([wxNO])		{$self->Wx::LogStatus ("You pressed:  \"No\" ")}
			when ([wxCANCEL])	{$self->Wx::LogStatus ("You pressed:  \"Cancel\" ")}
			when ([wxOK])		{$self->Wx::LogStatus ("You pressed:  \"Ok\" ")};
				
	}	
}
