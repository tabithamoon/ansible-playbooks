#!/bin/fish

logger "Preparing to start sphynx..."
echo true > /tmp/vm-sphynx.running

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

if test -e /tmp/vm-persian.running
	logger "Shutting down persian..."
	virsh shutdown persian

	while test -e /tmp/vm-persian.running
		logger "Waiting for persian to shut down..."
		sleep 1
	end

	sleep 1
	logger "Success!"
else
	logger "persian not running."
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

logger "sphynx should be starting now!"
