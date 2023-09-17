$tkdb::VERSION = '2.3';

use strict;
use Data::Dumper;
use Tcl::Tk;

#
# This package is the main_window object for the debugger.  We start
# with the Devel:: prefix because we want to install it with 
# the DB:: package that is required to be in a Devel/ subdir of a 
# directory in the @INC set.  
#
package Devel::tkdb;


=head1 NAME

Devel::tkdb - Perl debugger using a Tcl/Tk GUI

=head1 SYNOPSIS

    perl -d:tkdb myscript.pl

=head1 DESCRIPTION

tkdb is a debugger for perl that uses perl+Tcl/Tk for a user interface.
Features include:

=over 4

=item Hot Variable Inspection (currently disabled)

=item Breakpoint Control Panel

=item Expression List

=item Subroutine Tree

=back

=head1 Usage

To debug a script using tkdb invoke perl like this:

    perl -d:tkdb myscript.pl

=head1 Code Pane

=over 4

=item Line Numbers

Line numbers are presented on the left side of the window. Lines that
have lines through them are not breakable. Lines that are plain text
are breakable. Clicking on these line numbers will insert a
breakpoint on that line and change the line number color to red.
Clicking on the number again will remove the breakpoint.  If you
disable the breakpoint with
the controls on the BrkPt notebook page the color will change to green.

=item Cursor Motion

If you place the cursor over a variable (i.e. $myVar, @myVar, or
%myVar) and pause for a second the debugger will evaluate the current
value of the variable and pop a balloon up with the evaluated
result.

If there is an active selection, the text of that selection will be evaluated.

=back

=head1 Notebook Pane

=over 2

=item Exprs

This is a list of expressions that are evaluated each time the
debugger stops. The results of the expresssion are presented
heirarchically for expression that result in hashes or lists.  Double
clicking on such an expression will cause it to collapse; double
clicking again will cause the expression to expand. Expressions are
entered through B<Enter Expr> entry, or by Alt-E when text is
selected in the code pane.

The B<Quick Expr> entry, will take an expression, evaluate it, and
replace the entries contents with the result.  The result is also
transfered to the 'clipboard' for pasting.

=item Subs

Displays a list of all the packages invoked with the script
heirarchially. At the bottom of the heirarchy are the subroutines
within the packages.  Double click on a package to expand
it. Subroutines are listed by their full package names.

=item BrkPts

Presents a list of the breakpoints current in use. The pushbutton
allows a breakpoint to be 'disabled' without removing it. Expressions
can be applied to the breakpoint.  If the expression evaluates to be
'true' (results in a defined value that is not 0) the debugger will
stop the script.  Pressing the 'Goto' button will set the text pane
to that file and line where the breakpoint is set.  Pressing the
'Delete' button will delete the breakpoint.

=back

=head1 Menus

=head2 File Menu

=over

=item About...

Presents a dialog box telling you about the version of tkdb.  It
recovers your OS name, version of perl, version of Tcl/Tk, and some other
information

=item Open

Presents a list of files that are part of the invoked perl
script. Selecting a file from this list will present this file in the
text window.

=item Save Config...

Prompts for a filename to save the
configuration to. Saves the breakpoints, expressions, eval text and
window geometry. If the name given as the default is used and the
script is reinvoked, this configuration will be reloaded automatically.

=item Restore Config...

Prompts for a filename to restore a configuration saved with
the "Save Config..." menu item.  

=item Goto Line...

Prompts for a line number.  Pressing the "Okay" button sends the window
to the line number entered.

=item Find Text...

Prompts for text to search for.  Options include forward search,
backwards search, and regular expression searching.

=item Quit

Causes the debugger and the target script to exit. 

=back

=head2 Control Menu

=over

=item Run

The debugger allows the script to run to the next breakpoint or until
the script exits.

=item Run To Here

Runs the debugger until it comes to wherever the insertion cursor
in text window is placed.

=item Set Breakpoint

Sets a breakpoint on the line at the insertion cursor.  

=item Clear Breakpoint

Remove a breakpoint on the at the insertion cursor.

=item Clear All Breakpoints

Removes all current breakpoints

=item Step Over

Causes the debugger to step over the next line.  If the line is a
subroutine call it steps over the call, stopping when the subroutine
returns.

=item Step In

Causes the debugger to step into the next line.  If the line is a
subroutine call it steps into the subroutine, stopping at the first
executable line within the subroutine.

=item Return

Runs the script until it returns from the currently executing subroutine.  

=item Restart

Saves the breakpoints and expressions in a temporary file and restarts
the script from the beginning.  CAUTION: This feature will not work
properly with debugging of CGI Scripts.

=item Stop On Warning

When C<-w> is enabled the debugger will stop when warnings such as, "Use
of uninitialized value at undef_warn.pl line N" are encountered.  The debugger
will stop on the NEXT line of execution since the error can't be detected
until the current line has executed.  

This feature can be turned on at startup by adding:

  $DB::tkdb::stop_on_warning = 1 ;

to a .ptkdbrc file

=back

=head2 Data Menu

=over

=item Enter Expression

When an expression is entered in the "Enter Expression:" text box,
selecting this item will enter the expression into the expression
list.  Each time the debugger stops this expression will be evaluated
and its result updated in the list window.

=item Delete Expression

Deletes the highlighted expression in the expression window.

=item Delete All Expressions

Delete all expressions in the expression window.

=item Expression Eval Window

Pops up a two pane window. Expressions of virtually unlimitted length
can be entered in the top pane.  Pressing the 'Eval' button will cause
the expression to be evaluated and its placed in the lower pane. 
Undo is enabled for the text in the upper pane.

HINT:  You can enter multiple expressions by separating them with commas.  

=back

=head2 Stack Menu

Maintains a list of the current subroutine stack each time the
debugger stops. Selecting an item from this menu will set the text in
the code window to that particular subourtine entry point.

=head2 Bookmarks Menu

Maintains a list of bookmarks.  The booksmarks are saved in ~/.ptkdb_bookmarks

=over

=item Add Bookmark

Adds a bookmark to the bookmark list.  

=back

=head1 Options

Here is a list of the current active XResources options. Several of
these can be overridden with environmental variables. Resources can be
added to .Xresources or .Xdefaults depending on your X configuration.
To enable these resources you must either restart your X server or use
the xrdb -override resFile command.  xfontsel can be used to select
fonts.

    /*
    * Perl Tk Debugger XResources.   
    * Note... These resources are subject to change.   
    *
    * Use 'xfontsel' to select different fonts.
    *
    * Append these resource to ~/.Xdefaults | ~/.Xresources
    * and use xrdb -override ~/.Xdefaults | ~/.Xresources
    * to activate them. 
    */

    ptkdb.frame*font: fixed                    /* Menu Bar */
    ptkdb.frame2.frame1.rotext.font: fixed     /* Code Pane */

    ptkdb.toplevel.frame.textundo.font: fixed  /* Eval Expression Entry Window */
    ptkdb.toplevel.frame1.text.font: fixed     /* Eval Expression Results Window */
    ptkdb.toplevel.button.font:  fixed         /* "Eval..." Button */
    ptkdb.toplevel.button1.font: fixed         /* "Clear Eval" Button */
    ptkdb.toplevel.button2.font: fixed         /* "Clear Results" Button */
    ptkdb.toplevel.button3.font: fixed         /* "Clear Dismiss" Button */

=head1 Environmental Variables

=over 4

=item PTKDB_CODE_FONT

Sets the font of the Text in the code pane.

=item PTKDB_EXPRESSION_FONT

Sets the font used in the expression notebook page.

=item PTKDB_EVAL_FONT

Sets the font used in the Expression Eval Window

=item PTKDB_DISPLAY

Sets the X display that the ptkdb window will appear on when invoked.
Useful for debugging CGI scripts on remote systems.  

=item PTKDB_BOOKMARKS_PATH

Sets the path of the bookmarks file.  Default is $ENV{'HOME'}/.ptkdb_bookmarks

=back

=head1 FILES

=head2 .ptkdbrc

If this file is present in ~/ or in the directory where perl is
invoked the file will be read and executed as a perl script before the
debugger makes its initial stop at startup.  There are several 'api'
calls that can be used with such scripts. There is an internal
variable $DB::no_stop_at_start that may be set to non-zero to prevent
the debugger from stopping at the first line of the script.  This is
useful for debugging CGI scripts.

=over 4

=item brkpt($fname, @lines)

Sets breakspoints on the list of lines in $fname.  A warning message
is generated if a line is not breakable.

=item condbrkpt($fname, @($line, $expr) ) 

Sets conditional breakpoints in $fname on pairs of $line and $expr. A
warning message is generated if a line is not breakable.  NOTE: the
validity of the expression will not be determined until execution of
that particular line.

=item brkonsub(@names)

Sets a breakpoint on each subroutine name listed. A warning message is
generated if a subroutine does not exist.  NOTE: for a script with no
other packages the default package is "main::" and the subroutines
would be "main::mySubs".

=item brkonsub_regex(@regExprs)

Uses the list of @regExprs as a list of regular expressions to set breakpoints.  Sets breakpoints 
on every subroutine that matches any of the listed regular expressions.

=back

=head1 NOTES

=head2 Debugging Other perlTk Applications

ptkdb can be used to debug other perlTk applications if some cautions
are observed. Basically, do not click the mouse in the application's
window(s) when you've entered the debugger and do not click in the
debugger's window(s) while the application is running.  Doing either
one is not necessarily fatal, but it can confuse things that are going
on and produce unexpected results.

Be aware that most perlTk applications have a central event loop.
User actions, such as mouse clicks, key presses, window exposures, etc
will generate 'events' that the script will process. When a perlTk
application is running, its 'MainLoop' call will accept these events
and then dispatch them to appropriate callbacks associated with the
appropriate widgets.

=head2 Debugging CGI Scripts

One advantage of ptkdb over the builtin debugger(-d) is that it can be
used to debug CGI perl scripts as they run on a web server. Be sure
that that your web server's perl instalation includes Tcl::Tk.

Change your

  #! /usr/local/bin/perl

to

  #! /usr/local/bin/perl -d:tkdb

TIP: You can debug scripts remotely if you're using a unix based
Xserver and where you are authoring the script has an Xserver.
In your script insert the following BEGIN subroutine:

    sub BEGIN {
      $ENV{'DISPLAY'} = "myHostname:0.0" ;
    }

Be sure that your web server has permission to open windows on your
Xserver (see the xhost manpage).

Access your web page with your browswer and 'submit' the script as
normal.  The ptkdb window should appear on myHostname's monitor. At
this point you can start debugging your script.  Be aware that your
browser may timeout waiting for the script to run.

To expedite debugging you may want to setup your breakpoints in
advance with a .ptkdbrc file and use the $DB::no_stop_at_start
variable.  NOTE: for debugging web scripts you may have to have the
.ptkdbrc file installed in the server account's home directory (~www)
or whatever username your webserver is running under.  Also try
installing a .ptkdbrc file in the same directory as the target script.

=head1 See also

https://github.com/vadrer/Perl-Devel-tkdb

=head1 AUTHORS

 Andrew E. Page
 Vadim Konovalov

=cut

use vars qw(@dbline);

sub BEGIN {

 $DB::on = 0 ;     

 $DB::subroutine_depth = 0 ; # our subroutine depth counter
 $DB::step_over_depth = -1 ;

   # Fonts used in the displays

 @Devel::tkdb::code_text_font = $ENV{'PTKDB_CODE_FONT'} ? ( "-font" => $ENV{'PTKDB_CODE_FONT'} ) : () ;

 @Devel::tkdb::expression_text_font = $ENV{'PTKDB_EXPRESSION_FONT'} ? ( "-font" => $ENV{'PTKDB_EXPRESSION_FONT'} ) : () ;
 @Devel::tkdb::eval_text_font = $ENV{'PTKDB_EVAL_FONT'} ? ( -font => $ENV{'PTKDB_EVAL_FONT'} ) : () ; # text for the expression eval window

 $Devel::tkdb::linenumber_length = 5;

   #
   # DB Options (things not directly involving the window)
   #

   # Flag to disable us from intercepting $SIG{'INT'}

 $DB::sigint_disable = defined $ENV{'PTKDB_SIGINT_DISABLE'} && $ENV{'PTKDB_SIGINT_DISABLE'} ;
#
# Possibly for debugging perl CGI Web scripts on
# remote machines.  
#
   $ENV{'DISPLAY'} = $ENV{'PTKDB_DISPLAY'} if exists $ENV{'PTKDB_DISPLAY'} ;

 } # end of BEGIN

##
## subroutine provided to the user for initializing
## files in .ptkdbrc
##
sub brkpt {
  my ($fName, @idx) = @_ ;
  local(*dbline) = $main::{'_<' . $fName} ;

  for( @idx ) {
    if( !&DB::checkdbline($fName, $_) ) {
      my ($package, $filename, $line) = caller ;
      print "$filename:$line:  $fName line $_ is not breakable\n" ;
      next ;
    }
  $DB::window->insertBreakpoint($fName, $_, 1) ; # insert a simple breakpoint
  }
} # end of brkpt

#
# Set conditional breakpoint(s)
#
sub condbrkpt {
  my ($fname) = shift ;
  local(*dbline) = $main::{'_<' . $fname} ;

  while( @_ ) { # arg loop
    my($index, $expr) = splice @_, 0, 2 ; # take args 2 at a time

    if( !&DB::checkdbline($fname, $index) ) {
      my ($package, $filename, $line) = caller ;
      print "$filename:$line:  $fname line $index is not breakable\n" ;
      next ;
    }
    $DB::window->insertBreakpoint($fname, $index, 1, $expr) ; # insert a simple breakpoint
  } # end of arg loop
}

