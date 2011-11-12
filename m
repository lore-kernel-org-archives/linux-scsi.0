From: Biblioteka UR <biblio@univ.rzeszow.pl>
Subject: Bug#647900: mptspi init failure on Sparc SMP in Linux 3.0
Date: Sat, 12 Nov 2011 16:35:49 +0100
Message-ID: <4EBE9255.5070209@univ.rzeszow.pl>
References: <4EB7D137.7090903@univ.rzeszow.pl>	 <20111107205409.GG3366@decadent.org.uk> <4EB858E8.6090304@univ.rzeszow.pl> <1320721518.18929.15.camel@deadeye> <A6888A6805518E4EA4AF7072A28264A6047262C728@inbmail02.lsi.com>
Reply-To: Biblioteka UR <biblio@univ.rzeszow.pl>, 647900@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.647900.B647900.132111216310009@bugs.debian.org>
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6047262C728@inbmail02.lsi.com>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, "647900@bugs.debian.org" <647900@bugs.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

No, I can't. Only from putty.log. This is new, longer version. Maybe=20
will by helpful.

  Sun Fire V490, No Keyboard
  Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
  OpenBoot 4.30.4, 8192 MB memory installed, Serial #67176146.
  Ethernet address 0:14:4f:1:6:d2, Host ID: 840106d2.

  Initializing     1MB of memory at addr        a1ffb2c000 -
Initializing    12MB of memory at addr        a1ff000000 -

Initializing  8176MB of memory at addr        a000000000 -

  Rebooting with command: boot
  Boot device: /pci@8,600000/scsi@1/disk@0,0  File and args:
  SILO Version 1.4.14
  boot: Linux
  Allocated 64 Megs of memory at 0x40000000 for kernel
  \
Uncompressing image...
  |
