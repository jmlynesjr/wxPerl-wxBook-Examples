#!/usr/bin/perl

# CppTrial-pg283.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 283 - Drawing a masked image
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_PAINT);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg283.pl',
		           wxDefaultPosition, wxDefaultSize);
EVT_PAINT($frame,\&OnPaint);
$frame->Show;
$app->MainLoop;

# Example specific code
sub OnPaint {
	my ( $self, $event) = @_;

		my $memdc = Wx::MemoryDC->new();
		
		my $bitMap = Wx::Bitmap->new(400,400);
		$memdc->SelectObject($bitMap);
		
		my $brush1 = Wx::Brush->new(wxBLUE, wxSOLID);
		$memdc->SetBackground($brush1);
		$memdc->Clear();					# Fill DC with background brush color
		
		my $pen1 = Wx::Pen->new(wxRED,1,wxSOLID);
		$memdc->SetPen($pen1);
		 my $brush2 = Wx::Brush->new(wxRED,wxSOLID);
		$memdc->SetBrush($brush2);
		$memdc->DrawRectangle(50, 50, 200, 200);		# Red rectangle on blue background

		
		my $image = $bitMap->ConvertToImage();
		$image->SetMaskColour(255, 0, 0);
		$image->SetMask(1);
		
#		my $dispBitMap = Wx::Bitmap->new($image, -1);		# Constructor not supported by wxPerl		
#		$dc->DrawBitmap($dispBitMap, 0, 0, 1);			# Can't display $image	
#
#		Code added for display purposes - many book examples are only fragments
#
		my $bmp = Wx::Bitmap->new("test2.bmp", wxBITMAP_TYPE_BMP);
		$bmp->SetMask(Wx::Mask->new($bmp, wxBLUE));
#		Wx:StaticBitMap->new($memdc, -1, $bmp, [300,120]);

		my $dcPaint = Wx::PaintDC->new($self);
		$dcPaint->Blit(0, 0, 400, 400, $memdc, 0, 0, wxCOPY, 1);
		
		$memdc->SelectObject(wxNullBitmap);
		
}
