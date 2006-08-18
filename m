From: Joshua Rubin <joshua@rubixlinux.org>
Subject: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Fri, 18 Aug 2006 09:05:53 -0600
Message-ID: <200608180905.53645.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1403443.dxuAH4CN2Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 70-89-161-115-Joshua-Rubin-co.hfc.comcastbusiness.net ([70.89.161.115]:20897
	"EHLO smokescreen.cybertron.cc") by vger.kernel.org with ESMTP
	id S1030475AbWHRPGj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 11:06:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 380272@bugs.debian.org
Cc: maximilian attems <maks@sternwelten.at>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

--nextPart1403443.dxuAH4CN2Z
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Maks,

I can confirm that removing floppy from /etc/initramfs-tools/modules (which=
=20
still causes a non-bootable system) and inserting cpqarray (which is the on=
ly=20
uncommented module in /etc/initramfs-tools/modules) does in fact allow the=
=20
system to boot.

I have attached the dmesg and lsmod.

Thanks again,
Joshua Rubin

Begin dmesg:
____________________________________
Linux version 2.6.16-2-686-smp (Debian 2.6.16-17) (waldi@debian.org) (gcc=20
version 4.0.4 20060630 (prerelease) (Debian 4.0.3-4)) #1 SMP Sat Jul 15=20
22:33:00 UTC 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fffc000 (usable)
 BIOS-e820: 000000000fffc000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
255MB LOWMEM available.
found SMP MP-table at 000f4ff0
On node 0 totalpages: 65532
  DMA zone: 4096 pages, LIFO batch:0
  DMA32 zone: 0 pages, LIFO batch:0
  Normal zone: 61436 pages, LIFO batch:15
  HighMem zone: 0 pages, LIFO batch:0
