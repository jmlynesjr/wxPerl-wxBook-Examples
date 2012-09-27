#!/usr/bin/perl

# CppTrial-pg073.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 73 - Notebook Example
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg073.pl',
		           wxDefaultPosition, wxDefaultSize);
Wx::InitAllImageHandlers();
Notebook($frame);
$frame->Show;
$app->MainLoop;

#Example specific code
sub Notebook {
	my ( $self ) = @_;
	
	my $noteBook = Wx::Notebook->new($self, -1, wxDefaultPosition, wxDefaultSize);
	
	my $imageList = Wx::ImageList->new(16, 16, 1, 3);
	
	my $cutxpm = Wx::Bitmap->new( "cut.xpm", wxBITMAP_TYPE_XPM );	
	my $copyxpm = Wx::Bitmap->new( "copy.xpm", wxBITMAP_TYPE_XPM );
	my $printxpm = Wx::Bitmap->new( "print.xpm", wxBITMAP_TYPE_XPM );
	
	$imageList->Add($cutxpm);
	$imageList->Add($copyxpm);
	$imageList->Add($printxpm);
	
	$noteBook->SetImageList($imageList);
	
	my $window1 = Wx::Panel->new($noteBook, wxID_ANY);
	my $window2 = Wx::Panel->new($noteBook, wxID_ANY);
	my $window3 = Wx::Panel->new($noteBook, wxID_ANY);
	
	$noteBook->AddPage($window1, "Tab One", 1, 0);
	$noteBook->AddPage($window2, "Tab Two", 0, 1);
	$noteBook->AddPage($window3, "Tab Three", 0, 2);			
}


