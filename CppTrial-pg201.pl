#!/usr/bin/perl

# CppTrial-pg201.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 201 - Sizers -Dialog with grid bag sizer
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1, "Grid Bag Sizer Dialog Example",
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
mydialog($dialog);
$dialog->Show;
$app->MainLoop;

# Example specific code
sub mydialog {
	my ($dialog)= @_;
	
#	Create a Grid Bag Sizers make column 2 and row 3 growable

	my $gridBagSizer = Wx::GridBagSizer->new();
	$dialog->SetSizer($gridBagSizer);

	
#	Create Buttons and add to GridBagSizer
	
	my $b1 = Wx::Button->new($dialog , -1, "One  (0,0)");
	$gridBagSizer->Add($b1, Wx::GBPosition->new(0, 0));
		    
	my $b2 = Wx::Button->new($dialog , -1, "Two  (2, 2)");
	$gridBagSizer->Add($b2, Wx::GBPosition->new(2, 2), Wx::GBSpan->new(1, 2), wxGROW);	
		
	my $b3 = Wx::Button->new($dialog , -1, "Three  (3, 2)");
	$gridBagSizer->Add($b3, Wx::GBPosition->new(3, 2));	
	
	my $b4 = Wx::Button->new($dialog , -1, "Four  (3, 3)");
	$gridBagSizer->Add($b4, Wx::GBPosition->new(3, 3));	

	$gridBagSizer->AddGrowableRow(3);
	$gridBagSizer->AddGrowableCol(2);		
		    	
	$gridBagSizer->Fit($dialog);
	$gridBagSizer->SetSizeHints($dialog);
	
}