DMI 2.3 present.
ACPI: RSDP (v000 COMPAQ                                ) @ 0x000f4f90
ACPI: RSDT (v001 COMPAQ MICRO    0x00000002 =D2=04 0x0000162e) @ 0x0fffc000
ACPI: FADT (v001 COMPAQ MICRO    0x00000002 =D2=04 0x0000162e) @ 0x0fffc040
ACPI: MADT (v001 COMPAQ 00000083 0x00000002  0x00000000) @ 0x0fffc100
ACPI: SSDT (v001 COMPAQ     SSDT 0x00000001 MSFT 0x0100000b) @ 0x0ffff800
ACPI: DSDT (v001 COMPAQ     DSDT 0x00000001 MSFT 0x0100000b) @ 0x00000000
ACPI: PM-Timer IO Port: 0x240
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3 6:8 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-34
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 10000000:eec00000)
Built 1 zonelists
Kernel command line: root=3D/dev/ida/c0d0p1 ro=20
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 16384 bytes)
Detected 997.113 MHz processor.
Using pmtmr for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 251936k/262128k available (1505k kernel code, 9532k reserved, 545k=
=20
data, 176k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2003.87 BogoMIPS=20
(lpj=3D4007752)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000=20
00000000 00000000 00000000
CPU: After vendor identify, caps: 0383fbff 00000000 00000000 00000000 00000=
000=20
00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000=20
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
CPU0: Intel Pentium III (Coppermine) stepping 06
Booting processor 1/0 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1993.85 BogoMIPS=20
(lpj=3D3987713)
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000=20
00000000 00000000 00000000
CPU: After vendor identify, caps: 0383fbff 00000000 00000000 00000000 00000=
000=20
00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000=20
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Coppermine) stepping 06
Total of 2 processors activated (3997.73 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D0 apic2=3D-1 pin2=3D-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=3D4000
checking if image is initramfs... it is
=46reeing initrd memory: 4287k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0094, last bus=3D3
PCI: Using configuration type 1
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:03.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:03)
PCI: Probing PCI hardware (bus 03)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Link [FAKE] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [INA0] (IRQs 5 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [INA1] (IRQs 5 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [ITR0] (IRQs 5 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [ITR1] (IRQs 5 *10 11 15)
ACPI: PCI Interrupt Link [ITR2] (IRQs 5 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [ITR3] (IRQs 5 10 11 15) *7
ACPI: PCI Interrupt Link [ITR4] (IRQs 5 10 *11 15)
ACPI: PCI Interrupt Link [INB0] (IRQs 5 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [INB1] (IRQs 5 10 11 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 10 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
PCI: Device 0000:00:00.0 not found by BIOS
PCI: Device 0000:00:00.1 not found by BIOS
PCI: Device 0000:00:0f.0 not found by BIOS
pnp: 00:01: ioport range 0xf50-0xf58 has been reserved
audit: initializing netlink socket (disabled)
audit(1155913049.052:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI No-Shortcut mode
ACPI wakeup devices:=20

ACPI: (supports S0 S4 S5)
=46reeing unused kernel memory: 176k freed
input: AT Translated Set 2 keyboard as /class/input/input0
Compaq SMART2 Driver (v 2.6.0)
cpqarray: Device 0x10 has been found at bus 0 dev 1 func 0
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 19 (level, low) -> IRQ 177
cpqarray: Finding drives on ida0 (Integrated Array)
cpqarray ida/c0d0: blksz=3D512 nr_blks=3D17756160
cpqarray: Starting firmware's background processing
 ida/c0d0: p1 p2 < p5 p6 p7 p8 p9 >
ACPI: Thermal Zone [THM0] (8 C)
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 17 (level, low) -> IRQ 185
e100: eth0: e100_probe: addr 0xc6fff000, irq 185, MAC addr 00:02:A5:8A:13:A8
ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 24 (level, low) -> IRQ 193
e100: eth1: e100_probe: addr 0xc6dff000, irq 193, MAC addr 00:02:A5:8A:13:A6
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
SvrWks OSB4: IDE controller at PCI slot 0000:00:0f.1
SvrWks OSB4: chipset revision 0
SvrWks OSB4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x2800-0x2807, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x2808-0x280f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: CD-224E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 24X CD-ROM drive, 512kB Cache
Uniform CD-ROM driver Revision: 3.20
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a National Semiconductor PC87306
input: PC Speaker as /class/input/input1
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: unable to determine aperture size.
agpgart: agp_backend_initialize() failed.
agpgart-serverworks: probe of 0000:00:00.0 failed with error -22
agpgart: unable to determine aperture size.
agpgart: agp_backend_initialize() failed.
agpgart-serverworks: probe of 0000:00:00.1 failed with error -22
piix4_smbus 0000:00:0f.0: Found 0000:00:0f.0 device
piix4_smbus 0000:00:0f.0: SMB base address uninitialized - upgrade BIOS or =
use=20
force_addr=3D0xaddr
Adding 473876k swap on /dev/ida/c0d0p7.  Priority:-1 extents:1 across:47387=
6k
EXT3 FS on ida/c0d0p1, internal journal
Probing IDE interface ide0...
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on ida/c0d0p9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on ida/c0d0p8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on ida/c0d0p5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on ida/c0d0p6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
eth0: no IPv6 routers present
____________________________________
End dmesg

Begin lsmod:
____________________________________
Module                  Size  Used by
ipv6                  229184  16=20
nfs                   193108  1=20
lockd                  54952  2 nfs
nfs_acl                 3488  1 nfs
sunrpc                136420  4 nfs,lockd,nfs_acl
dm_mod                 49204  0=20
ide_generic             1344  0 [permanent]
ide_disk               14816  0=20
i2c_piix4               8368  0=20
i2c_core               19840  1 i2c_piix4
evdev                   8992  0=20
sworks_agp              8832  0=20
psmouse                34696  0=20
agpgart                29864  1 sworks_agp
pcspkr                  3460  0=20
serio_raw               6916  0=20
floppy                 57200  0=20
ext3                  118152  5=20
jbd                    51412  1 ext3
mbcache                 8292  1 ext3
ide_cd                 35936  0=20
cdrom                  32304  1 ide_cd
serverworks             8264  0 [permanent]
generic                 4388  0 [permanent]
ide_core              113868  5=20
ide_generic,ide_disk,ide_cd,serverworks,generic
e100                   32356  0=20
mii                     5280  1 e100
thermal                13288  0=20
processor              25896  1 thermal
fan                     4676  0=20
cpqarray               20868  7=20
____________________________________
End lsmod

--nextPart1403443.dxuAH4CN2Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBE5ddRkKWMTL7MAq4RAqUpAKCR3X28I9OARiK53HMb9fhTflE9UACfUdbv
D5HTjcu+vYyeSZldHgl0lrA=
=QR6D
-----END PGP SIGNATURE-----

--nextPart1403443.dxuAH4CN2Z--
