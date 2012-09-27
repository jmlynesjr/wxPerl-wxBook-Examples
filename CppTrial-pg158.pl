#!/usr/bin/perl

# CppTrial-pg158.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 158 - Copy(Tile) Bitmaps Between Device Contexts - Extends pg 157 example
# C++ Example from pg 157 - Drawing Bitmaps - Extends pg 150 example
# C++ Example from pg 150 - Drawing Text -    Extends pg 135 example
# C++ Example from pg 135 - Drawing on Windows with wxPaintDC
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
Wx::InitAllImageHandlers();
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg158.pl',
		           wxDefaultPosition, wxDefaultSize);
EVT_PAINT($frame,\&OnPaint);
$frame->Show;
$app->MainLoop;

# Example specific code
sub OnPaint {
	my ( $self, $event) = @_;

		my $dcPaint = Wx::PaintDC->new($self);		#OnPaint Event Requires a PaintDC
		my $dcSource = Wx::MemoryDC->new();
		my $dcDest = Wx::MemoryDC->new();
			
		my $destWidth = 350;
		my $destHeight = 400;
		my $bmpDest = Wx::Bitmap->new($destWidth, $destHeight);
		my $bmpSource = Wx::Bitmap->new("padre_logo_64x64.png", wxBITMAP_TYPE_PNG);
		my $sourceWidth = $bmpSource->GetWidth();
		my $sourceHeight = $bmpSource->GetHeight();
		$dcDest->SelectObject($bmpDest);
		$dcDest->SetBackground(wxWHITE_BRUSH);
		$dcDest->Clear();
		$dcSource->SelectObject($bmpSource);
		
		
		for (my $i = 0; $i < $destWidth; $i += $sourceWidth)
			{
			for (my $j = 0; $j < $destHeight; $j += $sourceHeight)
			{
				$dcDest->Blit($i, $j, $sourceWidth, $sourceHeight, $dcSource, 0, 0, wxCOPY, 1);
			}
			}
			
		$dcPaint->Blit(0,0,$destWidth,$destHeight,$dcDest,0,0,wxCOPY,1);	#Copy to PaintDC for display
			
		$dcDest->SelectObject(wxNullBitmap);
		$dcSource->SelectObject(wxNullBitmap);
		

		return;
		
}
