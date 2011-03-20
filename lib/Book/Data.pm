package Book::Data;

use strict;
use warnings;
use Class::Accessor "antlers";
use Readonly;
use Carp qw( croak );
use Scalar::Util qw( blessed );
use Config::Pit ();
use MongoDB;
use WWW::Amazon::BookInfo;
use Book::Data::Book;

Readonly my @NEED_INIT_FIELDS => qw( conn ua );

has conn => ( is => "rw", isa => "MongoDB::Connection" );
has ua   => ( is => "rw", isa => "WWW::Amazon::BookInfo" );

our $VERSION = "0.01";

sub new {
    my $class = shift;
    my %param = @_;

    my $self = $class->next::method( \%param );

    foreach my $key ( @NEED_INIT_FIELDS ) {
        my $method = "init_$key";
        $self->$method
            unless $self->$key;
    }

    return $self;
}

sub init_conn {
    my $self = shift;

    unless ( $self->conn ) {
        $self->conn( MongoDB::Connection->new );
    }

    return $self->conn;
}

sub init_ua {
    my $self = shift;

    unless ( $self->ua ) {
        $self->ua( WWW::Amazon::BookInfo->new( %{ Config::Pit::get( "amazon.co.jp" ) } ) );
    }

    return $self->ua;
}

sub book_info_to_hash_ref {
    my $self = shift;
    my $res  = shift
        or croak "book info required.";

    croak "WWW::Amazon::BookInfo::Response required."
        unless blessed $res && $res->isa( "WWW::Amazon::BookInfo::Response" );

    my $ref = {
        map { $_ => $res->$_ }
        qw( authors numpages publication_date title isbn publisher )
    };
    $ref->{isbn}      = $ref->{isbn}->as_string;
    $ref->{thumbnail} = $res->image( "thumbnail" );

    return $ref;
}

sub record_to_object {
    my $self       = shift;
    my $record_ref = shift
        or croak "Record required.";

    return bless $record_ref, "Book::Data::Book";
}

sub find {
    my $self    = shift;
    my @options = @_;

    foreach my $condition_ref ( @options ) {
        next
            unless ref $condition_ref eq ref { };

        if ( exists $condition_ref->{isbn} ) {
            if ( blessed $condition_ref->{isbn} && $condition_ref->{isbn}->isa( "Business::ISBN" ) ) {
                $condition_ref->{isbn} = $condition_ref->{isbn}->as_isbn13->as_string;
            }
        }
    }

    my $cursor = $self->conn->book->books->find( @options );

    return $cursor
        if $cursor->has_next;

    if ( @options == 1 && keys %{ $options[0] } == 1 && $options[0]->{isbn} ) {
        my $res  = $self->ua->search( %{ $options[0] } );
        my $ref  = $self->book_info_to_hash_ref( $res );
        my $book = $self->conn->book->books->save( $ref );
        return $self->find( @options );
    }
    else {
        return;
    }
}

1;

__END__
=encoding utf-8

=head1 NAME

Book::Data -

=head1 SYNOPSIS

  use Book::Data;
  my $data = Book::Data->new;
  my $book = 

=head1 DESCRIPTION

Book::Data is blah blah blah.

=head1 AUTHOR

kuniyoshi kouji E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

