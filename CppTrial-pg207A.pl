#!/usr/bin/perl

# CppTrial-pg207A.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 207(A) - Message Dialog Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg207A.pl',
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

# Example specific code
sub myStdDialogs {
	my ( $self ) = @_;

	my $stdDialog = Wx::MessageDialog->new($self, "Message Box Caption", 
			"Message Box Text", wxNO_DEFAULT | wxYES_NO | 
			wxCANCEL | wxICON_INFORMATION);
			
	my $selection = $stdDialog->ShowModal();

	given ($selection) {
			when ([wxID_YES])	  {$self->Wx::LogStatus ("You pressed:  \"Yes\" ")}
			when ([wxID_NO])	  {$self->Wx::LogStatus ("You pressed:  \"No\" ")}
			when ([wxID_CANCEL])      {$self->Wx::LogStatus ("You pressed:  \"Cancel\" ")}			
	}	
}
