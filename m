From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] New: insmod: error inserting '/lib/aic7xxx.ko': -1
 Invalid modulkjournald starting
Date: Wed, 10 Mar 2010 05:58:04 GMT
Message-ID: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53141 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0CJF6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2010 00:58:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2A5w40X022085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2010 05:58:04 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D15503

           Summary: insmod: error inserting '/lib/aic7xxx.ko': -1 Inval=
id
                    modulkjournald starting
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: linux-2.6.33-git15
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: wlgivens@gmail.com
        Regression: No


Compiling and installing kernel... error below is what I received on re=
start:

[root@jericho ~]# cat /etc/aboot.conf
# aboot default configurations
# NOTICE: You have a /boot partition. This means that
#         all kernel paths are relative to /boot/
0:1/vmlinuz-2.6.17-1.2187_FC5.6axp initrd=3D/initrd-2.6.17-1.2187_FC5.6=
axp.img
root=3D/dev/VolGroup00/LogVol00 selinux=3Doff console=3DttyS0
1:1/linux-2.6/vmlinuz-2.6.33-git15 initrd=3D/initrd-2.6.17-1.2187_FC5.6=
axp.img
root=3D/dev/VolGroup00/LogVol00 selinux=3Doff console=3DttyS0

Configured with: ../gcc-4.4.2/configure --build=3Dalpha-alpha-linux
--host=3Dalpha-alpha-linux --prefix=3D/usr --mandir=3D/usr/share/man
--infodir=3D/usr/share/info --enable-shared --enable-threads=3Dposix
--enable-checking=3Drelease --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-libgcj-multifile
--enable-languages=3Dc,c++,objc,obj-c++,java,fortran --disable-dssi
--with-java-home=3D/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre --with-long-=
double-128
Thread model: posix
gcc version 4.4.2 (GCC)


[root@jericho ~]# cat /proc/cpuinfo
cpu                     : Alpha
cpu model               : EV68AL
cpu variation           : 7
cpu revision            : 0
cpu serial number       :
system type             : Nautilus
system variation        : 0
system revision         : 0
system serial number    :
cycle frequency [Hz]    : 796418537 est.
timer frequency [Hz]    : 1024.00
page size [bytes]       : 8192
phys. address bits      : 44
max. addr. space #      : 255
BogoMIPS                : 1586.36
kernel unaligned acc    : 0 (pc=3D0,va=3D0)
user unaligned acc      : 0 (pc=3D0,va=3D0)
platform string         : UP1500 796 MHz
cpus detected           : 1
L1 Icache               : 64K, 2-way, 64b line
L1 Dcache               : 64K, 2-way, 64b line
L2 cache                : 8192K, 1-way, 64b line
L3 cache                : n/a