sub brkonsub {
  my(@names) = @_ ;

  for (@names) {

    # get the filename and line number range of the target subroutine

    if( !exists $DB::sub{$_} ) {
      print "No subroutine $_.  Try main::$_\n" ;
      next ;
    }

  $DB::sub{$_} =~ /(.*):(\d+)-(\d+)$/o ; # file name will be in $1, start line $2, end line $3

    for( $2..$3 ) {
      next unless &DB::checkdbline($1, $_) ;
    $DB::window->insertBreakpoint($1, $_, 1) ;
      last ; # only need the one breakpoint
    }
  } # end of name loop
}

#
# set breakpoints on subroutines matching a regular expression
#
sub brkonsub_regex {
  my(@regexps) = @_ ;
  my($regexp, @subList) ;

  #
  # accumulate matching subroutines
  #
  foreach $regexp ( @regexps ) {
    study $regexp ;
    push @subList, grep /$regexp/, keys %DB::sub ;
  } # end of brkonsub_regex

  brkonsub(@subList) ; # set breakpoints on matching subroutines

} # end of brkonsub_regex

#
# Run files provided by the user
#
sub do_user_init_files {
    for (grep {-e} ( (exists $ENV{'HOME'}?("$ENV{'HOME'}/.ptkdbrc"):()), ".ptkdbrc")) {
	do $_;
	if ($@) {
	    print STDERR "init file $_ failed: $@\n" ;
	}
    }
    &set_stop_on_warning();
}

#
# Constructor for our Devel::tkdb
#
sub new {
  my($type) = @_;

  my $self = {

  # Current position of the executing program

      current_file => "",
      current_line => -1, # initial value indicating we haven't set our line/tag
      window_pos_offset => 10, # when we enter how far from the top of the text are we positioned down
      search_start => "1.0",
      fwdOrBack => 1,
      BookMarksPath => ($ENV{'PTKDB_BOOKMARKS_PATH'} || "$ENV{'HOME'}/.ptkdb_bookmarks" || '.ptkdb_bookmarks'),

  # list of expressions to eval in our window fields:  {'expr'} The expr itself {'depth'} expansion depth
      expr_list => [], 

      brkPtCnt => 0,

      main_window => undef,

      subs_list_cnt => 0,
  };
  bless $self, $type;

  $self->setup_main_window();

  return $self;
} # end of new

sub setup_main_window {
  my($self) = @_ ;

  # Main Window
  my $int = new Tcl::Tk;
  $self->{int} = $int;

  $int->_packageRequire('treectrl');

  $self->{main_window} = $self->{int}->mainwindow();
  $self->{main_window}->geometry($ENV{'PTKDB_GEOMETRY'} || "800x600");

  $self->{main_window}->bind('<Control-c>', \&DB::dbint_handler) ;

  #
  # Bind our 'quit' routine to a close command from the window manager (Alt-F4) 
  # 
  $self->{main_window}->protocol('WM_DELETE_WINDOW', sub { $self->close_ptkdb_window(); } );

  #
  # setup Frames
  # Setup our Code, Data, and breakpoints
  $self->setup_frames();

  # Menu bar
  $self->setup_menu_bar();
}

#
# Check for changes to the bookmarks and quit
#
sub DoQuit {
    print STDERR "DoQuit\n";
    my($self) = @_;

    $self->save_bookmarks($self->{BookMarksPath}) if $self->{'bookmarks_changed'};
    $self->{main_window}->destroy if $self->{main_window} ; 
    $self->{main_window} = undef;

}

#
# This supports the File -> Open menu item
# We create a new window and list all of the files
# that are contained in the program.  We also
# pick up all of the perlTk files that are supporting
# the debugger.  
#
sub DoOpen {
  my $self = shift ;
  my ($topLevel, $listBox, $selectedFile, @fList) ;

  #
  # subroutine we call when we've selected a file
  #

  my $chooseSub = sub { $selectedFile = $listBox->get('active') ;
                        print "attempting to open $selectedFile\n" ;
                      $DB::window->set_file($selectedFile, 0) ;
                         $topLevel->destroy; 
                      } ;

  #
  # Take the list the files and resort it.  
  # we put all of the local files first, and
  # then list all of the system libraries.
  #
  @fList = sort { 
    # sort comparison function block
    my $fa = substr($a, 0, 1);
    my $fb = substr($b, 0, 1);

    return $a cmp $b if ($fa eq '/') && ($fb eq '/');

    return -1 if ($fb eq '/');
    return 1 if ($fa eq '/' );

    return $a cmp $b ;

  } grep s/^_<//, keys %main:: ;

  #
  # Create a list box with all of our files to select from
  #
  $topLevel = $self->{main_window}->Toplevel(-title => "File Select", -overanchor => 'cursor') ;

  $listBox = $topLevel->Scrolled('Listbox', 
		   @Devel::tkdb::expression_text_font,
	     -width => 30)->pack(qw/-side top -fill both -expand 1/);


  # Bind a double click on the mouse button to the same action as pressing the Okay button

  $listBox->bind('<Double-Button-1>' => $chooseSub) ;

  $listBox->_insertEnd(@fList);

  $topLevel->Button(-text => "Okay", -command => $chooseSub)
  	->pack(-side => 'left', -fill => 'both', -expand => 1) ;

  $topLevel->Button( -text => "Cancel", -command => "destroy $topLevel")
  	->pack(qw/-side left -fill both -expand 1/);
} # end of DoOpen

sub do_tabs {
  my $w = $DB::window->{'main_window'}->DialogBox(-title => "Tabs", -buttons => [qw/Okay Cancel/]);

  my $tabs_cfg = $DB::window->{text}->cget('-tabs');
  my $tabs_str = join " ", @$tabs_cfg if $tabs_cfg;

  $w->add('Label', -text => 'Tabs:')->pack(-side => 'left');
  $w->add('Entry', -textvariable => \$tabs_str)->pack(-side => 'left')->selectionRange(0,'end');
  my $result = $w->Show();

  $DB::window->{'text'}->configure(-tabs => [ split /\s+/, $tabs_str ])
      if $result eq 'Okay' ;
}

sub close_ptkdb_window {
    print STDERR "close_ptkdb_window\n";
  my($self) = @_ ;

  $self->{current_file} = ""; # force a file reset
  $self->{'main_window'}->destroy;
  $self->{'main_window'} = undef;
  $self->{int}->SetVar('event','run');
}

sub setup_menu_bar {
  my ($self) = @_;

  my $mw = $self->{main_window} ;
  my $int = $self->{int};

  # file menu in menu bar

  my $items1 = [ [ command => 'About...', -command => sub { $self->DoAbout() ; } ],
		 [ command => 'Bug Report...', -command => 'puts "bugreport TBD"' ],
             "-",

             [ command => 'Open', -accelerator => 'Alt+O',
               -underline => 0,
               -command => sub { $self->DoOpen() ; } ],

             [ command => 'Save Config...', 
               -underline => 0,
               -command => \&DB::SaveState ],

             [ command => 'Restore Config...',
               -underline => 0,
               -command => \&DB::RestoreState],

             [ command => 'Goto Line...',
               -underline => 0,
               -accelerator => 'Alt-g',
               -command => sub { $self->GotoLine() ; } ],

             [ command => 'Find Text...',
               -accelerator => 'Ctrl-f',
               -underline => 0,
               -command => sub { $self->FindText() ; } ],

             [ command => "Tabs...", -command => \&do_tabs ],

             "-",

             [ command => 'Close Window and Run', -accelerator => 'Alt+W',
               -underline => 6, -command => sub { $self->close_ptkdb_window ; } ],

             [ command => 'Quit...', -accelerator => 'Alt+Q',
               -underline => 0,
               -command => sub { $self->DoQuit } ]
             ];


  $mw->bind('<Alt-g>' =>  sub { $self->GotoLine() ; }) ;
  $mw->bind('<Control-f>' => sub { $self->FindText() ; }) ;
  $mw->bind('<Control-r>' => \&Devel::tkdb::DoRestart) ;
  $mw->bind('<Alt-q>' => 'set event quit' );
  $mw->bind('<Alt-w>' => sub { $self->close_ptkdb_window ; });


  # Control Menu

  my $runSub = sub { $DB::step_over_depth = -1 ; $int->SetVar('event','run') };

  my $runToSub = sub { $int->SetVar('event','run') if  $DB::window->SetBreakPoint(1) ; } ;

  my $stepOverSub = sub { &DB::SetStepOverBreakPoint(0) ; 
                        $DB::single = 1 ; 
                        $int->SetVar('event','step');
		    } ;

  my $stepInSub = sub { 
                      $DB::step_over_depth = -1 ; 
                      $DB::single = 1 ; 
                      $int->SetVar('event','step');
		  };

  my $returnSub =  sub { 
      &DB::SetStepOverBreakPoint(-1) ;
      $int->SetVar('event','run');
  };


  my $items2 = [ [ command => 'Run', -accelerator => 'Alt+r', -underline => 0, -command => $runSub ],
             [ command => 'Run To Here', -accelerator => 'Alt+t', -underline => 5, -command => $runToSub ],
             '-',
             [ command =>  'Set Breakpoint', -underline => 4, -command => sub { $self->SetBreakPoint ; }, -accelerator => 'Ctrl-b' ],
             [ command => 'Clear Breakpoint', -command => sub { $self->UnsetBreakPoint } ],
             [ command => 'Clear All Breakpoints', -underline => 6, -command => sub {     
             $DB::window->removeAllBreakpoints($DB::window->{current_file});
               &DB::clearalldblines();
             } ],
             '-',
             [ command => 'Step Over', -accelerator => 'Alt+N', -underline => 0, -command => $stepOverSub ],
             [ command => 'Step In', -accelerator => 'Alt+S', -underline => 5, -command => $stepInSub ],
             [ command => 'Return', -accelerator => 'Alt+U', -underline => 3, -command => $returnSub ],
             '-',
             [ command => 'Restart...', -accelerator => 'Ctrl-r', -underline => 0, -command => \&Devel::tkdb::DoRestart ],
             '-',
             [ checkbutton => 'Stop On Warning', -variable => \$DB::tkdb::stop_on_warning, -command => \&set_stop_on_warning ]
           ]; # end of control menu items

  $mw->bind('<Alt-r>' => $runSub) ;
  $mw->bind('<Alt-t>', $runToSub) ;
  $mw->bind('<Control-b>', sub { $self->SetBreakPoint ; });

  # step over a subroutine
  for ('<F9>', '<Alt-n>') {
    $mw->bind($_ => $stepOverSub);
  }

  # keys for step into a subroutine 
  for ('<Shift-F9>', '<Alt-s>') {
    $mw->bind($_ => $stepInSub );
  }

  # return from a subroutine
  $mw->bind('<Alt-u>' => $returnSub );

  # Data Menu

  my $items3 = [ [ command => 'Enter Expression', -accelerator => 'Alt+E', -command => sub { $self->EnterExpr() } ],
             [ command => 'Delete Expression', -accelerator => 'Ctrl+D', -command => sub { $self->deleteExpr() } ],
             [ command => 'Delete All Expressions',  -command => sub { 
                                       $self->deleteAllExprs() ;
                                       $self->{'expr_list'} = [];
                                     } ],
             '-',
             [ command => 'Expression Eval Window...', -accelerator => 'F8', -command => sub { $self->setupEvalWindow() ; } ],
	  ];

  $mw->bind('<Alt-e>' => sub { $self->EnterExpr() } ) ;
  $mw->bind('<Control-d>' => sub { $self->deleteExpr() } );
  $mw->bind('<F8>', sub { $self->setupEvalWindow() ; }) ;

  #
  # Windows Menu
  #
  my $bsub = "focus $self->{text}";
  my $csub = "focus $self->{quick_entry}";
  my $dsub = "focus $self->{entry}";

  my $items4 = [ [ command => 'Code Pane', -accelerator => 'Alt+0', -command => $bsub ],
             [ command => 'Quick Entry', -accelerator => 'F9', -command => $csub ],
             [ command => 'Expr Entry', -accelerator => 'F11', -command => $dsub ]
           ];

  $mw->bind('<Alt-0>', $bsub);
  $mw->bind('<F9>', $csub);
  $mw->bind('<F11>', $dsub);

  my $menu = $mw->Menu(-menuitems => [
          [Cascade=>'File', -tearoff => 0, -underline=>0, -menuitems=>$items1],
          [Cascade=>'Control', -tearoff=>0, -underline=>0, -menuitems => $items2],
	  [Cascade=>'Data', -tearoff=>0, -menuitems => $items3, -underline => 0],
          [Cascade=>'Stack', -tearoff=>0, -underline => 2],
          [Cascade=>'Bookmarks', -tearoff=>0, -underline=>0],
	  [Cascade=>'Windows', -tearoff=>0, -menuitems => $items4]
      ]);
  #
  # Stack menu
  $self->{stack_menu} = $int->widget($menu->entrycget(4,'-menu'),'Menubutton');
  #
  # Bookmarks menu
  $self->{bookmarks_menu} = $int->widget($menu->entrycget(5,'-menu'),'Menubutton');

  $self->setup_bookmarks_menu();

  $mw->config(-menu=>$menu);

  #
  # Bar for some popular controls
  my $bb = $mw->Frame()->pack(-side => 'top');

  $bb->Button(-text => "Step In", -command => $stepInSub) ->pack(-side => 'left');
  $bb->Button(-text => "Step Over", -command => $stepOverSub) ->pack(-side => 'left');
  $bb->Button(-text => "Return", -command => $returnSub) ->pack(-side => 'left');
  $bb->Button(-text => "Run", -background => 'green', -command => $runSub) ->pack(-side => 'left');
  $bb->Button(-text => "Run To", -command => $runToSub) ->pack(-side => 'left');
  $bb->Button(-text => "Break", -command => sub { $self->SetBreakPoint ; } ) ->pack(-side => 'left');
  $bb->Button(-text => "eval selection <F6>", -command => 'set event vexpr') ->pack(-side => 'left');
  $mw->bind('<F6>', 'set event vexpr');

} # end of setup_menu_bar

