#!/usr/bin/perl -w
use strict;

# path to this repo
my $root_dir = "~/remote_scan";

# where to install syft and grype if don't have them (use /usr/local/bin for global install, home dir folder for local)
my $install_dir = "/path/to/remote_scan";

# list of servers to scan. must have passwordless ssh access
my @servers = ('server1',
                'server2',
                'server3');

`curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b $install_dir` unless (-f "$install_dir/grype");
`curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b $install_dir` unless (-f "$install_dir/syft");

foreach (@servers) {
    print "Working on " . $_ . "\n";
    `scp $install_dir/syft $_:~/`;
    `ssh $_ "./syft packages dir:/opt/ -o json > $_-sbom.json"`;
    `scp $_:~/$_-sbom.json $root_dir/sbom/`;
    `cat $root_dir/sbom/$_-sbom.json | $install_dir/grype > $root_dir/grype_output/$_`;  
}
