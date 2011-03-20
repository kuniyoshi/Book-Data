package Book::Data::Book;

use strict;
use warnings;
use Class::Accessor "antlers";

has _id              => ( is => "ro", isa => "Int"     );
has isbn13           => ( is => "rw", isa => "Str"     );
has title            => ( is => "rw", isa => "Str"     );
has authors          => ( is => "rw", isa => "Str"     );
has numpages         => ( is => "rw", isa => "Int"     );
has thumbnails       => ( is => "rw", isa => "HashRef" );
has publication_date => ( is => "rw", isa => "Str"     );
has publisher        => ( is => "rw", isa => "Str"     );

sub id {
    return shift->_id;
}

1;

