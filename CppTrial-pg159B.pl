#!/usr/bin/perl

# CppTrial-pg159B.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 159B - Logical Functions  - Extends pg 135 example
# C++ Example from pg 135 - Drawing on Windows with wxPaintDC
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/24/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg159B.pl',
		           wxDefaultPosition, wxDefaultSize);
EVT_MOTION($frame,\&OnMotion,);
$frame->Show;
$app->MainLoop;

# Example specific code
sub OnMotion {
	my ( $self, $event) = @_;

		my $dc = Wx::PaintDC->new($self);
		
		my $pen = Wx::Pen->new(wxBLACK,1,wxSOLID);
		$dc->SetPen($pen);
		my $brush=Wx::Brush->new(wxRED,wxSOLID);
		$dc->SetBrush($brush);
		
		$dc->SetLogicalFunction(wxINVERT);	# Invert Pixels
		$dc->DrawCircle(200, 200, 50);		# Circle appears and erases as mouse moves
		
}
