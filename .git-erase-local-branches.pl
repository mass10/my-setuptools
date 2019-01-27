#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub enum_local_branches {

	my $stream = undef;

	if (!open($stream, 'git branch |')) {
		print('[ERROR]', $!);
		return;
	}

	my @local_branch_names;
	while (my $line = <$stream>) {
		chomp($line);
		my $name = '';
		# 現在開いているブランチはスキップしています。
		if ($line =~ m/\A  ([0-9a-zA-Z-_\.]+)\z/ms) {
			$name = $1;
			push(@local_branch_names, $name);
		}
	}
	close($stream);

	return @local_branch_names;
}

sub prompt {

	my ($question) = @_;

	print($question, "\n");
	print('(y/N)> ');
	my $input = <STDIN>;
	chomp($input);
	$input = uc($input);
	if (uc($input) eq 'Y') {
		return 1;
	}
	if (uc($input) eq 'YES') {
		return 1;
	}
	return 0;
}

sub delete_local_branch {

	my ($name) = @_;

	my $prompt = sprintf('delete local repository [%s] ? ', $name);
	if (!prompt($prompt)) {
		return;
	}

	system('git', 'branch', '--delete', $name);
}

sub show_local_branches {

	system('git', 'branch', '--all');
}

sub erase_local_branches {

	my @names = enum_local_branches();
	foreach my $name (@names) {
		delete_local_branch($name);
	}
}

sub main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	erase_local_branches();

	show_local_branches();
}

main();
