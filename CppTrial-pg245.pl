#!/usr/bin/perl

# CppTrial-pg245.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 245 - Personal Records Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1, "Personal Records Dialog Example",
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);

mydialog($dialog);

$dialog->Show;
$app->MainLoop;

# Example specific code
sub mydialog {
	my ($dialog)= @_;
	
	my ($ID_NAME, $ID_AGE, $ID_SEX, $ID_VOTE, $ID_RESET, $ID_OK, $ID_CANCEL, $ID_HELP) = (1..8);
	my ($wxEmptyString, $true) = ("", 1);

	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);
	$dialog->SetSizer($topSizer);
		
	my $boxSizer = Wx::BoxSizer->new(wxVERTICAL);
	$topSizer->Add($boxSizer, 0, wxALIGN_CENTER_HORIZONTAL | wxALL, 5);
	
	my $desc = Wx::StaticText->new($dialog, wxID_STATIC, 
				   "Please enter your name, age, and sex, and specify whether you wish to\nvote in a general election.",
				   wxDefaultPosition, wxDefaultSize, 0);
	$boxSizer->Add($desc, 0, wxALIGN_LEFT | wxALL, 5);
	
	my $nameCtrl = Wx::TextCtrl->new($dialog, $ID_NAME, "Maylee",
		       wxDefaultPosition, wxDefaultSize, 0);
	$boxSizer->Add($nameCtrl, 0, wxGROW | wxALL, 5);
	
	my $ageSexVoteBox = Wx::BoxSizer->new(wxHORIZONTAL);
	$boxSizer->Add($ageSexVoteBox, 0, wxGROW | wxALL, 5);
	
	my $ageLabel = Wx::StaticText->new($dialog, wxID_STATIC, "&Age:", wxDefaultPosition, wxDefaultSize, 0);
	$ageSexVoteBox->Add($ageLabel, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $ageSpin = Wx::SpinCtrl->new($dialog, $ID_AGE, $wxEmptyString, wxDefaultPosition,
		      Wx::Size->new(60, -1), wxSP_ARROW_KEYS, 0, 120, 50);
	$ageSexVoteBox->Add($ageSpin, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $sexLabel = Wx::StaticText->new($dialog, wxID_STATIC, "&Sex:", wxDefaultPosition, wxDefaultSize, 0);
	$ageSexVoteBox->Add($sexLabel, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my @sexStrings = ("Male", "Female");
	my $sexChoice = Wx::Choice->new($dialog, $ID_SEX, wxDefaultPosition,
			Wx::Size->new(85,-1), \@sexStrings);
	$sexChoice->SetStringSelection("Female");
	$ageSexVoteBox->Add($sexChoice, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	$ageSexVoteBox->Add(5, 5, 1, wxALIGN_CENTER_VERTICAL | wxALL, 5);	# Spacer Box
	
	my $voteCheckBox = Wx::CheckBox->new($dialog, $ID_VOTE, "&Vote", 
			   wxDefaultPosition, wxDefaultSize, 0);
	$voteCheckBox->SetValue($true);
	$ageSexVoteBox->Add($voteCheckBox, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $line = Wx::StaticLine->new($dialog, wxID_STATIC, wxDefaultPosition,
		   wxDefaultSize, wxLI_HORIZONTAL);
	$boxSizer->Add($line, 0, wxGROW | wxALL, 5);
	
	my $okCancelBox = Wx::BoxSizer->new(wxHORIZONTAL);
	$boxSizer->Add($okCancelBox, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $reset = Wx::Button->new($dialog, $ID_RESET, "&Reset",
		    wxDefaultPosition, wxDefaultSize, 0);
	$okCancelBox->Add($reset, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $ok = Wx::Button->new($dialog, $ID_OK, "&Ok",
		    wxDefaultPosition, wxDefaultSize, 0);
	$ok->SetDefault();
	$okCancelBox->Add($ok, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $cancel = Wx::Button->new($dialog, $ID_CANCEL, "&Cancel",
		    wxDefaultPosition, wxDefaultSize, 0);
	$okCancelBox->Add($cancel, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	my $help = Wx::Button->new($dialog, $ID_HELP, "&Help",
		    wxDefaultPosition, wxDefaultSize, 0);
	$okCancelBox->Add($help, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	
	$topSizer->Fit($dialog);
	$topSizer->SetSizeHints($dialog);	# Return values not processed in this example
}
