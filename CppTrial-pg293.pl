#!/usr/bin/perl

# CppTrial-pg293.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 293 - Writing Text to the Clipboard
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);


# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg293.pl',
		           wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button presses	
my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
$frame->SetStatusBar($statusBar);
my @widths = (200, 100, -1);
$statusBar->SetFieldsCount($#widths+1);
$statusBar->SetStatusWidths(@widths);
$statusBar->SetStatusText("Ready", 0);

myStdDialogs($frame);

$frame->Show;
$app->MainLoop;

# Example specific code
sub myStdDialogs {
	my ( $self ) = @_;

	use Wx::DND;						# Loads all of the Clipboard
								# and Drag and Drop packages
								# Like - Wx::DataObjectSimple

	my $textDataObject1 = Wx::TextDataObject->new("Save this string to the clipboard");
	
	wxTheClipboard->Open;
	wxTheClipboard->SetData( $textDataObject1 );
	wxTheClipboard->Close;
	
	wxTheClipboard->Open;
	my $text;
	if( wxTheClipboard->IsSupported( wxDF_TEXT ) ) {
		my $textDataObject2 = Wx::TextDataObject->new;
		my $ok = wxTheClipboard->GetData( $textDataObject2 );
			if( $ok ) {
				$self->Wx::LogStatus( "Pasted and Retrieved text" );
				$text = $textDataObject2->GetText;
			}
			else {
				$self->Wx::LogStatus( "Error pasting and Retrieving text" );
				$text = '';
			}
	}
	Wx::MessageBox($text);
}
