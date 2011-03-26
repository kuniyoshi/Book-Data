package Book::Data::Book;

use strict;
use warnings;
use Class::Accessor "antlers";
use DateTime::Format::Strptime;

has _id              => ( is => "ro", isa => "Int"      );
has isbn13           => ( is => "rw", isa => "Str"      );
has title            => ( is => "rw", isa => "Str"      );
has authors          => ( is => "rw", isa => "Str"      );
has numpages         => ( is => "rw", isa => "Int"      );
has images           => ( is => "rw", isa => "ArrayRef" );
has publication_date => ( is => "rw", isa => "Str"      );
has publisher        => ( is => "rw", isa => "Str"      );
has timestamp        => ( is => "rw", isa => "Str"      );

my $strp = DateTime::Format::Strptime->new(
    pattern   => "%FT%T",
    time_zone => "Asia/Tokyo",
);

sub id {
    return shift->_id;
}

sub datetime {
    my $self = shift;
    return $strp->parse_datetime( $self->timestamp );
}

1;

