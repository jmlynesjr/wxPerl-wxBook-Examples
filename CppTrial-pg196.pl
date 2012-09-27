#!/usr/bin/perl

# CppTrial-pg196.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 196 - Sizers -Dialog with static box sizer and check box
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1, "Static Box Sizer Dialog Example",
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
mydialog($dialog);
$dialog->Show;
$app->MainLoop;

# Example specific code
sub mydialog {
	my ($dialog)= @_;
	
#	Create two Sizers and a Static Box

	my $topLevel = Wx::BoxSizer->new(wxVERTICAL);
	my $staticBox = Wx::StaticBox->new($dialog, wxID_ANY, "General Settings");
	my $staticSizer = Wx::StaticBoxSizer->new($staticBox, wxVERTICAL);

#	Create a Check Box
	
	my $checkBox = Wx::CheckBox->new($dialog, -1, "&Show Splash Screen",
		       wxDefaultPosition, wxDefaultSize);
	
#	Associate Check Box Control with Sizers

	$topLevel->Add($staticSizer, 0, wxALIGN_CENTER_HORIZONTAL | wxALL, 5);
	$staticSizer->Add($checkBox, 0, wxALIGN_LEFT | wxALL, 5);
	
#	Associate Button Sizer with TopSizer

	$dialog->SetSizer($topLevel);
	$topLevel->Fit($dialog);
	$topLevel->SetSizeHints($dialog);
	
}
