#!/usr/bin/perl

# CppTrial-pg202.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 202 - Sizers -Dialog with Standard Dialog Button Sizer
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1, "Standard Dialog Button Sizer Example",
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
mydialog($dialog);
$dialog->Show;
$app->MainLoop;

# Example specific code
sub mydialog {
	my ($dialog)= @_;
	
#	Create Sizer

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);
	$dialog->SetSizer($topSizer);

#	Create an OK, CANCEL, and HELP Buttons
	
	my $buttOk = Wx::Button->new($dialog, wxID_OK, "OK");
	my $buttCancel = Wx::Button->new($dialog, wxID_CANCEL, "Cancel");
	my $buttHelp = Wx::Button->new($dialog, wxID_HELP, "Help");
	
#	Associate buttons with Sizers

	my $buttonSizer = Wx::StdDialogButtonSizer->new();
	$topSizer->Add($buttonSizer, 0, wxEXPAND | wxALL, 10);

	$buttonSizer->AddButton($buttOk);
	$buttonSizer->AddButton($buttCancel);
	$buttonSizer->AddButton($buttHelp);

	$buttonSizer->Realize();
}