sub edit_bookmarks {
  my ($self) = @_ ;

  my $top =  $self->{main_window}->Toplevel(-title => "Edit Bookmarks");
  my $list = $top->Scrolled('Listbox', -selectmode => 'multiple')->pack(qw/-side top -fill both -expand 1/);

  my $deleteSub = sub {
    my $cnt = 0 ;
    for( $list->curselection ) {
      $list->delete($_ - $cnt++) ;
    }
  };

  my $okaySub = sub {
    $self->{'bookmarks'} = [ $list->get(0, 'end') ]  ; # replace the bookmarks
  };

  my $frm = $top->Frame()->pack(-side => 'top', -fill => 'x', -expand => 1 ) ;

  $frm->Button(-text => 'Delete', -command => $deleteSub)->pack(-side => 'left', -fill => 'x', -expand => 1 );
  $frm->Button(-text => 'Cancel', -command => "destroy $top")->pack(-side  =>'left', -fill => 'x', -expand => 1 );
  $frm->Button(-text => 'Okay', -command => $okaySub)->pack(-side => 'left', -fill => 'x', -expand => 1 );

  $list->insert('end', @{$self->{'bookmarks'}}) ;

} # end of edit_bookmarks

sub setup_bookmarks_menu {
  my ($self) = @_ ;

  #
  # "Add bookmark" item
  #
  my $bkMarkSub = sub { $self->add_bookmark() ; } ;

  $self->{'bookmarks_menu'}->command(-label => "Add Bookmark",
			 -accelerator => 'Alt+k',
			 -command => $bkMarkSub);

  $self->{'main_window'}->bind('<Alt-k>', $bkMarkSub) ;

  $self->{'bookmarks_menu'}->command(-label => "Edit Bookmarks", 
			 -command => sub { $self->edit_bookmarks() } );

  $self->{'bookmarks_menu'}->separator() ;

  #
  # Check to see if there is a bookmarks file
  #
  return unless -e $self->{BookMarksPath} && -r $self->{BookMarksPath} ;

  use vars qw($ptkdb_bookmarks) ;
  local($ptkdb_bookmarks) ; # ref to hash of bookmark entries

  do $self->{BookMarksPath} ; # eval the file

  $self->add_bookmark_items(@$ptkdb_bookmarks) ;

} # end of setup_bookmarks_menu

#
# $item = "$fname:$lineno"
#
sub add_bookmark_items {
  my($self, @items) = @_ ;
  my($menu) = ( $self->{'bookmarks_menu'} ) ;

  $self->{'bookmarks_changed'} = 1 ;

  for( @items ) {
    my $item = $_ ;
    $menu->command( -label => $_,
                    -command => sub { $self->bookmark_cmd($item) });
    push @{$self->{'bookmarks'}}, $item;
  }
} # end of add_bookmark_item

#
# Invoked from the "Add Bookmark" command
#
sub add_bookmark {
  my($self) = @_ ;

  my $line = $self->get_lineno();
  my $fname = $self->{'current_file'};
  $self->add_bookmark_items("$fname:$line");

} # end of add_bookmark

#
# Command executed when someone selects a bookmark
#
sub bookmark_cmd {
  my ($self, $item) = @_;
  $item =~ /^(.*):(\d+)$/;
  $self->set_file($1,$2);
}

sub save_bookmarks {
  my($self, $pathName) = @_ ;

  local(*F) ;

  eval {
    open F, ">$pathName" || die "open failed" ;
    my $d = Data::Dumper->new([ $self->{'bookmarks'} ],
                              [  'ptkdb_bookmarks' ]);
    $d->Indent(2) ; # make it more editable for people

    print F $d->Dump() || die "outputing bookmarks failed";
    close(F);
  };

  if ($@) {
    $self->DoAlert("Couldn't save bookmarks file $@") ;
    return;
  }

} # end of save_bookmarks 


sub line_number_from_coord {
  my($txtWidget, $coord) = @_ ;
  $txtWidget->index($coord) =~ /^(\d*)\.(\d*)$/;
  return $1;
} # end of line_number_from_coord

#
# It may seem as if $txtWidget and $self are
# erroneously reversed, but this is a result
# of the calling syntax of the text-bind callback.  
#
sub set_breakpoint_tag {
  my ($self, $txtWidget, $coord, $value) = @_ ;

  my $idx = line_number_from_coord($txtWidget, $coord) ;

  $self->insertBreakpoint($self->{'current_file'}, $idx, $value) ;

} # end of set_breakpoint_tag

sub clear_breakpoint_tag {
  my ($self, $txtWidget, $coord) = @_ ;

  my $idx = line_number_from_coord($txtWidget, $coord) ;

  $self->removeBreakpoint($self->{'current_file'}, $idx) ;

} # end of clear_breakpoint_tag

sub change_breakpoint_tag {
  my ($self, $txtWidget, $coord, $value) = @_ ;
  my ($brkPt, @tagSet) ;

  my $idx = line_number_from_coord($txtWidget, $coord) ;

  #
  # Change the value of the breakpoint
  #
  @tagSet = ( "$idx.0", "$idx.$Devel::tkdb::linenumber_length" ) ;

  $brkPt = &DB::getdbline($self->{'current_file'}, $idx) ;
  return unless $brkPt ;

  #
  # Check the breakpoint tag
  #

  if ( $txtWidget ) {
    $txtWidget->tagRemove('breaksetLine', @tagSet ) ;
    $txtWidget->tagRemove('breakdisabledLine', @tagSet ) ;
  }

  $brkPt->{'value'} = $value ;

  if ( $txtWidget ) {
    if ( $brkPt->{'value'} ) {
      $txtWidget->tagAdd('breaksetLine', @tagSet ) ;
    }
    else {
      $txtWidget->tagAdd('breakdisabledLine', @tagSet ) ;    
    }
  }

} # end of change_breakpoint_tag

#
# God Forbid anyone comment something complex and tightly optimized.
#
#  We can get a list of the subroutines from the interpreter
# by querrying the *DB::sub typeglob:  keys %DB::sub
#
# The list appears broken down by module:
#
#  main::BEGIN
#  main::mySub
#  main::otherSub
#  Tk::Adjuster::Mapped
#  Tk::Adjuster::Packed
#  Tk::Button::BEGIN
#  Tk::Button::Enter
#  
#  We would like to break this list down into a heirarchy.
#
#         main                             Tk
#  |        |       |                       |
# BEGIN   mySub  OtherSub          |                 |
#                               Adjuster           Button 
#                             |         |        |        |
#                           Mapped    Packed   BEGIN    Enter
#
#
#  We translate this list into a heirarchy of hashes(say three times fast).
# We take each entry and split it into elements.  Each element is a leaf in the tree.  
# We traverse the tree with the inner for loop.  
# With each branch we check to see if it already exists or
# we create it.  When we reach the last element, this becomes our entry.
# 

#
# An incoming list is potentially 'large' so we
# pass in the ref to it instead.
#
#  New entries can be inserted by providing a $topH
# hash ref to an existing tree.  
#
sub tree_split {
  my ($listRef) = @_;
  my $topH = {};

  for my $list_elem (@$listRef) {
    my $h = $topH ;
    for (split /::/, $list_elem) { # Tk::Adjuster::Mapped  -> ( Tk Adjuster Mapped )
      $h->{$_} or $h->{$_} = {}; # either we have an entry for this OR we create one
      $h = $h->{$_};
    }
    @$h{'name', 'path'} = (undef, $list_elem) ; # the last leaf is our entry
  } # end of tree_split loop

  return $topH ;
} # end of tree_split

#
# callback executed when someone double clicks
# an entry in the 'Subs' Tk::Notebook page.
#
sub sub_list_cmd {
  my ($self, $path) = @_;
  print STDERR "arg=[[@_]]\n";
  my $sub_list = $self->{'sub_list'} ;

  if ($sub_list->info('children', $path)) {
    #
    # Delete the children
    $sub_list->deleteOffsprings($path);
  print STDERR "vvvv2\n";
    return;
  }
  print STDERR "vvvv3\n";

  #
  # split the path up into elements
  # end descend through the tree.
  #
  my $h = $Devel::tkdb::subs_tree ; 
  for ( split /\./, $path ) {
    $h = $h->{$_} ; # next level down
  }

  #
  # if we don't have a 'name' entry we
  # still have levels to decend through.
  #
  if ( !exists $h->{'name'} ) {
    #
    # Add the next level paths
    #   
    for ( sort keys %$h ) {

      if ( exists $h->{$_}->{'path'} ) {
        $sub_list->add($path . '.' . $_, -text => $h->{$_}->{'path'}) ;
      } else {
        $sub_list->add($path . '.' . $_, -text => $_) ;
      }
    }
    return ;
  }

  $DB::sub{$h->{'path'}} =~ /^(.*):(\d+)-\d+$/; # file name will be in $1, line number will be in $2

  $self->set_file($1, $2);
} # end of sub_list_cmd

sub sub_list_cmd0 {
  my ($self) = @_;
  my $list = $self->{sub_list0} ;
  my ($la, $le) = ($list->_indexActive,$list->_indexEnd);
  print STDERR "<<$la-$le>>\n";
  my @l = map {$list->get($_)} $la .. $le;
  # check if items following $l[0] are its children, and delete it, if it is the case
  my @levs = map {/^(\s*)/;length($1)} @l;
  print STDERR "{{@l}}\n";
  print STDERR "{{@levs}}\n";
  my $lev = $levs[0];
  my $l1 = 1;
  my $direct_children=0;
  while ($l1<=$#l and $lev<$levs[$l1]) {
      # delete list[l1]
      $list->delete($la+1);
      $l1++;
      $direct_children=1;
  }
  return if $direct_children;

  #
  # split the path up into elements end descend through the tree.
  my $path = $list->get($la);
  $path =~ s/^\s+//;
  my $h = $Devel::tkdb::subs_tree;
  for ( split /::/, $path ) {
    $h = $h->{$_} ; # next level down
  }

  #
  # if we don't have a 'name' entry we
  # still have levels to decend through.
  #
  if ( !exists $h->{'name'} ) {
    #
    # Add the next level paths
    my $sp = " " x ($lev+1);
    for (sort keys %$h) {
      if ( exists $h->{$_}->{'path'} ) {
        $list->insert($la+$l1,$sp.$h->{$_}->{'path'});
      } else {
        $list->insert($la+$l1,$sp.$_);
      }
      $l1++;
    }
    return ;
  }

  $DB::sub{$h->{'path'}} =~ /(.*):(\d+)-\d+$/; # file name will be in $1, line number in $2

  $self->set_file($1, $2);
}

sub fill_subs_page {
  my $self = shift;
  my @list = keys %DB::sub;

  $self->{sub_list0}->delete(0,'end'); # clear existing entries

  $Devel::tkdb::subs_tree = tree_split(\@list);

  for ( sort keys %$Devel::tkdb::subs_tree ) {
      $self->{sub_list0}->_insertEnd($_);
  }
}


sub check_search_request {
  my($entry, $self, $searchButton, $regexBtn) = @_ ;
  my($txt) = $entry->get ;

  if( $txt =~ /^\s*\d+\s*$/ ) {
    $self->DoGoto($entry) ;
    return ;
  }

  if( $txt =~ /\.\*/ ) { # common regex search pattern
    $self->FindSearch($entry, $regexBtn, 1) ;
    return ;
  }

  # vanilla search
  $self->FindSearch($entry, $searchButton, 0) ;
}

sub setup_search_panel {
  my ($self, $parent) = @_ ;
  my ($srchBtn, $regexBtn, $entry) ;

  my $frm = $parent->Frame()->pack(qw/-side top -fill x/);

  $frm->Button(-text => 'Goto', -command => sub { $self->DoGoto($entry) })->pack(-side => 'left');
  $srchBtn = $frm->Button(-text => 'Search', -command => sub { $self->FindSearch($entry, $srchBtn, 0) ; }
	   )->pack(-side => 'left');

  $regexBtn = $frm->Button(-text => 'Regex',
	       -command => sub { $self->FindSearch($entry, $regexBtn, 1) ; }
	   )->pack(-side => 'left');

  $entry = $frm->Entry(-width => 50)->pack(qw/-side left -fill both -expand 1/);

  $entry->bind('<Return>', sub { check_search_request($entry, $self, $srchBtn, $regexBtn) ; } );

} # end of setup search_panel

