use strict;
use warnings;

use WWW::Mechanize;

my $url = 'http://localhost:3003/viewtable/s/vewSuppliers';
my $mech = WWW::Mechanize->new(onerr => undef, cookie_jar => {});

sub main {
	my $page = $mech->get($url);
	print $page->decoded_content() . "\n";
	return 0;
}

main();
