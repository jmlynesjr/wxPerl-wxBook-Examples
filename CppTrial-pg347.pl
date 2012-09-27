#!/usr/bin/perl

# CppTrial-pg347.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 347 - Simple Grid Example
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);
use Wx::Grid;					# Package not loaded by "use Wx qw(:everything)"

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $dialog = Wx::Dialog->new(undef, -1,
		             'CppTrial-pg347.pl',
		             wxDefaultPosition, wxDefaultSize,
		             wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER);
Wx::InitAllImageHandlers();
myStdDialogs($dialog);
$dialog->Show;
$app->MainLoop;

# Example specific code
sub myStdDialogs {
	my ( $self ) = @_;
	
	my $grid = Wx::Grid->new($self, wxID_ANY, wxDefaultPosition,
		   Wx::Size->new(400,300));

	$grid->CreateGrid(8, 10);				# 8 rows by 10 columns
	$grid->SetRowSize(0, 60);				# row size in pixels
	$grid->SetColSize(0, 120);				# column size in pixels
	
	$grid->SetCellValue(0, 0, "wxGrid is Good");		# A1
	
	$grid->SetCellValue(0, 3, "This is Read-only");		# D1
	$grid->SetReadOnly(0, 3);
	
	$grid->SetCellValue(3, 3, "Green on Grey");		# D4
	$grid->SetCellTextColour(3, 3, wxGREEN);
	$grid->SetCellBackgroundColour(3, 3, wxLIGHT_GREY);

	$grid->SetColFormatFloat(5, 6, 2);
	$grid->SetCellValue(0, 5, "3.1415");			# F1
	
	$grid->Fit();
	$self->SetClientSize($grid->GetSize);
}
