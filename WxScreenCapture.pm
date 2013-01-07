use strict;
use warnings;

package WxScreenCapture;
use parent qw(Exporter);

our @EXPORT = qw(take_screenshot file_entry_dialog_simple file_entry_dialog_standard);

use Wx qw(:everything);
use Wx::Event qw( EVT_PAINT );

=head2
#
# Copy the screen to the output file-similar to wxBook pg 139 example.
#
=cut
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

=head2
#
# Ask for the output filename - simple text entry dialog
#
=cut
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

=head2
#
# Ask for the output filename - standard file dialog
#
=cut
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
1;
__END__

=head1 NAME

WxScreenCapture.pm

=head1 SYNOPSIS

Module to capture a screen to a file. Written in wxPerl.

=head1 DESCRIPTION

This module exports three subroutines: take_screenshot, file_entry_dialog_simple, and file_entry_dialog_standard. take_screenshot uses Wx::ScreenDC and Wx::MemoryDC device contexts and a Wx::Bitmap. Blit copies the ScreenDC to the MemoryDC Bitmap which is then copied to an output file. file_entry_dialog_simple provides a text_entry_dialog for requesting the capture filename. file_entry_dialog_standard provides the full directory/file entry screen for requesting the capture pathname.

If the frame you wish to capture is smaller than the full screen, the background windows will also be captured.

=head1 USAGE

use Wx qw(:everything);

use Wx::Event qw( EVT_PAINT );

use WxScreenCapture;

my $app = Wx::SimpleApp->new;

my $frame = Wx::Frame->new(undef, -1, "Screen Capture Module Example", [0,0], [1024,768] , wxDEFAULT_FRAME_STYLE);

EVT_PAINT( $frame, \&onPaint);

my $file = file_entry_dialog_standard($frame);

$frame->Show;

take_screenshot($frame, $file);

$app->MainLoop;

sub onPaint{}      #paint the screen to be captured here.

=head1 AUTHOR

James M. Lynes, Jr. <jmlynesjr@gmail.com>

Lakeland, Florida USA October 21,2012.

Original author: "PodMaster" from Perl Monks-2003 (no idea of real identity-not active for 6+ years)

=head1 BUGS/FEATURES

To capture the complete sample graphic(not included in this module definition), the frame size
had to be set to the screen size of [1024x768]. Using wxDefaultSize caused the screen to paint in two passes
and the capture to clip. If the frame is not defined large enough, parts of underlying
windows will also be captured.

=head1 SEE ALSO

"The wxBook" - Cross-Platform GUI Programming with wxWidgets - 
               Smart, Hock, and Csomor

The wxWidgets documentation L<http://www.wxwidgets.org/>

The Citrus Perl Distribution L<http://www.citrusperl.com/>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

