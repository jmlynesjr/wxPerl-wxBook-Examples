#!/usr/bin/perl

# CppTrial-pg340.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 340 - HTML Window - Displays an HTML file
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);
use Wx::Html;					# Html package not loaded by "use Wx qw(:everything)"
						# Html pulls in all of the HTML modules
# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1,
		             'CppTrial-pg340.pl',
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
Wx::InitAllImageHandlers();
myStdDialogs($dialog);
$app->MainLoop;
	
# Example specific code
sub myStdDialogs {
	my ( $self ) = @_;
	
	my $topSizer = Wx::BoxSizer->new(wxVERTICAL);
	
	my $html = Wx::HtmlWindow->new($self, wxID_ANY, wxDefaultPosition, 
		   Wx::Size->new(600,400), wxHW_SCROLLBAR_NEVER);
		   
	$html->SetBorders(5);
	$html->LoadPage("pg342.html");
#
#	GetInternalRepresentation() not supported under wxPerl
#         
	$topSizer->Add($html, 1, wxALL, 10);

	my $staticLine = Wx::StaticLine->new($self, wxID_ANY);	
	$topSizer->Add($staticLine, 0, wxEXPAND | wxLEFT | wxRIGHT, 10);
	
	my $button = Wx::Button->new($self, wxID_OK, "Ok");
	$button->SetDefault();
	$topSizer->Add($button, 0, wxALL | wxALIGN_RIGHT, 15);
	
	$self->SetSizer($topSizer);
	$topSizer->Fit($self);
	$self->ShowModal();

}
