#!/usr/bin/perl

# CppTrial-pg195.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 195 - Sizers -Dialog with streatching text control
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1, "Sizer Dialog Example",
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
mydialog($dialog);
$dialog->Show;
$app->MainLoop;

# Example specific code
sub mydialog {
	my ($dialog)= @_;
	
#	Create two Sizers

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);
	my $buttonSizer = Wx::BoxSizer->new(wxHORIZONTAL);

#	Create a Text Control, and OK and CANCEL Buttons
	
	my $textCtrl = Wx::TextCtrl->new($dialog, wxID_ANY, "Stretching Text Control...",
		       wxDefaultPosition, Wx::Size->new(100, 60), wxTE_MULTILINE);
	my $buttOk = Wx::Button->new($dialog, wxID_OK, "OK");
	my $buttCancel = Wx::Button->new($dialog, wxID_CANCEL, "Cancel");
	
#	Associate Text Control and buttons with Sizers

	$topSizer->Add($textCtrl, 1, wxEXPAND, wxALL, 10);
	$buttonSizer->Add($buttOk, 0, wxALL, 10);
	$buttonSizer->Add($buttCancel, 0, wxALL, 10);
	
#	Associate Button Sizer with TopSizer

	$topSizer->Add($buttonSizer, 0, wxALIGN_CENTER);
	
	$dialog->SetSizer($topSizer);
	$topSizer->Fit($dialog);
	$topSizer->SetSizeHints($dialog);
	
}
