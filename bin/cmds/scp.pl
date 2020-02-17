#!/usr/bin/env perl

use strict;
use warnings;

my $port=shift(@ARGV);
my $password=shift(@ARGV);
my $args=join(" ",@ARGV);

open(P,"scp.exp $port $password $args |") or die;
my $l=0;
my $pw=0;
my $exitcode=0;
my $s="";
while (<P>) {
	++$l;
	if (($l==1) && /^spawn/) {
		$s.=$_;
		next;
	}
	if ($pw==0 && /assword:/) {
		$pw=1;
		$s.=$_;
		next;
	}
	if ($pw==0) {
		$s.=$_;
		next;
	}

	print STDERR $s;
	$s="";
	print STDERR $_;
	$exitcode=1
}
close(P);
if ($pw==0) {
	print STDERR $s;
	$exitcode=2;
}
exit $exitcode
