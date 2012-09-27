#!/usr/bin/perl

# CppTrial-pg226.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 226 - Multiple Choice Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg226.pl',
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

	my @choices = ("One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight");
			
	my $multiChoiceDialog = Wx::MultiChoiceDialog->new($self, 
				 "A Multi-choice convenience dialog",
				 "Please select several values", \@choices);
	
	if( $multiChoiceDialog->ShowModal() == wxID_OK) {
		my @selections = $multiChoiceDialog->GetSelections();		# Returns list of index numbers
		my $count = $#selections +1;					# Index into @choices for text
		my $msg = "";
		foreach my $selection (@selections) {
			$msg .= $selection . " : " . $choices[$selection] . "\n";
		}
		Wx::MessageBox($msg, "Selections", wxOK | wxICON_INFORMATION, $self);
	}
}
