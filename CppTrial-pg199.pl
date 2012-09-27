#!/usr/bin/perl

# CppTrial-pg199.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 199 - Sizers -Dialog with flex grid sizer
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1, "Flex Grid Sizer Dialog Example",
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
mydialog($dialog);
$dialog->Show;	
$app->MainLoop;

# Example specific code
sub mydialog {
	my ($dialog)= @_;
	
#	Create a Grid Sizers make column 0 growable

	my $flexGridSizer = Wx::FlexGridSizer->new(2, 3, 0, 0);
	$dialog->SetSizer($flexGridSizer);
	$flexGridSizer->AddGrowableCol(0);	
	
#	Create Buttons and add to FlexGridSizer
	
	my $button1 = Wx::Button->new($dialog , -1, "One");
	$flexGridSizer->Add($button1, 0, wxALIGN_CENTER_HORIZONTAL | 
		    wxALIGN_CENTER_VERTICAL | wxALL,5);
		    
	my $button2 = Wx::Button->new($dialog , -1, "Two  (the second button)");
	$flexGridSizer->Add($button2, 0, wxALIGN_CENTER_HORIZONTAL | 
		    wxALIGN_CENTER_VERTICAL | wxALL,5);	
		
	my $button3 = Wx::Button->new($dialog , -1, "Three");
	$flexGridSizer->Add($button3, 0, wxALIGN_CENTER_HORIZONTAL | 
		    wxALIGN_CENTER_VERTICAL | wxALL,5);	
	
	my $button4 = Wx::Button->new($dialog , -1, "Four");
	$flexGridSizer->Add($button4, 0, wxALIGN_CENTER_HORIZONTAL | 
		    wxALIGN_CENTER_VERTICAL | wxALL,5);	
		
	my $button5 = Wx::Button->new($dialog , -1, "Five");
	$flexGridSizer->Add($button5, 0, wxALIGN_CENTER_HORIZONTAL | 
		    wxALIGN_CENTER_VERTICAL | wxALL,5);	
		
	my $button6 = Wx::Button->new($dialog , -1, "Six");
	$flexGridSizer->Add($button6, 0, wxALIGN_CENTER_HORIZONTAL | 
		    wxALIGN_CENTER_VERTICAL | wxALL,5);	
		    	
	$flexGridSizer->Fit($dialog);
	$flexGridSizer->SetSizeHints($dialog);
	
}
