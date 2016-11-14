#checkLineBreaks.pl

Detect and optionally convert line breaks of a given text file to match system

##Usage 

    ./checkLineBreaks.pl FILE [options]

##Options
    
    -w,--write_if_diff
        Only create and write to output file if line breaks differ between
        the input file and the current system.
        
    -o,--output FILE
        Output file. If provided the input file will be written to this file 
        with all line breaks converted to the current systems

    -d,--dos
        Force system line breaks to match those of DOS/Windows. 
        Can be used to output DOS/Windows formatted lines if on a different 
        system type.

    -u,--unix
        Force system line breaks to match those of Unix.
        Can be used to output Unix formatted lines if on a different 
        system type.

    -m,--mac
        Force system line breaks to match those of OLD Mac OS (OS9 and earlier).
        Can be used to output old Mac OS formatted lines if on a different 
        system type.

    -h,--help
        Show this message and exit

##Tests

These scripts have been tested on Linux systems only (to date). To test on your
system type 'prove' from within your installation directory in order to run the 
tests provided.

##Author

David A. Parry

##COPYRIGHT AND LICENSE

Copyright 2016  David A. Parry

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

