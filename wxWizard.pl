#!/usr/bin/perl

# wxWizard.pl
# Adapted from wxperl_demo.pl from the wxPerl distribution
# James M. Lynes Jr. - Last Modified 1/6/2013

use 5.010;
use strict;
use warnings;

use Wx qw(:everything);
use Wx::Event qw(EVT_WIZARD_PAGE_CHANGED EVT_BUTTON EVT_WIZARD_FINISHED EVT_WIZARD_CANCEL);

# create the WxApplication

my $app = Wx::SimpleApp->new;

    my $frame = Wx::Frame->new( undef, -1,'wxWizard.pl', wxDefaultPosition, wxDefaultSize );

    my $panel = Wx::Panel->new($frame, -1, wxDefaultPosition, wxDefaultSize);
    Wx::StaticText->new($panel, -1, "WxWizard Sample Program", Wx::Point->new(100,100),
                        Wx::Size->new(200,200), wxALIGN_CENTER);

    my $button = Wx::Button->new( $panel, -1, "Start Wizard", Wx::Point->new(150, 225), wxDefaultSize );

    Wx::InitAllImageHandlers();
    my $bmp = Wx::Bitmap->new("logo.png", wxBITMAP_TYPE_PNG);
    my $wizard = Wx::Wizard->new( $panel, -1, "Wizard Example", $bmp );

    # first page
    my $page1 = Wx::WizardPageSimple->new( $wizard );
    Wx::TextCtrl->new( $page1, -1, "First page", wxDefaultPosition, Wx::Size->new(200,25) );

    # second page
    my $page2 = Wx::WizardPageSimple->new( $wizard );
    Wx::TextCtrl->new( $page2, -1, "Second page", wxDefaultPosition, Wx::Size->new(200,25) );

    # third page
    my $page3 = Wx::WizardPageSimple->new( $wizard );
    Wx::TextCtrl->new( $page3, -1, "Third page", wxDefaultPosition, Wx::Size->new(200,25) );

    # fourth page
    my $page4 = Wx::WizardPageSimple->new( $wizard );
    Wx::TextCtrl->new( $page4, -1, "Fourth page", wxDefaultPosition, Wx::Size->new(200,25) );

    Wx::WizardPageSimple::Chain( $page1, $page2 );
    Wx::WizardPageSimple::Chain( $page2, $page3 );
    Wx::WizardPageSimple::Chain( $page3, $page4 );

    EVT_BUTTON( $panel, $button, sub {$wizard->RunWizard( $page1 ); } );
    EVT_WIZARD_CANCEL( $panel, $wizard, sub {Wx::Wizard->Destroy();} );
    EVT_WIZARD_FINISHED($panel, $wizard, sub { Wx::Wizard->Destroy(); } );

#    Testing Messages comment out matching event above
#    EVT_WIZARD_FINISHED($panel, $wizard, sub { Wx::LogMessage( "Wizard Canceled" ); } );
#    EVT_WIZARD_PAGE_CHANGED( $panel, $wizard, sub {Wx::LogMessage( "Wizard page changed" ); } );
#    EVT_WIZARD_CANCEL( $panel, $wizard, sub {Wx::LogMessage( "Wizard Canceled" ); } );

$frame->Show;
$app->MainLoop;