0000-0xe5ffffff]
pci 0000:01:05.0: BAR 6: assigned [mem 0xe8000000-0xe801ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
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
raid6: int64x1    852 MB/s
raid6: int64x2   1084 MB/s
raid6: int64x4   1100 MB/s
raid6: int64x8    640 MB/s
raid6: using algorithm int64x4 (1100 MB/s)
Switching to clocksource jiffies
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 524288 bytes)
TCP established hash table entries: 262144 (order: 9, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 6, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 2, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 2, 32768 bytes)
NET: Registered protocol family 1
pci 0000:00:07.0: Activating ISA DMA hang workarounds
Trying to unpack rootfs image as initramfs...
=46reeing initrd memory: 2295k freed
srm_env: version 0.0.6 loaded successfully
audit: initializing netlink socket (disabled)
type=3D2000 audit(1268198602.219:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
msgmni has been set to 4043
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
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
legacy ISA IDE ports
ide-gd driver 1.18
ide-cd driver 5.00
(scsi0) <Adaptec AIC-7892 Ultra 160/m SCSI host adapter> found at PCI 0=
/9/0
(scsi0) Wide Channel, SCSI ID=3D7, 32/255 SCBs
(scsi0) Downloading sequencer code... 396 instructions downloaded
scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
       <Adaptec AIC-7892 Ultra 160/m SCSI host adapter>
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
0000:00:0b.0: DE500-BA at 0x8c00, h/w address 00:00:f0:51:19:de
      and requires IRQ11 (provided by PCI BIOS).
de4x5.c:V0.546 2001/02/22 davies@maniac.ultranet.com
usbmon: debugfs is not available
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cm109: Keymap for Komunikate KIP1000 phone loaded
atkbd.c: keyboard reset failed on isa0060/serio0
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised:
dm-devel@redhat.com
atkbd.c: keyboard reset failed on isa0060/serio1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP bic registered
TCP cubic registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
register_blkdev: cannot get major 3 for hd
scsi: waiting for bus probes to complete ...
scsi 0:0:1:0: Direct-Access     ModusLnk                       PQ: 0 AN=
SI: 3
sd 0:0:1:0: Attached scsi generic sg0 type 0
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
(scsi0:0:1:0) Synchronous at 160.0 Mbyte/sec, offset 127.
sd 0:0:1:0: [sda] 143638992 512-byte logical blocks: (73.5 GB/68.4 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't su=
pport
DPO or FUA
 sda: sda1 sda2
sd 0:0:1:0: [sda] Attached SCSI disk
=46reeing unused kernel memory: 216k freed
Red Hat nash version 5.0.32 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Loading scsi_modscsi_mod: no symbol version for module_layout
=2Eko module
sd_mod: no symbol version for module_layout
insmod: error inscsi_transport_spi: no symbol version for module_layout
serting '/lib/scaic7xxx: no symbol version for module_layout
si_mod.ko': -1 Ijbd: no symbol version for module_layout
nvalid module foext3: no symbol version for module_layout
rmat
Loading sddm_mod: no symbol version for module_layout
_mod.ko module
dm_mirror: no symbol version for module_layout
insmod: error indm_zero: no symbol version for module_layout
serting '/lib/sddm_snapshot: no symbol version for module_layout
_mod.ko': -1 Invalid module format
Loading scsi_transport_spi.ko module
insmod: error inserting '/lib/scsi_transport_spi.ko': -1 Invalid module=
 format
Loading aic7xxx.ko module
insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid modulkjournald st=
arting.=20
Commit interval 5 seconds
e format
mounted filesystem with writeback data mode
                                           insmod: error i
nserting '/lib/jbd.ko': -1 Invalid module format
Loading ext3.kUnable to handle kernel paging request at virtual address
0000000000000000
o module
insmodinit(1): Oops 0
: error insertinpc =3D [<fffffc00003cfd08>]  ra =3D [<fffffc00003cbc84>=
]  ps =3D 0000
   Not tainted
g '/lib/ext3.ko'v0 =3D 0000000000000007  t0 =3D 0000000000000001  t1 =3D
fffffc007f0e91e8
: -1 Invalid modt2 =3D 0000000000000001  t3 =3D 0000000000000000  t4 =3D
0000000000000000
ule format
Loadt5 =3D 0000000000000001  t6 =3D 0000000000000002  t7 =3D fffffc007f=
044000
ing dm-mod.ko mos0 =3D fffffc007f0e91c8  s1 =3D fffffc007f0e9180  s2 =3D
0000000000000001
dule
insmod: ers3 =3D fffffc007f0e9180  s4 =3D fffffc007f0e9180  s5 =3D 0000=
00000000000c
ror inserting '/s6 =3D 0000000000000002
lib/dm-mod.ko': a0 =3D 0000000000000000  a1 =3D 0000000000000000  a2 =3D
0000000000000001
-1 Invalid modula3 =3D 0000000000000000  a4 =3D 0000000000000000  a5 =3D
0000000000000400
e format
Loadint8 =3D 0000000000000001  t9 =3D 0000000000000001  t10=3D fffffc00=
7e84c030
g dm-mirror.ko mt11=3D fffffc007e443c50  pv =3D fffffc00003cfcac  at =3D
0000000000200200
odule
insmod: egp =3D fffffc0000982fa0  sp =3D fffffc007f0477f8
rror inserting 'Disabling lock debugging due to kernel taint
/lib/dm-mirror.kTrace:
o': -1 Invalid m[<fffffc00003cbc84>]odule format
Lo
ading dm-zero.ko[<fffffc000067e6ec>] module
insmod:
 error inserting[<fffffc000067f268>] '/lib/dm-zero.k
o': -1 Invalid m[<fffffc000067f650>]odule format
Lo
ading dm-snapsho[<fffffc0000360000>]t.ko module
ins
mod: error inser[<fffffc000067f374>]ting '/lib/dm-sn
apshot.ko': -1 I[<fffffc000067f474>]nvalid module fo
rmat
Making dev[<fffffc00004e1e04>]ice-mapper contr
ol node
Scannin[<fffffc00004e1fdc>]g logical volume
s
  Reading all[<fffffc00003cfe8c>] physical volume
s.  This may tak[<fffffc00003d03c8>]e a while...

=46ound volume gro[<fffffc00003d0628>]up "VolGroup00"
using metadata t[<fffffc000044da80>]ype lvm2
Activa
ting logical vol[<fffffc00004f6eec>]umes
  2 logica
l volume(s) in v[<fffffc000036b2e8>]olume group "Vol
Group00" now act[<fffffc000044da80>]ive
Creating ro
ot device.
Moun[<fffffc000044b350>]ting root filesy
stem.
Setting u[<fffffc000045d008>]p other filesyst
ems.
Setting up[<fffffc0000374958>] new root fs
no
 fstab.sys, moun[<fffffc0000374b8c>]ting internal de
faults
Switchin[<fffffc000036c604>]g to new root an
[<fffffc000039caf4>]
                    unmounting old
/dev
unmounting[<fffffc000039cc00>] old /proc
unmo
[<fffffc000039c9bc>]

[<fffffc000039cbd8>]
[<fffffc00003a292c>]
[<fffffc00003a3a64>]
[<fffffc0000312be0>]
[<fffffc0000310c14>]

Code: 2129fff0  412103a1  f4200002  a4290000  8be10000  e5600005 <a8300=
000>
44211401
Kernel panic - not syncing: Attempted to kill init!

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
