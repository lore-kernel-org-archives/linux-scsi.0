From: =?iso-8859-1?q?Jos=E9_Luis_S=E1nchez?=
	<jsanchez@todounix.homeip.net>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Wed, 23 Nov 2005 16:56:22 +0100
Message-ID: <200511231656.23288.jsanchez@todounix.homeip.net>
References: <20051123134327.GS1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nEJhDhEYO8FjRQF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-202-88-178.user.ono.com ([81.202.88.178]:30445 "EHLO
	mafalda.lcv") by vger.kernel.org with ESMTP id S1750837AbVKWP40
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 10:56:26 -0500
In-Reply-To: <20051123134327.GS1598@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

--Boundary-00=_nEJhDhEYO8FjRQF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Matthew,

El Mi=E9rcoles, 23 de Noviembre de 2005 14:43, Matthew Wilcox escribi=F3:
> Hi Jose, I was forwarded your bug report below.  It doesn't have quite
> enough information in it for me to diagnose, but I have some suggestions
> anyway ...
>
> 1. Can you send me your dmesg?  I want to see what devices these are and
>    what transfer agreement they negotiate.

Attached to this e-mail, is dmesg. For your information, my distribution is=
 a=20
Slackware 10.2 without tweaks.

> 2. Can you try a later kernel?  If you have git, you can pull from
>    git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git
>    otherwise http://www.parisc-linux.org/~willy/sym2-2.2.2.diff applies
>    to a 2.6.15-rc1 kernel.

Yes, I try it later, but with patience, why a P-III 500 Mhz isn't a fast=20
machine to compile the linux kernel 2.6.

> 3. Can you try an earlier kernel?  It'd be interesting to know if, say,
>    2.6.8 worked.

Same as the point 2. :)

> 4. Can you try the sym2 driver in 2.4.32?  You'll have to say Y to
>    "SYM53C8XX Version 2 SCSI support".

I'm sorry, but that's my fault. The driver used is SYM53C88XX_2, not the=20
ncr53C8xx. In 2.6 kernel isn't possible to select the NCR driver from 'make=
=20
menuconfig'.

But with the kernel 2.4 I haven't any problem with this card, what works=20
perfectly with WinXP (ouch!) and Solaris 10 x86.

If I can help to you, don't hesitate to ask me. :)

Best regards

--Boundary-00=_nEJhDhEYO8FjRQF
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.15-rc2 (root@mafalda) (gcc versi=F3n 3.3.6) #3 PREEMPT Mo=
n Nov 21 16:36:18 CET 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
 BIOS-e820: 000000003fffd000 - 000000003ffff000 (ACPI data)
 BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
On node 0 totalpages: 262141
  DMA zone: 4096 pages, LIFO batch:2
  DMA32 zone: 0 pages, LIFO batch:2
  Normal zone: 225280 pages, LIFO batch:64
  HighMem zone: 32765 pages, LIFO batch:16
