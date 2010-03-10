From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid
 modulkjournald starting
Date: Wed, 10 Mar 2010 19:27:37 GMT
Message-ID: <201003101927.o2AJRb5Q017433@demeter.kernel.org>
References: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41506 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0CJT1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2010 14:27:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2AJRb6O017434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2010 19:27:37 GMT
In-Reply-To: <bug-15503-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D15503





--- Comment #1 from Will L Givens <wlgivens@gmail.com>  2010-03-10 19:2=
7:32 ---
After recompiling and rolling the dodgy drivers into the kernel... I ha=
ve a NEW
error *hmmm*

1:1/linux-2.6/vmlinuz-2.6.33-git15 initrd=3D/initrd-2.6.17-1.2187_FC5.6=
axp.img
root=3D/dev/VolGroup00/LogVol00 selinux=3Doff console=3DttyS0
aboot> 1
aboot: loading uncompressed linux-2.6/vmlinuz-2.6.33-git15...
aboot: loading compressed linux-2.6/vmlinuz-2.6.33-git15...
aboot: zero-filling 145528 bytes at 0xfffffc0000994968
aboot: loading initrd (2350556 bytes/2295 blocks) at 0xfffffc007fb48000
aboot: starting kernel linux-2.6/vmlinuz-2.6.33-git15 with arguments=20
root=3D/dev/VolGroup00/LogVol00 selinux=3Doff console=3DttyS0 Linux ver=
sion
2.6.33-git15 (root@jericho.southkc.net) (gcc version 3.4.3) #1 Wed Mar =
10
02:03:05 CST 2010 Booting on Nautilus using machine vector Nautilus fro=
m SRM
Major Options: EV67 LEGACY_START Command line:  root=3D/dev/VolGroup00/=
LogVol00
selinux=3Doff console=3DttyS0
memcluster 0, usage 1, start        0, end      256
memcluster 1, usage 0, start      256, end   130994
memcluster 2, usage 1, start   130994, end   131072
memcluster 3, usage 0, start   131072, end   262142
memcluster 4, usage 1, start   262142, end   262144
freeing pages 256:384
freeing pages 1247:130994
freeing pages 131072:262142
reserving pages 1247:1251
Initial ramdisk at: 0xfffffc007fb48000 (2350556 bytes) 8192K Bcache det=
ected;
load hit latency 18 cycles, load miss latency 161 cycles Iron stat_cmd =
22100006
Iron ECC f00 Built 1 zonelists in Zone order, mobility grouping on.  To=
tal
pages: 260350 Kernel command line:  root=3D/dev/VolGroup00/LogVol00 sel=
inux=3Doff
console=3DttyS0 PID hash table entries: 4096 (order: 2, 32768 bytes) De=
ntry cache
hash table entries: 262144 (order: 8, 2097152 bytes) Inode-cache hash t=
able
entries: 131072 (order: 7, 1048576 bytes)
Memory: 2067112k/2097136k available (4644k kernel code, 26664k reserved=
, 354k
data, 216k init) Hierarchical RCU implementation.
NR_IRQS:16
HWRPB cycle frequency bogus.  Estimated 796433400 Hz Using epoch =3D 19=
52
Console: colour VGA+ 80x25
console [ttyS0] enabled
Calibrating delay loop... 1582.24 BogoMIPS (lpj=3D772096) Security Fram=
ework
initialized Mount-cache hash table entries: 512
devtmpfs: initialized
xor: automatically using best checksumming function: alpha prefetch
   alpha prefetch:  5210.112 MB/sec
