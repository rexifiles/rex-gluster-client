package Rex::Gluster::Client; 
use Rex -base;
use Rex::Ext::ParamLookup;

# Usage: rex setup server=gluster.my.domain.com
# Usage: rex remove

desc 'Set up gluster agent';
task 'setup', sub { 

	my $server = param_lookup "server";

	unless ($server) {
		say "No server defined. Define server=gluster.my.domain.com";
		exit 1;
	};

	unless ( is_installed("glusterfs-client") ) {

		update_package_db;

		pkg "glusterfs-client",
			ensure    => "latest",
			on_change => sub { say "package was installed/updated"; };

   		mount "$server:/gv0", "/mnt/gluster",
          		ensure    => "persistent",
          		type      => "glusterfs",
          		options   => [qw/defaults 1 2/],
          		on_change => sub { say "device mounted"; };
   			# mount persistent with entry in /etc/fstab

 	};

};

desc 'Remove gluster client';
task 'clean', sub {

	my $server = param_lookup "server";

	if ( is_installed("glusterfs-client") ) {
		remove package => "glusterfs-client";
	};

	unless ($server) {
		say "No server defined. Define server=gluster.my.domain.com";
		exit 1;
	};

	mount "$server:/gv0", "/mnt/gluster",
		ensure => "absent";


}
