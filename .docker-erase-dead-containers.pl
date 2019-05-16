#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _readline {
	my ($line) = @_;

	if ($line =~ m/\ACONTAINER\ ID/ms) {
		# this is title line.
		return '';
	}
	if ($line =~ m/\A([a-zA-Z0-9\-\_]+) /ms) {
		return $1;
	}
	return '';
}

sub _remove {
	my ($container_id) = @_;

	if(!length($container_id)) {
		return;
	}
	system('sudo', 'docker', 'rm', $container_id);
}

sub _println {

	print(@_, "\n");
}

sub _enum_images {

	my $stream;
	my @images;
	if (!open($stream, 'sudo docker ps --all --filter \'status=exited\' |')) {
		return @images;
	}
	while(my $line = <$stream>) {
		my $container_id = _readline($line);
		if (!length($container_id)) {
			# ignore title
			next;
		}
		push(@images, $container_id);
	}
	close($stream);
	return @images;
}

sub _remove_dead_containers {

	my @images = _enum_images();
	my $affected = 0;
	foreach my $container_id (@images) {
		_remove($container_id);
		$affected++;
	}
	if (!$affected) {
		_println('[TRACE] nothing to do.');
		return;
	}
	_println('[TRACE] ', $affected, ' images detected.');
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_remove_dead_containers();
}

_main(@ARGV);
