#!/use/bin/env perl
use strict;
use warnings;
use Test::More;# tests => 158;
use FindBin qw($RealBin);

BEGIN 
{ 
    use_ok("Getopt::Long");
    use_ok("File::Temp");
    use_ok("IO::Uncompress::Gunzip");
}
my $n_tests = 3;
my $script_prefix = "perl $RealBin/../checkLineBreaks.pl";

doUnix();
doDos();
doMac();

done_testing($n_tests);

##################################################
sub doUnix{
    doUnixTests("$RealBin/test_data/unix.txt", "text");   
    doUnixTests("$RealBin/test_data/unix.txt.gz", "gzipped data");   
}
##################################################
sub doDos{
    doDosTests("$RealBin/test_data/dos.txt", "text");   
    doDosTests("$RealBin/test_data/dos.txt.gz", "gzipped data");   
}
##################################################
sub doMac{
    doMacTests("$RealBin/test_data/mac.txt", "text");   
    doMacTests("$RealBin/test_data/mac.txt.gz", "gzipped data");   
}

##################################################
sub doUnixTests{
    my $f = shift;
    my $data_type = shift;
    my $cmd = "$script_prefix $f -u";
    my $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Unix'\n". 
        "Line breaks appear to MATCH system line break type.\n",
        "correctly detect unix line breaks from $data_type",
    );
    $n_tests++;

    $cmd =~ s/\-u$/-d/;
    $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Unix'\n". 
        "Line breaks do NOT appear to match system line break type.\n",
        "correctly detect unix as non-DOS from $data_type",
    );
    $n_tests++;

    $cmd =~ s/\-d$/-m/;
    $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Unix'\n". 
        "Line breaks do NOT appear to match system line break type.\n",
        "correctly detect unix as non-oldschool Mac from $data_type",
    );
    $n_tests++;

}

##################################################
sub doDosTests{
    my $f = shift;
    my $data_type = shift;
    my $cmd = "$script_prefix $RealBin/test_data/dos.txt -d";
    my $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Windows/DOS'\n".
        "Line breaks appear to MATCH system line break type.\n",
        "correctly detect DOS line breaks from $data_type",
    );
    $n_tests++;

    $cmd =~ s/\-d$/-u/;
    $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Windows/DOS'\n".
        "Line breaks do NOT appear to match system line break type.\n",
        "correctly detect DOS as non-unix from $data_type",
    );
    $n_tests++;

    $cmd =~ s/\-u$/-m/;
    $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Windows/DOS'\n".
        "Line breaks do NOT appear to match system line break type.\n",
        "correctly detect DOS as non-oldschool Mac from $data_type",
    );
    $n_tests++;

}

##################################################
sub doMacTests{
    my $f = shift;
    my $data_type = shift;
    my $cmd = "$script_prefix $RealBin/test_data/mac.txt -m";
    my $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Mac OS 9 or earlier'\n". 
        "Line breaks appear to MATCH system line break type.\n",
        "correctly detect mac line breaks from $data_type",
    );
    $n_tests++;

    $cmd =~ s/\-m$/-d/;
    $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Mac OS 9 or earlier'\n". 
        "Line breaks do NOT appear to match system line break type.\n",
        "correctly detect mac as non-DOS from $data_type",
    );
    $n_tests++;

    $cmd =~ s/\-d$/-u/;
    $output = `$cmd 2>&1`;
    is
    (
        $output,
        "Interpretting line breaks as of type 'Mac OS 9 or earlier'\n". 
        "Line breaks do NOT appear to match system line break type.\n",
        "correctly detect mac as non-unix from $data_type",
    );
    $n_tests++;

}
