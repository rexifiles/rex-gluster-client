package Rex::Gluster::Client; 
use Rex -base;
use Rex::Ext::ParamLookup;

# Usage: rex setup server=gluster.my.domain.com
# Usage: rex remove

desc 'Set up gluster agent';
task 'setup', sub { 

	my $server     = param_lookup "server";
	my $mountpoint = param_lookup "mountpoint", "/mnt/gluster";
	my $volname    = param_lookup "volname", "gv0";

	unless ($server) {
		say "No server defined. Define server=gluster.my.domain.com";
		exit 1;
	};

	unless ( is_installed("glusterfs-client") ) {

		update_package_db;

		pkg "glusterfs-client",
			ensure    => "latest",
			on_change => sub { say "package was installed/updated"; };
 	};

	# mount persistent with entry in /etc/fstab
   	mount "$server:$volname", "$mountpoint",
		ensure    => "persistent",
		type      => "glusterfs",
		options   => [qw/defaults _netdev/],
		on_change => sub { 
			say "gluster point added to fstab"; 
		};

	file "$mountpoint",
		ensure => "directory",
		owner  => "root",
		group  => "root";
	
	mount "$mountpoint";
};


desc 'Remove gluster client';
task 'clean', sub {

	my $server     = param_lookup "server";
	my $mountpoint = param_lookup "mountpoint", "/mnt/gluster";

	if ( is_installed("glusterfs-client") ) {
		remove package => "glusterfs-client";
	};

	unless ($server) {
		say "No server defined. Define server=gluster.my.domain.com";
		exit 1;
	};

	mount "$server:$volname", "$mountpoint",
		ensure => "absent";

	umount "$mountpoint";
}