sub setup_frames {
  my ($self) = @_;
  my $mw = $self->{'main_window'};

  my $pw = $mw->Frame->pack(qw/-side bottom -fill both -expand 1/)->Panedwindow()->pack(qw/-side left -fill both -expand 1/);
  my $frm = $pw->Frame->pack(qw/-side top -fill both -expand 1/); # frame for our code pane and search controls

  $self->setup_search_panel($frm);

  #
  # Text window for the code of our currently viewed file
  #
  my $txt = $frm->Scrolled('ROText', -wrap => "none",
		 @Devel::tkdb::code_text_font
	   )->pack(qw/-side top -fill both -expand 1/);
  $self->{'text'} = $txt->Subwidget;

  $self->configure_text();

  #
  # Notebook
  #

  my $nb = $self->{'notebook'} = $pw->BWNoteBook()
        ->pack(qw/-side left -fill both -expand 1/);
  $self->{w_nb} = $nb;

  $pw->add($frm, $nb);

  #
  # a widget for the data entries
  #
  $nb->_insertEnd("datapage", -text => "Exprs");
  $self->{'data_page'} = $nb->getframe("datapage");

  #
  # frame, entry and label for quick expressions
  #
  my $frame = $self->{'data_page'}->Frame()->pack(-side => 'top', -fill => 'x') ;
  my $label = $frame->Label(-text => "Quick Expr:")->pack(-side => 'left') ;

  $self->{'quick_entry'} = $frame->Entry()->pack(-side => 'left', -fill => 'x', -expand => 1) ;
  $self->{'quick_entry'}->bind('<Return>', sub { $self->QuickExpr() ; } ) ;

  #
  # Entry widget for expressions and breakpoints
  #
  $frame = $self->{'data_page'}->Frame()->pack(-side => 'top', -fill => 'x') ;
  $label = $frame->Label(-text => "Enter Expr:")->pack(-side => 'left') ;

  $self->{'entry'} = $frame->Entry()->pack(-side => 'left', -fill => 'x', -expand => 1) ;
  $self->{'entry'}->bind('<Return>', sub { $self->EnterExpr() }) ;

  #
  # tk widget for data expressions
  #
  my $w_tree = $self->{'data_page'}->Scrolled('Treectrl',-showroot=>1,-showrootbutton=>1)
		  ->pack(qw/-side top -fill both -expand 1/);
  $self->{data_list0} = [$w_tree->Subwidget, $w_tree->columnCreate()];
  $w_tree->elementCreate('foo','text');
  $w_tree->elementCreate('bar','rect',-showfocus=>1);
  $w_tree->styleCreate('st');
  $w_tree->styleElements('st',['foo','bar']);
  $w_tree->styleLayout('st','bar',-union=>'foo');
  $w_tree->configure(-defaultstyle=>'st',-treecolumn=>$self->{data_list0}->[1]);

  # subs page
  #$self->setup_subs_page();
  $nb->_insertEnd("subspage", -text => "Subs");
  my $w1 = $nb->getframe("subspage")->Scrolled('Listbox', -selectmode=>'single');
  $self->{'sub_list0'} = $w1->Subwidget;
  $self->{int}->bind($self->{'sub_list0'}, "<Double-1>" => sub { $self->sub_list_cmd0(@_); });
  $w1->pack(qw/-side left -fill both -expand 1/);
  $self->fill_subs_page();
  $self->{'subs_list_cnt'} = scalar keys %DB::sub;

  # breakpts page
  $self->{'notebook'}->_insertEnd("brkptspage", -text => "BrkPts") ;
  my $sw = $self->{'notebook'}->getframe("brkptspage")->ScrolledWindow()->pack(qw(-side top -fill both -expand  1));
  $self->{'breakpts_table'} = $sw->ScrollableFrame();
  $sw->setwidget($self->{'breakpts_table'});
  $self->{'breakpts_table_data'} = {}; # controls addressed by "fname:lineno"

  # eval page
  $nb->_insertEnd("evalpage", -text => "Eval");
  $self->{'w_eval_text'} = $nb->getframe("evalpage")->Scrolled('Text')->pack(qw/-side  top -fill both  -expand 1/);

  # done
  $nb->_raise("datapage");

} # end of setup_frames


sub configure_text {
  my($self) = @_ ;
  my($txt, $mw) = ($self->{'text'}, $self->{'main_window'}) ;

  if (0) {
      # balloon
      $self->{'expr_balloon'} = $txt->Balloon();
      $self->{'balloon_expr'} = ' '; # initial expression

      $self->{'expr_ballon_msg'} = ' ';
      $self->{'expr_balloon'}->attach($txt, -initwait => 300,
	      -msg => \$self->{'expr_ballon_msg'},
	      -balloonposition => 'mouse',
	      -postcommand => \&Devel::tkdb::balloon_post,
	      -motioncommand => \&Devel::tkdb::balloon_motion );
  }

    $self->{'quick_dumper'} = new Data::Dumper([]);
    $self->{'quick_dumper'}->Terse(1);
    $self->{'quick_dumper'}->Indent(0);

  # tags for the text
  #  'code'               Format for code in the text pane
  #  'stoppt'             Format applied to the line where the debugger is currently stopped
  #  'breakableLine'      Format applied to line numbers where the code is 'breakable'
  #  'nonbreakableLine'   Format applied to line numbers where the code is no breakable
  #  'breaksetLine'       Format applied to line numbers were a breakpoint is set
  #  'breakdisabledLine'  Format applied to line numbers were a disabled breakpoint is set
  #  'search_tag'         Format applied to text when located by a search.  

  $txt->_tagConfigure('stoppt', -foreground => 'white', -background  => 'blue');
  $txt->_tagConfigure('search_tag', -background => "green");

  $txt->_tagConfigure("breakableLine", -overstrike => 0);
  $txt->_tagConfigure("nonbreakableLine", -overstrike => 1);
  $txt->_tagConfigure("breaksetLine", -background => 'red');
  $txt->_tagConfigure("breakdisabledLine", -background => 'green');

  $txt->tagBind("breakableLine", '<Button-1>', \\'xy', sub {my($ex,$ey)=($_[-2],$_[-1]);$self->set_breakpoint_tag($txt, "\@$ex,$ey", 1 )} );
  $txt->tagBind("breakableLine", '<Shift-Button-1>', \\'xy', sub {my($ex,$ey)=($_[-2],$_[-1]); $self->set_breakpoint_tag($txt, "\@$ex,$ey", 0 )} ) ;

  $txt->tagBind("breaksetLine", '<Button-1>',  \\'xy', sub {my($ex,$ey)=($_[-2],$_[-1]); $self->clear_breakpoint_tag($txt, "\@$ex,$ey", )}  ) ;
  $txt->tagBind("breaksetLine", '<Shift-Button-1>',  \\'xy', sub {my($ex,$ey)=($_[-2],$_[-1]); $self->change_breakpoint_tag($txt, "\@$ex,$ey", 0 )}  ) ;

  $txt->tagBind("breakdisabledLine", '<Button-1>', \\'xy', sub {my($ex,$ey)=($_[-2],$_[-1]); $self->clear_breakpoint_tag($txt, "\@$ex,$ey", )}  ) ;
  $txt->tagBind("breakdisabledLine", '<Shift-Button-1>', \\'xy', sub {my($ex,$ey)=($_[-2],$_[-1]); $self->change_breakpoint_tag($txt, "\@$ex,$ey", 1) }  ) ;

} # end of configure_text


sub DoAlert {
  my($self, $msg, $title) = @_ ;

  my $dlg = $self->{main_window}->Toplevel(-title => $title || "Alert", -overanchor => 'cursor');

  $dlg->Label(-text => $msg)->pack( -side => 'top');
  $dlg->Button(-text => "Okay", -command => "destroy $dlg")->pack(-side => 'top')->focus;
  $dlg->bind('<Return>', "destroy $dlg");

} # end of DoAlert

sub simplePromptBox {
  my ($self, $title, $defaultText, $okaySub, $cancelSub) = @_ ;
  $Devel::tkdb::promptString = $defaultText;

  my $top = $self->{main_window}->Toplevel(-title => $title, -overanchor => 'cursor');
  my $entry = $top->Entry(-textvariable => \$Devel::tkdb::promptString)->pack(-side => 'top', -fill => 'both', -expand => 1);
  $top->Button(-text => "Okay", -command => sub { &$okaySub(); $top->destroy ;}
	   )->pack(-side => 'left', -fill => 'both', -expand => 1);
  $top->Button(-text => "Cancel", -command => sub { &$cancelSub() if $cancelSub ; $top->destroy() }, 
      )->pack(-side => 'left', -fill => 'both', -expand => 1);
  $entry->icursor('end');
  $entry->selectionRange(0, 'end');
  $entry->focus();

  return $top ;
} # end of simplePromptBox


#
# Clear any text that is in the entry field.  If there
# was any text in that field return it.  If there
# was no text then return any selection that may be active.  
#
sub clear_entry_text {
  my($self) = @_ ;
  my $str = $self->{'entry'}->get() ;
  $self->{'entry'}->delete(0, 'end') ;

  #
  # No String
  # Empty String
  # Or a string that is only whitespace
  #
  if( !$str || $str =~ /^\s*$/ ) {
    #
    # If there is no string or the string is just white text
    # Get the text in the selection (if any)
    # 
    if( $self->{'text'}->tagRanges('sel') ) { # check to see if 'sel' tag exists
      $str = $self->{'text'}->get("sel.first", "sel.last") ; # get the text between the 'first' and 'last' point of the sel (selection) tag
    }
    # If still no text, bring the focus to the entry
    if (!$str || $str =~ /^\s*$/) {
      $self->{'entry'}->focus();
      $str = "";
    }
  }
  #
  # Erase existing text
  #
  return $str;
} # end of clear_entry_text

sub brkPtCheckbutton {
  my ($self, $fname, $idx, $brkPt) = @_ ;
  $self->change_breakpoint_tag($self->{text}, "$idx.0", $brkPt->{value}) if $fname eq $self->{'current_file'} ;
} # end of brkPtCheckbutton

#
# insert a breakpoint control into our breakpoint list.  
# returns a handle to the control
#
#  Expression, if defined, is to be evaluated at the breakpoint
# and execution stopped if it is non-zero/defined.
#
# If action is defined && True then it will be evalled
# before continuing.  
#
sub insertBreakpoint {
  my ($self, $fname, @brks) = @_ ;
  my ($btn, $cnt, $item) ;

  local(*dbline) = $main::{'_<' . $fname} ;

  while( @brks ) {
    my($index, $value, $expression) = splice @brks, 0, 3 ; # take args 3 at a time

    my $brkPt = {} ; 
    my $txt = &DB::getdbtextline($fname, $index) ;
    @$brkPt{'type', 'line',  'expr',      'value', 'fname', 'text'} =
        ('user',   $index, $expression, $value,   $fname,  "$txt") ;

    &DB::setdbline($fname, $index, $brkPt) ;
    $self->add_brkpt_to_brkpt_page($brkPt) ;

    next unless $fname eq $self->{'current_file'} ;

    $self->{'text'}->tagRemove("breakableLine", "$index.0", "$index.$Devel::tkdb::linenumber_length") ;    
    $self->{'text'}->tagAdd($value ? "breaksetLine" : "breakdisabledLine",  "$index.0", "$index.$Devel::tkdb::linenumber_length") ;
  } # end of loop
} # end of insertBreakpoint

sub add_brkpt_to_brkpt_page { 
  my($self, $brkPt) = @_ ;
  # 
  # Add the breakpoint to the breakpoints page 
  # 
  my ($fname, $index) = @$brkPt{'fname', 'line'} ; 
  return if exists $self->{'breakpts_table_data'}->{"$fname:$index"} ; 
  $self->{'brkPtCnt'} += 1 ; 

  my $btnName = $fname ;
  $btnName =~ s/.*\/([^\/]*)$/$1/;

  # take the last leaf of the pathname

  my $frm = $self->{'breakpts_table'}->getframe;
  my $upperFrame = $frm->Frame()->pack(qw/-side top -fill x -expand 1/);

  $upperFrame->Checkbutton(-text => "$btnName:$index",
	  -variable => \$brkPt->{'value'}, # CAUTION value tracking
	  -command => sub { $self->brkPtCheckbutton($fname, $index, $brkPt) })
      ->pack(-side => 'left') ;

  $upperFrame->Button(-text => "Delete", -command => sub { $self->removeBreakpoint($fname, $index) ; } )
      ->pack(qw/-side left -fill x -expand 1/);

  $upperFrame->Button(-text => "Goto", -command => sub { $self->set_file($fname, $index) ; } )
      ->pack(qw/-side left -fill x -expand 1/);

  my $lowerFrame = $frm->Frame()->pack(-side => 'top', '-fill' => 'x', '-expand' => 1);

  $lowerFrame->Label(-text => "Cond:")->pack(-side => 'left');

  $lowerFrame->Entry(-textvariable => \$brkPt->{'expr'})
      ->pack(qw/-side left -fill x -expand 1/);

  $self->{'breakpts_table_data'}->{"$fname:$index"}->{'frm1'} = $upperFrame;
  $self->{'breakpts_table_data'}->{"$fname:$index"}->{'frm2'} = $lowerFrame;

  #TODO $self->{'main_window'}->update;

  #TODO my $width = $frm->cget('-width') ;#TODO < Must be widget method
  #TODO if ( $width > $self->{'breakpts_table'}->width ) {
  #TODO   $self->{'notebook'}->configure(-width => $width) ;
  #TODO }

} # end of add_brkpt_to_brkpt_page

sub remove_brkpt_from_brkpt_page {
  my($self, $fname, $idx) = @_ ;

  my $table = $self->{'breakpts_table'} ;

  # Delete the breakpoint control in the breakpoints window

  $self->{'breakpts_table_data'}->{"$fname:$idx"}->{frm1}->destroy;
  $self->{'breakpts_table_data'}->{"$fname:$idx"}->{frm2}->destroy;
  delete $self->{'breakpts_table_data'}->{"$fname:$idx"};

  $self->{'brkPtCnt'} -= 1;

} # end of remove_brkpt_from_brkpt_page


