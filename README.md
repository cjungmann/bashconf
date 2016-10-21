# bashconf

A simple script-based program for accessing _gsettings_ values, similar
to _dconf-editor_, with the ability to use a shortcut via a command line
argument.  It was developed and tested on Ubuntu 14.04.  It doesn't apply
to Windows at all, and may not work on other Linux-based platforms.

At the current stage of development, this program is mainly suitable for
viewing schema keys with current and default values.

Having neglected far more important projects while working on this,
I am setting this aside with no plans.  However, there are some things I
would like to add if I do come back to this.  These ideas are
listed in the _Future Plans_ section at the bottom of this document.

## Purpose of Program

The program, _bashconf_ has two purposes,

1. Allow easier, possibly saved, access to specific configuration pages.

2. A demonstration of techniques with BASH, AWK, YAD, and xsltproc.  Some
   of the techniques are described under _Programming Techniques_ later
   in this document, others are simply comments in the script files. Look
   around.

## Program Usage

The following examples assume that you are in the _bashconf_ working
directory. Ignore the _./_ if you've installed to to _/usr/bin_.

Start fresh with a list of the lowest-level schema domains, then select
a line to get subcategories.  Drill down to eventually open the keys pages
of specific schemas.

~~~sh
$ ./bashconf
~~~

If you want to open a specific page or branch, add it to the command:

~~~sh
$ ./bashconf org.gnome.desktop.wm.keybindings
~~~

Press _Cancel_ or the _Escape_ key on any page to close the current
dialog.  Closing a dialog reveals the dialog that opened the just-closed
dialog.  This continues until the initial dialog is closed, at which
point the program ends.

## Program Setup

I don't expect this program to replace _dconf-editor_, so I have not
attempted to conform to the [Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard).
I plan to use this program in its working directory.

### Generate Cached Information

This program compares information from _gsettings_ and the set of
_.gschema.xml_ files that explain how to access and edit the configuration
settings.  Run the following command to compile a list of schemas and
their helper files for faster access later.  The program will not run
without the cache file.

~~~sh
./setup_schema_list
~~~

### Shortcut to Program
I made a shortcut in /~/bin (which is in my PATH):

~~~sh
#!/bin/bash
savedir="$PWD"
cd /home/chuck/work/bashconf
./bashconf $*
cd "$savedir"
~~~


## Programming Techniques

I don't get a lot of practice using **bash** scripts, and even less with
**awk** scripting, so I want to document some techniques I used in this
program for future reference.

- **awk** for processing data.  Other times I have used _awk_ to create an
  XML file from data, then XSL to modify the data.  However, with this project,
  I realized that _awk_ would be completely adequate for what I wanted to do,
  and a much lower computational cost.

  I want to particularly highlight:

  - **awk interpreter directive** Using `#!/usr/bin/awk -f` in the first line
    of the script invokes _awk_ to run the script.  For a complete _awk_
    solution, this is more direct that making a _bash_ script call _awk_.
    
  - **if/else-if/else execution** When an _awk_ script must execute _actions_
    based on _pattern_ matches, an _if/else-if/else_ model can be duplicated
    with a _next_ instruction at the end of an _action_.  If the _pattern_
    doesn't match, _awk_ won't encounter the _next_, to the following pattern
    will be considered.

    Seek the script **util_identify_relocatables** for an example.

  - **awk lookup pattern**  _util_identify_relocatables_ is also an example
    of using a third source of data as a guide for the output.  A list of
    special-case schemas is passed to the _awk_ script via a named value.
    The script selects an action based on whether or not the schema of the
    current line is included in the third data source.

  - **awk unique selection** The script _util_get_schemas_ compares each line
    with the previous, only writing output if the current and previous lines
    are different.  This obviously depends on the list being sorted on the
    target field.

  - **awk _pattern_ / _action_ syntax**  Unlike the flexibility of favored C/C++
    syntax for code blocks, _awk_ requires that the opening curly-brace of the
    _action_ follows the _pattern_ on the _same line_, even if the _action_
    block continues for multiple lines.  Also note the use of _OFS_ (output
    field separator) instead of _printf_.

    ~~~awk
    # Single-line action obviously follows,
    BEGIN { RS = "\n"; FS = "\t"; OFS = "\t" }

    # For multi-line actions, the curly-brace follows the pattern on the same line:
    rlist~$1 {
       print 
       print $1, "r", $2
    }
    ~~~

- **bash** use, on the command line and in scripts.

  - **awk script in heredoc**  Avoid using multiple scripts to accomplish a
    single task by including an _awk_ script in the _bash_ script.

    The script **util_get_keys** demonstrates:
    - A here doc _awk_ script.
    - How to use the _awk_ script variable with _awk_.

  - **awk script with parameters**

  - Variable substitution notation to replace periods with slashes, also
    in _util_get_keys_.

  - Convert strings to arrays in **bashconf** script.
  
    For a string like 12|13|14 can be converted to (12 13 14) with:
    `IFS='|' read -r -a parr <<< "$1"`

- **YAD** Yet Another Dialog.  I started this with _dialog_ for console
  dialogs, then found _gdialog_ for X11 to show more text in a smaller area,
  and finally decided to implement with _YAD_.

  This is my first attempt using _YAD_, so there's probably not much to
  learn here.  I intend to use _YAD_ frequently in the future to do things
  I couldn't easily do previously.  Those projects will be better examples
  of what can be done in _YAD_.

## Future Plans

I must set this aside to do more pressing work, but there are some features
I would like to add to this project.

- **Ability to edit key values**  There are several key types, many can also
  hold arrays (ie, multiple values), so this part is not done.  To do it
  right, I would have to use a list dialog to show current entries, perhaps
  as checkboxes perform an action on several at once, like delete.  The
  list dialog would need an add button as well.

- **Handling Relocatable Schemas**  Relocatable schemas are the reason this
  project is so rudimentary, I spent two days trying to figure them out,
  specifically, how to read the _.gschema.xml_ and _gsettings_ values to
  determine the appropriate path to access keys in a org.compiz profile.
  I wanted to be able to view and change the workspaces configuration, but
  I could never get the observed current value of _hsize_ and _vsize_, that
  is, I have a 3x2 workspaces configuration, _gsettings_ reported 1x1.

- **Bookmarking Schemas** With the ability to jump directly to a page
  from a command line parameter, it should be a short step to adding
  bookmarks.  However, this would mean a more formal installation, with
  a _/~/.bashconf_ directory in which to save the bookmarks, and more
  sophisiticated YAD configuration to advertise and make the bookmarks
  available.

- **Quicker Exit**  It's not very nice to have to escape-escape-escape...
  to exit the program. I should add handling for Ctrl-C or add a button
  to the dialog to fully exit.