/
-
\
|
/
-
\
Loaded kernel version 3.0.0
  Loading initial ramdisk (10098428 bytes at 0xA1FF000000 phys,=20
0x40C00000 virt).
.|
/
-
\
|
/
-
\
  [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.30.4 2009/08/19 07:20=
'
  [    0.000000] PROMLIB: Root node compatible:
  [    0.000000] Initializing cgroup subsys cpuset
  [    0.000000] Initializing cgroup subsys cpu
  [    0.000000] Linux version 3.0.0-1-sparc64-smp (Debian 3.0.0-3)=20
(ben@decadent
1[    0.000000] bootconsole [earlyprom0] enabled
  [    0.000000] ARCH: SUN4U
  [    0.000000] Ethernet address: 00:14:4f:01:06:d2
  [    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
  [    0.000000] Remapping the kernel... done.
  [    0.000000] OF stdout device is: /pci@9,700000/ebus@1/serial@1,40000=
0:a
  [    0.000000] PROM: Built device tree with 101044 bytes of memory.
  [    0.000000] Top of RAM: 0xa1ffb2e000, Total RAM: 0x1ffb18000
  [    0.000000] Memory hole size: 655360MB
  [    0.000000] [0000010140000000-fffff8a000c00000] page_structs=3D13107=
2=20
node=3D0 e
2[    0.000000] [0000010140000000-fffff8a001000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010140800000-fffff8a001400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010140800000-fffff8a001800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141000000-fffff8a001c00000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141000000-fffff8a002000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141800000-fffff8a002400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141800000-fffff8a002800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142000000-fffff8a002c00000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142000000-fffff8a003000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142800000-fffff8a003400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142800000-fffff8a003800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143000000-fffff8a003c00000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143000000-fffff8a004000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143800000-fffff8a004400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143800000-fffff8a004800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] Zone PFN ranges:
  [    0.000000]   Normal   0x05000000 -> 0x050ffd97
  [    0.000000] Movable zone start PFN for each node
  [    0.000000] early_node_map[4] active PFN ranges
  [    0.000000]     0: 0x05000000 -> 0x050ff7ff
  [    0.000000]     0: 0x050ff800 -> 0x050ffd7c
  [    0.000000]     0: 0x050ffd84 -> 0x050ffd94
  [    0.000000]     0: 0x050ffd96 -> 0x050ffd97
  [    0.000000] Booting Linux...
  [    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,ultra3,mul32,div32=
]
  [    0.000000] CPU CAPS: [v8plus,popc,vis,vis2]
  [    0.000000] PERCPU: Embedded 6 pages/cpu @fffff8a004c00000 s12352=20
r8192 d286
6[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. =20
Total pa
0[    0.000000] Kernel command line: root=3D/dev/sda2 ro
  [    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
  [    0.000000] Dentry cache hash table entries: 1048576 (order: 10,=20
8388608 byt
)[    0.000000] Inode-cache hash table entries: 524288 (order: 9,=20
4194304 bytes)
  [    0.000000] Memory: 8288896k available (3632k kernel code, 1560k=20
data, 232k
][    0.000000] Hierarchical RCU implementation.
  [    0.000000] CONFIG_RCU_FANOUT set to non-default value of 32
  [    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
  [    0.000000] NR_IRQS:255
  [    0.000000] clocksource: mult[64000000] shift[24]
  [    0.000000] clockevent: mult[28f5c29] shift[32]
  [    0.000000] Console: colour dummy device 80x25
  [    0.000000] console [tty0] enabled, bootconsole disabled
  [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.30.4 2009/08/19 07:20=
'
  [    0.000000] PROMLIB: Root node compatible:
  [    0.000000] Initializing cgroup subsys cpuset
  [    0.000000] Initializing cgroup subsys cpu
  [    0.000000] Linux version 3.0.0-1-sparc64-smp (Debian 3.0.0-3)=20
(ben@decadent
1[    0.000000] bootconsole [earlyprom0] enabled
  [    0.000000] ARCH: SUN4U
  [    0.000000] Ethernet address: 00:14:4f:01:06:d2
  [    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
  [    0.000000] Remapping the kernel... done.
  [    0.000000] OF stdout device is: /pci@9,700000/ebus@1/serial@1,40000=
0:a
  [    0.000000] PROM: Built device tree with 101044 bytes of memory.
  [    0.000000] Top of RAM: 0xa1ffb2e000, Total RAM: 0x1ffb18000
  [    0.000000] Memory hole size: 655360MB
  [    0.000000] [0000010140000000-fffff8a000c00000] page_structs=3D13107=
2=20
node=3D0 e
2[    0.000000] [0000010140000000-fffff8a001000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010140800000-fffff8a001400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010140800000-fffff8a001800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141000000-fffff8a001c00000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141000000-fffff8a002000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141800000-fffff8a002400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010141800000-fffff8a002800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142000000-fffff8a002c00000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142000000-fffff8a003000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142800000-fffff8a003400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010142800000-fffff8a003800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143000000-fffff8a003c00000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143000000-fffff8a004000000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143800000-fffff8a004400000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] [0000010143800000-fffff8a004800000] page_structs=3D131072=
=20
node=3D0 e
2[    0.000000] Zone PFN ranges:
  [    0.000000]   Normal   0x05000000 -> 0x050ffd97
  [    0.000000] Movable zone start PFN for each node
  [    0.000000] early_node_map[4] active PFN ranges
  [    0.000000]     0: 0x05000000 -> 0x050ff7ff
  [    0.000000]     0: 0x050ff800 -> 0x050ffd7c
  [    0.000000]     0: 0x050ffd84 -> 0x050ffd94
  [    0.000000]     0: 0x050ffd96 -> 0x050ffd97
  [    0.000000] Booting Linux...
  [    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,ultra3,mul32,div32=
]
  [    0.000000] CPU CAPS: [v8plus,popc,vis,vis2]
  [    0.000000] PERCPU: Embedded 6 pages/cpu @fffff8a004c00000 s12352=20
r8192 d286
6[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. =20
Total pa
0[    0.000000] Kernel command line: root=3D/dev/sda2 ro
  [    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
  [    0.000000] Dentry cache hash table entries: 1048576 (order: 10,=20
8388608 byt
)[    0.000000] Inode-cache hash table entries: 524288 (order: 9,=20
4194304 bytes)
  [    0.000000] Memory: 8288896k available (3632k kernel code, 1560k=20
data, 232k
][    0.000000] Hierarchical RCU implementation.
  [    0.000000] CONFIG_RCU_FANOUT set to non-default value of 32
  [    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
  [    0.000000] NR_IRQS:255
  [    0.000000] clocksource: mult[64000000] shift[24]
  [    0.000000] clockevent: mult[28f5c29] shift[32]
  [    0.000000] Console: colour dummy device 80x25
  [    0.000000] console [tty0] enabled, bootconsole disabled
  [   41.406042] Calibrating delay using timer specific routine.. 19.99=20
BogoMIPS
)[   41.406057] pid_max: default: 32768 minimum: 301
  [   41.406213] Security Framework initialized
  [   41.406230] SELinux:  Disabled at boot.
  [   41.406302] Mount-cache hash table entries: 512
  [   41.406707] Initializing cgroup subsys cpuacct
  [   41.406733] Initializing cgroup subsys memory
  [   41.406760] Initializing cgroup subsys devices
  [   41.406769] Initializing cgroup subsys freezer
  [   41.406777] Initializing cgroup subsys net_cls
  [   41.406786] Initializing cgroup subsys blkio
  [   41.406965] Performance events: Supported PMU type is 'ultra4+'
  [   41.408240] CPU 0: synchronized TICK with master CPU (last diff 0=20
cycles, ma
)[   41.409080] CPU 16: synchronized TICK with master CPU (last diff 0=20
cycles, m
)[   41.409678] CPU 18: synchronized TICK with master CPU (last diff 0=20
cycles, m
)[   41.409711] Brought up 4 CPUs
  [   41.409726] Testing NMI watchdog ... OK.
  [   41.490289] devtmpfs: initialized
  [   41.490738] print_constraints: dummy:
  [   41.490895] NET: Registered protocol family 16
  [   41.494575] /pci@8,700000: SCHIZO PCI Bus Module ver[7:0]
  [   41.494590] /pci@8,700000: PCI IO[7ffef000000] MEM[7fe00000000]
  [   41.498586] PCI: Scanning PBM /pci@8,700000
  [   41.498803] /pci@8,600000: SCHIZO PCI Bus Module ver[7:0]
  [   41.498817] /pci@8,600000: PCI IO[7ffed000000] MEM[7fd00000000]
  [   41.502814] PCI: Scanning PBM /pci@8,600000
  [   41.503172] /pci@9,700000: SCHIZO PCI Bus Module ver[7:0]
  [   41.503186] /pci@9,700000: PCI IO[7ffeb000000] MEM[7fc00000000]
  [   41.507180] PCI: Scanning PBM /pci@9,700000
  [   41.508127] /pci@9,600000: SCHIZO PCI Bus Module ver[7:0]
  [   41.508142] /pci@9,600000: PCI IO[7ffe9000000] MEM[7fb00000000]
  [   41.512133] PCI: Scanning PBM /pci@9,600000
  [   41.513960] bio: create slab <bio-0> at 0
  [   41.514272] vgaarb: loaded
  [   41.514799] /pci@9,700000/ebus@1/rtc@1,300070: RTC regs at=20
0x7fc7e300070
  [   41.515091] Switching to clocksource stick
  [   41.515783] Switched to NOHz mode on CPU #0
  [   41.516546] Switched to NOHz mode on CPU #16
  [   41.517433] Switched to NOHz mode on CPU #18
  [   41.517901] Switched to NOHz mode on CPU #2
  [   41.521086] NET: Registered protocol family 2
  [   41.521283] IP route cache hash table entries: 262144 (order: 8,=20
2097152 byt
)[   41.523632] TCP established hash table entries: 524288 (order: 10,=20
8388608 b
)[   41.550909] TCP bind hash table entries: 65536 (order: 7, 1048576 byt=
es)
  [   41.554334] TCP: Hash tables configured (established 524288 bind 655=
36)
  [   41.554347] TCP reno registered
  [   41.554362] UDP hash table entries: 4096 (order: 4, 131072 bytes)
  [   41.554802] UDP-Lite hash table entries: 4096 (order: 4, 131072 byte=
s)
  [   41.555543] NET: Registered protocol family 1
  [   41.555685] Unpacking initramfs...
  [   41.968964] Freeing initrd memory: 9861k freed
  [   41.969683] power: Control reg at 7fc7e30002e
  [   41.969902] chmc: UltraSPARC-III memory controller at=20
/memory-controller@0,4
][   41.969934] chmc: UltraSPARC-III memory controller at=20
/memory-controller@2,4
][   41.970298] audit: initializing netlink socket (disabled)
  [   41.970326] type=3D2000 audit(0.644:1): initialized
  [   42.199326] HugeTLB registered 4 MB page size, pre-allocated 0 pages
  [   42.199914] VFS: Disk quotas dquot_6.5.2
  [   42.200076] Dquot-cache hash table entries: 1024 (order 0, 8192 byte=
s)
  [   42.200272] msgmni has been set to 16208
  [   42.200725] alg: No test for stdrng (krng)
  [   42.200801] Block layer SCSI generic (bsg) driver version 0.4=20
loaded (major
)[   42.200822] io scheduler noop registered
  [   42.200833] io scheduler deadline registered
  [   42.200886] io scheduler cfq registered (default)
  [   42.202087] f00c182c: ttyS0 at MMIO 0x7fc7e3062f8 (irq =3D 18) is a=20
16550A
  [   42.202188] f00c3154: ttyS1 at MMIO 0x7fc7e3083f8 (irq =3D 19) is a=20
16550A
  [   42.202414] f00c4a7c: ttyS2 at MMIO 0x7fc7e400000 (irq =3D 20) is a=20
SAB82532 V
2[   42.202433] Console: ttyS2 (SAB82532)
  [   50.621762] console [ttyS0] enabled
  [   50.663432] f00c4a7c: ttyS3 at MMIO 0x7fc7e400040 (irq =3D 20) is a=20
SAB82532 V
2[   50.751013] [drm] Initialized drm 1.1.0 20060810
  [   50.867493] Uniform Multi-Platform E-IDE driver
  [   50.920775] ide-gd driver 1.18
  [   50.957372] mousedev: PS/2 mouse device common for all mice
  [   51.024254] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
  [   51.099913] rtc0: no alarms, 114 bytes nvram
  [   51.151630] TCP cubic registered
  [   51.189618] NET: Registered protocol family 10
  [   51.243961] Mobile IPv6
  [   51.272195] NET: Registered protocol family 17
  [   51.325326] Registering the dns_resolver key type
  [   51.381719] registered taskstats version 1
  [   51.430834] rtc_cmos rtc_cmos: setting system clock to 2011-11-12=20
14:56:43 U
)[   51.530578] Initializing network drop monitor service
=C5=A3Loading, please wait...[   51.616916] udevd[58]: starting version 1=
72

  [   51.710081] cassini: cassini.c:v1.6 (21 May 2008)
  [   51.713731] usbcore: registered new interface driver usbfs
  [   51.713766] usbcore: registered new interface driver hub
  [   51.714422] usbcore: registered new device driver usb
  [   51.715260] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
  [   51.715842] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
  [   51.716625] SCSI subsystem initialized
  [   51.721703] pata_cmd64x 0000:00:06.0: Secondary port is disabled
  [   51.723829] scsi0 : pata_cmd64x
  [   51.815557] Fusion MPT base driver 3.04.19
  [   51.815561] Copyright (c) 1999-2008 LSI Corporation
  [   51.816671] Fusion MPT SPI Host driver 3.04.19
  [   51.816814] mptbase: ioc0: Initiating bringup
  [   52.295114] ioc0: LSI53C1030 C0: Capabilities=3D{Initiator,Target}
  [   52.545823] scsi1 : pata_cmd64x
  [   52.552553] cassini 0002:00:02.0: eth0: Sun Cassini+ (64bit/33MHz=20
PCI/Cu) Et
3[   52.553886] ohci_hcd 0002:00:01.3: OHCI Host Controller
  [   52.553931] ohci_hcd 0002:00:01.3: new USB bus registered, assigned=20
bus numb
1[   52.553984] ohci_hcd 0002:00:01.3: irq 21, io mem 0x7fc01000000
  [   52.558517] cassini 0003:00:01.0: eth1: Sun Cassini+ (64bit/66MHz=20
PCI/Cu) Et
2[   52.611170] usb usb1: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0001
  [   52.611177] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber
1[   52.611183] usb usb1: Product: OHCI Host Controller
  [   52.611188] usb usb1: Manufacturer: Linux 3.0.0-1-sparc64-smp ohci_h=
cd
  [   52.611193] usb usb1: SerialNumber: 0002:00:01.3
  [   52.611373] hub 1-0:1.0: USB hub found
  [   52.611385] hub 1-0:1.0: 4 ports detected
  [   53.484174] /pci@8,600000: Safari/JBUS interrupt, UNMAPPED error,=20
interrogat
.[   53.580160] /pci@8,600000: STC_ERR(32)[wr(1)rd(1)]
  [   53.637287] /pci@8,600000: STC_ERR(33)[wr(1)rd(1)]
  [   53.694582] /pci@8,600000: STC_ERR(34)[wr(1)rd(1)]
  [   53.751874] /pci@8,600000: STC_ERR(35)[wr(1)rd(1)]
  [   53.809168] /pci@8,600000: STC_ERR(36)[wr(1)rd(1)]
  [   53.866462] /pci@8,600000: STC_ERR(37)[wr(1)rd(1)]
  [   53.923757] /pci@8,600000: STC_ERR(38)[wr(1)rd(1)]
  [   53.981049] /pci@8,600000: STC_ERR(39)[wr(1)rd(1)]
  [   54.038345] /pci@8,600000:=20
STC_TAG(4)[PA(0000000000000000)VA(00000000)V(0)R(
][   54.125854] /pci@8,600000:=20
STC_LINE(4)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   54.210227] /pci@8,600000: STC_ERR(40)[wr(1)rd(1)]
  [   54.267519] /pci@8,600000: STC_ERR(41)[wr(1)rd(1)]
  [   54.324814] /pci@8,600000: STC_ERR(42)[wr(1)rd(1)]
  [   54.382106] /pci@8,600000: STC_ERR(43)[wr(1)rd(1)]
  [   54.439400] /pci@8,600000: STC_ERR(44)[wr(1)rd(1)]
  [   54.496695] /pci@8,600000: STC_ERR(45)[wr(1)rd(1)]
  [   54.553989] /pci@8,600000: STC_ERR(46)[wr(1)rd(1)]
  [   54.611283] /pci@8,600000: STC_ERR(47)[wr(1)rd(1)]
  [   54.668578] /pci@8,600000:=20
STC_TAG(5)[PA(0000000000000000)VA(00000000)V(0)R(
][   54.756086] /pci@8,600000:=20
STC_LINE(5)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   54.840458] /pci@8,600000: STC_ERR(48)[wr(1)rd(1)]
  [   54.897753] /pci@8,600000: STC_ERR(49)[wr(1)rd(1)]
  [   54.955046] /pci@8,600000: STC_ERR(50)[wr(1)rd(1)]
  [   55.012340] /pci@8,600000: STC_ERR(51)[wr(1)rd(1)]
  [   55.069633] /pci@8,600000: STC_ERR(52)[wr(1)rd(1)]
  [   55.126926] /pci@8,600000: STC_ERR(53)[wr(1)rd(1)]
  [   55.184221] /pci@8,600000: STC_ERR(54)[wr(1)rd(1)]
  [   55.241515] /pci@8,600000: STC_ERR(55)[wr(1)rd(1)]
  [   55.298808] /pci@8,600000:=20
STC_TAG(6)[PA(0000000000000000)VA(00000000)V(0)R(
][   55.386318] /pci@8,600000:=20
STC_LINE(6)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   55.470691] /pci@8,600000: STC_ERR(56)[wr(1)rd(1)]
  [   55.527984] /pci@8,600000: STC_ERR(57)[wr(1)rd(1)]
  [   55.585278] /pci@8,600000: STC_ERR(58)[wr(1)rd(1)]
  [   55.642572] /pci@8,600000: STC_ERR(59)[wr(1)rd(1)]
  [   55.699865] /pci@8,600000: STC_ERR(60)[wr(1)rd(1)]
  [   55.757159] /pci@8,600000: STC_ERR(61)[wr(1)rd(1)]
  [   55.814453] /pci@8,600000: STC_ERR(62)[wr(1)rd(1)]
  [   55.871748] /pci@8,600000: STC_ERR(63)[wr(1)rd(1)]
  [   55.929041] /pci@8,600000:=20
STC_TAG(7)[PA(0000000000000000)VA(00000000)V(0)R(
][   56.016551] /pci@8,600000:=20
STC_LINE(7)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   56.100924] /pci@8,600000: STC_ERR(64)[wr(1)rd(0)]
  [   56.158215] /pci@8,600000: STC_ERR(65)[wr(1)rd(0)]
  [   56.215510] /pci@8,600000: STC_ERR(66)[wr(1)rd(1)]
  [   56.272805] /pci@8,600000: STC_ERR(67)[wr(0)rd(0)]
  [   56.330098] /pci@8,600000: STC_ERR(68)[wr(0)rd(1)]
  [   56.387391] /pci@8,600000: STC_ERR(69)[wr(1)rd(1)]
  [   56.444685] /pci@8,600000: STC_ERR(70)[wr(0)rd(1)]
  [   56.501979] /pci@8,600000: STC_ERR(71)[wr(1)rd(0)]
  [   56.559275] /pci@8,600000:=20
STC_TAG(8)[PA(0000000000000000)VA(00000000)V(0)R(
][   56.646783] /pci@8,600000:=20
STC_LINE(8)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   56.731155] /pci@8,600000: STC_ERR(72)[wr(0)rd(0)]
  [   56.788449] /pci@8,600000: STC_ERR(73)[wr(0)rd(1)]
  [   56.845742] /pci@8,600000: STC_ERR(74)[wr(1)rd(0)]
  [   56.903036] /pci@8,600000: STC_ERR(75)[wr(0)rd(0)]
  [   56.960331] /pci@8,600000: STC_ERR(76)[wr(0)rd(1)]
  [   57.017624] /pci@8,600000: STC_ERR(77)[wr(1)rd(0)]
  [   57.074917] /pci@8,600000: STC_ERR(78)[wr(1)rd(1)]
  [   57.132211] /pci@8,600000: STC_ERR(79)[wr(0)rd(1)]
  [   57.189506] /pci@8,600000:=20
STC_TAG(9)[PA(0000000000000000)VA(00000000)V(0)R(
][   57.277014] /pci@8,600000:=20
STC_LINE(9)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   57.361548] /pci@8,700000: STC_ERR(32)[wr(1)rd(1)]
  [   57.418681] /pci@8,700000: STC_ERR(33)[wr(1)rd(1)]
  [   57.475975] /pci@8,700000: STC_ERR(34)[wr(1)rd(1)]
  [   57.533268] /pci@8,700000: STC_ERR(35)[wr(1)rd(1)]
  [   57.590562] /pci@8,700000: STC_ERR(36)[wr(1)rd(1)]
  [   57.647856] /pci@8,700000: STC_ERR(37)[wr(1)rd(1)]
  [   57.705149] /pci@8,700000: STC_ERR(38)[wr(1)rd(1)]
  [   57.762444] /pci@8,700000: STC_ERR(39)[wr(1)rd(1)]
  [   57.819738] /pci@8,700000:=20
STC_TAG(4)[PA(0000000000000000)VA(00000000)V(0)R(
][   57.907248] /pci@8,700000:=20
STC_LINE(4)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   57.991619] /pci@8,700000: STC_ERR(40)[wr(1)rd(1)]
  [   58.048913] /pci@8,700000: STC_ERR(41)[wr(1)rd(1)]
  [   58.106208] /pci@8,700000: STC_ERR(42)[wr(1)rd(1)]
  [   58.163500] /pci@8,700000: STC_ERR(43)[wr(1)rd(1)]
  [   58.220794] /pci@8,700000: STC_ERR(44)[wr(1)rd(1)]
  [   58.278088] /pci@8,700000: STC_ERR(45)[wr(1)rd(1)]
  [   58.335381] /pci@8,700000: STC_ERR(46)[wr(1)rd(1)]
  [   58.392676] /pci@8,700000: STC_ERR(47)[wr(1)rd(1)]
  [   58.449972] /pci@8,700000:=20
STC_TAG(5)[PA(0000000000000000)VA(00000000)V(0)R(
][   58.537480] /pci@8,700000:=20
STC_LINE(5)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   58.621854] /pci@8,700000: STC_ERR(48)[wr(1)rd(1)]
  [   58.679146] /pci@8,700000: STC_ERR(49)[wr(1)rd(1)]
  [   58.736438] /pci@8,700000: STC_ERR(50)[wr(1)rd(1)]
  [   58.793733] /pci@8,700000: STC_ERR(51)[wr(1)rd(1)]
  [   58.851026] /pci@8,700000: STC_ERR(52)[wr(1)rd(1)]
  [   58.908320] /pci@8,700000: STC_ERR(53)[wr(1)rd(1)]
  [   58.965615] /pci@8,700000: STC_ERR(54)[wr(1)rd(1)]
  [   59.022908] /pci@8,700000: STC_ERR(55)[wr(1)rd(1)]
  [   59.080203] /pci@8,700000:=20
STC_TAG(6)[PA(0000000000000000)VA(00000000)V(0)R(
][   59.167713] /pci@8,700000:=20
STC_LINE(6)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   59.252084] /pci@8,700000: STC_ERR(56)[wr(1)rd(1)]
  [   59.309378] /pci@8,700000: STC_ERR(57)[wr(1)rd(1)]
  [   59.366671] /pci@8,700000: STC_ERR(58)[wr(1)rd(1)]
  [   59.423965] /pci@8,700000: STC_ERR(59)[wr(1)rd(1)]
  [   59.481259] /pci@8,700000: STC_ERR(60)[wr(1)rd(1)]
  [   59.538553] /pci@8,700000: STC_ERR(61)[wr(1)rd(1)]
  [   59.595847] /pci@8,700000: STC_ERR(62)[wr(1)rd(1)]
  [   59.653141] /pci@8,700000: STC_ERR(63)[wr(1)rd(1)]
  [   59.710436] /pci@8,700000:=20
STC_TAG(7)[PA(0000000000000000)VA(00000000)V(0)R(
][   59.797945] /pci@8,700000:=20
STC_LINE(7)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   59.882317] /pci@8,700000: STC_ERR(64)[wr(0)rd(1)]
  [   59.939611] /pci@8,700000: STC_ERR(65)[wr(0)rd(0)]
  [   59.996904] /pci@8,700000: STC_ERR(66)[wr(0)rd(0)]
  [   60.054198] /pci@8,700000: STC_ERR(67)[wr(0)rd(0)]
  [   60.111491] /pci@8,700000: STC_ERR(68)[wr(0)rd(0)]
  [   60.168786] /pci@8,700000: STC_ERR(69)[wr(0)rd(0)]
  [   60.226080] /pci@8,700000: STC_ERR(70)[wr(0)rd(0)]
  [   60.283372] /pci@8,700000: STC_ERR(71)[wr(0)rd(0)]
  [   60.340667] /pci@8,700000:=20
STC_TAG(8)[PA(0000000000000000)VA(00000000)V(0)R(
][   60.428176] /pci@8,700000:=20
STC_LINE(8)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   60.512549] /pci@8,700000: STC_ERR(72)[wr(0)rd(0)]
  [   60.569841] /pci@8,700000: STC_ERR(73)[wr(0)rd(0)]
  [   60.627136] /pci@8,700000: STC_ERR(74)[wr(0)rd(0)]
  [   60.684429] /pci@8,700000: STC_ERR(75)[wr(0)rd(0)]
  [   60.741724] /pci@8,700000: STC_ERR(76)[wr(0)rd(0)]
  [   60.799018] /pci@8,700000: STC_ERR(77)[wr(0)rd(0)]
  [   60.856310] /pci@8,700000: STC_ERR(78)[wr(0)rd(0)]
  [   60.913604] /pci@8,700000: STC_ERR(79)[wr(0)rd(0)]
  [   60.970899] /pci@8,700000:=20
STC_TAG(9)[PA(0000000000000000)VA(00000000)V(0)R(
][   61.058409] /pci@8,700000:=20
STC_LINE(9)[LIDX(0)SP(0)LADDR(0)EP(0)V(0)FOFN(0)]
  [   61.142827] QLogic Fibre Channel HBA Driver: 8.03.07.03-k
  [   61.143686] ata1: PATA max UDMA/33 cmd 0x7ffef000300 ctl=20
0x7ffef000318 bmdma
6[   61.143691] ata2: DUMMY
  [   61.343378] qla2xxx 0003:00:02.0: Found an ISP2200, irq 32, iobase=20
0x000007f
0[   61.419483] ata1.00: ATAPI: TOSHIBA ODD-DVD SD-C2732, 1055, max UDMA/=
33
  [   61.435425] ata1.00: configured for UDMA/33
  [   61.441030] scsi 0:0:0:0: CD-ROM            TOSHIBA  ODD-DVD=20
SD-C2732 1055 P
5[   61.449619] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
  [   61.449624] cdrom: Uniform CD-ROM driver Revision: 3.20
  [   61.452802] sr 0:0:0:0: Attached scsi generic sg0 type 5
  [   61.862823] qla2xxx 0003:00:02.0: Configuring PCI space...
  [   61.928046] qla2xxx 0003:00:02.0: Configure NVRAM parameters...
  [   62.093514] qla2xxx 0003:00:02.0: Inconsistent NVRAM detected:=20
checksum=3D0x0
.[   62.195651] qla2xxx 0003:00:02.0: Falling back to functioning (yet=20
invalid -
.[   62.297736] qla2xxx 0003:00:02.0: Verifying loaded RISC code...
  [   67.767148] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[   68.623116] mptbase: ioc0: Attempting Retry Config request type 0x3,=20
page 0x
0[   73.043170] qla2xxx 0003:00:02.0: Allocated (252 KB) for firmware=20
dump...
  [   73.267121] qla2xxx 0003:00:02.0: LIP reset occurred (f8f7).
  [   73.333967] scsi2 : qla2xxx
  [   73.356190] qla2xxx 0003:00:02.0: LIP occurred (f8f7).
  [   73.359857] qla2xxx 0003:00:02.0: LOOP UP detected (1 Gbps).
  [   73.496867] qla2xxx 0003:00:02.0:
  [   73.496869]  QLogic Fibre Channel HBA Driver: 8.03.07.03-k
  [   73.496872]   QLogic QLA22xx -
  [   73.496874]   ISP2200: PCI (66 MHz) @ 0003:00:02.0 hdma-, host#=3D2,=
=20
fw=3D2.02.0
P[   73.501903] scsi 2:0:0:0: Direct-Access     SEAGATE =20
ST314670FSUN146G 055A P
3[   73.505485] scsi 2:0:1:0: Direct-Access     SEAGATE =20
ST314670FSUN146G 055A P
3[   73.511291] scsi 2:0:0:0: Attached scsi generic sg1 type 0
  [   73.511486] scsi 2:0:1:0: Attached scsi generic sg2 type 0
  [   74.104139] sd 2:0:0:0: [sda] 286739329 512-byte logical blocks:=20
(146 GB/136
)[   74.192803] sd 2:0:1:0: [sdb] 286739329 512-byte logical blocks:=20
(146 GB/136
)[   74.194913] sd 2:0:0:0: [sda] Write Protect is off
  [   74.198379] sd 2:0:0:0: [sda] Write cache: disabled, read cache:=20
enabled, su
A[   74.216926]  sda: sda1 sda3
  [   74.477713] sd 2:0:1:0: [sdb] Write Protect is off
  [   74.536406] sd 2:0:1:0: [sdb] Write cache: disabled, read cache:=20
enabled, su
A[   74.638652] sd 2:0:0:0: [sda] Attached SCSI disk
  [   74.656179]  sdb: sdb1 sdb3
  [   74.735717] sd 2:0:1:0: [sdb] Attached SCSI disk
  [   83.715125] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[   83.812095] mptbase: ioc0: Initiating recovery
  [   89.747119] mptbase: ioc0: Attempting Retry Config request type=20
0x3, page 0x
0[  104.839261] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  104.936225] mptbase: ioc0: Initiating recovery
  udevd[99]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[99]: '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000sd000010C0bc01sc0
)
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  125.975271] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0udevd[98]: timeout: killing '/sbin/modprobe -b pci:v00001000d0[ =20
126.831117] mp
00000030sv00001000sd000010C0bc01sc00i00' [119]

  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  141.923232] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  142.020238] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  148.059117] mptbase: ioc0: Attempting Retry Config request type=20
0x4, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  163.151160] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  163.248128] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]

  udevadm settle - timeout of 120 seconds reached, the event queue contai=
