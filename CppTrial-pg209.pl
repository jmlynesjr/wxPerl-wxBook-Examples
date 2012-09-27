#!/usr/bin/perl

# CppTrial-pg209.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 209 - Progress Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg209.pl',
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

	my $continue = 1;
	my $max = 10;
	
	my $myProgressDialog = Wx::ProgressDialog->new("Progress Dialog Example",
			       "An Information Message", $max, $self,
			       wxPD_CAN_ABORT       |
			       wxPD_APP_MODAL       |
			       wxPD_ELAPSED_TIME    |
			       wxPD_ESTIMATED_TIME  |
			       wxPD_REMAINING_TIME);

	for ( my $i = 0; $i <= $max; $i++) {
		Wx::Sleep(1);
		
		if ($i == $max) {
			$continue = $myProgressDialog->Update($i, "That's all, folks!");
		}
		elsif ($i == $max/2) {
			$continue = $myProgressDialog->Update($i, "Only a half left (very long message)!");
		}
		else {
			$continue = $myProgressDialog->Update($i);
		}
		
		if (! $continue) {
			if ( Wx::MessageBox("Do you really want to cancel?", 
					"Progress Dialog Question", wxYES_NO | 
					wxICON_QUESTION, $self) == wxYES ) {
				last;
			}
			else {
				$self->Wx::LogStatus ("Progress Dialog Resumed");
				$myProgressDialog->Resume();
			}
		}
	}

	if (! $continue) {
		$self->Wx::LogStatus ("Progress Dialog Aborted!");
	}
	else {
		$self->Wx::LogStatus ("Countdown from %d Finished", $max);
	}
}
