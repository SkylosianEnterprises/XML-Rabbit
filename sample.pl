#!/usr/bin/perl 

use 5.16.0;

use strict;
use warnings;

 
package ComicsVine::Issue;
use JSON::Rabbit::Root;
 
has_jpath_value 'issue_number' => '$..issue_number';
 
has_jpath_object 'volume' => '$..volume' => 'ComicsVine::Issue::Volume';
 
has_jpath_object_list 'persons' => '$..person_credits', 'ComicsVine::Issue::Person';
 
finalize_class();
 
package ComicsVine::Issue::Volume;
use JSON::Rabbit;
 
has_jpath_value 'name' => '$.name';
 
finalize_class();
 
package ComicsVine::Issue::Person;
use JSON::Rabbit;
 
has_jpath_value 'name'   => '$.name';
 
finalize_class();
 
package main;

use JSON::Rabbit;

my $issue = ComicsVine::Issue->new( file => 'sample.json' );

$DB::single = 1;

say "issue number ", $issue->issue_number;
say "volume: ", $issue->volume->name;
say "credits ", join ' ', map { $_->name } $issue->persons;
 
exit;


