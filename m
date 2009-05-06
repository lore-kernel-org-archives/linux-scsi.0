From: maximilian attems <max@stro.at>
Subject: [scott.bailey@eds.com: Bug#527265: linux-image-2.6.29-1-alpha-smp: detached firmware qlogic/1040.bin fails to load for qla1280]
Date: Wed, 6 May 2009 16:19:12 +0200
Message-ID: <20090506141912.GA31614@baikonur.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:53383 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZEFOWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 10:22:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "R. Scott Bailey" <scott.bailey@eds.com>, 527265@bugs.debian.org

forwarding to linux-scsi,
could you send in a dmesg from a working boot,
what was the last working kernel?

----- Forwarded message from "R. Scott Bailey" <scott.bailey@eds.com> -----

Subject: Bug#527265: linux-image-2.6.29-1-alpha-smp: detached firmware qlogic/1040.bin fails to load for qla1280
From: "R. Scott Bailey" <scott.bailey@eds.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Date: Wed, 06 May 2009 09:22:46 -0400

Package: linux-image-2.6.29-1-alpha-smp
Version: 2.6.29-3
Severity: important

Yes, I have the firmware on the system. The non-free package 
firmware-qlogic (from sid) is installed, /lib/firmware/qlogic/1040.bin 
exists and update-initramfs doesn't whine about missing firmware. ;-)

See the attached console output from a recent boot attempt. Firmware for 
my SCSI cards fails to load, leaving all hard drives inaccessible and 
the system unusable.

Let me know if there are tweaks I can make that would gather additional 
information for troubleshooting purposes.

-- Package-specific info:

-- System Information:
Debian Release: 5.0.1
Architecture: alpha

Kernel: Linux 2.6.26-1-alpha-smp (SMP w/1 CPU core)
Locale: LANG=C, LC_CTYPE=C (charmap=ANSI_X3.4-1968)
Shell: /bin/sh linked to /bin/bash

Versions of packages linux-image-2.6.29-1-alpha-smp depends on:
ii  debconf [debconf-2.0]         1.5.24     Debian configuration management sy
ii  initramfs-tools [linux-initra 0.92o      tools for generating an initramfs
ii  module-init-tools             3.4-1      tools for managing Linux kernel mo

linux-image-2.6.29-1-alpha-smp recommends no packages.

Versions of packages linux-image-2.6.29-1-alpha-smp suggests:
ii  aboot                  1.0~pre20040408-3 Linux bootloader for the SRM conso
ii  fdutils                5.5-20060227-3    Linux floppy utilities
pn  linux-doc-2.6.29       <none>            (no description available)

-- debconf information:
  linux-image-2.6.29-1-alpha-smp/postinst/bootloader-test-error-2.6.29-1-alpha-smp:
  linux-image-2.6.29-1-alpha-smp/postinst/create-kimage-link-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/postinst/old-system-map-link-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/postinst/depmod-error-initrd-2.6.29-1-alpha-smp: false
  linux-image-2.6.29-1-alpha-smp/postinst/bootloader-error-2.6.29-1-alpha-smp:
  linux-image-2.6.29-1-alpha-smp/prerm/removing-running-kernel-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/preinst/initrd-2.6.29-1-alpha-smp:
  linux-image-2.6.29-1-alpha-smp/postinst/kimage-is-a-directory:
  linux-image-2.6.29-1-alpha-smp/preinst/overwriting-modules-2.6.29-1-alpha-smp: true
  shared/kernel-image/really-run-bootloader: true
  linux-image-2.6.29-1-alpha-smp/preinst/failed-to-move-modules-2.6.29-1-alpha-smp:
  linux-image-2.6.29-1-alpha-smp/postinst/old-initrd-link-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/preinst/elilo-initrd-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/preinst/lilo-has-ramdisk:
  linux-image-2.6.29-1-alpha-smp/prerm/would-invalidate-boot-loader-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/postinst/old-dir-initrd-link-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/preinst/lilo-initrd-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/postinst/depmod-error-2.6.29-1-alpha-smp: false
  linux-image-2.6.29-1-alpha-smp/preinst/abort-install-2.6.29-1-alpha-smp:
  linux-image-2.6.29-1-alpha-smp/preinst/bootloader-initrd-2.6.29-1-alpha-smp: true
  linux-image-2.6.29-1-alpha-smp/preinst/abort-overwrite-2.6.29-1-alpha-smp:

 CPU 0 booting
 
 (boot dkb0.0.0.2000.1 -flags 0)
 block 0 of dkb0.0.0.2000.1 is a valid boot block
 reading 158 blocks from dkb0.0.0.2000.1
 bootstrap code read in
 base = 200000, image_start = 0, image_bytes = 13c00
 initializing HWRPB at 2000
 initializing page table at 1f2000
 initializing machine state
 setting affinity to the primary CPU
 configuring I/O adapters...
   ncr0, hose 1, bus 0, slot 1
   isp0, hose 1, bus 2, slot 0
   tulip0, hose 1, bus 0, slot 3
   floppy0, hose 0, bus 1, slot 0
   tulip1, hose 0, bus 0, slot 3
   isp1, hose 0, bus 2, slot 0
   isp2, hose 0, bus 3, slot 0
 jumping to bootstrap code
 aboot: Linux/Alpha SRM bootloader version 1.0_pre20040408
 aboot: switching to OSF/1 PALcode version 1.23
 aboot: booting from device 'SCSI 1 2000 0 0 0 1011 10201077'
 aboot: valid disklabel found: 4 partitions.
 aboot: loading uncompressed vmlinuz-2.6.29-1-alpha-smp...
 aboot: loading compressed vmlinuz-2.6.29-1-alpha-smp...
 aboot: zero-filling 705668 bytes at 0xfffffc000186664c
 aboot: loading initrd (11327449 bytes/11061 blocks) at 0xfffffc013f3fa000
 aboot: starting kernel vmlinuz-2.6.29-1-alpha-smp with arguments  ro root=/dev/md1 console=ttyS0
 [    0.000000] Initializing cgroup subsys cpuset
 [    0.000000] Initializing cgroup subsys cpu
 [    0.000000] Linux version 2.6.29-1-alpha-smp (Debian 2.6.29-3) (maks@debian.org) (gcc version 4.3.3 (Debian 4.3.3-8) ) #1 SMP Fri
 [    0.000000] Booting GENERIC on Rawhide variation Dodge using machine vector Rawhide from SRM
 [    0.000000] Major Options: SMP MAGIC_SYSRQ 
 [    0.000000] Command line:  ro root=/dev/md1 console=ttyS0
 [    0.000000] memcluster 0, usage 1, start        0, end      256
 [    0.000000] memcluster 1, usage 0, start      256, end   393216
 [    0.000000] memcluster 2, usage 0, start   524288, end   655351
 [    0.000000] memcluster 3, usage 1, start   655351, end   655360
 [    0.000000] freeing pages 256:2048
 [    0.000000] freeing pages 3212:393216
 [    0.000000] freeing pages 524288:655351
 [    0.000000] reserving pages 3212:3222
 [    0.000000] Initial ramdisk at: 0xfffffc013f3fa000 (11327449 bytes)
 [    0.000000] 4096K Bcache detected; load hit latency 29 cycles, load miss latency 115 cycles
 [    0.000000] SMP: 3 CPUs probed -- cpu_present_map = 7
 [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 650871
 [    0.000000] Kernel command line:  ro root=/dev/md1 console=ttyS0
 [    0.000000] mcpcia_init_hoses: found 2 hoses
 [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
 [    0.000000] HWRPB cycle frequency bogus.  Estimated 466245954 Hz
 [    0.000000] Using epoch = 2000
 [    0.000000] Turning on RTC interrupts.
 [4194001.854623] Console: colour dummy device 80x25
 [4194001.854623] console [ttyS0] enabled
 [4194003.618294] Dentry cache hash table entries: 1048576 (order: 10, 8388608 bytes)
 [4194003.775520] Inode-cache hash table entries: 524288 (order: 9, 4194304 bytes)
 [4194004.375129] Memory: 4120296k/5242808k available (2695k kernel code, 71208k reserved, 260k data, 472k init)
 [4194004.494270] Calibrating delay loop... 1141.64 BogoMIPS (lpj=557056)
 [4194004.597785] Security Framework initialized
 [4194004.648566] Mount-cache hash table entries: 512
 [4194004.706184] Initializing cgroup subsys ns
 [4194004.756965] Initializing cgroup subsys cpuacct
 [4194004.811652] Initializing cgroup subsys devices
 [4194004.867316] Initializing cgroup subsys freezer
 [4194004.922004] Initializing cgroup subsys net_cls
 [4194004.977668] SMP starting up secondaries.
 [4194005.039191] Calibrating delay loop... 1074.72 BogoMIPS (lpj=524288)
 [4194005.152472] Calibrating delay loop... 1074.72 BogoMIPS (lpj=524288)
 [4194005.255988] Brought up 3 CPUs
 [4194005.294074] SMP: Total of 3 processors activated (3295.33 BogoMIPS).
 [4194005.388800] net_namespace: 1888 bytes
 [4194005.436652] regulator: core version 0.5
 [4194005.484504] NET: Registered protocol family 16
 [4194005.545050] EISA bus registered
 [4194005.587043] pci: enabling save/restore of SRM state
 [4194005.657355] pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
 [4194005.730597] pci 0000:00:04.0:   IO window: 0x8000-0x8fff
 [4194005.797003] pci 0000:00:04.0:   MEM window: 0x2200000-0x22fffff
 [4194005.869269] pci 0000:00:04.0:   PREFETCH window: disabled
 [4194005.936652] pci 0000:00:05.0: PCI bridge, secondary bus 0000:02
 [4194006.008917] pci 0000:00:05.0:   IO window: 0x9000-0x9fff
 [4194006.075324] pci 0000:00:05.0:   MEM window: 0x2300000-0x23fffff
 [4194006.147589] pci 0000:00:05.0:   PREFETCH window: disabled
 [4194006.214972] pci 0001:03:02.0: PCI bridge, secondary bus 0001:04
 [4194006.288214] pci 0001:03:02.0:   IO window: 0x8000-0x8fff
 [4194006.353644] pci 0001:03:02.0:   MEM window: 0x2200000-0x22fffff
 [4194006.426886] pci 0001:03:02.0:   PREFETCH window: disabled
 [4194006.509894] bio: create slab <bio-0> at 0
 [4194006.564581] SCSI subsystem initialized
 [4194006.622198] NET: Registered protocol family 2
 [4194006.686651] IP route cache hash table entries: 262144 (order: 8, 2097152 bytes)
 [4194006.789190] TCP established hash table entries: 524288 (order: 10, 8388608 bytes)
 [4194006.923956] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
 [4194007.011846] TCP: Hash tables configured (established 524288 bind 65536)
 [4194007.093878] TCP reno registered
 [4194007.136846] NET: Registered protocol family 1
 [4194007.192510] checking if image is initramfs... it is
 [4194014.770632] Freeing initrd memory: 11061k freed
 [4194014.833132] VFS: Disk quotas dquot_6.5.2
 [4194014.881960] Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
 [4194014.963014] msgmni has been set to 8070
 [4194015.011842] alg: No test for stdrng (krng)
 [4194015.063600] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
 [4194015.155397] io scheduler noop registered
 [4194015.204225] io scheduler anticipatory registered
 [4194015.261842] io scheduler deadline registered
 [4194015.314577] io scheduler cfq registered (default)
 [4194015.374147] isapnp: Scanning for PnP cards...
 [4194015.863404] isapnp: No Plug & Play device found
 [4194015.950318] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
 [4194016.028443] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 [4194016.102662] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
 [4194016.195436] brd: module loaded
 [4194016.242311] serio: i8042 KBD port at 0x60,0x64 irq 1
 [4194016.303834] serio: i8042 AUX port at 0x60,0x64 irq 12
 [4194016.367310] mice: PS/2 mouse device common for all mice
 [4194016.432740] EISA: Probing bus 0 at 0000:00:01.0
 [4194016.489381] atkbd.c: keyboard reset failed on isa0060/serio0
 [4194016.489381] EISA: Mainboard DEC6400 detected.
 [4194016.613404] Cannot allocate resource for EISA slot 8
 [4194016.674927] EISA: Detected 0 cards.
 [4194016.722779] TCP cubic registered
 [4194016.763795] atkbd.c: keyboard reset failed on isa0060/serio1
 [4194016.763795] NET: Registered protocol family 17
 [4194016.889771] registered taskstats version 1
 [4194016.941529] /build/buildd-linux-2.6_2.6.29-3-alpha-bvFcox/linux-2.6-2.6.29/debian/build/source_alpha_none/drivers/rtc/hctosys.c
 [4194017.117310] Freeing unused kernel memory: 472k freed
 Loading, please wait...
 Begin: Loading essential drivers ... done.
 Begin: Running /scripts/init-premount ... [4194022.040159] Linux Tulip driver version 1.1.15-NAPI (Feb 27, 2007)
 [4194022.120237] tulip0:  EEPROM default media type Autosense.
 [4194022.187620] tulip0:  Index #0 - Media MII (#11) described by a 21140 MII PHY (1) block.
 [4194022.291136] tulip0:  MII transceiver #5 config 2100 status 780f advertising 01e1.
 [4194022.390745] eth0: Digital DS21140 Tulip rev 32 at Port 0xa000, 00:00:f8:05:1f:4a, IRQ 20.
 [4194022.496214] tulip1:  EEPROM default media type Autosense.
 [4194022.563596] tulip1:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY (2) block.
 [4194022.667112] tulip1:  Index #1 - Media 10baseT-FDX (#4) described by a 21142 Serial PHY (2) block.
 [4194022.775510] tulip1:  Index #2 - Media 100baseTx (#3) described by a 21143 SYM PHY (4) block.
 [4194022.879026] tulip1:  Index #3 - Media 100baseTx-FDX (#5) described by a 21143 SYM PHY (4) block.
 [4194022.993284] eth1: Digital DS21142/43 Tulip rev 48 at Port 0x200009400, 08:00:2b:c4:5c:d1, IRQ 44.
 [4194023.188596] qla1280: QLA1040 found on PCI bus 1, dev 0
 [4194023.309690] qla1280 0000:01:00.0: firmware: requesting qlogic/1040.bin
 [4194023.390744] ------------[ cut here ]------------
 [4194023.448362] WARNING: at /build/buildd-linux-2.6_2.6.29-3-alpha-bvFcox/linux-2.6-2.6.29/debian/build/source_alpha_none/kernel/so
 [4194023.631955] Modules linked in: qla1280(+) tulip bitrev crc32
 [4194023.702268] fffffc013f0df6c8 0000000000000005 fffffc0001045508 fffffc013b6e6fc0 
 [4194023.791135]        0000000000000000 fffffc013b6a8c00 fffffc013b6e6fc0 fffffc000131b2d3 
 [4194023.889768]        fffffc000117241c 0000000000000800 625f6c61636f6c5f 656c62616e655f68 
 [4194023.987424]        303578302b70695f ffff00636278302f fffffc013f07d000 fffffc013e829f40 
 [4194024.086057]        fffffc000183dec8 fffffc00013215fd fffffc00011217bc fffffc013b7fdb30 
 [4194024.184689]        fffffc013f0d1f80 fffffc00018c50a8 fffffc013f0d1f80 0000000000000001 
 [4194024.285275] Trace:
 [4194024.311642] [<fffffc0001045508>] _local_bh_enable_ip+0x50/0xbc
 [4194024.382931] [<fffffc000117241c>] add_uevent_var+0x98/0x11c
 [4194024.451291] [<fffffc00011217bc>] sysfs_new_dirent+0xbc/0x178
 [4194024.521603] [<fffffc00010d6fc0>] ifind+0x60/0xb4
 [4194024.578244] [<fffffc0001120fa4>] sysfs_ilookup_test+0x0/0x14
 [4194024.648556] [<fffffc0001121e94>] create_dir+0x74/0xac
 [4194024.711056] [<fffffc0001170388>] ida_get_new_above+0x6c/0x294
 [4194024.782345] [<fffffc0001221b88>] sk_filter+0xd0/0x108
 [4194024.844845] [<fffffc0001236c60>] netlink_broadcast+0x268/0x478
 [4194024.917111] [<fffffc0001172830>] kobject_uevent_env+0x390/0x4a0
 [4194024.990353] [<fffffc00011d78e4>] _request_firmware+0x494/0x5b0
 [4194025.061642] [<fffffc00011d78cc>] _request_firmware+0x47c/0x5b0
 [4194025.134884] [<fffffc00011881b8>] local_pci_probe+0x24/0x38
 [4194025.202267] [<fffffc0001188504>] pci_device_probe+0x64/0xa0
 [4194025.270626] [<fffffc00011d1d58>] driver_probe_device+0xf8/0x20c
 [4194025.344845] [<fffffc00011d1ef4>] __driver_attach+0x88/0xd4
 [4194025.412228] [<fffffc00011d12a4>] bus_for_each_dev+0x60/0xc8
 [4194025.481564] [<fffffc00011d1e6c>] __driver_attach+0x0/0xd4
 [4194025.547970] [<fffffc00011d1ae0>] driver_attach+0x2c/0x40
 [4194025.613399] [<fffffc00011d0840>] bus_add_driver+0xd4/0x2e8
 [4194025.681759] [<fffffc00011d2290>] driver_register+0xec/0x1b4
 [4194025.751095] [<fffffc0001188860>] __pci_register_driver+0x5c/0xc8
 [4194025.825313] [<fffffc000101010c>] do_one_initcall+0x9c/0x220
 [4194025.893673] [<fffffc000106ccf0>] SyS_init_module+0xf0/0x2a0
 [4194025.963009] [<fffffc0001058648>] kthread_stop+0x10c/0x18c
 [4194026.029415] [<fffffc00010ba514>] kfree+0x98/0xb0
 [4194026.087032] [<fffffc00010ba514>] kfree+0x98/0xb0
 [4194026.144649] [<fffffc00010bc5ec>] percpu_free+0x84/0xa8
 [4194026.208126] [<fffffc0001078728>] stop_machine_destroy+0x58/0x84
 [4194026.281368] [<fffffc000106c9cc>] load_module+0x1b3c/0x1c20
 [4194026.349727] [<fffffc000106cc7c>] SyS_init_module+0x7c/0x2a0
 [4194026.418087] [<fffffc0001032bd8>] enqueue_entity+0x144/0x16c
 [4194026.487422] [<fffffc0001032c34>] enqueue_task_fair+0x34/0x5c
 [4194026.557735] [<fffffc0001081d0c>] marker_module_notify+0x38/0x48
 [4194026.630001] [<fffffc0001083564>] tracepoint_module_notify+0x38/0x48
 [4194026.707149] [<fffffc000105d410>] notifier_call_chain+0x70/0xd0
 [4194026.780391] [<fffffc000105d924>] __blocking_notifier_call_chain+0x7c/0xc0
 [4194026.863399] [<fffffc000105d934>] __blocking_notifier_call_chain+0x8c/0xc0
 [4194026.946407] [<fffffc000106ccd8>] SyS_init_module+0xd8/0x2a0
 [4194027.015743] [<fffffc0001010ed4>] entSys+0xa4/0xc0
 [4194027.074336] 
 [4194027.093867] ---[ end trace 7848fd890f8447bb ]---
 [4194027.513789] sym0: <810> rev 0x2 at pci 0001:03:01.0 irq 56
 [4194027.587031] sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
 [4194027.659297] sym0: SCSI BUS has been reset.
 [4194027.717891] scsi1 : sym-2.2.3
 [4194032.129021] scsi 1:0:5:0: CD-ROM            DEC      RRD46   (C) DEC  0557 PQ: 0 ANSI: 2
 [4194032.228630] scsi target1:0:5: Beginning Domain Validation
 [4194032.295037] scsi target1:0:5: asynchronous
 [4194032.348748] scsi target1:0:5: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 8)
 [4194032.434685] scsi target1:0:5: Domain Validation skipping write tests
 [4194032.513787] scsi target1:0:5: Ending Domain Validation
 [4194052.313581] qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 0x4003, istatus = 0x0000
 [4194052.313581] m0 4003, m1 aaaa, m2 0002, m3 aa55
 [4194052.313581] m4 55aa, m5 a5a5, m6 5a5a, m7 2525
 [4194052.313581] scsi(0): RISC checksum failed.
 [4194052.313581] scsi(0): initialize: pci probe failed!
 [4194052.657331] qla1x160: Failed to initialize adapter
 [4194052.718854] qla1280: QLA1040 found on PCI bus 2, dev 0
 [4194052.783307] qla1280 0000:02:00.0: firmware: requesting qlogic/1040.bin
 [4194053.672955] Driver 'sr' needs updating - please use bus_type methods
 [4194053.769635] sr0: scsi-1 drive
 [4194053.807721] Uniform CD-ROM driver Revision: 3.20
 [4194054.592877] sr 1:0:5:0: Attached scsi generic sg0 type 5
 [4194054.869244] qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 0x4003, istatus = 0x0000
 [4194054.869244] m0 4003, m1 aaaa, m2 0002, m3 aa55
 [4194054.869244] m4 55aa, m5 a5a5, m6 5a5a, m7 2525
 [4194054.869244] scsi(2): RISC checksum failed.
 [4194054.869244] scsi(2): initialize: pci probe failed!
 [4194055.213970] qla1x160: Failed to initialize adapter
 [4194055.273541] qla1280: QLA1040 found on PCI bus 4, dev 0
 [4194055.337994] qla1280 0001:04:00.0: firmware: requesting qlogic/1040.bin
 [4194056.386821] qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 0x4003, istatus = 0x0000
 [4194056.386821] m0 4003, m1 aaaa, m2 0002, m3 aa55
 [4194056.386821] m4 55aa, m5 a5a5, m6 5a5a, m7 2525
 [4194056.386821] scsi(3): RISC checksum failed.
 [4194056.386821] scsi(3): initialize: pci probe failed!
 [4194056.730571] qla1x160: Failed to initialize adapter
 done.
 Begin: Mounting root file system ... Begin: Running /scripts/local-top ... Begin: Loading[4194057.335063] md: raid1 personality regi
 Success: loaded module raid1.
 done.
 Begin: Assembling all MD arrays ... mdadm: No devices listed in conf file were found.
 Failure: failed to assemble all arrays.
 done.
 Begin: Waiting for udev to process events ... done.[4194057.637797] device-mapper: uevent: version 1.0.3
 
 [4194057.698344] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
   Volume group "vg00" not found
 done.
 Begin: Waiting for root file system ... 


----- End forwarded message -----