ns:
    /sys/devices/root/f0089c90/pci0001:00/0001:00:01.0 (399)
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  184.287160] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  185.127119] mptbase: ioc0: Attempting Retry Config request type=20
0x1, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  200.219155] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  200.316095] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  206.355117] mptbase: ioc0: Attempting Retry Config request type=20
0x1, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  221.447193] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  221.544193] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  242.583205] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  243.439117] mptbase: ioc0: Attempting Retry Config request type=20
0x1, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  258.531210] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  258.628210] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  264.667117] mptbase: ioc0: Attempting Retry Config request type=20
0x1, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  279.759198] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  279.856209] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  300.895313] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  301.751116] mptbase: ioc0: Attempting Retry Config request type=20
0x0, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  316.843285] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  316.940226] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  322.979117] mptbase: ioc0: Attempting Retry Config request type=20
0x0, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  338.071384] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  338.168332] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  359.207321] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  360.063116] mptbase: ioc0: Attempting Retry Config request type=20
0x9, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  375.155306] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  375.252237] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  381.291116] mptbase: ioc0: Attempting Retry Config request type=20
0x9, page 0x
0udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  396.383237] mptbase: ioc0: WARNING - Issuing Reset from=20
mpt_config!!, doorbe
0[  396.480231] mptbase: ioc0: Initiating recovery
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  401.995119] INFO: task modprobe:226 blocked for more than 120 second=
s.
  [  402.072315] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this
