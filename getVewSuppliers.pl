use strict;
use warnings;

use WWW::Mechanize;

my $url = 'http://localhost:3003/viewtable/s/vewSuppliers';
my $mech = WWW::Mechanize->new(onerr => undef, cookie_jar => {});

sub main {
	my $resp = $mech->get($url);
	print $resp . "\n";

}

main();
