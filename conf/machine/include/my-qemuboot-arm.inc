# For runqemu

IMAGE_CLASSES += "qemuboot"

# QEMU Name
QB_SYSTEM_NAME = "qemu-system-arm"

# Memory of QEMU
QB_MEM = "-m 1024"

# QEMU CPU
QB_CPU = "-cpu cortex-a15"

# Kernel Command Line
QB_KERNEL_CMDLINE_APPEND = "console=ttyAMA0"

# Add the 'virtio-rng-pci' device otherwise the guest may run out of entropy
QB_OPT_APPEND += "-object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0"

# Virtio Networking support
QB_TAP_OPT = "-netdev tap,id=net0,ifname=@TAP@,script=no,downscript=no"
QB_NETWORK_DEVICE = "-device virtio-net-device,netdev=net0,mac=@MAC@"

KMACHINE_qemuarm = "qemuarma15"