xor: using function: alpha prefetch (5210.112 MB/sec)
NET: Registered protocol family 16
pci 0000:00:11.0: quirk: [io  0x4000-0x403f] claimed by ali7101 ACPI pc=
i
0000:00:11.0: quirk: [io  0x5000-0x501f] claimed by ali7101 SMB pci
0000:00:01.0: BAR 15: assigned [mem 0xe8000000-0xffffffff pref] pci
0000:00:01.0: BAR 14: assigned [mem 0xe4000000-0xe5ffffff] pci 0000:00:=
0b.0:
BAR 6: assigned [mem 0xe6000000-0xe603ffff pref] pci 0000:00:09.0: BAR =
6:
assigned [mem 0xe6040000-0xe605ffff pref] pci 0000:00:03.0: BAR 0: assi=
gned
[mem 0xe6060000-0xe6060fff] pci 0000:00:03.0: BAR 0: set to [mem
0xe6060000-0xe6060fff] (PCI address [0xe6060000-0xe6060fff] pci 0000:00=
:06.0:
BAR 1: assigned [mem 0xe6061000-0xe6061fff] pci 0000:00:06.0: BAR 1: se=
t to
[mem 0xe6061000-0xe6061fff] (PCI address [0xe6061000-0xe6061fff] pci
0000:00:09.0: BAR 1: assigned [mem 0xe6062000-0xe6062fff 64bit] pci
0000:00:09.0: BAR 1: set to [mem 0xe6062000-0xe6062fff 64bit] (PCI addr=
ess
[0xe6062000-0xe6062fff] pci 0000:00:14.0: BAR 0: assigned [mem
0xe6063000-0xe6063fff] pci 0000:00:14.0: BAR 0: set to [mem
0xe6063000-0xe6063fff] (PCI address [0xe6063000-0xe6063fff] pci 0000:00=
:0b.0:
BAR 1: assigned [mem 0xe6064000-0xe60643ff] pci 0000:00:0b.0: BAR 1: se=
t to
[mem 0xe6064000-0xe60643ff] (PCI address [0xe6064000-0xe60643ff] pci
0000:00:03.0: BAR 1: assigned [io  0x8000-0x80ff] pci 0000:00:03.0: BAR=
 1: set
to [io  0x8000-0x80ff] (PCI address [0x8000-0x80ff] pci 0000:00:06.0: B=
AR 0:
assigned [io  0x8400-0x84ff] pci 0000:00:06.0: BAR 0: set to [io=20
0x8400-0x84ff] (PCI address [0x8400-0x84ff] pci 0000:00:09.0: BAR 0: as=
signed
[io  0x8800-0x88ff] pci 0000:00:09.0: BAR 0: set to [io  0x8800-0x88ff]=
 (PCI
address [0x8800-0x88ff] pci 0000:00:0b.0: BAR 0: assigned [io  0x8c00-0=
x8c7f]
pci 0000:00:0b.0: BAR 0: set to [io  0x8c00-0x8c7f] (PCI address
[0x8c00-0x8c7f] pci 0000:00:10.0: BAR 4: assigned [io  0x8c80-0x8c8f] p=
ci
0000:00:10.0: BAR 4: set to [io  0x8c80-0x8c8f] (PCI address [0x8c80-0x=
8c8f]
pci 0000:01:05.0: BAR 1: assigned [mem 0xf0000000-0xffffffff pref] pci
0000:01:05.0: BAR 1: set to [mem 0xf0000000-0xffffffff pref] (PCI addre=
ss
[0xf0000000-0xffffffff] pci 0000:01:05.0: BAR 0: assigned [mem
0xe4000000-0xe4ffffff] pci 0000:01:05.0: BAR 0: set to [mem
0xe4000000-0xe4ffffff] (PCI address [0xe4000000-0xe4ffffff] pci 0000:01=
:05.0:
BAR 2: assigned [mem 0xe5000000-0xe5ffffff] pci 0000:01:05.0: BAR 2: se=
t to
[mem 0xe5000000-0xe5ffffff] (PCI address [0xe5000000-0xe5ffffff] pci
0000:01:05.0: BAR 6: assigned [mem 0xe8000000-0xe801ffff pref] pci
0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xe4000000-0xe5ffffff]
pci 0000:00:01.0:   bridge window [mem 0xe8000000-0xffffffff pref]
bio: create slab <bio-0> at 0
vgaarb: device added: PCI:0000:01:05.0,decodes=3Dio+mem,owns=3Dio+mem,l=
ocks=3Dnone
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int64x1    828 MB/s
raid6: int64x2   1084 MB/s
raid6: int64x4   1096 MB/s
raid6: int64x8    680 MB/s
raid6: using algorithm int64x4 (1096 MB/s) Switching to clocksource jif=
fies
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 524288 bytes) TCP
established hash table entries: 262144 (order: 9, 4194304 bytes) TCP bi=
nd hash
table entries: 65536 (order: 6, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536) TCP reno re=
gistered
UDP hash table entries: 1024 (order: 2, 32768 bytes) UDP-Lite hash tabl=
e
entries: 1024 (order: 2, 32768 bytes)
NET: Registered protocol family 1
pci 0000:00:07.0: Activating ISA DMA hang workarounds Trying to unpack =
rootfs
image as initramfs...
=46reeing initrd memory: 2295k freed
srm_env: version 0.0.6 loaded successfully
audit: initializing netlink socket (disabled) type=3D2000
audit(1268246795.169:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 8192 bytes) msgmni has b=
een set
to 4043
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253) io
scheduler noop registered io scheduler deadline registered io scheduler=
 cfq
registered (default)
pci-stub: invalid id string ""
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
=C3=BFserial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
brd: module loaded
nbd: registered device at major 43
Uniform Multi-Platform E-IDE driver
alim15x3 0000:00:10.0: IDE controller (0x10b9:0x5229 rev 0xc4)
alim15x3 0000:00:10.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x8c80-0x8c87
    ide1: BM-DMA at 0x8c88-0x8c8f
ide0: not ready before the probe
ide1: no devices on the port
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=3D0x3f" module parameter for probin=
g all
legacy ISA IDE ports ide-gd driver 1.18 ide-cd driver 5.00 Unable to ha=
ndle
kernel paging request at virtual address 036b036903670360
swapper(1): Oops -1
pc =3D [<036b036903670360>]  ra =3D [<fffffc00005cc35c>]  ps =3D 0000  =
  Not tainted
v0 =3D 0000000000000001  t0 =3D 0000000000000001  t1 =3D 00000000000003=
ff
t2 =3D 0000000000000000  t3 =3D 0000000000000000  t4 =3D fffffc007f047a=
40
t5 =3D fffffc00007c7428  t6 =3D 000000000000000f  t7 =3D fffffc007f0440=
00 s0 =3D
fffffc00007c7448  s1 =3D 000000000000036b  s2 =3D 000000000000036b
s3 =3D fffffc007f047a18  s4 =3D fffffc007f047a48  s5 =3D fffffc007e5260=
00
s6 =3D fffffc00007c80e8
a0 =3D fffffc007e526000  a1 =3D fffffc007f047a48  a2 =3D 00000000000003=
6b
a3 =3D fffffc007f047a18  a4 =3D fffffc007f047b68  a5 =3D 00000000001001=
00
t8 =3D fffffc007f004540  t9 =3D 0000000000000013  t10=3D fffffc007e4f76=
f0 t11=3D
fffffc007f004550  pv =3D 036b036903670361  at =3D 0000000000200200 gp =3D
fffffc000098ead0  sp =3D fffffc007f0478e8 Disabling lock debugging due =
to kernel
taint
Trace:
[<fffffc00005cd0a0>]
[<fffffc00005cc6dc>]
[<fffffc00005d705c>]
[<fffffc00005cd3ac>]
[<fffffc00005cbbe0>]
[<fffffc00005d6bd8>]
[<fffffc00005d6bc0>]
[<fffffc00005dc168>]
[<fffffc000050e9b8>]
[<fffffc00004f4d2c>]
[<fffffc00005748b0>]
[<fffffc000050ec78>]
[<fffffc000050eda0>]
[<fffffc000057906c>]
[<fffffc00005792f8>]
[<fffffc0000577694>]
[<fffffc0000579270>]
[<fffffc0000579370>]
[<fffffc00005781c0>]
[<fffffc0000579b8c>]
[<fffffc0000579b50>]
[<fffffc000050ea60>]
[<fffffc00005dc464>]
[<fffffc00003100cc>]
[<fffffc0000310fe8>]

Code:
Kernel panic - not syncing: Attempted to kill init!

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