#
# Supporting the "Run To Here..." command
#
sub insertTempBreakpoint {
  my ($self, $fname, $index) = @_ ;
  local(*dbline) = $main::{'_<' . $fname} ;

  return if( &DB::getdbline($fname, $index) ) ; # we already have a breakpoint here

  &DB::setdbline($fname, $index, {type => 'temp', line => $index, value => 1 } ) ;

} # end of insertTempBreakpoint

sub reinsertBreakpoints {
  my ($self, $fname) = @_ ;

  for my $brkPt ( &DB::getbreakpoints($fname) ) {
    #
    # Our breakpoints are indexed by line therefore we can have 'gaps' where
    # there lines, but not breaks set for them.
    #
    next unless defined $brkPt;

    $self->insertBreakpoint($fname, @$brkPt{'line', 'value', 'expr'}) if( $brkPt->{'type'} eq 'user' );
    $self->insertTempBreakpoint($fname, $brkPt->{line}) if( $brkPt->{'type'} eq 'temp' );
  } # end of reinsert loop

} # end of reinsertBreakpoints

sub removeBreakpointTags {
  my ($self, @brkPts) = @_ ;

  for my $brkPt (@brkPts) {
    my $idx = $brkPt->{'line'};
    if ( $brkPt->{'value'} ) {
      $self->{'text'}->tagRemove("breaksetLine", "$idx.0", "$idx.$Devel::tkdb::linenumber_length");
    }
    else {
      $self->{'text'}->tagRemove("breakdisabledLine", "$idx.0", "$idx.$Devel::tkdb::linenumber_length");
    }
    $self->{'text'}->tagAdd("breakableLine", "$idx.0", "$idx.$Devel::tkdb::linenumber_length");
  }
} # end of removeBreakpointTags

#
# Remove a breakpoint from the current window
#
sub removeBreakpoint {
  my ($self, $fname, @idx) = @_;

  local(*dbline) = $main::{'_<' . $fname} ;

  for my $idx (@idx) { # end of removal loop
    next unless defined $idx ;
    my $brkPt = &DB::getdbline($fname, $idx);
    next unless $brkPt ; # if we do not have an entry
    &DB::cleardbline($fname, $idx);

    $self->remove_brkpt_from_brkpt_page($fname, $idx) ;

    next unless $brkPt->{fname} eq $self->{'current_file'}  ; # if this isn't our current file there will be no controls

    # Delete the ext associated with the breakpoint expression (if any)    

    $self->removeBreakpointTags($brkPt) ;
  } # end of remove loop

  return ;
} # end of removeBreakpoint

sub removeAllBreakpoints {
  my ($self, $fname) = @_ ;

  $self->removeBreakpoint($fname, &DB::getdblineindexes($fname)) ;

} # end of removeAllBreakpoints

#
# Delete expressions prior to an update
#
sub deleteAllExprs {
  my ($self) = @_ ;
  my $c = $self->{data_list0}->[0]->_item('children','root'); # this returns Tcl::List or empty. TODO - do this better
  my @c = ref $c ? @$c : split / /,$c;
  #print STDERR "{{{@c;$#c;($c);w=$self->{data_list0}->[0]}}}";
  $self->{data_list0}->[0]->_item(delete=>$_) for @c;
} # end of deleteAllExprs

sub EnterExpr {
  my ($self) = @_ ;
  my $str = $self->clear_entry_text() ;
  if( $str && $str !~ /^\s*$/ ) { # if there is an expression and it's more than white space
    $self->{'expr'} = $str ;
    $self->{int}->SetVar('event','expr');
  }
} # end of EnterExpr

#
#
sub QuickExpr {
  my ($self) = @_;
  my $str = $self->{'quick_entry'}->get() ;
  if( $str && $str !~ /^\s*$/ ) { # if there is an expression and it's more than white space
    $self->{'qexpr'} = $str ;
    $self->{int}->SetVar('event','qexpr');
  }
} # end of QuickExpr

sub deleteExpr {
  my ($self) = @_ ;
  my ($tv, $tcol) = @{$self->{data_list0}}; 
  my $ret = $tv->_selectionGet; # TODO
  my @sList = ref $ret ? @$ret : split / /,$ret;

  for (@sList) {
      if ($tv->itemParent($_) == 0) {
          # if we're deleteing a top level expression we have to take it out of the list of expressions
          my $e = delete $self->{el2expr}->{$_};
          $self->{'expr_list'} = [grep {$_->{expr} ne $e} @{$self->{'expr_list'}}];
      }
      $tv->_item('delete', $_);
  }
} # end of deleteExpr

##
##  Inserts an expression($theRef) into tk widget.  If the expression
## is an array, blessed array, hash, or blessed hash(typical object), then this
## routine is called recursively, adding the members to the next level of heirarchy,
## prefixing array members with a [idx] and the hash members with the key name.
## This continues until the entire expression is decomposed to it's atomic constituents.
## Protection is given(with $reusedRefs) to ensure that 'circular' references within
## arrays or hashes(i.e. where a member of a array or hash contains a reference to a
## parent element within the heirarchy.  
##
#
# Returns 1 if sucessfully added 0 if not
#
sub insertExpr {
  my ($self, $reusedRefs, $theRef, $name, $depth, $el) = @_;
  my ($type, $result, @circRefs);
  local $^W = 0; # spare us uncessary warnings about comparing strings with ==
  my ($tv, $tcol) = @{$self->{data_list0}}; 

  while( ref $theRef eq 'SCALAR' ) {
    $theRef = $$theRef ;
  }

  my $label = "" ;
 REF_CHECK: for( ; ; ) {
   push @circRefs, $theRef ;
   $type = ref $theRef ;
   last unless ($type eq "REF")  ;
   $theRef = $$theRef ; # dref again

   $label .= "\\" ; # append a 
   if( grep $_ == $theRef, @circRefs ) {
     $label .= "(circular)" ;
     last ;
   }
 }

  if( !$type || $type eq "" || $type eq "GLOB" || $type eq "CODE") {
    eval {
	my $t = "$name = $label" . (defined $theRef?$theRef:"undef");
	$el = $tv->itemCreate(-button=>'no',-parent=>$el);
        $self->{el2expr}->{$el->[0]} = $name;
	$tv->itemElementConfigure($el, $tcol, 'foo', -text=>"$t");
    };
    $self->DoAlert($@), return 0 if $@ ;
    return 1 ;
  }

  if( $type eq 'ARRAY' or "$theRef" =~ /ARRAY/ ) {
    my $idx = 0 ;
    eval {
	$el = $tv->itemCreate(-button=>'yes',-parent=>$el);
        $self->{el2expr}->{$el->[0]} = $name;
	$tv->itemElementConfigure($el, $tcol, 'foo', -text=>"$name = $theRef");
    } ;
    if( $@ ) {
      $self->DoAlert($@) ;
      return 0 ;
    }
    $result = 1 ;
    for my $r ( @$theRef ) {

      if( grep $_ == $r, @$reusedRefs ) { # check to make sure that we're not doing a single level self reference
        eval {
	    $el = $tv->itemCreate(-button=>'yes',-parent=>$el);
	    $tv->itemElementConfigure($el, $tcol, 'foo', -text=>"[$idx] = $r REUSED ADDR");
        } ;
        $self->DoAlert($@) if( $@ ) ;
        next ;
      }

      push @$reusedRefs, $r ;
      $result = $self->insertExpr($reusedRefs, $r, "[$idx]", $depth-1, $el) unless $depth == 0 ;
      pop @$reusedRefs ;

      return 0 unless $result ;
      $idx += 1 ;
    }
    return 1 ;
  } # end of array case

  if ("$theRef" !~ /HASH\050\060x[\da-f]*\051/) {
    eval {
	$el = $tv->itemCreate(-button=>'yes',-parent=>$el);
        $self->{el2expr}->{$el->[0]} = $name;
	$tv->itemElementConfigure($el, $tcol, 'foo', -text=>"$name = $theRef");
    };
    if( $@ ) {
      $self->DoAlert($@) ;
      return 0 ;
    }
    return 1 ;
  }
# 
# Anything else at this point is # either a 'HASH' or an object of some kind.
#
  my $idx = 0 ;
  my @theKeys = sort keys %$theRef;
  $el = $tv->itemCreate(-button=>'yes',-parent=>$el);
  $self->{el2expr}->{$el->[0]} = $name;
  $tv->itemElementConfigure($el, $tcol, 'foo', -text=>"$name = " . "$theRef");
  $result = 1 ;

  for my $r ( @$theRef{@theKeys} ) { # slice out the values with the sorted list

    if( grep $_ == $r, @$reusedRefs ) { # check to make sure that we're not doing a single level self reference
      eval {
	$el = $tv->itemCreate(-parent=>$el);
	$tv->itemElementConfigure($el, $tcol, 'foo', -text=>"$theKeys[$idx++] = $r REUSED ADDR");
      } ;
      print "bad path $@\n" if( $@ ) ;
      next ;
    }

    push @$reusedRefs, $r;

    $result = $self->insertExpr($reusedRefs,         # recursion protection
                                $r,                  # reference whose value is displayed
                                $theKeys[$idx],      # name
                                $depth-1,            # remaining expansion depth
				$el)
	    unless $depth == 0 ;

    pop @$reusedRefs ;

    return 0 unless $result ;
    $idx += 1 ;
  } # end of ref add loop

  return 1 ;
} # end of insertExpr

#
# We're setting the line where we are stopped.  
# Create a tag for this and set it as bold.  
#
sub set_line {
  my ($self, $lineno) = @_ ;
  my $text = $self->{'text'} ;

  return if( $lineno <= 0 ) ;

  if( $self->{current_line} > 0 ) {
    $text->tagRemove('stoppt', "$self->{current_line}.0 linestart", "$self->{current_line}.0 lineend") ;
  }
  $self->{current_line} = $lineno;
  $text->tagAdd('stoppt', "$self->{current_line}.0 linestart", "$self->{current_line}.0 lineend") ;

  $self->{'text'}->see("$self->{current_line}.0 linestart") ;
} # end of set_line

#
# Set the file that is in the code window.
#
# $fname the 'new' file to view
# $line the line number we're at
# $brkPts any breakpoints that may have been set in this file
#