.[  402.166072] modprobe        D 0000000010242004     0   226     56=20
0x41005110
0[  402.257736] Call Trace:
  [  402.286912]  [000000000066994c] wait_for_device_probe+0x74/0x9c
  [  402.357748]  [0000000010242004] wait_scan_init+0x4/0x14=20
[scsi_wait_scan]
  [  402.437955]  [0000000000426c04] do_one_initcall+0x68/0x148
  [  402.503589]  [000000000049995c] SyS_init_module+0x68/0x198
  [  402.569218]  [0000000000406154] linux_sparc_syscall32+0x34/0x40
  udevd[98]: timeout: killing '/sbi[  402.675233] scsi3 : ioc0:=20
LSI53C1030 C0, Fw
9[  402.765250] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  402.765333] mptbase: ioc1: Initiating bringup
  n/modprobe -b pci:v00001000d00000030sv00001000sd000010C0bc01sc00i00' [1=
19]

  [  403.243117] ioc1: LSI53C1030 C0: Capabilities=3D{Initiator,Target}
  udevd[98]: timeout: killing '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000
]
  [  403.801651] scsi4 : ioc1: LSI53C1030 C0, FwRev=3D01032700h, Ports=3D=
1,=20
MaxQ=3D255,
0udevd[98]: '/sbin/modprobe -b=20
pci:v00001000d00000030sv00001000sd000010C0bc01sc0
)
  Begin: Loading essential drivers ... done.
  Begin: Running /scripts/init-premount ... done.
  Begin: Mounting root file system ... Begin: Running /scripts/local-top=20
