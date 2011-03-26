#!/usr/bin/perl

use 5.10.0;
use utf8;
use strict;
use warnings;
use open ":utf8";
use open ":std";
use Business::ISBN;
use Data::Dumper qw( Dumper );
use lib "lib";
use Book::Data;

die usage()
    unless @ARGV;

my @isbns = map { Business::ISBN->new( $_ ) } <>;

my $util = Book::Data->new;

foreach my $isbn ( @isbns ) {
    $util->update( isbn => $isbn );
}

foreach my $isbn ( @isbns ) {
    my $book = $util->find( { isbn => $isbn } )->next;
    say Dumper $book;
}

exit;

sub usage {
    return "usage: $0 <file.isbn.list>\n";
}

