#!/usr/bin/env perl

use strict;
use warnings;

my $port=shift(@ARGV);
my $userhost=shift(@ARGV);
my $password=shift(@ARGV);
my $cmd=join(" ",@ARGV);

open(P,"ssh.exp $port $userhost $password '$cmd' |") or die;
my $l=0;
my $pw=0;
my $s="";
while (<P>) {
	s/\r//g;
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
	if (/\+\+\+\-exit\-\+\+\+ (\d+)/) {
		print STDERR "$s\n";
		print STDERR "exit $1\n";
		exit $1;
	}
	print;
}
if (!close(P)) {
	print STDERR "$s";
	exit 2;
}