... Begi
3[  404.972643] scsi 4:0:1:0: Information Units disabled by blacklist
  [  405.045560] scsi target4:0:1: Beginning Domain Validation
  e.
  cannot i[  405.123437] scsi target4:0:1: Domain Validation skipping=20
write tests
  [  405.198690] scsi target4:0:1: Ending Domain Validation
  [  405.260216] scsi target4:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5=20
ns, offs
)nitialise MD subsystem (/proc/mdstat missing)
  done.
  Begin: Waiting for root file system ... [  424.939132] mptscsih: ioc0:=20
attempti
)[  425.018402] scsi 3:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
  done.
  Gave up waiting for root device.  Common problems:
   - Boot args (cat /proc/cmdline)
     - Check rootdelay=3D (did the system [  435.199262] mptscsih: ioc0:=20
WARNING -
0wait long enough?)
     - Check root=3D (did the system wait for the right device?)
   - Missing modules (cat /proc/modules; ls /dev)
  ALERT!  /dev/sda2 does not exist.  Dropping to a shell!


  BusyBox v1.18.5 (Debian 1:1.18.5-1) built-in shell (ash)
  Enter 'help' for a list of built-in commands.

  /bin/sh: can't access tty; job control turned off
  (initramfs) [  436.067122] mptscsih: ioc0: task abort: SUCCESS=20
