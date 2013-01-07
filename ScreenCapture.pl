#! /usr/bin/perl
#
# Capture Screen to a file. Written in wxPerl. Tested on Citrus Perl 5.16 and wxWidgets 2.8.x.
#
#           This script draws and captures a sample graphic.
#	    Take_Screenshot needs to be generalized into a module
#	    that can be used by any application.
#
#	    To capture the complete sample graphic, the frame size had to be set to the screen size
#	    of [1024x768]. Using wxDefaultSize caused the screen to paint in two passes
#	    and the capture to clip.
#
# Reference: GetScreenShot C++ code page 139 of "The wxBook" - 
#            Cross-Platform GUI Programming with wxWidgets - 
#            Smart, Hock, and Csomor
#
# Original author: "PodMaster" from Perl Monks-2003 (no idea of real identity-not active for 6+ years)
#
# Modified by: James M. Lynes. Jr.
# Last Modified Date: October 21, 2012
#
#
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw( EVT_PAINT );
#
# Main Application
#
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1, "Screen Capture Example", [0,0], [1024,768] , wxDEFAULT_FRAME_STYLE);
EVT_PAINT( $frame, \&onPaint);
my $file = file_entry_dialog_standard($frame);
$frame->Show;
take_screenshot($frame, $file);
$app->MainLoop;
#
# Generate a sample graphic screen to capture
#
sub onPaint{
    my($self,$event)=@_;
    my $screen = Wx::PaintDC->new($self);
    $screen->SetBackgroundMode( wxTRANSPARENT ); 
    $screen->SetFont(Wx::Font->new( 12, wxFONTFAMILY_ROMAN, wxNORMAL, wxBOLD));

        for(0..17){
            my $c = $_ * 15;

                $screen->SetTextForeground( Wx::Colour->newRGB(0,0,$c));
                $screen->DrawRotatedText("wxPerl",100 ,100 ,$c);
	}
                $screen->DrawRotatedText("wxPerl and PodMaster",000 ,400 ,0);
                $screen->DrawRotatedText("are messing up your screen",000 ,450 ,0);

        for(0..17){
            my $c = $_ * 15;

                $screen->SetTextForeground( Wx::Colour->newRGB(0,$c,0));
                $screen->DrawRotatedText("wxPerl",200 ,200 ,$c);
	}
                $screen->DrawRotatedText("wxPerl and PodMaster",100 ,500 ,0);
                $screen->DrawRotatedText("are messing up your screen",100 ,550 ,0);

        for(0..17){
            my $c = $_ * 15;

                $screen->SetTextForeground( Wx::Colour->newRGB($c,0,0));
                $screen->DrawRotatedText("wxPerl",300 ,300 ,$c);
	}
                $screen->DrawRotatedText("wxPerl and PodMaster",200 ,600 ,0);
                $screen->DrawRotatedText("are messing up your screen",200 ,650 ,0);
}
#
# Copy the screen to the output file-similar to wxBook pg 139 example.
#
sub take_screenshot {
    my($self, $file ) = @_;
    $self->Refresh;						# without Refresh and Update
    $self->Update;						# the underlying window is captured
    my $screen = Wx::ScreenDC->new();
    my( $x, $y) = $screen->GetSizeWH();
    my $bitmap = Wx::Bitmap->new($x,$y,-1);
    my $memory = Wx::MemoryDC->new();
    $memory->SelectObject( $bitmap );
    $memory->Blit(0,0,$x,$y, $screen, 0, 0);			# copy the screen to the bitmap
    $bitmap->SaveFile( $file , wxBITMAP_TYPE_BMP ) ;		# copy the bitmap to the output file
}
#
# Ask for the output filename - simple text entry dialog
#
sub file_entry_dialog_simple {
  my( $self ) = @_;
  my $textvalue = "capture.bmp";
  my $dialog = Wx::TextEntryDialog->new
    ( $self, "Enter the Screen Capture output filename\n(Cancel will use the default filename shown below)\n",
      "Screen Capture Output File Entry",
      $textvalue, wxOK | wxCANCEL );
  if( $dialog->ShowModal == wxID_OK ) {
      $textvalue = $dialog->GetValue;
  }
  $dialog->Destroy;
  return $textvalue;
}
#
# Ask for the output filename - standard file dialog
#
sub file_entry_dialog_standard {
	my ( $self ) = @_;
	my $caption = "Choose a Screen Capture Output Filename";
	my $wildcard = "*.bmp";
	my $defaultDir = ".";
	my $defaultFilename = "capture.bmp";
	my $filevalue = $defaultFilename;	
	my $fileDialog = Wx::FileDialog->new($self, $caption, $defaultDir, 
			 $defaultFilename, $wildcard, wxFD_SAVE | wxFD_OVERWRITE_PROMPT);			 
	if ($fileDialog->ShowModal() == wxID_OK ) {
	$filevalue =  $fileDialog->GetPath();
	}
 	$fileDialog->Destroy;
 	return $filevalue;	
}
