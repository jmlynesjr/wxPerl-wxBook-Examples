#! /home/pete/CitrusPerl/perl/bin/perl

# LM3.pl - wxPerl Process Control Example
#          uses the LinearMeter3.pm modular meter
#
# Last modified by James M. Lynes, Jr - January 30,2013
#
# Draws and animates 8 Linear Meters, uses LinearMeter3.pm
# Meters change green/red to indicate limit violations
# Creates a 1 second timer to update the animation
# Left click selects/deselects the meter and sets the border to yellow/blue
# Right click on a selected meter pops a limit change dialog
# Right click on a deselected meter pops an error messsage box
# Multiple meters may be selected at the same time - may want to limit
#   this in the future.
#
# The panel is created 40 units longer than the meter to allow space
# for drawing the meter label
#

package main;
use strict;
use warnings;
my $app = App->new();
$app->MainLoop;

package App;
use strict;
use warnings;
use base 'Wx::App';
sub OnInit {
    my $frame = Frame->new();
    $frame->Show(1);
}

package Frame;
use strict;
use warnings;
use Wx qw(:everything);
use base qw(Wx::Frame);
use LinearMeter3;
use Data::Dumper;
use Wx::Event qw(EVT_PAINT EVT_TIMER EVT_LEFT_DOWN EVT_RIGHT_DOWN);

sub new {
    my ($self) = @_;
    my($meters, $width, $height) = (8, 100, 550);
    $self = $self->SUPER::new(undef, -1, "wxPerl Process Control Example", wxDefaultPosition,
                              [(($meters)+1)*10+20 + (($meters)*$width),($height+90)]);
    my $font = Wx::Font->new(12, wxFONTFAMILY_SWISS, wxNORMAL, wxBOLD);
    $self->SetFont($font);
    Wx::StaticText->new($self, -1, "Boiler 1", [190, 15], wxDefaultSize, wxALIGN_LEFT);
    Wx::StaticText->new($self, -1, "Boiler 2", [650, 15], wxDefaultSize, wxALIGN_LEFT);
 
# Create 8 panels to hold 8 meters - single row layout
    $self->{MP1} = Wx::Panel->new($self, wxID_ANY, [10 ,40], [$width, $height+40]);
    $self->{MP2} = Wx::Panel->new($self, wxID_ANY, [($width*1)+20 ,40], [$width, $height+40]);
    $self->{MP3} = Wx::Panel->new($self, wxID_ANY, [($width*2)+30 ,40], [$width, $height+40]);
    $self->{MP4} = Wx::Panel->new($self, wxID_ANY, [($width*3)+40 ,40], [$width, $height+40]);
    $self->{MP5} = Wx::Panel->new($self, wxID_ANY, [($width*4)+70 ,40], [$width, $height+40]);
    $self->{MP6} = Wx::Panel->new($self, wxID_ANY, [($width*5)+80 ,40], [$width, $height+40]);
    $self->{MP7} = Wx::Panel->new($self, wxID_ANY, [($width*6)+90 ,40], [$width, $height+40]);
    $self->{MP8} = Wx::Panel->new($self, wxID_ANY, [($width*7)+100 ,40], [$width, $height+40]);

# Create 8 meter objects - Override some default values
    $self->{LM1} = LinearMeter->new();
        $self->{LM1}->InitialValue(73);
        $self->{LM1}->Limit(76);
        $self->{LM1}->Label("Temp 1");
        $self->{LM1}->MeterHeight($height);
        $self->{LM1}->MeterWidth($width);
    $self->{LM2} = LinearMeter->new();
        $self->{LM2}->InitialValue(28);
        $self->{LM2}->Limit(31);
        $self->{LM2}->Label("Flow 1");
        $self->{LM2}->MeterHeight($height);
        $self->{LM2}->MeterWidth($width);
    $self->{LM3} = LinearMeter->new();
        $self->{LM3}->InitialValue(42);
        $self->{LM3}->Limit(46);
        $self->{LM3}->Label("Pressure 1");
        $self->{LM3}->MeterHeight($height);
        $self->{LM3}->MeterWidth($width);
    $self->{LM4} = LinearMeter->new();
        $self->{LM4}->InitialValue(62);
        $self->{LM4}->Limit(66);
        $self->{LM4}->Label("Level 1");
        $self->{LM4}->MeterHeight($height);
        $self->{LM4}->MeterWidth($width);
    $self->{LM5} = LinearMeter->new();
        $self->{LM5}->InitialValue(24);
        $self->{LM5}->Limit(28);
        $self->{LM5}->Label("Temp 2");
        $self->{LM5}->MeterHeight($height);
        $self->{LM5}->MeterWidth($width);
    $self->{LM6} = LinearMeter->new();
        $self->{LM6}->InitialValue(63);
        $self->{LM6}->Limit(66);
        $self->{LM6}->Label("Flow 2");
        $self->{LM6}->MeterHeight($height);
        $self->{LM6}->MeterWidth($width);
    $self->{LM7} = LinearMeter->new();
        $self->{LM7}->InitialValue(33);
        $self->{LM7}->Limit(37);
        $self->{LM7}->Label("Pressure 2");
        $self->{LM7}->MeterHeight($height);
        $self->{LM7}->MeterWidth($width);
    $self->{LM8} = LinearMeter->new();
        $self->{LM8}->InitialValue(81);
        $self->{LM8}->Limit(85);
        $self->{LM8}->Label("Level 2");
        $self->{LM8}->MeterHeight($height);
        $self->{LM8}->MeterWidth($width);
#
# Set up Event Handlers -------------------------------------------------------
#
# Timer
    my $timer = Wx::Timer->new( $self );
    $timer->Start( 1000 );					# 1 second period
    EVT_TIMER($self, -1, \&onTimer);
# Paint
    EVT_PAINT($self, \&onPaint);
# Mouse
    EVT_LEFT_DOWN($self->{MP1}, sub{$self->_evt_left_down( $self->{LM1}, @_);});
    EVT_LEFT_DOWN($self->{MP2}, sub{$self->_evt_left_down( $self->{LM2}, @_);});
    EVT_LEFT_DOWN($self->{MP3}, sub{$self->_evt_left_down( $self->{LM3}, @_);});
    EVT_LEFT_DOWN($self->{MP4}, sub{$self->_evt_left_down( $self->{LM4}, @_);});
    EVT_LEFT_DOWN($self->{MP5}, sub{$self->_evt_left_down( $self->{LM5}, @_);});
    EVT_LEFT_DOWN($self->{MP6}, sub{$self->_evt_left_down( $self->{LM6}, @_);});
    EVT_LEFT_DOWN($self->{MP7}, sub{$self->_evt_left_down( $self->{LM7}, @_);});
    EVT_LEFT_DOWN($self->{MP8}, sub{$self->_evt_left_down( $self->{LM8}, @_);});

    EVT_RIGHT_DOWN($self->{MP1}, sub{$self->_evt_right_down( $self->{LM1}, @_);});
    EVT_RIGHT_DOWN($self->{MP2}, sub{$self->_evt_right_down( $self->{LM2}, @_);});
    EVT_RIGHT_DOWN($self->{MP3}, sub{$self->_evt_right_down( $self->{LM3}, @_);});
    EVT_RIGHT_DOWN($self->{MP4}, sub{$self->_evt_right_down( $self->{LM4}, @_);});
    EVT_RIGHT_DOWN($self->{MP5}, sub{$self->_evt_right_down( $self->{LM5}, @_);});
    EVT_RIGHT_DOWN($self->{MP6}, sub{$self->_evt_right_down( $self->{LM6}, @_);});
    EVT_RIGHT_DOWN($self->{MP7}, sub{$self->_evt_right_down( $self->{LM7}, @_);});
    EVT_RIGHT_DOWN($self->{MP8}, sub{$self->_evt_right_down( $self->{LM8}, @_);});
    return $self;
}
1;
#
# Right Mouse Pressed Event - Change the Selected Meter's Limit -----------------
#
sub _evt_right_down {
    my($frame, $meter, $panel, $event) = @_;
    if($meter->Selected()) {
        my $label = $meter->Label();
        my $dialog = Wx::TextEntryDialog->new( $frame,
                     "Select a New Limit", "Change the  $label  Alarm Limit",
                     $meter->Limit());
        if($dialog->ShowModal == wxID_CANCEL) {
            $meter->BorderColour(wxBLUE);
            $meter->Selected(0);
            return;
        };
        $meter->Limit($dialog->GetValue());
        $meter->BorderColour(wxBLUE);
        $meter->Selected(0);
    }
    else {
        my $msg = Wx::MessageBox("No Meter Selected\nLeft Click a Meter to Select",
                 "Meter Limit Entry Error", wxICON_ERROR, $frame);    
    }
    $event->Skip(1);
}
#
# Left Mouse Pressed Event - Selects a Meter - Selection will Toggle -----------
#
sub _evt_left_down {
    my($frame, $meter, $panel, $event) = @_;
    if($meter->Selected()) {
        $meter->BorderColour(wxBLUE);
        $meter->Selected(0);
    }
    else {
    $meter->BorderColour(Wx::Colour->new("yellow"));        
    $meter->Selected(1);
    }
    $event->Skip(1);
}

