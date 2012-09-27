A Compilation of wxPerl Ports of the C++ Examples from "The wxBook"
---------------------------------------------------------------------------------
Ported and compiled by James M. Lynes, Jr. April-May 2011 & August-September 2012.

Major Modifications implemented in September 2012. Setup code for each example was
greatly simplified using wx::SimpleApp as suggested by Mattia Barbon.

Introduction
------------
While I have many years in real-time control system software development, I am new to
Ubuntu, Perl, and wxPerl. It is probably best to not try to learn all of these at the
same time, but that's where I am at.

I purchased a copy of "The wxBook" - "Cross-Platform GUI Programming with wxWidgets"
by Smart, Hock, & Csomar. After two complete read-throughs, I downloaded a copy of
wxIndustrialControls(Appendix E - www.koansoftware.com) and began a port of their
LCD Display program. I soon realized that I did not understand enough about the 
relationship between C++ and wxPerl to complete this port.

To get past this learning curve I decided to port the C++ examples from the wxBook
to wxPerl. Over 45 examples have been ported so far. Each port was kept as close
to the C++ example code as possible. However, changes were made where required
by differences in wxPerl syntax or implementation. Also, code
was added where necessary to provide screen output of the example topic.

The examples were coded to be clear to someone new to wxPerl(like myself) and it
is not my desire to trade clarity for efficiency. I believe in coding for the next
guy that has to maintain my code - KISS. Almost all programs deal with a single topic
unlike some of the other examples available on-line. The single topic implementation
should be easier for a beginner to grasp. I think this style would have shortened
my learning process. An exception is CppTrial-pg086.pl which consists of 20 short
Static and Non-Static Control examples. Most of these are 3-4 lines long and
don't need to be discussed individually.

As much as possible the setup code was kept the same from example to example. The
specific example code was isolated to a subroutine in the bottom half of the
program. These example code subroutines were called directly and via OnPaint and
OnMotion events as necessary to generate screen output of the example results. 
You will notice that the setup code did evolve somewhat as the porting
progressed(and has since evolved more). An example of the learning curve in action!


Lessons Learned
---------------
The 2300+ page wx.pdf manual is hard to use on my relatively slow Thinkpad R31. The
search feature is so slow as to be unusable. So, page through the index to find your
topic, add 28(+/-) to the page number, then jump directly to that page.

Not all features in wxwidgets are implemented in wxPerl. Look for wxPerl specific
notes in wx.pdf. A digest of all of these notes would be useful.

wxwidgets features that use "wxArraySomething" will instead use a wxPerl list - @list
or a list reference \@list or array syntax [x,y].

use Wx qw(:everything) doesn't really load all modules- like the Grid, HTML and Clipboard
modules. Substantial time can be spent locating the module that exports the function
that you need. It would be nice to have an index of all the modules and their
exporters, as well as all constant definitions. Any input on this topic would be welcome.

Case matters! C++ wxFunction() becomes wxPerl Wx::Function->new(). wx is not Wx.
WxFunction is not Wx::Function. Typos will cause module loading errors.

The PADRE debugger locks up from time to time. Save your work often.


Porting Environment
-------------------
All porting was done using Ubuntu 10.10, Perl 5.10.1, and the PADRE IDE. Modifications
were done with gedit.


RESOURCES
---------
These resources were found to be useful in porting the wxBook examples. Many thanks
to their authors.

"Cross-Platform GUI Programming with wxWidgets" Smart, Hock, & Csomar - The "wxBook"
(Buy this book! It's well worth the cost)

"Learning Perl" - Schwartz, Phoenix, & d Foy

"Programming Perl" - Christiansen, d Foy, Wall, & Orwant

"Perl Cookbook" - Christiansen & Torkington

perldoc (perldoc perltoc) - On-line Man Pages

"wxWidgets 2.8.10: A Portable C++ and Python GUI Toolkit"
	Smart, Roebling, Zeitlin, Dunn et. al. - PDF Format (Wx.pdf)

"wxWidgets 2.8.7: A Portable C++ and Python GUI Toolkit"
	Smart, Roebling, Zeitlin, Dunn et. al. - HTML Format(many files)

Numerous Demo and Example Programs by Mattia Barbon - (Sourceforge.net)

Tutorials from the Perl Monks (
www.perlmonks.org)
	Three by Boo Radley
	A Simple Socket Server Using "inetd" - Samizdat

Tutorials from the wxPerl Wiki:
	C++ Docs for Perl Programmers
	WxPerl Tablet (i.e. The Cheat-sheet)
	Download with Progress Bar
	Memory DC
	Mini Image Demo
	Tiled Background Image
	wxPerl GUI for a Twitter Script

The PADRE IDE and Included Sample Programs

www.perlmonks.org

wxperl.sourceforge.net

wiki.wxperl.info

www.wxwidgets.org

www.perl.org

www.nntp.perl.org/group/perl.wxperl.users/2012/

search.cpan.org

And others that were read, but the references were not recorded....

Original version uploaded to www.perlmonks.org August 2012 - two large files.
(This) github initial version uploaded September 2012 - separate files.

I hope you find this information useful.

James M. Lynes, Jr.  -  Lakeland, Florida September 2012


