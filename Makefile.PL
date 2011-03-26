use inc::Module::Install;
name 'Book-Data';
all_from 'lib/Book/Data.pm';

# requires '';
requires "Readonly";
requires "MongoDB";
requires "WWW::Amazon::BookInfo";
requires "Config::Pit";
requires "DateTime::Format::Strptime";

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
