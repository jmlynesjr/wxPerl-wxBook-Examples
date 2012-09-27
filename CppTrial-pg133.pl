#!/usr/bin/perl

# CppTrial-pg133.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 133 - Drawing on Windows with wxClientDC
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);
use Wx::Event qw(EVT_MOTION);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg133.pl',
		           wxDefaultPosition, wxDefaultSize,);
EVT_MOTION($frame,\&OnMotion);
$frame->Show;
$app->MainLoop;

# Example specific code
sub OnMotion {
	my ( $self, $event) = @_;
	if($event->Dragging) {				# True if mouse button pressed & mouse moving
		my $dc = Wx::ClientDC->new($self);
		my $pen = Wx::Pen->new(wxRED,1,wxSOLID);
		$dc->SetPen($pen);
		$dc->DrawPoint($event->GetPosition->x,$event->GetPosition->y);
		$dc->SetPen(wxNullPen);
	}
}
