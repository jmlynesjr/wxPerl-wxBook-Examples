#!/usr/bin/perl

# CppTrial-pg086.pl
# Cross-Platform GUI Programming with wxWidgets - Smart, Hock, & Csomor
# C++ Example from pg 86 - 20 Assorted Static & Non-Static Controls Examples
# Several small examples combined into one source file covers pg86 - pg116
# Ported to wxPerl by James M. Lynes Jr. - Last Modified 9/23/2012

use 5.010;
use strict;
use warnings;
use Wx qw(:everything);

# create the WxApplication
my $app = Wx::SimpleApp->new;
my $frame = Wx::Frame->new(undef, -1,
		           'CppTrial-pg086.pl',
		           wxDefaultPosition, Wx::Size->new(500,700));
assortedControls($frame);
$frame->Show;
$app->MainLoop;

# Example specific code
sub assortedControls {
	my ( $self ) = @_;

# Create a panel to place all of the controls on	
	my $panel= Wx::Panel->new($self, wxID_ANY, wxDefaultPosition, wxDefaultSize);
	
# pg86----- Plain Button	
	my $button = Wx::Button->new($panel, wxID_OK, "Ok",
		     Wx::Point->new(10, 10), wxDefaultSize);
	
# pg89----- Bitmap Button
	my $bmp1 = Wx::Bitmap->new("print.xpm", wxBITMAP_TYPE_XPM);
	my $picButton = Wx::BitmapButton->new($panel, wxID_OK, $bmp1,
			Wx::Point->new(150, 10), wxDefaultSize, wxBU_AUTODRAW);
			 
# pg91----- Choice Control
	my $ID_CHOICEBOX = 1;
	my @strings1 = ("One", "Two", "Three", "Four", "Five");
	my $choice = Wx::Choice->new($panel, $ID_CHOICEBOX,
		     Wx::Point->new(250, 10), wxDefaultSize, \@strings1);

# pg92----- ComboBox Control
	my $ID_COMBOBOX = 2;
	my @strings2 = ("Apple", "Orange", "Pear", "Grapefruit");
	my $combo = Wx::ComboBox->new($panel, $ID_COMBOBOX, "Apple",
		    Wx::Point->new(10,50), wxDefaultSize, \@strings2, wxCB_DROPDOWN);
		    
# pg94----- CheckBox Control
	my $ID_CHECKBOX = 3;
	my $checkBox = Wx::CheckBox->new($panel, $ID_CHECKBOX, "&Check Me",
		       Wx::Point->new(10,200), wxDefaultSize);
	$checkBox->SetValue(1);
	
# pg95----- ListBox Control
	my $ID_LISTBOX = 4;
	my @strings3 = ("First String", "Second String", "Third String",
		        "Fourth String", "Fifth String", "Sixth String");
	my $listbox = Wx::ListBox->new($panel, $ID_LISTBOX,
		      Wx::Point->new(200,200), Wx::Size->new(180,80),
		      \@strings3, wxLB_SINGLE);

# pg96----- CheckListBox Control
	my $ID_CHECKLISTBOX = 5;
	my @strings4 = ("1st String", "2nd String", "3rd String",
		        "4th String", "5th String", "6th String");
	my $checklistbox = Wx::CheckListBox->new($panel, $ID_CHECKLISTBOX,
		           Wx::Point->new(200,300), Wx::Size->new(180,80),
		           \@strings4, wxLB_SINGLE);

# pg99----- RadioBox Control
	my $ID_RADIOBOX = 6;
	my @strings5 = ("&One", "&Two", "T&hree", "&Four", "F&ive","&Six");
	my $radiobox = Wx::RadioBox->new($panel, $ID_RADIOBOX, "RadioBox",
		       Wx::Point->new(10,300), wxDefaultSize, \@strings5,
		       3, wxRA_SPECIFY_COLS);

# pg101---- Radio Button Control (Spacing forced for display purposes - Sizers want to use whole window)
	my $ID_RADIOBUTTON1 = 7;
	my $ID_RADIOBUTTON2 = 8;
	my $radioButton1 = Wx::RadioButton->new($panel, $ID_RADIOBUTTON1,
			   "&Male", Wx::Point->new(10,400), wxDefaultSize, wxRB_GROUP);
	$radioButton1->SetValue(1);
	my $radioButton2 = Wx::RadioButton->new($panel, $ID_RADIOBUTTON2,
			   "&Female", Wx::Point->new(75,400));
	my $topSizer = Wx::BoxSizer->new(wxHORIZONTAL);
	my $boxSizer = Wx::BoxSizer->new(wxHORIZONTAL);
	$boxSizer->Add($radioButton1, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
	$boxSizer->Add($radioButton2, 0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
#	$topSizer->Add($boxSizer,  0, wxALIGN_CENTER_VERTICAL | wxALL, 5);
#	$self->SetSizer($topSizer);

# pg102---- ScrollBar Control
	my $ID_SCROLLBAR = 9;
	my $scrollbar = Wx::ScrollBar->new($panel, $ID_SCROLLBAR,
			Wx::Point->new(10,450), Wx::Size->new(200,20), wxSB_HORIZONTAL);

# pg103---- Spin Button Control
	my $ID_SPINBUTTON = 10;
	my $spinbutton = Wx::SpinButton->new($panel, $ID_SPINBUTTON,
			 Wx::Point->new(330,400), wxDefaultSize, wxSP_VERTICAL);

# pg105---- Spin Control
	my $ID_SPINCONTROL = 11;
	my $spincontrol = Wx::SpinCtrl->new($panel, $ID_SPINCONTROL, "5",
			  Wx::Point->new(250,450), wxDefaultSize,
			  wxSP_ARROW_KEYS, 0, 100, 5);
			  
# pg106---- Slider Control
	my $ID_SLIDERCONTROL = 12;
	my $slidercontrol = Wx::Slider->new($panel, $ID_SLIDERCONTROL, 16, 0, 40,
			    Wx::Point->new(10,500), Wx::Size->new(200, -1),
			    wxSL_HORIZONTAL | wxSL_AUTOTICKS | wxSL_LABELS);

# pg108---- Text Control (w/pg109 also)
	my $ID_TEXTCONTROL = 13;
	my $textcontrol = Wx::TextCtrl->new($panel, $ID_TEXTCONTROL, "",
			  Wx::Point->new(250,500), Wx::Size->new(240, 100),
			  wxTE_MULTILINE);
	$textcontrol->SetDefaultStyle(Wx::TextAttr->new(wxRED));
	$textcontrol->AppendText("Red Text\n");
	$textcontrol->SetDefaultStyle(Wx::TextAttr->new(wxNullColour, wxLIGHT_GREY));
	$textcontrol->AppendText("Red on Gray Text\n");
	$textcontrol->SetDefaultStyle(Wx::TextAttr->new(wxBLUE));
	$textcontrol->AppendText("Blue on Gray Text\n");

# pg111---- Toggle Button
	my $ID_TOGGLEBUTTON = 14;
	my $togglebutton = Wx::ToggleButton->new($panel, $ID_TOGGLEBUTTON, "&Toggle Button",
			   Wx::Point->new(10,550), wxDefaultSize);
	$togglebutton->SetValue(1);

# pg112---- Guage Control
	my $ID_GAUGE = 15;
	my $gauge = Wx::Gauge->new($panel, $ID_GAUGE, 200,
		    Wx::Point->new(10,600), wxDefaultSize, wxGA_HORIZONTAL);
	$gauge->SetValue(50);
	
# pg113---- Static Text Control
	my $ID_STATICTEXT = 16;
	my $statictext = Wx::StaticText->new($panel, $ID_STATICTEXT,
			 "This is my &static text label",
			 Wx::Point->new(250,600), wxDefaultSize, wxALIGN_LEFT);	

# pg114---- Static Bitmap Control
	my $ID_STATICBITMAP = 17;
	my $bmp2 = Wx::Bitmap->new("print.xpm", wxBITMAP_TYPE_XPM);
	my $staticbitmap = Wx::StaticBitmap->new($panel, $ID_STATICBITMAP, $bmp2,
			   Wx::Point->new(175, 600), wxDefaultSize);

# pg115---- Static Line Control
	my $ID_STATICLINE = 18;
	my $staticline = Wx::StaticLine->new($panel, $ID_STATICLINE,
			 Wx::Point->new(10, 650), Wx::Size->new(450,-1),
			 wxLI_HORIZONTAL);

# pg116---- Static Box Control
	my $ID_STATICBOX = 19;
	my $staticbox = Wx::StaticBox->new($panel, $ID_STATICBOX,
			"&Static Box",
			Wx::Point->new(350, 10), Wx::Size->new(100, 100));
}
