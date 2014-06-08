use strict;
use warnings;
use LWP;
use JSON qw( decode_json );
use ElectricCommander;
use Data::Dumper;

my $ec = new ElectricCommander;

my $browser = LWP::UserAgent->new;
my $url = "https://rbcommons.com/s/ecdemo/api/review-requests/$request_id/";
my $req = HTTP::Request->new(GET => $url);
$req->authorization_basic("USERNAME", "PASSWORD");

my $status = 'pending';
do {
    my $response = $browser->request($req);
    if ($response->is_error) {
        if ($response->status_line ne '') {
            print "Error: " . $response->status_line;
        } else {
            print "Error: Unable to retrieve URL $url";
        }
        exit;
    }
    my $decoded = decode_json($response->content());
    $status = $decoded->{'review_request'}->{'status'};
    if ($status eq 'pending') {
        sleep 5;
    }
} while ($status eq 'pending');
$ec->setProperty("summary", "Status: $status");
if ($status eq 'discarded') {
    print "Review was rejected!";
    exit 1;
}
print "Review was accepted!";