sub set_file {
  my ($self, $fname, $line) = @_ ;

  return unless $fname;  # we're getting an undef here on 'Restart...'

  local(*dbline) = $main::{'_<' . $fname};

  #
  # with the #! /usr/bin/perl -d:tkdb at the header of the file
  # we've found that with various combinations of other options the
  # files haven't come in at the right offsets
  #
  if( $fname eq $self->{current_file} ) {
    $self->set_line($line);
    return;
  }

  $self->{main_window}->configure(-title => $fname) ;

  #
  # This is the tightest loop we have in the ptkdb code.
  # It is here where performance is the most critical.
  # The map block formats perl code for display.  Since
  # the file could be potentially large, we will try
  # to make this loop as thin as possible. 
  #

  local($^W) = 0 ; # spares us useless warnings under -w when checking $dbline[$_] != 0

  my $noCode = ($#dbline - 1) < 0 ;

  my $i0 = "0" x $Devel::tkdb::linenumber_length;
  $self->{text}->_delete('1.0','end');
  $self->{text}->_insertEnd(map {
    #$lineStr .= "\n" unless /\n$/; # append a \n if there isn't one already
    ($i0++, ($_==0?'nonbreakableLine':'breakableLine'), " $_", 'code') # a string,tag pair for text insert

  } @dbline[1 .. $#dbline] ) unless $noCode;

  #
  # Reinsert breakpoints (if info provided)
  #

  $self->set_line($line);
  $self->{current_file} = $fname;
  return $self->reinsertBreakpoints($fname);
} # end of set_file

#
# Get the current line that the insert cursor is in
#
sub get_lineno {
  my ($self) = @_ ; 

  my $info = $self->{'text'}->index('insert'); # get the location for the insertion point
  $info =~ s/\..*$/\.0/ ;

  return int $info ;
} # end of get_lineno

sub DoGoto {
  my ($self, $entry) = @_ ;

  my $txt = $entry->get() ;

  $txt =~ s/(\d*).*/$1/; # take the first blob of digits
  if( $txt eq "" ) {
    print "invalid text range\n";
    return;
  }

  $self->{'text'}->see("$txt.0") ;

  $entry->_selectionRange(0, 'end');
} # end of DoGoto

sub GotoLine {
  my ($self) = @_ ;

  if( $self->{goto_window} ) {
    $self->{goto_window}->raise() ;
    $self->{goto_text}->focus() ;
    return ;
  }

  #
  # Construct a dialog that has an
  # entry field, okay and cancel buttons
  #
  my $okaySub = sub { $self->DoGoto($self->{'goto_text'}) } ;

  my $topLevel = $self->{main_window}->Toplevel(-title => "Goto Line?", -overanchor => 'cursor') ;

  $self->{goto_text} = $topLevel->Entry()->pack(-side => 'top', -fill => 'both', -expand => 1) ;
  $self->{goto_text}->bind('<Return>', $okaySub) ; # make a CR do the same thing as pressing an okay
  $self->{goto_text}->focus();

  $topLevel->Button( -text => "Okay", -command => $okaySub,
                     )->pack(-side => 'left', -fill => 'both', -expand => 1) ;

  #
  # Subroutone called when the 'Dismiss' button is pushed.
  my $dismissSub = sub {
    delete $self->{goto_text} ;
    $self->{goto_window}->destroy;
    delete $self->{goto_window} ; # remove the entry from our hash so we won't
  } ;

  $topLevel->Button( -text => "Dismiss",
                     -command => $dismissSub )->pack(-side => 'left', -fill => 'both', -expand => 1) ;

  $topLevel->protocol('WM_DELETE_WINDOW', "destroy $topLevel");
  $self->{goto_window} = $topLevel;

} # end of GotoLine


#
# Subroutine called when the 'okay' button is pressed
#
sub FindSearch {
  my ($self, $entry, $btn, $regExp) = @_ ;
  my (@switches, $result) ;
  my $txt = $entry->get() ;

  return if $txt eq "" ; 

  push @switches, "-forward" if $self->{fwdOrBack} eq "forward" ;
  push @switches, "-backward" if $self->{fwdOrBack} eq "backward" ;

  if( $regExp ) {
    push @switches, "-regexp" ;
  }
  else {
    push @switches, "-nocase" ; # if we're not doing regex we may as well do caseless search
  }

  $result = $self->{'text'}->search(@switches, $txt, $self->{search_start}) ;

  # untag the previously found text

  $self->{'text'}->tagRemove('search_tag', @{$self->{search_tag}}) if defined $self->{search_tag} ;

  if( !$result || $result eq "" ) {
    # No Text was found
    $btn->flash() ;
    $btn->bell() ;

    delete $self->{search_tag} ;
    $self->{'search_start'} = "1.0" ;
  }
  else { # text found
    $self->{'text'}->see($result) ;
    # set the insertion of the text as well
    $self->{'text'}->markSet(insert => $result) ;
    my $len = length $txt;

    if( $self->{fwdOrBack} ) {
      $self->{search_start}  = "$result +$len chars"  ;
      $self->{search_tag} = [ $result, $self->{search_start} ]  ;
    }
    else {
      # backwards search 
      $self->{search_start}  = "$result -$len chars"  ;
      $self->{search_tag} = [ $result, "$result +$len chars"  ]  ;
    }

    # tag the newly found text

    $self->{'text'}->tagAdd('search_tag', @{$self->{search_tag}}) ;
  } # end of text found

  $entry->_selectionRange(0, 'end');

} # end of FindSearch


#
# Support for the Find Text... Menu command
#
sub FindText {
  my ($self) = @_ ;
  my ($okayBtn);

  #
  # if we already have the Find Text Window open don't bother openning
  # another, bring the existing one to the front.  
  if( $self->{find_window} ) {
    $self->{find_window}->raise();
    return;
  }

  $self->{search_start} = $self->{'text'}->index('insert') if( $self->{search_start} eq "" ) ;

  #
  # Subroutine called when the 'Dismiss' button is pushed.  
  my $dismissSub = sub {
    $self->{'text'}->tagRemove('search_tag', @{$self->{search_tag}}) if defined $self->{search_tag} ;
    $self->{search_start} = "" ;
    $self->{find_window}->destroy;
    delete $self->{search_tag} ;
    delete $self->{find_window} ;
  };

  #
  # Construct a dialog that has an entry field, forward, backward, regex option, okay and cancel buttons
  #
  my $top = $self->{main_window}->Toplevel(-title => "Find Text?");

  my $we = $top->Entry()->pack(qw/-side top -fill both -expand 1/);

  my $frm = $top->Frame()->pack(qw/-side top -fill both -expand 1/);

  $self->{fwdOrBack} = 'forward';
  $frm->Radiobutton(-text => "Forward", -value => 1, -variable => \$self->{fwdOrBack})
      ->pack(-side => 'left', -fill => 'both', -expand => 1);
  $frm->Radiobutton(-text => "Backward", -value => 0, -variable => \$self->{fwdOrBack})
      ->pack(-side => 'left', -fill => 'both', -expand => 1);

  my $regExp = 0 ;
  $frm->Checkbutton(-text => "RegExp", -variable => \$regExp)
      ->pack(-side => 'left', -fill => 'both', -expand => 1);

  # Okay and dismiss buttons
  $okayBtn = $top->Button( -text => "Okay", -command => sub { $self->FindSearch($we, $okayBtn, $regExp) ; }, 
          )->pack(-side => 'left', -fill => 'both', -expand => 1) ;

  $we->bind('<Return>', sub { $self->FindSearch($we, $okayBtn, $regExp) ; }) ;

  $top->Button( -text => "Dismiss",
        -command => $dismissSub)->pack(-side => 'left', -fill => 'both', -expand => 1) ;

  $top->protocol('WM_DELETE_WINDOW', $dismissSub) ;
  $we->focus();
  $self->{find_window} = $top;

} # end of FindText

sub main_loop {
  my ($self) = @_;

 SWITCH:
   for (; $DB::window->{main_window}; ) {

       $self->{int}->invoke('tkwait', 'variable', 'event');
       my $evt = $self->{int}->GetVar('event');
       #print STDERR "evt=$evt;\n";
       $evt eq 'step' && do { return $evt; };
       $evt eq 'null' && do { next SWITCH; };
       $evt eq 'run' && do { return $evt; };
       $evt eq 'quit' && do { $self->DoQuit; };
       $evt eq 'expr' && do { return $evt; }; # adds an expression to our expression window
       $evt eq 'vexpr' && do { return $evt; };
       $evt eq 'qexpr' && do { return $evt; }; # does a 'quick' expression
       $evt eq 'update' && do { return $evt; }; # forces an update on our expression window
       $evt eq 'reeval' && do { return $evt; }; # updated the open expression eval window
       $evt eq 'balloon_eval' && do { return $evt };
  } # end of switch block
} # end of main_loop

sub refresh_stack_menu {
  my ($self) = @_;

  #
  # CAUTION:  In the effort to 'rationalize' the code
  # are moving some of this function down from DB::DB
  # to here.  $sub_offset represents how far 'down'
  # we are from DB::DB.  The $DB::subroutine_depth is
  # tracked in such a way that while we are 'in' the debugger
  # it will not be incremented, and thus represents the stack depth
  # of the target program.  
  #
  my $sub_offset = 1;
  my $subStack = [];

  # clear existing entries

  for (my $i = 0 ; $i <= $DB::subroutine_depth ; $i++) {
    my ($package, $filename, $line, $subName) = caller $i+$sub_offset ;
    last if !$subName ;
    push @$subStack, {name => $subName, pck => $package, filename => $filename, line => $line};
  }

  $self->{stack_menu}->menu->delete(0, 'last') ; # delete existing menu items

  for (my $i = 0 ; $subStack->[$i] ; $i++) {

    my $str = defined $subStack->[$i+1] ? "$subStack->[$i+1]->{name}" : "MAIN" ;

    my ($f, $line) = ($subStack->[$i]->{filename}, $subStack->[$i]->{line}) ; # make copies of the values for use in 'sub'
    $self->{stack_menu}->command(-label => $str, -command => sub { $self->set_file($f, $line); } );
  }
} # end of refresh_stack_menu

no strict ;

sub get_state {
  my ($self, $fname) = @_ ;
  local($files, $expr_list, $eval_saved_text, $main_win_geometry) ;

  do "$fname";

  if( $@ ) {
    $self->DoAlert($@) ;
    return ( undef ) x 4 ; # return a list of 4 undefined values
  }

  return ($files, $expr_list, $eval_saved_text, $main_win_geometry) ;
} # end of get_state

use strict ;

sub restoreStateFile {
  my ($self, $fname) = @_ ;

  if (!(-e $fname && -r $fname)) {
    $self->DoAlert("$fname does not exist") ;
    return;
  }

  my ($files, $expr_list, $eval_saved_text, $main_win_geometry) = $self->get_state($fname) ;

  return unless defined $files || defined $expr_list ;

  &DB::restore_breakpoints_from_save($files) ;

  #
  # This should force the breakpoints to be restored
  #
  my $saveCurFile = $self->{current_file} ;

  @$self{ 'current_file', 'expr_list', 'eval_saved_text' } =
      ( ""             , $expr_list,  $eval_saved_text) ;

  $self->set_file($saveCurFile, $self->{current_line}) ;

  if ( $main_win_geometry && $self->{'main_window'} ) { 
    # restore the height and width of the window
    $self->{main_window}->geometry( $main_win_geometry ) ;
  }
  $self->{int}->SetVar('event','update');

} # end of retstoreState

sub updateEvalWindow {
  my ($self, @result) = @_ ;
  my ($leng, $str) = (0,'');

  for (@result) {
    if( $self->{hexdump_evals} ) {
      # eventually put hex dumper code in here
      $self->{eval_results}->insert('end', hexDump($_)) ;
    } else {
      my $d = Data::Dumper->new([$_]);
      $d->Indent(2);
      $d->Terse(1);
      $str = $d->Dump($_);
    }
    $leng += length $str ;
    $self->{eval_results}->insert('end', $str) ;
  }
} # end of updateEvalWindow

##
## converts non printable chars to '.' for a string
##
sub printablestr {
    return join "", map { (ord($_) >= 32 && ord($_) < 127) ? $_ : '.' } split //, $_[0] ;
}

##
## hex dump utility function
##
sub hexDump {
    my @retList;
    my $width = 8;
    my $offset = 0;

    for (@_) {
	my $str = '';
	my $len = length $_ ;

	while($len) {
	    my $n = $len >= $width ? $width : $len ;

	    my $fmt = "\n%04X  " . ("%02X " x $n ) . ( '   ' x ($width - $n) ) . " %s" ;
	    my @elems = map ord, split //, (substr $_, $offset, $n) ;
	    $str .= sprintf($fmt, $offset, @elems, printablestr(substr $_, $offset, $n)) ;
	    $offset += $width;

	    $len -= $n;
	} # while

	push @retList, $str;
    } # for

    return $retList[0] unless wantarray ;
    return @retList ;
} # end of hd


sub setupEvalWindow {
  my($self) = @_;
  $self->{eval_window}->focus(), return if exists $self->{eval_window} ; # already running this window?

  my $top = $self->{main_window}->Toplevel(-title => "Evaluate Expressions...");
  $self->{eval_window} = $top;
  $self->{eval_text} = $top->Scrolled('Text',
		@Devel::tkdb::eval_text_font,
		  -width => 50,
		  -height => 10,
		  -wrap => "none",
	  )->pack(qw/-side top -fill both -expand 1/);

  $self->{eval_text}->insert('end', $self->{eval_saved_text}) if exists $self->{eval_saved_text} && defined $self->{eval_saved_text};

  $top->Label(-text => "Results:")->pack(qw/-side top -fill both -expand n/);

  $self->{eval_results} = $top->Scrolled('Text',
		 -width => 50,
		 -height => 10,
		 -wrap => "none",
	       @Devel::tkdb::eval_text_font
	  )->pack(qw/-side top -fill both -expand 1/);

  my $btn = $top->Button(-text => 'Eval...',
          -command => 'set event reeval'
	 )->pack(-side => 'left', -fill => 'x', -expand => 1);

  my $dismissSub = sub { 
    $self->{eval_saved_text} = $self->{eval_text}->get('1.0', 'end') ;
    $self->{eval_window}->destroy ;
    delete $self->{eval_window} ;
  };

  $top->protocol('WM_DELETE_WINDOW', $dismissSub ) ;

  $top->Button(-text => 'Clear Eval', -command => sub { $self->{eval_text}->delete('1.0', 'end') }
	   )->pack(-side => 'left', -fill => 'x', -expand => 1);

  $top->Button(-text => 'Clear Results', -command => sub { $self->{eval_results}->delete('1.0', 'end') }
               )->pack(-side => 'left', -fill => 'x', -expand => 1) ;

  $top->Button(-text => 'Dismiss', -command => $dismissSub)->pack(-side => 'left', -fill => 'x', -expand => 1) ;
  $top->Checkbutton(-text => 'Hex', -variable => \$self->{hexdump_evals})->pack(-side => 'left') ;

} # end of setupEvalWindow ;

sub filterBreakPts {
  my ($breakPtsListRef, $fname) = @_ ;
  my $dbline = $main::{'_<' . $fname}; # breakable lines
  local($^W) = 0 ;
  #
  # Go through the list of breaks and take out any that
  # are no longer breakable
  #

  for( @$breakPtsListRef ) {
    next unless defined $_ ;

    next if $dbline->[$_->{'line'}] != 0 ; # still breakable

    $_ = undef ;
  }
} # end of filterBreakPts

sub DoAbout {
  my $self = shift ;
  my $str = <<"__STR__" ;
tkdb $tkdb::VERSION
Copyright 1998,2003 by Andrew E. Page, 2010,2011,2023 Vadim Konovalov.

This program is free software; you can redistribute it and/or modify
it under the terms of either:

a) the GNU General Public License as published by the Free
Software Foundation; either version 1, or (at your option) any
later version, or

b) the "Artistic License" which comes with this Kit.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either
the GNU General Public License or the Artistic License for more details.

OS $^O
Tcl/Tk Version $Tcl::Tk::TK_VERSION
Tcl::Tk Version $Tcl::Tk::VERSION
Perl Version $]
__STR__

    $self->DoAlert($str, "About tkdb");
} # end of DoAbout

