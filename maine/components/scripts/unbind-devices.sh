# Wait a while to avoid any race conditions during startup
sleep 20

# Unbind devices
echo 0000:04:00.0 | tee /sys/bus/pci/drivers/xhci_hcd/unbind
echo 0000:0d:00.3 | tee /sys/bus/pci/drivers/xhci_hcd/unbind
echo 0000:0d:00.4 | tee /sys/bus/pci/drivers/xhci_hcd/unbind

# Wait a second again, for race conditions
sleep 1

# Load vfio-pci
modprobe vfio-pci

# Bind relevant devices to it
echo 1002 73ff | tee /sys/bus/pci/drivers/vfio-pci/new_id
echo 1002 ab28 | tee /sys/bus/pci/drivers/vfio-pci/new_id
echo 1022 43ee | tee /sys/bus/pci/drivers/vfio-pci/new_id
echo 1022 1639 | tee /sys/bus/pci/drivers/vfio-pci/new_id
echo 1022 15e3 | tee /sys/bus/pci/drivers/vfio-pci/new_id

# Sleep... again... can you guess why?
sleep 1

# Load AMD GPU driver for integrated graphics
modprobe amdgpu

# You know what they say, ya snooze you lose
sleep 1

# Start podman containers *after* driver shuffle dance, to avoid
# starting Jellyfin before /dev/dri/renderD128 is available
podman start --all