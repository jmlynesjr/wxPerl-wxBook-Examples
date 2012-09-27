#!/usr/bin/perl

# CppTrial-pg124.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 124 - Tool Bar Example
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;

use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		          'CppTrial-pg124.pl',
		           wxDefaultPosition, wxDefaultSize);
Wx::InitAllImageHandlers();
ToolBar($frame);
$frame->Show;
$app->MainLoop;

# Example specific code
sub ToolBar {
	my ( $self ) = @_;
	
	my $toolBar = Wx::ToolBar->new($self, -1,
			     wxDefaultPosition, wxDefaultSize,
			     wxTB_HORIZONTAL | wxNO_BORDER);

	my $cutxpm = Wx::Bitmap->new( "cut.xpm", wxBITMAP_TYPE_XPM );	
	my $copyxpm = Wx::Bitmap->new( "copy.xpm", wxBITMAP_TYPE_XPM );
	my $printxpm = Wx::Bitmap->new( "print.xpm", wxBITMAP_TYPE_XPM );
	
	$toolBar->AddTool(wxID_CUT, $cutxpm, "cut");
	$toolBar->AddTool(wxID_COPY, $copyxpm, "Copy");
	$toolBar->AddTool(wxID_PRINT, $printxpm, "Print");
	$toolBar->AddSeparator();
	my $ID_COMBOBOX = 1;
	my $comboBox = Wx::ComboBox->new($toolBar, $ID_COMBOBOX);
	$toolBar->AddControl($comboBox);
	$toolBar->Realize();
	$self->SetToolBar($toolBar);

}