#
# return 1 if succesfully set,
# return 0 if otherwise
#
sub SetBreakPoint {
  my ($self, $isTemp) = @_;
  my $dbw = $DB::window;
  my $lineno = $dbw->get_lineno();
  my $expr = $dbw->clear_entry_text();
  local($^W) = 0 ;

  if( !&DB::checkdbline($dbw->{current_file}, $lineno) ) {
    $dbw->DoAlert("line $lineno in $dbw->{current_file} is not breakable") ;
    return 0 ;
  }

  if( !$isTemp ) {
    $dbw->insertBreakpoint($dbw->{current_file}, $lineno, 1, $expr) ;
    return 1 ;
  }
  else {
    $dbw->insertTempBreakpoint($dbw->{current_file}, $lineno) ;
    return 1 ;
  }

  return 0 ;
} # end of SetBreakPoint

sub UnsetBreakPoint {
  my ($self) = @_ ;
  my $lineno = $self->get_lineno();

  $self->removeBreakpoint($DB::window->{current_file}, $lineno) ;
} # end of UnsetBreakPoint

sub balloon_post {
  my $self = $DB::window ;
  my $txt = $DB::window->{'text'} ;

  return 0 if ($self->{'expr_ballon_msg'} eq "") || ($self->{'balloon_expr'} eq "") ; # don't post for an empty string

  return $self->{'balloon_coord'} ;
}

sub balloon_motion {
  my ($txt, $x, $y) = @_ ;
  my ($offset_x, $offset_y) = ($x + 4, $y + 4) ;
  my $self = $DB::window ;
  my $txt2 = $self->{'text'} ;
  my $data ;

  $self->{'balloon_coord'} = "$offset_x,$offset_y" ;

  $x -= $txt->rootx;
  $y -= $txt->rooty;
  #
  # Post an event that will cause us to put up a popup
  #

  if ($txt2->_tagRangesSel) { # check to see if 'sel' tag exists (return undef value)
    $data = $txt2->get("sel.first", "sel.last") ; # get the text selection
  }
  else {
    $data = $DB::window->retrieve_text_expr($x, $y);
  }

  if( !$data ) {
    $self->{'balloon_expr'} = "" ;
    return 0 ; 
  }

  return 0 if ($data eq $self->{'balloon_expr'}) ; # nevermind if it's the same expression

  $self->{'balloon_expr'} = $data;
  $self->{int}->SetVar('event','balloon_eval');

  return 1 ; # ballon will be canceled and a new one put up(maybe)
} # end of balloon_motion

sub retrieve_text_expr {
  my($self, $x, $y) = @_ ;
  my $txt = $self->{'text'} ;

  my ($idx, $col) = $txt->index("\@$x,$y") =~ /^(\d*)\.(\d*)$/;

  my $offset = $Devel::tkdb::linenumber_length + 1 ; # line number text + 1 space

  return undef if $col < $offset ; # no posting

  $col -= $offset ;

  local(*dbline) = $main::{'_<' . $self->{current_file}} ;   

  return undef if( !defined $dbline[$idx] || $dbline[$idx] == 0 ) ; # no executable text, no real variable(?)

  my $data = $dbline[$idx] ;

  # if we're sitting over white space, leave
  my $len = length $data ;
  return unless $data && $col && $len > 0 ;

  return if substr($data, $col, 1) =~ /\s/ ;

  # walk backwards till we find some whitespace

  $col = $len if $len < $col ;
  while( --$col >= 0 ) {
    last if  substr($data, $col, 1) =~ /[\s\$\@\%]/ ;
  }

  substr($data, $col) =~ /^([\$\@\%]\w+)/ ;

  return $1 ;
}

