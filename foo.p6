#!/usr/bin/perl6

use v6;

rule desc {
	'<' (<ident>) '>'
	{ say $1; }
}

say desc($*IN.slurp).result_object;

