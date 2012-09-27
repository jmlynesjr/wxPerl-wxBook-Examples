#!/usr/bin/perl

# CppTrial-pg215.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 215 - File Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_MOTION);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg215.pl',
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

	my $caption = "Choose A File";
	my $wildcard = "*.*";
	my $defaultDir = "~/Projects/perlprojects/wx.proj";
	my $defaultFilename = "";
	
	my $fileDialog = Wx::FileDialog->new($self, $caption, $defaultDir, 
			 $defaultFilename, $wildcard, wxOPEN);
			 
	my $fileDialogStatus = $fileDialog->ShowModal();
	
	my $selecteddir = $fileDialog->GetDirectory();
	my $selectedfile = $fileDialog->GetFilename();
#	print $selecteddir, "\n", $selectedfile, "\n";
	
	if ( $fileDialogStatus == wxID_OK ) {$self->Wx::LogStatus ("You pressed:  \"Open\" ")};
	if ( $fileDialogStatus == wxID_CANCEL ) {$self->Wx::LogStatus ("You pressed:  \"Cancel\" ")};
}
