Goto: a quick, dirty, and god-awful bash script to quickly
move between places in your system. Create an alias with:

 > goto -m target alias

Zoom to the target with:

 > goto alias

Currently doesn't sanitize arguments very well, is rife with
potential bugs, and probably shouldn't be used by anyone.
In order for the 'cd' command to work as expected, this has
to be run in the same shell you call it in, and not a
subshell. To do this, either put this in a function goto()
in your .bashrc or configure an alias like:

 > alias goto='. goto'

in your .bashrc.
