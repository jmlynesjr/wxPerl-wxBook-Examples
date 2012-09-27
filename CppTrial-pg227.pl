#!/usr/bin/perl

# CppTrial-pg227.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 227 - Number Entry Dialog (**Alternate Implementation - GetNumberFromUser**)
# Could not get NumberEntryDialog, TextEntryDialog, or PasswordEntryDialog to load
# Instead used GetNumberFromUser Function
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg227.pl',
		           wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button pushes
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

#
#	Not sure where the initial value of 20 is comming from....
#	
	my $getNumberFromUser = Wx::GetNumberFromUser( 			# Appears to not support min/max bounds
				 "Number Entry Dialog Example",
				 "Enter A Number:",
				 "Number Entry", 50, wxOK | wxCANCEL, $self);
#
#	Returns -1 upon Cancel
#
	Wx::MessageBox("$getNumberFromUser", "Entered Number:", wxOK | wxICON_INFORMATION, $self);
}