(rv=3D2002) (sc=3Dff
)[  436.153727] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  436.246432] scsi target3:0:0: FAST-5 WIDE SCSI 2.0 MB/s DT IU QAS=20
RDSTRM RTI
)[  436.372475] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  446.463391] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
76a0)
  [  446.542648] scsi 3:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  456.735253] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  457.603121] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f76
)[  457.689638] mptscsih: ioc0: attempting target reset!=20
(sc=3Dfffff8a1ff1f76a0)
  [  457.771923] scsi 3:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
  [  457.836510] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  457.929226] scsi target3:0:0: asynchronous
  [  457.978179] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  468.187306] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  469.055120] mptscsih: ioc0: target reset: SUCCESS (sc=3Dfffff8a1ff1f7=
6a0)
  [  469.133298] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  469.226008] scsi target3:0:0: asynchronous
  [  469.274962] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  479.271161] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
76a0)
  [  479.350452] scsi 3:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  489.543167] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  490.411123] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f76
)[  490.497650] mptscsih: ioc0: attempting bus reset! (sc=3Dfffff8a1ff1f7=
6a0)
  [  490.576810] scsi 3:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
  [  490.641407] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  490.734116] scsi target3:0:0: asynchronous
  [  490.783064] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  500.803118] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  501.671120] mptscsih: ioc0: bus reset: SUCCESS (sc=3Dfffff8a1ff1f76a0=
)
  [  501.746205] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  501.838910] scsi target3:0:0: asynchronous
  [  501.887861] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  521.747149] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
76a0)
  [  521.826433] scsi 3:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  532.019160] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  532.887122] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f76
)[  532.973648] mptscsih: ioc0: attempting host reset! (sc=3Dfffff8a1ff1f=
76a0)
  [  533.053848] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  533.146559] scsi target3:0:0: asynchronous
  [  533.195508] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  533.895118] mptscsih: ioc0: host reset: SUCCESS (sc=3Dfffff8a1ff1f76a=
0)
  [  533.971279] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  534.063984] scsi target3:0:0: asynchronous
  [  534.112939] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  553.975137] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
76a0)
  [  554.054430] scsi 3:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  564.247211] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  565.115121] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f76
)[  565.201629] scsi 3:0:0:0: Device offlined - not ready after error=20
recovery
  [  565.283947] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  565.376647] scsi target3:0:0: asynchronous
  [  565.425593] scsi target3:0:0: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  565.519150] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  586.179453] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
66e0)
  [  586.258690] scsi 3:0:1:0: CDB: Inquiry: 12 00 00 00 24 00
  [  596.443149] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  597.311121] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f66
)[  597.397662] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  597.490362] scsi target3:0:1: asynchronous
  [  597.539316] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  607.407165] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
66e0)
  [  607.486364] scsi 3:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  617.679140] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  618.547122] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f66
)[  618.633672] mptscsih: ioc0: attempting target reset!=20
(sc=3Dfffff8a1ff1f66e0)
  [  618.715958] scsi 3:0:1:0: CDB: Inquiry: 12 00 00 00 24 00
  [  618.780550] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  618.873266] scsi target3:0:1: FAST-5 WIDE SCSI 2.0 MB/s DT IU QAS=20
RDSTRM RTI
)[  618.999311] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  628.899118] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  629.767120] mptscsih: ioc0: target reset: SUCCESS (sc=3Dfffff8a1ff1f6=
6e0)
  [  629.845353] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  629.938062] scsi target3:0:1: asynchronous
  [  629.987014] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  639.983123] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
66e0)
  [  640.062398] scsi 3:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  642.639154] INFO: task scsi_scan_4:232 blocked for more than 120=20
seconds.
  [  642.719484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this
.[  642.813237] scsi_scan_4     D 0000000000789a38     0   232      2=20
0x28000000
0[  642.900735] Call Trace:
  [  642.929912]  [0000000000789c80] schedule_timeout+0x18/0x2b0
  [  642.996576]  [0000000000789a38] wait_for_common+0xb8/0x148
  [  643.062241]  [00000000100141d4] do_scan_async+0x68/0x168 [scsi_mod]
  [  643.137209]  [0000000000481c8c] kthread+0x5c/0x70
  [  643.193464]  [000000000042aa58] kernel_thread+0x30/0x48
  [  643.255959]  [0000000000481fa0] kthreadd+0xd0/0x11c
  [  650.255400] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  651.123124] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f66
)[  651.209708] mptscsih: ioc0: attempting bus reset! (sc=3Dfffff8a1ff1f6=
6e0)
  [  651.288870] scsi 3:0:1:0: CDB: Inquiry: 12 00 00 00 24 00
  [  651.353455] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  651.446174] scsi target3:0:1: asynchronous
  [  651.495127] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  661.603072] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  662.471122] mptscsih: ioc0: bus reset: SUCCESS (sc=3Dfffff8a1ff1f66e0=
)
  [  662.546186] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  662.638892] scsi target3:0:1: asynchronous
  [  662.687843] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  682.547125] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
66e0)
  [  682.626415] scsi 3:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  692.819073] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  693.687123] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f66
)[  693.773631] mptscsih: ioc0: attempting host reset! (sc=3Dfffff8a1ff1f=
66e0)
  [  693.853832] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  693.946541] scsi target3:0:1: asynchronous
  [  693.995495] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  694.695119] mptscsih: ioc0: host reset: SUCCESS (sc=3Dfffff8a1ff1f66e=
0)
  [  694.771266] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  694.863972] scsi target3:0:1: asynchronous
  [  694.912924] scsi target3:0:1: mptspi: ioc0: dma_alloc_coherent for=20
parameter
d[  714.775230] mptscsih: ioc0: attempting task abort! (sc=3Dfffff8a1ff1f=
66e0)
  [  714.854517] scsi 3:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
  [  725.047245] mptscsih: ioc0: WARNING - Issuing Reset from=20
