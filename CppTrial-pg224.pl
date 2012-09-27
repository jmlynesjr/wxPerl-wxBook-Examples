#!/usr/bin/perl

# CppTrial-pg224.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 224 - Font Selection Dialog
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg224.pl',
		           wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button presses	
my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
$frame->SetStatusBar($statusBar);
my @widths = (250, 100, -1);
$statusBar->SetFieldsCount($#widths+1);
$statusBar->SetStatusWidths(@widths);
$statusBar->SetStatusText("Ready", 0);

EVT_PAINT($frame, \&myStdDialogs);

$frame->Show;
$app->MainLoop;

# Example specific code
sub myStdDialogs {
	my ( $self, $event ) = @_;

	my $font = Wx::Font->new(18, wxFONTFAMILY_ROMAN, wxNORMAL, wxNORMAL);
	
	my $fontData = Wx::FontData->new();
	$fontData->SetInitialFont($font);
	$fontData->SetColour(wxGREEN);
	
	my $fontDialog = Wx::FontDialog->new($self, $fontData);
	
	my $fontDialogStatus = $fontDialog->ShowModal();
	
	$fontData = $fontDialog->GetFontData();
	my $selectedfont = $fontData->GetChosenFont();
	my $selectedcolour = $fontData->GetColour();
#
#	Code added to provide something to display, drag dialog off of frame to see text displayed
#	
	my $dc = Wx::PaintDC->new($self); 
	my $pt=Wx::Point->new(100,200); 
	$dc->SetFont($selectedfont); 
	$dc->SetBackgroundMode(wxTRANSPARENT); 
	$dc->SetTextForeground($selectedcolour); 
	$dc->SetTextBackground(wxWHITE); 
	$dc->DrawText("Font Selection Sample",$pt->x, $pt->y); 
	$self->Refresh();

#
#	Loop until Cancel is Selected
#	
	if ( $fontDialogStatus == wxID_CANCEL ) {die "Font Selection Terminated"};
}
