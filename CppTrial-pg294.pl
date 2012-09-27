#!/usr/bin/perl

# CppTrial-pg294.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 294 - Writing a bitmap/image to the Clipboard
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/25/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		        'CppTrial-pg294.pl',
		        wxDefaultPosition, wxDefaultSize);

# Use status bar to indicate button presses
Wx::InitAllImageHandlers();	
my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
$frame->SetStatusBar($statusBar);
my @widths = (200, 100, -1);
$statusBar->SetFieldsCount($#widths+1);
$statusBar->SetStatusWidths(@widths);
$statusBar->SetStatusText("Ready", 0);

EVT_PAINT($frame, \&myStdDialogs);

$frame->Show;
$app->MainLoop;

# Example specific code
sub myStdDialogs {
	my ( $self, $event ) = @_;

	use Wx::DND;						# Loads all of the Clipboard
								# and Drag and Drop packages
								# Like - Wx::DataObjectSimple

	my $bmp = Wx::Bitmap->new("logo.png", wxBITMAP_TYPE_PNG); 
	my $bmpObject1 = Wx::BitmapDataObject->new($bmp);
	
	wxTheClipboard->Open;
	wxTheClipboard->SetData( $bmpObject1 );			# Put the bitmap object on the clipboard
	wxTheClipboard->Close;
	
	wxTheClipboard->Open;
	my $bitmap = wxNullBitmap;
	if( wxTheClipboard->IsSupported( wxDF_BITMAP ) ) {
		my $bmpObject2 = Wx::BitmapDataObject->new($bitmap);
		my $ok = wxTheClipboard->GetData( $bmpObject2 ); # Get the bitmap object from the clipboard
		if( $ok ) {
			$self->Wx::LogStatus("Pasted and Retrieved bitmap" );
			$bitmap =  $bmpObject2->GetBitmap();
		}
		else {
			$self->Wx::LogStatus("Error pasting bitmap" );
			$bitmap = wxNullBitmap;
		}
	wxTheClipboard->Close; 
}
#
#	Use a paint event to get the bitmap to draw on screen
#
	my $dc = Wx::PaintDC->new($self);  
	my $pen = Wx::Pen->new(wxBLACK, 1, wxSOLID); 
	$dc->SetPen($pen); 
	my $brush=Wx::Brush->new(wxRED, wxSOLID); 
	$dc->SetBrush($brush); 
	$dc->DrawBitmap($bitmap, 30, 100, 1); 
}