mptscsih_IssueTaskM
0[  725.915123] mptscsih: ioc0: task abort: SUCCESS (rv=3D2002)=20
(sc=3Dfffff8a1ff1f66
)[  726.001718] scsi 3:0:1:0: Device offlined - not ready after error=20
recovery
  [  726.084030] scsi target3:0:1: Beginning Domain Validation
  [  726.148605] Unable to handle kernel NULL pointer dereference
  [  726.216307] tsk->{mm,active_mm}->context =3D 00000000000003a9
  [  726.282971] tsk->{mm,active_mm}->pgd =3D fffff8a1fa23a000
  [  726.345480]               \|/ ____ \|/
  [  726.345482]               "@'/ .. \`@"
  [  726.345484]               /_| \__/ |_\
  [  726.345487]                  \__U_/
  [  726.521524] kworker/18:1(42): Oops [#1]
  [  726.567364] TSTATE: 0000004480001603 TPC: 0000000010139f30 TNPC:=20
00000000101
d[  726.685096] TPC: <spi_dv_device+0xc8/0x628 [scsi_transport_spi]>
  [  726.756950] g0: 000000001002c800 g1: 0000000000000000 g2:=20
00000000008d3700 g
8[  726.861128] g4: fffff8a1fe18c760 g5: fffff8a0045ac000 g6:=20
fffff8a1faab8000 g
0[  726.965297] o0: 0000000000000043 o1: fffff8a1faa91b48 o2:=20
000000001013b1c8 o
8[  727.069468] o4: 0000000000010000 o5: 0000000010028e68 sp:=20
fffff8a1faabb2b1 r
c[  727.177809] RPC: <spi_dv_device+0xa4/0x628 [scsi_transport_spi]>
  [  727.249680] l0: 000000001002cad0 l1: fffff8a1faa7c000 l2:=20
fffff8a1faa91cf8 l
8[  727.353854] l4: fffff8a1faa91b20 l5: fffff8a1faa91b20 l6:=20
0000000000000000 l
0[  727.458026] i0: fffff8a1faa95800 i1: 0000000000000001 i2:=20
fffff8a1faa91d30 i
8[  727.562194] i4: 0000000000000000 i5: 0000000000000000 i6:=20
fffff8a1faabb391 i
8[  727.666373] I7: <mptspi_dv_device+0x98/0x118 [mptspi]>
  [  727.727818] Call Trace:
  [  727.756989]  [000000001016d868] mptspi_dv_device+0x98/0x118 [mptspi]
  [  727.833035]  [000000001016dd74]=20
mptspi_dv_renegotiate_work+0xd0/0xf8 [mptspi
][  727.918462]  [000000000047c1f8] process_one_work+0x23c/0x3a0
  [  727.986168]  [000000000047e4e4] worker_thread+0x1dc/0x2e8
  [  728.050749]  [0000000000481c8c] kthread+0x5c/0x70
  [  728.107003]  [000000000042aa58] kernel_thread+0x30/0x48
  [  728.169506]  [0000000000481fa0] kthreadd+0xd0/0x11c
  [  728.227836] Disabling lock debugging due to kernel taint
  [  728.291387] Caller[000000001016d868]: mptspi_dv_device+0x98/0x118=20
[mptspi]
  [  728.373681] Caller[000000001016dd74]:=20
mptspi_dv_renegotiate_work+0xd0/0xf8 [
][  728.465354] Caller[000000000047c1f8]: process_one_work+0x23c/0x3a0
  [  728.539313] Caller[000000000047e4e4]: worker_thread+0x1dc/0x2e8
  [  728.610145] Caller[0000000000481c8c]: kthread+0x5c/0x70
  [  728.672649] Caller[000000000042aa58]: kernel_thread+0x30/0x48
  [  728.741402] Caller[0000000000481fa0]: kthreadd+0xd0/0x11c
  [  728.805985] Instruction DUMP: fa0e20a3  c25c2178  f85ca010=20
<c2586018> b93730
  [  728.935167] Unable to handle kernel paging request at virtual=20
address ffffff
0[  729.029949] tsk->{mm,active_mm}->context =3D 00000000000003a9
  [  729.096613] tsk->{mm,active_mm}->pgd =3D fffff8a1fa23a000
  [  729.159116]               \|/ ____ \|/
  [  729.159118]               "@'/ .. \`@"
  [  729.159121]               /_| \__/ |_\
  [  729.159123]                  \__U_/
  [  729.335163] kworker/18:1(42): Oops [#2]
  [  729.381001] TSTATE: 0000000011e01602 TPC: 0000000000481ec4 TNPC:=20
00000000004
  [  729.510178] TPC: <kthread_data+0x8/0xc>
  [  729.556006] g0: fffff8a004f00040 g1: 0000000000000000 g2:=20
fffff8a0045ac000 g
0[  729.660182] g4: fffff8a1fe18c760 g5: fffff8a0045ac000 g6:=20
fffff8a1faab8000 g
8[  729.764352] o0: fffff8a1fe18c760 o1: fffff8a1fe18c760 o2:=20
0000000000000001 o
a[  729.868525] o4: fffff8a1fe18c760 o5: fffff8a1fe190288 sp:=20
fffff8a1faabab61 r
c[  729.976863] RPC: <wq_worker_sleeping+0x4/0xac>
  [  730.029981] l0: fffff8a004f013b8 l1: 0000000000467844 l2:=20
0000000000000001 l
0[  730.134158] l4: 0000000000872620 l5: fffff8a1fe080cc0 l6:=20
0000000000000000 l
a[  730.238329] i0: fffff8a1fe18c760 i1: 0000000000000012 i2:=20
0000000000000001 i
1[  730.342500] i4: 0000000000847c78 i5: 0000000000000004 i6:=20
fffff8a1faabac11 i
8[  730.446675] I7: <schedule+0x154/0x850>
  [  730.491456] Call Trace:
  [  730.520625]  [0000000000788f38] schedule+0x154/0x850
  [  730.580006]  [000000000046930c] do_exit+0x750/0x770
  [  730.638341]  [000000000042774c] die_if_kernel+0x29c/0x2c4
  [  730.702926]  [000000000078c5cc] unhandled_fault+0x8c/0x98
  [  730.767512]  [000000000078ccdc] do_sparc64_fault+0x704/0x7b0
  [  730.835223]  [00000000004079e8] sparc64_realfault_common+0x10/0x20
  [  730.909187]  [0000000010139f30] spi_dv_device+0xc8/0x628=20
[scsi_transport_spi
][  730.994607]  [000000001016d868] mptspi_dv_device+0x98/0x118 [mptspi]
  [  731.070651]  [000000001016dd74]=20
mptspi_dv_renegotiate_work+0xd0/0xf8 [mptspi
][  731.156069]  [000000000047c1f8] process_one_work+0x23c/0x3a0
  [  731.223780]  [000000000047e4e4] worker_thread+0x1dc/0x2e8
  [  731.288363]  [0000000000481c8c] kthread+0x5c/0x70
  [  731.344617]  [000000000042aa58] kernel_thread+0x30/0x48
  [  731.407119]  [0000000000481fa0] kthreadd+0xd0/0x11c
  [  731.465455] Caller[0000000000788f38]: schedule+0x154/0x850
  [  731.531083] Caller[000000000046930c]: do_exit+0x750/0x770
  [  731.595667] Caller[000000000042774c]: die_if_kernel+0x29c/0x2c4
  [  731.666503] Caller[000000000078c5cc]: unhandled_fault+0x8c/0x98
  [  731.737340] Caller[000000000078ccdc]: do_sparc64_fault+0x704/0x7b0
  [  731.811301] Caller[00000000004079e8]:=20
sparc64_realfault_common+0x10/0x20
  [  731.891516] Caller[0000000010139f0c]: spi_dv_device+0xa4/0x628=20
[scsi_transpo
][  731.983189] Caller[000000001016d868]: mptspi_dv_device+0x98/0x118=20
[mptspi]
  [  732.065481] Caller[000000001016dd74]:=20
mptspi_dv_renegotiate_work+0xd0/0xf8 [
][  732.157154] Caller[000000000047c1f8]: process_one_work+0x23c/0x3a0
  [  732.231110] Caller[000000000047e4e4]: worker_thread+0x1dc/0x2e8
  [  732.301944] Caller[0000000000481c8c]: kthread+0x5c/0x70
  [  732.364446] Caller[000000000042aa58]: kernel_thread+0x30/0x48
  [  732.433201] Caller[0000000000481fa0]: kthreadd+0xd0/0x11c
  [  732.497783] Instruction DUMP: 01000000  c25a2270  81c3e008=20
<d0587ff8> 81c3e0
  [  732.626953] Fixing recursive fault but reboot is needed!

[  786.407117] INFO: rcu_sched_state detected stalls on CPUs/tasks: {=20
18} (dete
)[  786.518706]   CPU[  0]: TSTATE[0000009980001600]=20
TPC[000000000078b558] TNPC[
][  786.637460]              TPC[_raw_spin_trylock_bh+0x30/0xf8]=20
O7[sched_rt_per
][  786.809336] * CPU[  2]: TSTATE[0000009980001603]=20
TPC[00000000004383ac] TNPC[
][  786.928095]              TPC[touch_nmi_watchdog+0x44/0x98]=20
O7[touch_nmi_watc
][  787.084342]   CPU[ 16]: TSTATE[0000004411001602]=20
TPC[00000000004383d0] TNPC[
][  787.203103]              TPC[touch_nmi_watchdog+0x68/0x98]=20
O7[touch_nmi_watc
][  787.361435]   CPU[ 18]: TSTATE[0000009911001600]=20
TPC[000000000078b584] TNPC[
][  787.480196]              TPC[_raw_spin_trylock_bh+0x5c/0xf8]=20
O7[schedule+0xc

[  966.627023] INFO: rcu_sched_state detected stalls on CPUs/tasks: {=20
18} (dete
)[  966.738573]   CPU[  0]: TSTATE[0000009980001600]=20
TPC[000000000078b55c] TNPC[
][  966.857330]              TPC[_raw_spin_trylock_bh+0x34/0xf8]=20
O7[sched_rt_per
][  967.029211] * CPU[  2]: TSTATE[0000000080001604]=20
TPC[00000000005d05bc] TNPC[
][  967.147968]              TPC[find_next_bit+0x68/0xa8]=20
O7[find_next_bit+0x94/
][  967.297966]   CPU[ 16]: TSTATE[0000004411001602]=20
TPC[00000000004383c4] TNPC[
][  967.416726]              TPC[touch_nmi_watchdog+0x5c/0x98]=20
O7[touch_nmi_watc
][  967.575060]   CPU[ 18]: TSTATE[0000009911001600]=20
TPC[000000000078b584] TNPC[
][  967.693819]              TPC[_raw_spin_trylock_bh+0x5c/0xf8]=20
O7[schedule+0xc
[ 1146.843206] INFO: rcu_sched_state detected stalls on CPUs/tasks: {=20
18} (dete
)[ 1146.955836]   CPU[  0]: TSTATE[0000009980001600]=20
TPC[000000000078b558] TNPC[
][ 1147.074594]              TPC[_raw_spin_trylock_bh+0x30/0xf8]=20
O7[sched_rt_per
][ 1147.246476] * CPU[  2]: TSTATE[0000000080001603]=20
TPC[00000000005d05f8] TNPC[
][ 1147.365230]              TPC[find_next_bit+0xa4/0xa8]=20
O7[touch_nmi_watchdog+
][ 1147.516273]   CPU[ 16]: TSTATE[0000009911001602]=20
TPC[00000000004383a4] TNPC[
][ 1147.635032]              TPC[touch_nmi_watchdog+0x3c/0x98]=20
O7[touch_nmi_watc
][ 1147.793366]   CPU[ 18]: TSTATE[0000009911001600]=20
TPC[000000000078b584] TNPC[
][ 1147.912124]              TPC[_raw_spin_trylock_bh+0x5c/0xf8]=20
O7[schedule+0xc
]
..... cut!

I can't send BREAK in this point. Only hard reset.

Regards,
Mariusz

W dniu 2011-11-10 12:32, Nandigama, Nagalakshmi pisze:
> Can you collect debug level for INIT?
>
> Regards,
> Nagalakshmi
>
>
> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Tuesday, November 08, 2011 8:35 AM
> To: Moore, Eric
> Cc: Biblioteka UR; 647900@bugs.debian.org; linux-scsi; DL-MPT Fusion Li=
nux
> Subject: mptspi init failure on Sparc SMP in Linux 3.0
>
> Mariusz at Biblioteka UR reports this failure in a new Debian installat=
ion on a SunFire v490 system:
>
>> [    0.000000] Linux version 3.0.0-1-sparc64-smp (Debian 3.0.0-3) (ben=
@decadent.org.uk) (gcc version 4.5.3 (Debian 4.5.3-8) ) #1 SMP Sat Aug 27=
 19:51:14 UTC 20
> [...]
>> [   52.190433] Fusion MPT base driver 3.04.19
>> [   52.238528] Copyright (c) 1999-2008 LSI Corporation
> [...]
>> [   52.370161] Fusion MPT SPI Host driver 3.04.19
>> [   52.370364] mptbase: ioc0: Initiating bringup
> [...]
>> [   52.847504] ioc0: LSI53C1030 C0: Capabilities=3D{Initiator,Target}
> [...]
>> [   68.319518] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!=
!, doorbell=3D0x24000000
>> [   69.175505] mptbase: ioc0: Attempting Retry Config request type 0x3=
, page 0x, action 0
>> [   84.267524] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!=
!, doorbell=3D0x24000000
>> [   84.364482] mptbase: ioc0: Initiating recovery
>> [   90.299505] mptbase: ioc0: Attempting Retry Config request type 0x3=
, page 0x, action 0
>> [  105.391523] mptbase: ioc0: WARNING - Issuing Reset from
>> mpt_config!!, doorbell=3D0x24000000 [  105.488509] mptbase: ioc0:
>> Initiating recovery [  126.527516] mptbase: ioc0: WARNING - Issuing
>> Reset from mpt_config!!, doorbell=3D0x24000000 [  127.383505] mptbase:
>> ioc0: Attempting Retry Config request type 0x4, page 0x1, action 0 [
>> 142.475528] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!,
>> doorbell=3D0x24000000 [  142.572504] mptbase: ioc0: Initiating recover=
y
>> [  148.611505] mptbase: ioc0: Attempting Retry Config request type
>> 0x4, page 0x1, action 0 [  163.703482] mptbase: ioc0: WARNING -
>> Issuing Reset from mpt_config!!, doorbell=3D0x24000000 [  163.800495]
>> mptbase: ioc0: Initiating recovery
> (I think there are some characters missing in the above log, particular=
ly the page numbers.)
>
> However, the driver apparently works on the same system in a !SMP kerne=
l configuration.
>
> The complete report can be found at<http://bugs.debian.org/647900>.
> Can you suggest any way to correct or debug this problem?
>
> Ben.
>
> --
> Ben Hutchings
> You can't have everything.  Where would you put it?
>