#
# after DB::eval get's us a result
#
sub code_motion_eval {
    my ($self, @result) = @_;
    my $d = new Data::Dumper([]);
    $d->Terse(1);
    $d->Indent(2);
    $d->Values( [ $#result == 0 ? @result : \@result ]); 
    my $str = $d->Dump();
    chomp($str) ;
    # Cut the string down to 1024 characters to keep from overloading the balloon window
    $self->{'expr_ballon_msg'} = "$self->{'balloon_expr'} = " . substr $str, 0, 1024 ;
} # end of code motion eval

#
# Subroutine called when we enter DB::DB()
# In other words when the target script 'stops'
# in the Debugger
#
sub EnterActions {
  my($self) = @_ ;

  # $self->{'main_window'}->Unbusy() ;
}

#
# Subroutine called when we return from DB::DB()
# When the target script resumes.  
#
sub LeaveActions {
  my($self) = @_ ;

  # $self->{'main_window'}->Busy() ;
}


sub BEGIN {
  $Devel::tkdb::scriptName = $0 ;
  @Devel::tkdb::script_args = @ARGV ; # copy args
}

##
## Save the ptkdb state file and restart the debugger
##
sub DoRestart {
  my $fname = $ENV{'TMP'} || $ENV{'TMPDIR'} || $ENV{'TMP_DIR'} || $ENV{'TEMP'} || $ENV{'HOME'};
  $fname .= '/' if $fname;
  $fname = "" unless $fname;

  $fname .= "ptkdb_restart_state$$" ;

  # print "saving temp state file $fname\n" ;

  &DB::save_state_file($fname) ;

  $ENV{'PTKDB_RESTART_STATE_FILE'} = $fname ;

  ##
  ## build up the command to do the restart
  ##

  $fname = "perl -w -d:tkdb $Devel::tkdb::scriptName @Devel::tkdb::script_args" ;

  # print "$$ doing a restart with $fname\n" ;

  exec $fname ;

} # end of DoRestart

##
## Enables/Disables the feature where we stop
## if we've encountered a perl warning such as:
## "Use of uninitialized value at undef_warn.pl line N"
##

sub stop_on_warning_cb {
  &$DB::tkdb::warn_sig_save() if $DB::tkdb::warn_sig_save ; # call any previously registered warning
 $DB::window->DoAlert(@_) ;
 $DB::single = 1 ; # forces debugger to stop next time
}

sub set_stop_on_warning {

  if( $DB::tkdb::stop_on_warning ) {

    return if $DB::tkdb::warn_sig_save == \&stop_on_warning_cb ; # prevents recursion

    $DB::tkdb::warn_sig_save = $SIG{'__WARN__'} if $SIG{'__WARN__'} ;
    $SIG{'__WARN__'} = \&stop_on_warning_cb ;
     }
  else {
    ##
    ## Restore any previous warning signal
    ##
    local($^W) = 0 ;
    $SIG{'__WARN__'} = $DB::tkdb::warn_sig_save ;
  }
} # end of set_stop_on_warning

# end of Devel::tkdb

package DB;

use vars '@dbline', '%dbline';

our $VERSION = '2.0';

#
# Here's the clue...
# eval only seems to eval the context of
# the executing script while in the DB
# package.  When we had updateExprs in the Devel::tkdb
# package eval would turn up an undef result.
#

sub updateExprs {
  my ($package) = @_ ;
  #
  # Update expressions
  # 
  $DB::window->deleteAllExprs();

  foreach my $expr (@{$DB::window->{'expr_list'}}) {
    next if length $expr == 0 ;

    my @result = &DB::dbeval($package, $expr->{'expr'}) ;

    my $r = (@result==1?$result[0]:\@result);
    $DB::window->insertExpr([$r], $r, $expr->{'expr'}, $expr->{'depth'},'root');
  }
} # end of updateExprs

#no strict ; # turning strict off (shame shame) because we keep getting errrs for the local(*dbline)

#
# returns true if line is breakable
#
sub checkdbline($$) { 
  my ($fname, $lineno) = @_ ;

  return 0 unless $fname; # we're getting an undef here on 'Restart...'

  local($^W) = 0 ; # spares us warnings under -w
  local(*dbline) = $main::{'_<' . $fname} ;

  my $flag = $dbline[$lineno] != 0 ;

  return $flag;

} # end of checkdbline

#
# sets a breakpoint 'through' a magic 
# variable that perl is able to interpert
#
sub setdbline($$$) {
  my ($fname, $lineno, $value) = @_ ;
  local(*dbline) = $main::{'_<' . $fname};

  $dbline{$lineno} = $value ;
} # end of setdbline

sub getdbline($$) {
  my ($fname, $lineno) = @_ ;
  local(*dbline) = $main::{'_<' . $fname};
  return $dbline{$lineno} ;
} # end of getdbline

sub getdbtextline {
  my ($fname, $lineno) = @_ ;
  local(*dbline) = $main::{'_<' . $fname};
  return $dbline[$lineno] ;
} # end of getdbline


sub cleardbline($$;&) {
  my ($fname, $lineno, $clearsub) = @_ ;
  local(*dbline) = $main::{'_<' . $fname};
  my $value ; # just in case we want it for something

  $value = $dbline{$lineno} ;
  delete $dbline{$lineno} ;
  &$clearsub($value) if $value && $clearsub ;

  return $value ;
} # end of cleardbline

sub clearalldblines(;&) {
  my ($clearsub) = @_ ;
  my ($key, $value, $brkPt, $dbkey) ;
  local(*dbline) ;

  while ( ($key, $value) = each %main:: )  { # key loop
    next unless $key =~ /^_</ ;
    *dbline = $value ;

    foreach $dbkey (keys %dbline) {
      $brkPt = $dbline{$dbkey} ;
      delete $dbline{$dbkey} ;
      next unless $brkPt && $clearsub ;
      &$clearsub($brkPt) ; # if specificed, call the sub routine to clear the breakpoint
    }

  } # end of key loop

} # end of clearalldblines

sub getdblineindexes {
  my ($fname) = @_ ;
  local(*dbline) = $main::{'_<' . $fname} ;
  return keys %dbline ;
} # end of getdblineindexes

sub getbreakpoints {
  my (@fnames) = @_;
  my @retList;

  for my $fname (@fnames) {
    next unless  $main::{'_<' . $fname};
    local(*dbline) = $main::{'_<' . $fname};
    push @retList, values %dbline;
  }
  return @retList;
} # end of getbreakpoints

#
# Construct a hash of the files that have breakpoints to save
#
sub breakpoints_to_save {
  my (@breaks);
  my $brkList = {};

  for my $file ( keys %main:: ) { # file loop
    next unless $file =~ /^_</ && exists $main::{$file};
    local(*dbline) = $main::{$file};

    next unless @breaks = values %dbline;

    $brkList->{$file} = [map { { %$_ } } @breaks]; # list of anon.hashes
  } # end of file loop

  return $brkList;

} # end of breakpoints_to_save

#
# When we restore breakpoints from a state file
# they've often 'moved' because the file has been editted.  
#
# We search for the line starting with the original line number,
# then we walk it back 20 lines, then with line right after the
# orginal line number and walk forward 20 lines.  
#
# NOTE: dbline is expected to be 'local' when called
#
sub fix_breakpoints {
  my(@brkPts) = @_ ;
  my (@retList) ;
  local($^W) = 0;

  my $nLines = scalar @dbline;

  for my $brkPt (@brkPts) {

    my $startLine = $brkPt->{'line'} > 20 ? $brkPt->{'line'} - 20 : 0 ;
    my $endLine   = $brkPt->{'line'} < $nLines - 20 ? $brkPt->{'line'} + 20 : $nLines;

    for( (reverse $startLine..$brkPt->{'line'}), $brkPt->{'line'} + 1 .. $endLine ) {
      next unless $brkPt->{'text'} eq $dbline[$_] ;
      $brkPt->{'line'} = $_ ;
      push @retList, $brkPt ;
      last;
    }
  } # end of breakpoint list

  return @retList;
} # end of fix_breakpoints

#
# Restore breakpoints saved above
#
sub restore_breakpoints_from_save {
  my ($brkList) = @_;

  while ( my ($key, $list) = each %$brkList ) { # reinsert loop
    next unless exists $main::{$key};
    local(*dbline) = $main::{$key};

    my @newList = fix_breakpoints(@$list);

    for my $brkPt ( @newList ) {
      if( !&DB::checkdbline($key, $brkPt->{'line'}) ) {
        print "Breakpoint $key:$brkPt->{'line'} in config file is not breakable.\n" ;
        next ;
      }
      $dbline{$brkPt->{'line'}} = { %$brkPt } ; # make a fresh copy
    }
  } # end of reinsert loop

} # end of restore_breakpoints_from_save ;

sub dbint_handler {
  my($sigName) = @_;
  $DB::single = 1;
  print STDERR "signalled\n";
} # end of dbint_handler

#
# Do first time initialization at the startup of DB::DB
#
my $isInitialized=0;
sub Initialize {
  my ($fName) = @_ ;
  $isInitialized = 1;

 $DB::window = new Devel::tkdb;

 $DB::window->do_user_init_files();

 $DB::dbint_handler_save = $SIG{'INT'} unless $DB::sigint_disable ; # saves the old handler
  $SIG{'INT'} = "DB::dbint_handler" unless $DB::sigint_disable ;

  # Save the file name we started up with
 $DB::startupFname = $fName ;

  # Check for a 'restart' file

  if( $ENV{'PTKDB_RESTART_STATE_FILE'} && -e $ENV{'PTKDB_RESTART_STATE_FILE'} ) {
    ##
    ## Restore expressions and breakpoints in state file
    ##
    $DB::window->restoreStateFile($ENV{'PTKDB_RESTART_STATE_FILE'}) ;
    unlink $ENV{'PTKDB_RESTART_STATE_FILE'} ; # delete state file

    # print "restoring state from $ENV{'PTKDB_RESTART_STATE_FILE'}\n" ;

    $ENV{'PTKDB_RESTART_STATE_FILE'} = "" ; # clear entry
  }
  else {
    &DB::restoreState($fName);
  }

} # end of Initialize 

sub restoreState {
  my ($fName) = @_;

  my $stateFile = makeFileSaveName($fName);
  if( -e $stateFile && -r $stateFile ) {
    my ($files, $expr_list, $eval_saved_text, $main_win_geometry) = $DB::window->get_state($stateFile) ;
    &DB::restore_breakpoints_from_save($files) ;
    $DB::window->{'expr_list'} = $expr_list if defined $expr_list ;
    $DB::window->{eval_saved_text} = $eval_saved_text ;

    if ($main_win_geometry) { 
        # restore the height and width of the window
        $DB::window->{main_window}->geometry($main_win_geometry) ;
    }
  }

} # end of Restore State

sub makeFileSaveName {
    return "$_[0].tkdb";
}

sub save_state_file {
  my ($fname) = @_;

  my $files = &DB::breakpoints_to_save();

  my $d = Data::Dumper->new( [ $files, $DB::window->{'expr_list'}, "" ],
                          [ "files", "expr_list",  "eval_saved_text" ] );
  $d->Purity(1);

  open my $fh, ">$fname" or die "Couldn't open file $fname";
  print $fh $d->Dump() or die "Couldn't write file";
} # end of save_state_file

sub SaveState {
  my($name_in) = @_ ;
  my ($eval_saved_text);
  my $win = $DB::window;

  #
  # Extract the height and width of our window
  #
  my $main_win_geometry = $win->{main_window}->geometry ;

  if ( defined $win->{save_box} ) {
    $win->{save_box}->raise ;
    $win->{save_box}->focus ;
    return ;
  }

  my $saveName = $name_in || makeFileSaveName($DB::startupFname) ;


  my $saveSub = sub {
    delete $win->{save_box} ;

    if( exists $win->{eval_window} ) {
      $eval_saved_text = $win->{eval_text}->get('1.0', 'end') ;
    }
    else {
      $eval_saved_text =  $win->{eval_saved_text} ;
    }

    my $files = &DB::breakpoints_to_save();

    my $d = Data::Dumper->new( [ $files, $win->{'expr_list'}, $eval_saved_text,   $main_win_geometry ], 
                            [ "files", "expr_list",        "eval_saved_text",  "main_win_geometry"] ) ;
    $d->Purity(1) ;
    eval {
      open my $fh, ">$saveName" or die "Couldn't open file $saveName";
      print $fh $d->Dump() or die "Couldn't write file";
    };
    $win->DoAlert($@) if $@;
    $win->{int}->SetVar('event','null');
  }; # end of save sub

  my $cancelSub = sub {
    delete $win->{'save_box'}
  } ; # end of cancel sub

  #
  # Create a dialog
  #

  $win->{'save_box'} = $win->simplePromptBox("Save Config?", $saveName, $saveSub, $cancelSub) ;

} # end of SaveState

sub RestoreState {
  $DB::window->simplePromptBox("Restore Config?", makeFileSaveName($DB::startupFname), sub {
    $DB::window->restoreStateFile($Devel::tkdb::promptString);
  });
} # end of RestoreState

sub SetStepOverBreakPoint {
  my ($offset) = @_ ;
 $DB::step_over_depth = $DB::subroutine_depth + ($offset ? $offset : 0) ;
} # end of SetStepOverBreakPoint

#
# NOTE:   It may be logical and somewhat more economical
#         lines of codewise to set $DB::step_over_depth_saved 
#         when we enter the subroutine, but this gets called
#         for EVERY callable line of code in a program that
#         is being debugged, so we try to save every line of
#         execution that we can.
#
sub isBreakPoint {
  my ($fname, $line, $package) = @_ ;

  if ( $DB::single && ($DB::step_over_depth < $DB::subroutine_depth) && ($DB::step_over_depth > 0) && !$DB::on) {
      $DB::single = 0  ;
      return 0 ;
  }
  #
  # doing a step over/in
  # 

  if( $DB::single || $DB::signal ) {
      $DB::single = 0 ;
      $DB::signal = 0 ;
      $DB::subroutine_depth = $DB::subroutine_depth ;
      return 1 ;
  }
  #
  # 1st Check to see if there is even a breakpoint there.  
  # 2nd If there is a breakpoint check to see if it's check box control is 'on'
  # 3rd If there is any kind of expression, evaluate it and see if it's true.  
  #
  my $brkPt = &DB::getdbline($fname, $line) ;

  return 0 if( !$brkPt || !$brkPt->{'value'} || !breakPointEvalExpr($brkPt, $package) ) ;

  &DB::cleardbline($fname, $line) if( $brkPt->{'type'} eq 'temp' ) ;

  $DB::subroutine_depth = $DB::subroutine_depth ;

  return  1 ;
} # end of isBreakPoint

#
# Check the breakpoint expression to see if it is true.  
#
sub breakPointEvalExpr {
  my ($brkPt, $package) = @_ ;

  return 1 unless $brkPt->{expr} ; # return if there is no expression

  no strict ;
  my @result = &DB::dbeval($package, $brkPt->{expr}) ;
  use strict ;

  $DB::window->DoAlert($@) if $@ ;

  return $result[0] || @result ; # we could have a case where the 1st element is undefined
  # but subsequent elements are defined

} # end of breakPointEvalExpr

#
# Evaluate the given expression, return the result.
# MUST BE CALLED from within DB::DB in order for it
# to properly interpret the vars
#
sub dbeval {
  my($ptkdb__package, $ptkdb__expr) = @_ ;
  local($^W) = 0 ; # temporarily turn off warnings

  no strict ;
  #
  # This substitution is done so that 
  # we return HASH, as opposed to an ARRAY.
  # An expression of %hash results in a
  # list of key/value pairs.  
  #

  $ptkdb__expr =~ s/^\s*%/\\%/;

  @_ = @DB::saved_args; # replace @_ arg array with what we came in with

  my @ptkdb__result = eval <<__EVAL__;
  \$\@ = \$DB::save_err;
  ${ \ ( $ptkdb__package ? "package $ptkdb__package;":"")}
  $ptkdb__expr;
__EVAL__

    @ptkdb__result = ("ERROR ($@)") if $@ ;

  use strict ;

  return @ptkdb__result ;
} # end of dbeval

#
# Call back we give to our 'quit' button
# and binding to the WM_DELETE_WINDOW protocol
# to quit the debugger.  
#
sub dbexit {
    print STDERR "dbexit\n";
  exit ;
} # end of dbexit

#
# This is the primary entry point for the debugger.  When a perl program
# is parsed with the -d (in our case -d:tkdb) option set the parser will
# insert a call to DB::DB in front of every excecutable statement.  
# 
# Refs:  Progamming Perl 2nd Edition, Larry Wall, O'Reilly & Associates, Chapter 8
#

sub DB {
  @DB::saved_args = @_ ; # save arg context
  $DB::save_err = $@ ; # save value of $@
   my ($package, $filename, $line) = caller ;

   unless( $isInitialized ) {
     return if( $filename ne $0 ) ; # not in our target file
     &DB::Initialize($filename) ;
   }

   if (!isBreakPoint($filename, $line, $package) ) {
     $DB::single = 0;
     $@ = $DB::save_err;
     return;
   }

   if ( !$DB::window ) { # not setup yet
     $@ = $DB::save_err;
     return;
   }

  $DB::window->setup_main_window() unless $DB::window->{'main_window'} ;

  $DB::window->EnterActions(); 

   my ($saveP) = $^P;
   $^P = 0 ;

  $DB::on = 1 ;

#
# The user can specify this variable in one of the startup files,
# this will make the debugger run right after startup without
# the user having to press the 'run' button.  
#
   if ($DB::no_stop_at_start) {
     $DB::no_stop_at_start = 0;
     $DB::on = 0;
     $@ = $DB::save_err;
     return;
   }

   if( !$DB::sigint_disable ) {
     $SIG{'INT'} = $DB::dbint_handler_save if $DB::dbint_handler_save ; # restore original signal handler
     $SIG{'INT'} = "DB::dbexit" unless   $DB::dbint_handler_save ;
   }

  $DB::window->{main_window}->focus();

  $DB::window->set_file($filename, $line) ;
   #
   # Refresh the exprs to see if anything has changed
   #
   updateExprs($package) ;

   #
   # Update subs Page if necessary
   #
   my $cnt = scalar keys %DB::sub;
   if ( $cnt != $DB::window->{'subs_list_cnt'} && exists $DB::window->{'subs_list0'} ) {
     $DB::window->fill_subs_page();
     $DB::window->{'subs_list_cnt'} = $cnt;
   }
   #
   # Update the subroutine stack menu
   #
   $DB::window->refresh_stack_menu();

   my (@result);

   for( ; ; ) {
     #
     # we wait here for something to do
     #
     my $evt = $DB::window->main_loop();

     last if( $evt eq 'step' );

     $DB::single = 0 if ($evt eq 'run');

     if ($evt eq 'balloon_eval' ) {
         $DB::window->code_motion_eval(&DB::dbeval($package, $DB::window->{'balloon_expr'})) ;
         next ;
     }

     if ( $evt eq 'vexpr' ) {
         @result = &DB::dbeval($package, $DB::window->{text}->get('sel.first','sel.last'));
         my $s = Data::Dumper->new([@result])->Terse(2)->Dump();
         #print STDERR "[$s]";
         $DB::window->{w_nb}->_raise("evalpage");
         $DB::window->{w_eval_text}->insert('end', $s);
         $DB::window->{w_eval_text}->_seeEnd;
         $evt = 'null';
         next;
     }
     if ( $evt eq 'qexpr' ) {
         @result = &DB::dbeval($package, $DB::window->{'qexpr'}) ;
         $DB::window->{'quick_entry'}->delete(0, 'end') ; # clear old text
         $DB::window->{'quick_dumper'}->Reset() ;
         $DB::window->{'quick_dumper'}->Values( [ $#result == 0 ? @result : \@result ] ) ;
         $DB::window->{'quick_entry'}->insert(0, $DB::window->{'quick_dumper'}->Dump());
         $DB::window->{'quick_entry'}->selectionRange(0, 'end') ; # select it
         $evt = 'update' ; # force an update on the expressions
     }

         if( $evt eq 'expr' ) {
           #
           # Append the new expression to the list
           # but first check to make sure that we don't already have it.
           #

           if ( grep $_->{expr} eq $DB::window->{expr}, @{$DB::window->{'expr_list'}} ) {
             $DB::window->DoAlert("$DB::window->{expr} is already listed") ;
             next ;
           }

           @result = &DB::dbeval($package, $DB::window->{expr}) ;
	   my $rr = (@result == 1? $result[0] : \@result);
           my $r = $DB::window->insertExpr([ $rr ], $rr, $DB::window->{expr}, -1,'root') ;

           #
           # $r will be 1 if the expression was added succesfully, 0 if not,
           # and it if wasn't added sucessfully it won't be reevalled the 
           # next time through.  
           #
           push @{$DB::window->{'expr_list'}}, { expr => $DB::window->{expr}, depth => -1 } if $r;

           next;
         }
         if( $evt eq 'update' ) {
           updateExprs($package);
           next;
         }
         if( $evt eq 'reeval' ) {
           #
           # Reevaluate the contents of the expression eval window
           my $txt = $DB::window->{'eval_text'}->get('1.0', 'end');
           my @result = &DB::dbeval($package, $txt);

           $DB::window->updateEvalWindow(@result) ;

           next;
         }
         last;
       }
       $^P = $saveP ;
       $SIG{'INT'} = "DB::dbint_handler"   unless $DB::sigint_disable ; # set our signal handler

     $DB::window->LeaveActions() ;

       $@ = $DB::save_err ;
     $DB::on = 0 ;
} # end of DB

##
## in this case we do not use local($^W) since we would like warnings
## to be issued past this point, and the localized copy of $^W will not
## go out of scope until  the end of compilation
##
##

#
# This is another place where we'll try and keep the
# code as 'lite' as possible to prevent the debugger
# from slowing down the user's application
#
# When a perl program is parsed with the -d(in our case a -d:tkdb) option
# the parser will route all subroutine calls through here, setting $DB::sub
# to the name of the subroutine to be called, leaving it to the debugger to
# make the actual subroutine call and do any pre or post processing it may
# need to do.  In our case we take the opportunity to track the depth of the call
# stack so that we can update our 'Stack' menu when we stop.  
#
# Refs:  Progamming Perl 2nd Edition, Larry Wall, O'Reilly & Associates, Chapter 8
#
#
   sub sub {
#
# See NOTES(1)
#
       $DB::subroutine_depth += 1 unless $DB::on ;
       $DB::single = 0 if ( ($DB::step_over_depth < $DB::subroutine_depth) && ($DB::step_over_depth >= 0) && !$DB::on) ;

       if( wantarray ) {
	 # array context

         no strict ; # otherwise perl gripes about calling the sub by the reference
         my @result = &$DB::sub ; # call the subroutine by name
         use strict ;

       $DB::subroutine_depth -= 1 unless $DB::on ;
       $DB::single = 1 if ($DB::step_over_depth >= $DB::subroutine_depth && !$DB::on); 
         return @result;

       } elsif(defined wantarray) {
	 # scalar context

         no strict;
         my $result = &$DB::sub;
         use strict;

       $DB::subroutine_depth -= 1 unless $DB::on;
       $DB::single = 1 if ($DB::step_over_depth >= $DB::subroutine_depth  && !$DB::on);
         return $result;

       } else {
	 # void context

         no strict;
         &$DB::sub;
         use strict;

       $DB::subroutine_depth -= 1 unless $DB::on ;
       $DB::single = 1 if ($DB::step_over_depth >= $DB::subroutine_depth && !$DB::on);
         return;

       }

   } # end of sub

1; # return true value

