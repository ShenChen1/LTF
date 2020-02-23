#!/usr/bin/env perl

use strict;
use warnings;

my $host=shift(@ARGV);
my $port=shift(@ARGV);
my $user=shift(@ARGV);
my $password=shift(@ARGV);
my $prompt=shift(@ARGV);
my $cmd=join(" ",@ARGV);

open(P,"telnet.exp $host $port $user $password $prompt '$cmd' |") or die;
my $l=0;
my $pr=0;
my $s="";
while (<P>) {
	s/\r//g;
	++$l;
	if (($l==1) && /^spawn/) {
		$s.=$_;
		next;
	}
	if ($pr==0 && /$prompt/) {
		$pr=1;
		$s.=$_;
		next;
	}
	if ($pr==0) {
		$s.=$_;
		next;
	}
	if ($pr==1 && /$prompt/) {
		$pr=0;
		$s.=$_;
		next;
	}
	if (/\+\+\+\-exit\-\+\+\+ (\d+)/) {
		print STDERR "exit $1\n";
		exit $1;
	}
	print;
}
if (!close(P)) {
	print STDERR "$s";
	exit 2;
}
