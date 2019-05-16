#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _remove_image {
	my ($image_id) = @_;

	print('removing ... [', $image_id, ']', "\n");
	system('sudo', 'docker', 'rmi', $image_id);
}

sub _remove_main {
	my ($stream) = @_;

	if (!open($stream, 'sudo docker images --quiet |')) {
		return;
	}
	while (my $line = <$stream>) {
		$line =~ m/\A([0-9a-zA-Z]+)/ms;
		my $image_id = $1;
		_remove_image($image_id);
	}
	close($stream);
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_remove_main();
}

_main();
