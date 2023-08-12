#!/bin/fish
logger "Preparing to start persian..."
echo true > /tmp/vm-persian.running

if test -e /tmp/vm-ragdoll.running
	logger "Shutting down ragdoll..."
	virsh shutdown ragdoll

	while test -e /tmp/vm-ragdoll.running
		logger "Waiting for ragdoll to shut down..."
		sleep 1
	end

	sleep 1
	logger "Success!"
else
	logger "ragdoll not running."
end

if test -e /tmp/vm-sphynx.running
	logger "Shutting down sphynx..."
	virsh shutdown sphynx

	while test -e /tmp/vm-sphynx.running
		logger "Waiting for sphynx to shut down..."
		sleep 1
	end

	sleep 1
	logger "Success!"
else
	logger "sphynx not running."
end

if not test -e /tmp/hugepages.allocd
	logger "Allocating hugepages..."
	while test -z (cat /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages | grep 10240)
		echo 3 > /proc/sys/vm/drop_caches
		echo 1 > /proc/sys/vm/compact_memory
		echo 10240 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
		logger "Hugepage count: $(cat /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages)"
		sleep 1
	end
	echo true > /tmp/hugepages.allocd
	logger "Hugepages allocated."
else
	logger "Hugepages already allocated, skipping."
end

logger "persian should be starting now!"
