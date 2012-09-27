#!/usr/bin/perl

# CppTrial-pg221.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 221 - Color Selection Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_MOTION);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg221.pl',
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
	my ( $self ) = @_;
	
	my $colourDialog = Wx::ColourDialog->new($self);
	
	my $colorDialogStatus = $colourDialog->ShowModal();
	
	my $colourdata = $colourDialog->GetColourData();
	my $selectedColour = $colourdata->GetColour();
	$self->SetBackgroundColour($selectedColour);
	$self->Refresh();
	
	if ( $colorDialogStatus == wxID_OK ) {$self->Wx::LogStatus ("You pressed:  \"Ok\" ")};
	if ( $colorDialogStatus == wxID_CANCEL ) {$self->Wx::LogStatus ("You pressed:  \"Cancel\" ")};
}
