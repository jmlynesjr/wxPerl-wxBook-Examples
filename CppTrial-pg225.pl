#!/usr/bin/perl

# CppTrial-pg225.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 225 - Single Choice Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg225.pl',
		           wxDefaultPosition, wxDefaultSize);

#Use status bar to indicate button presses	
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

	my @choices = ("One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight");
			
	my $singleChoiceDialog = Wx::SingleChoiceDialog->new($self, 
				 "This is a small sample\nA single-choice convenience dialog",
				 "Please select a value", \@choices);
				 
	$singleChoiceDialog->SetSelection(2);
	
	if( $singleChoiceDialog->ShowModal() == wxID_OK) {
		Wx::MessageBox($singleChoiceDialog->GetStringSelection(),
		"Got String", wxOK | wxICON_INFORMATION, $self);
	}
}
