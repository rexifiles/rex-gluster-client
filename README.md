# rex-gluster-client

## setup()
Will add the gluster client package to the designated server(s). Feel free to define a dns entry such as gluster.my.domain.com.


```
task "setup", make {

  Rex::Gluster::Client::setup(server="gluster.my.domain.com");

};
```

## clean()
Will remove the gluster client package

```
task "clean", make {

  Rex::Gluster::Client::clean();

};
```


# Gluster server 
#### (outside the scope of this script)
You will need to set up the server ready to accept the connections from the server. This will be done outside the scope of this
script, but will be along the lines of the following...
```
Server1# apt-get install glusterfs-server xfsprogs
Server2# apt-get install glusterfs-server xfsprogs

Server1# mkdir /data/brick1
Server2# mkdir /data/brick1

Server1# fdisk /dev/vdb
Server1# # Define a new partition on a designated disk (vdb1)
Server2# fdisk /dev/vdb
Server2# # Define a new partition on a designated disk (vdb1)

Server1# mount /dev/vdb1 /data/brick1
Server2# mount /dev/vdb1 /data/brick1

Server1# echo '/dev/vdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab && mount -a
Server2# echo '/dev/vdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab && mount -a

Server1# gluster peer probe gluster1
Server2# gluster peer probe gluster2

Server1# gluster volume create gv0 replica 2 gluster1:/data/brick1/gv0 gluster2:/data/brick1/gv0
Server1# gluster volume start gv0
```

