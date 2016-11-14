#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use File::Temp qw/ tempfile /;
use IO::Uncompress::Gunzip qw/ gunzip $GunzipError /;
my %opts = ();

my %breaks = 
(
    d => "\r\n",
    u => "\n",
    m => "\r",
);

GetOptions
(
    \%opts,
    'w|write_if_diff',
    'o|output=s',
    'd|dos',
    'u|unix',
    'm|mac',
    'h|help',
) or usage("Syntax error in option spec\n");
usage() if $opts{h};
usage("A single file must be provided on the commandline\n") if @ARGV != 1;
my $in = shift;
my @force_opts = ();
@force_opts = map { exists $opts{$_} ? $_ : () } qw / d u m /; 
if (@force_opts > 1){
    die "Only one of --dos/--unix/--mac options may be specified.\n";
}elsif(@force_opts == 1){
    $/ = $breaks{$force_opts[0]};
}

my ($TMP, $tmp); 
if ( -p $in or $in eq '-') {#reading from pipe/STDIN
    if ($opts{o}){#write to temp file if we want to write to output file
        ($TMP, $tmp) = tempfile( UNLINK => 1, TMPDIR => 1 );
    }
}

my $buffer = '';
my $IN;
if ($in =~ /\.gz$/){
    $IN = new IO::Uncompress::Gunzip $in,  MultiStream => 1
          or die "IO::Uncompress::Gunzip failed while opening $in for reading:".
          "\n$GunzipError";
}else{
    open ($IN, "<", $in) or die "Failed to open $in for reading: $! ";
}
my ($nl, $cr) = (0, 0);
while( read($IN, $buffer, 1024) ){
    $nl += () = $buffer =~ /\n/g;
    $cr += () = $buffer =~ /\r/g;
    if ($TMP){
        print $TMP $buffer;
    }
}
close $IN;
close $TMP if $TMP;

my $type = '';
my $in_newline = '';
if ($cr > $nl ){
    $type = 'Mac OS 9 or earlier';
    $in_newline = "\r";
}elsif($cr == $nl){
    $type = 'Windows/DOS';
    $in_newline = "\r\n";
}else{
    $type = 'Unix';
    $in_newline = "\n";
}

print STDERR "Interpretting line breaks as of type '$type'\n";
if ($in_newline eq $/){
    print STDERR "Line breaks appear to MATCH system line break type.\n";
}else{
    print STDERR "Line breaks do NOT appear to match system line break type.\n";
}

if ($opts{o}){
    if ($in_newline eq $/ and $opts{w}){
        print STDERR "Not writing to output file because line breaks match ".
                    "system type and -w/--write_if_diff option is specified.\n";
    }else{
        convertFile();
    }
}

##################################################
sub convertFile{
    my $INFILE;
    if ($tmp){
        open ($INFILE, $tmp) or 
          die "Error opening temporary file '$tmp' for reading: $!\n";
    }else{
        if ($in =~ /\.gz$/){
        $INFILE = new IO::Uncompress::Gunzip $in, MultiStream => 1 or 
          die "IO::Uncompress::Gunzip failed while opening $in for reading:".
          "\n$GunzipError";
        }else{
            open ($INFILE, "<", $in) or die "Failed to open $in for reading: $! ";
        }
    }
    open (my $OUT, ">", $opts{o}) or die "Could not open output file " .
                                         "'$opts{o}' for reading: $!\n";
    print STDERR "Writing output to $opts{o}...\n";
    my $conv_new_line = $/;
    $/ = $in_newline;
    while (my $line = <$INFILE>){
        $line =~ s/$in_newline/$conv_new_line/;
        print $OUT $line;
    }
    close $INFILE;
    close $OUT;
    print STDERR "Done.\n";
}

##################################################
sub usage{
    my $msg = shift;
    print STDERR "\n$msg\n" if $msg;
    print <<EOT

Detect and optionally convert line breaks of a given text file to match system

USAGE: $0 FILE [options]

OPTIONS:
    
    -o,--output FILE
        Output file. If provided the input file will be written to this file 
        with all line breaks converted to those of the current system

    -w,--write_if_diff
        Only create and write to output file if line breaks differ between
        the input file and the current system.
        
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

AUTHOR

    David A. Parry


COPYRIGHT AND LICENSE

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


EOT
    ;
    exit 1 if $msg;
    exit;
}