# Simple version of Event Handler Closure
#    More complex version fits better for this application
#    EVT_LEFT_DOWN($self->{MP1}, sub{
#        my($panel, $event) = @_;
#        $self->{LM1}->BordorColour(Wx::Colour->new("yellow"));
#        $event->Skip(1);
#    });

#
# 1 second timer to simulate meter movement ---------------------------------
#
sub onTimer {
    my($self, $event) = @_;
								# Randomize for each meter
								# for a more natural look
    my $dir = (rand 10) < 5 ? -1 : 1;
    my $inc = (rand 1) * $dir;
    $self->{LM1}->InitialValue($self->{LM1}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP1}, $self->{LM1});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM2}->InitialValue($self->{LM2}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP2}, $self->{LM2});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM3}->InitialValue($self->{LM3}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP3}, $self->{LM3});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM4}->InitialValue($self->{LM4}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP4}, $self->{LM4});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM5}->InitialValue($self->{LM5}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP5}, $self->{LM5});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM6}->InitialValue($self->{LM6}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP6}, $self->{LM6});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM7}->InitialValue($self->{LM7}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP7}, $self->{LM7});

    $dir = (rand 10) < 5 ? -1 : 1;
    $inc = (rand 1) * $dir;
    $self->{LM8}->InitialValue($self->{LM8}->InitialValue() + $inc);
    LinearMeter->Draw($self->{MP8}, $self->{LM8});
}
#
# Paint the Meters ---------------------------------------------------------------------
#
sub onPaint {
    my($self, $event) = @_;
# Draw the 8 meters
    LinearMeter->Draw($self->{MP1}, $self->{LM1});
    LinearMeter->Draw($self->{MP2}, $self->{LM2});
    LinearMeter->Draw($self->{MP3}, $self->{LM3});
    LinearMeter->Draw($self->{MP4}, $self->{LM4});
    LinearMeter->Draw($self->{MP5}, $self->{LM5});
    LinearMeter->Draw($self->{MP6}, $self->{LM6});
    LinearMeter->Draw($self->{MP7}, $self->{LM7});
    LinearMeter->Draw($self->{MP8}, $self->{LM8});
} 

