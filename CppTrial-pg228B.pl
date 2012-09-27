#!/usr/bin/perl

# CppTrial-pg228B.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 228 - Password Entry Dialog (**Alternate Implementation - GetPasswordFromUser**)
# Could not get NumberEntryDialog, TextEntryDialog, or PasswordEntryDialog to load
# Instead used GetPasswordFromUser Function
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg228B.pl',
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

#
#	Not sure where the initial value of 20 is comming from....
#	
	my $getPasswordFromUser = Wx::GetPasswordFromUser( 
				 "This is some text, actually a lot of text\nEven two rows of text",
				 "Enter a Password: ", wxOK | wxCANCEL, $self);
#
#	Returns empty string upon Cancel
#
	Wx::MessageBox("$getPasswordFromUser", "Entered Password:", wxOK | wxICON_INFORMATION, $self);
}