DMI 2.0 present.
Allocating PCI resources starting at 50000000 (gap: 40000000:bfff0000)
Built 1 zonelists
Kernel command line: BOOT_IMAGE=3DLinux-2.6.15 ro root=3D307 lapic
Local APIC disabled by BIOS -- reenabling.
=46ound and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 501.211 MHz processor.
Using tsc for high-res timesource
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1035392k/1048564k available (2261k kernel code, 12328k reserved, 63=
7k data, 208k init, 131060k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1003.74 BogoMIPS (lpj=3D20=
07489)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 0000=
0000 00000000 00000000
CPU: After vendor identify, caps: 0383fbff 00000000 00000000 00000000 00000=
000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00=
000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
mtrr: v2.0 (20020519)
CPU: Intel Pentium III (Katmai) stepping 03
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf0720, last bus=3D1
PCI: Using configuration type 1
usbcore: registered new driver usbfs
usbcore: registered new driver hub
Linux Plug and Play Support v0.97 (c) Adam Belay
Generic PHY: Registered new driver
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region e400-e43f claimed by PIIX4 ACPI
PCI quirk: region e800-e80f claimed by PIIX4 SMB
PIIX4 devres B PIO at 0290-0297
Boot video device is 0000:01:00.0
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:04.0
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: c6000000-c7dfffff
  PREFETCH window: c7f00000-cfffffff
apm: BIOS version 1.2 Flags 0x0b (Driver version 1.16ac)
highmem bounce pool size: 64 pages
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Limiting direct PCI/PCI transfers.
USB Universal Host Controller Interface driver v2.3
PCI: Found IRQ 5 for device 0000:00:04.2
PCI: Sharing IRQ 5 with 0000:00:0d.0
PCI: Setting latency timer of device 0000:00:04.2 to 64
uhci_hcd 0000:00:04.2: UHCI Host Controller
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.2: irq 5, io base 0x0000d400
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb 1-2: new low speed USB device using uhci_hcd and address 2
usbcore: registered new driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input0
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00=
:04.2-2
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
vesafb: framebuffer at 0xc8000000, mapped to 0xf8800000, using 1536k, total=
 131072k
vesafb: mode is 1024x768x8, linelength=3D1024, pages=3D3
vesafb: protected mode interface info at c000:ea60
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=3D8:8:8:8, shift=3D0:0:0:0
vesafb: Mode is VGA compatible
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
PCI: Found IRQ 10 for device 0000:00:0b.0
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0b.0: 3Com PCI 3c905B Cyclone 100baseTx at f8982000. Vers LK1.1.19
PCI: Setting latency timer of device 0000:00:0b.0 to 64
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
PIIX4: IDE controller at PCI slot 0000:00:04.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xd808-0xd80f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: ST320414A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: ST320414A, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 39102336 sectors (20020 MB) w/2048KiB Cache, CHS=3D38792/16/63, UDMA(3=
3)
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 >
hdc: max request size: 128KiB
hdc: 39102336 sectors (20020 MB) w/2048KiB Cache, CHS=3D38792/16/63, UDMA(3=
3)
hdc: cache flushes not supported
 hdc: hdc1
PCI: Found IRQ 12 for device 0000:00:0a.0
PCI: Setting latency timer of device 0000:00:0a.0 to 64
sym0: <875> rev 0x26 at pci 0000:00:0a.0 irq 12
sym0: Tekram NVRAM, ID 7, Fast-20, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.1
  Vendor: SEAGATE   Model: ST39140W          Rev: 1487
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target0:0:0: tagged command queuing enabled, command queue depth 16.
 target0:0:0: Beginning Domain Validation
 target0:0:0: asynchronous.
 target0:0:0: wide asynchronous.
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
 target0:0:0: Ending Domain Validation
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1401  Rev: 1009
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target0:0:1: Beginning Domain Validation
 target0:0:1: asynchronous.
 target0:0:1: Domain Validation skipping write tests
 target0:0:1: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target0:0:1: Ending Domain Validation
  Vendor: YAMAHA    Model: CRW8424S          Rev: 1.0j
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target0:0:2: Beginning Domain Validation
 target0:0:2: asynchronous.
 target0:0:2: Domain Validation skipping write tests
 target0:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
 target0:0:2: Ending Domain Validation
  Vendor: HP        Model: C5683A            Rev: C005
  Type:   Sequential-Access                  ANSI SCSI revision: 02
 target0:0:5: Beginning Domain Validation
 target0:0:5: asynchronous.
 target0:0:5: Domain Validation skipping write tests
 target0:0:5: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target0:0:5: Ending Domain Validation
SCSI device sda: 17783240 512-byte hdwr sectors (9105 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 17783240 512-byte hdwr sectors (9105 MB)
SCSI device sda: drive cache: write back
 sda: sda1
sd 0:0:0:0: Attached scsi disk sda
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
=46reeing unused kernel memory: 208k freed
kjournald starting.  Commit interval 5 seconds
input: AT Translated Set 2 keyboard as /class/input/input1
Adding 530104k swap on /dev/hda6.  Priority:42 extents:1 across:530104k
EXT3 FS on hda7, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XFS mounting filesystem hda3
Ending clean XFS mount for filesystem: hda3
XFS mounting filesystem hda8
Ending clean XFS mount for filesystem: hda8
PCI: Found IRQ 10 for device 0000:00:0b.0
nvidia: module license 'NVIDIA' taints kernel.
NVRM: loading NVIDIA Linux x86 NVIDIA Kernel Module  1.0-7676  Fri Jul 29 1=
2:58:54 PDT 2005
PCI: Found IRQ 5 for device 0000:00:0d.0
PCI: Sharing IRQ 5 with 0000:00:04.2
PCI: Setting latency timer of device 0000:00:0d.0 to 64
sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 24x/16x writer cd/rw xa/form2 cdda tray
sr 0:0:2:0: Attached scsi CD-ROM sr1
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 0:0:1:0: Attached scsi generic sg1 type 5
sr 0:0:2:0: Attached scsi generic sg2 type 5
 0:0:5:0: Attached scsi generic sg3 type 1
st: Version 20050830, fixed bufsize 32768, s/g segs 256
st 0:0:5:0: Attached scsi tape st0<4>st0: try direct i/o: yes (alignment 51=
2 B), max page reachable by HBA 1048575

--Boundary-00=_nEJhDhEYO8FjRQF--
