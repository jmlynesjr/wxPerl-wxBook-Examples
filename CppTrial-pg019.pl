#!/usr/bin/perl

# CppTrial-pg019.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 19 - Create a basic frame with menus and status bar
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;

use Wx qw(:everything);
use Wx::Event qw(EVT_MOTION);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg19.pl',
		            wxDefaultPosition, wxDefaultSize);
$frame->Show;

# Example specific code
	my $cutIcon = Wx::Icon->new( "cut.xpm", wxBITMAP_TYPE_XPM, -1, -1);
	$frame->SetIcon($cutIcon);

	my $fileMenu = Wx::Menu->new();
	my $helpMenu = Wx::Menu->new();
	
	$fileMenu->Append(wxID_EXIT, "E&xit\tAlt-X", "Quit This Program");
	$helpMenu->Append(wxID_ABOUT, "&About...\tF1", "Show About Dialog");
	
	my $menuBar = Wx::MenuBar->new();
	$menuBar->Append($fileMenu, "&File");
	$menuBar->Append($helpMenu, "&Help");
	
	$frame->SetMenuBar($menuBar);
	
	my $statusBar = Wx::StatusBar->new($frame, wxID_ANY, wxST_SIZEGRIP);
	$frame->SetStatusBar($statusBar);
	$statusBar->SetStatusText("Welcome to wxWidgets!", 0);
$app->MainLoop;
