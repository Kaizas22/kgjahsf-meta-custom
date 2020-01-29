# For runqemu

IMAGE_CLASSES += "qemuboot"

# QEMU Name
QB_SYSTEM_NAME = "qemu-system-x86_64"

# Memory of QEMU
QB_MEM = "-m 512"

# QEMU CPU
QB_CPU = "-cpu Nehalem -smp 2"
QB_CPU_KVM = "-cpu kvm64 -smp 2"

# Kernel Command Line
QB_KERNEL_CMDLINE_APPEND = "vga=0 uvesafb.mode_option=640x480-32 oprofile.timer=1 uvesafb.task_timeout=-1"

# Add the 'virtio-rng-pci' device otherwise the guest may run out of entropy
QB_OPT_APPEND += "-object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0"

# Virtio Networking support
QB_TAP_OPT = "-netdev tap,id=net0,ifname=@TAP@,script=no,downscript=no"
QB_NETWORK_DEVICE = "-device virtio-net-device,netdev=net0,mac=@MAC@"
