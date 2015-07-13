Goto: a quick and dirty bash script to quickly
move between places in your system. Create an alias with:

 > goto -m target alias

Zoom to the target with:

 > goto alias

List your aliases with:

 > goto -l

Delete an alias with:

 > goto -d alias

For goto to work properly, it should be sourced by your
main .bashrc file. Simply add the line:

source /path/to/goto.sh

And you should be good to go.

Any bug reports / suggestions are generally welcome.
