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

##Author

David A. Parry

 
