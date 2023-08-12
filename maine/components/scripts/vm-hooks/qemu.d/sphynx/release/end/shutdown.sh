#!/bin/fish

sleep 1

logger "sphynx has shut down!"

if not test -e /tmp/vm-persian.running
	logger "Tearing down dedicated VM environment..."
	echo 0 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
	rm /tmp/hugepages.allocd
	logger "Starting ragdoll..."
	virsh start ragdoll
else
	logger "Another dedicated VM is waiting, not tearing down environment."
end

rm /tmp/vm-sphynx.running
