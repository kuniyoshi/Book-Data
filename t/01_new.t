use Test::More tests => 1;

my $module = "Book::Data";
eval "use $module";

new_ok( $module );

