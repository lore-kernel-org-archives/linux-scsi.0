From: Christian Roessner <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Sat, 10 Apr 2004 22:39:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404102239.22192.info@roessner-net.com>
References: <Pine.LNX.4.44.0404102112500.4100-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:37063 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S262109AbUDJUjU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 16:39:20 -0400
In-Reply-To: <Pine.LNX.4.44.0404102112500.4100-100000@poirot.grange>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi,

this is all I can send you from dmesg:

_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: Skipping IOAPIC probe due to 'noapic' option.
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: OEM00000 <6>Product ID: PROD00000000 <6>APIC at: 0xFEE00000
I/O APIC #2 Version 17 at 0xFEC00000.
Processors: 1
Checking aperture...
CPU 0: aperture @ e0000000 size 128 MB
Built 1 zonelists
Kernel command line: hdc=ide-scsi vga=0x317 video=mtrr,vesa=1024x768 
root=/dev/hdb3 acpi=force lapic splash=silent console=tty0
ide_setup: hdc=ide-scsi
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 16 (order 4: 256 bytes)
time.c: Using 1.193182 MHz PIT timer.
time.c: Detected 2009.150 MHz processor.
Console: colour dummy device 80x25
Memory: 509880k/524224k available (2505k kernel code, 13564k reserved, 1146k 
data, 148k init)
Calibrating delay loop... 3981.31 BogoMIPS
Security Scaffold v1.0.0 initialized
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount-cache hash table entries: 256 (order: 0, 4096 bytes)
checking if image is initramfs...it isn't (ungzip failed); looks like an 
initrd
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 08
POSIX conformance testing by UNIFIX
Using local APIC NMI watchdog using perfctr0
Using local APIC timer interrupts.
Detected 12.557 MHz APIC timer.
NET: Registered protocol family 16
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040326
ACPI: IRQ9 SCI: Level Trigger.
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: Power Resource [ISAV] (on)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs *16)
ACPI: PCI Interrupt Link [APC2] (IRQs *17)
ACPI: PCI Interrupt Link [APC3] (IRQs *18)
ACPI: PCI Interrupt Link [APC4] (IRQs *19)
ACPI: PCI Interrupt Link [APC5] (IRQs *16)
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22)
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22)
SCSI subsystem initialized
drivers/usb/core/usb.c: registered new driver usbfs
drivers/usb/core/usb.c: registered new driver hub
ACPI: PCI Interrupt Link [LSMB] enabled at IRQ 7
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 11
ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 11
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 11
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 9
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 11
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 11
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 9
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 7
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 7
PCI: Using ACPI for IRQ routing
PCI: if you experience problems, try using option 'pci=noacpi' or even 
'acpi=off'
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: Maximum main memory to use for agp memory: 439M
agpgart: AGP aperture is 128M @ 0xe0000000
PCI-DMA: Disabling IOMMU.
vesafb: framebuffer at 0xe8000000, mapped to 0xffffff000004e000, size 16384k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: directcolor: size=0:5:6:5, shift=0:11:5:0
fb0: VESA VGA frame buffer device
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
ikconfig 0.7 with /proc/config*
devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)
devfs: boot_options: 0x1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Initializing Cryptographic API
ACPI: Power Button (FF) [PWRF]
ACPI: Processor [CPU0] (supports C1)
mice: PS/2 mouse device common for all mice
input: PC Speaker
serio: i8042 AUX port at 0x60,0x64 irq 12
input: PS/2 Generic Mouse on isa0060/serio1
serio: i8042 KBD port at 0x60,0x64 irq 1
input: AT Translated Set 2 keyboard on isa0060/serio0
bootsplash 3.1.4-2004/02/19: looking for picture.... silentjpeg size 21830 
bytes, found (1024x768, 16923 bytes, v3).
Console: switching to colour frame buffer device 122x40
Real Time Clock Driver v1.12
Linux agpgart interface v0.100 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Using anticipatory io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3: IDE controller at PCI slot 0000:00:08.0
NFORCE3: chipset revision 165
NFORCE3: not 100% native mode: will probe irqs later
NFORCE3: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3: 0000:00:08.0 (rev a5) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
hda: Maxtor 6E040L0, ATA DISK drive
hdb: MAXTOR 6L040J2, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: JLMS XJ-HD165H, ATAPI CD/DVD-ROM drive
hdd: IOMEGA ZIP 250 ATAPI Floppy, ATAPI FLOPPY drive
hdd: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hdd: set_drive_speed_status: error=0x04
ide1: Drive 1 didn't accept speed setting. Oh, well.
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(133)
 /dev/ide/host0/bus0/target0/lun0: p1
hdb: max request size: 128KiB
hdb: 78177792 sectors (40027 MB) w/1819KiB Cache, CHS=65535/16/63, UDMA(133)
 /dev/ide/host0/bus0/target1/lun0: p1 p2 p3
ide-floppy driver 0.99.newide
hdd: No disk in drive
hdd: 244736kB, 239/64/32 CHS, 4096 kBps, 512 sector size, 2941 rpm
oprofile: using NMI interrupt.
NET: Registered protocol family 2
IP: routing cache hash table of 4096 buckets, 32Kbytes
TCP: Hash tables configured (established 32768 bind 32768)
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
ACPI: (supports S0 S1 S4 S5)
RAMDISK: Couldn't find valid RAM disk image starting at 0.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Mounted devfs on /dev
Freeing unused kernel memory: 148k freed
Adding 1028152k swap on /dev/hdb2.  Priority:-1 extents:1
EXT3 FS on hdb3, internal journal
8139too Fast Ethernet driver 0.9.27
eth0: RealTek RTL8139 at 0xffffff0001051000, 00:e0:4c:39:30:fb, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8139C'
r8169 Gigabit Ethernet driver 1.2 loaded
r8169: PCI device 0000:01:0b.0: unknown chip version, assuming RTL-8169
r8169: PCI device 0000:01:0b.0: TxConfig = 0x4000000
eth1: Identified chip type is 'RTL-8169'.
eth1: RealTek RTL8169 Gigabit Ethernet at 0xffffff0001053000, 
00:0d:61:51:4a:fe, IRQ 11
eth1: Auto-negotiation Enabled.
eth1: 100Mbps Full-duplex operation.
nvidia: module license 'NVIDIA' taints kernel.
0: nvidia: loading NVIDIA Linux x86_64 NVIDIA Kernel Module  1.0-5332  Fri Jan  
9 12:42:32 PST 2004
CSLIP: code copyright 1989 Regents of the University of California
PPP generic driver version 2.4.2
ide-scsi is deprecated for cd burning! Use ide-cd and give dev=/dev/hdX as 
device
scsi0 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: JLMS      Model: XJ-HD165H         Rev: CH0Z
  Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 5
PCI: Setting latency timer of device 0000:00:06.0 to 64
intel8x0_measure_ac97_clock: measured 49525 usecs
intel8x0: clocking to 47386
Linux video capture interface: v1.00
bttv: driver version 0.9.12 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt848 (rev 18) at 0000:01:09.0, irq: 9, latency: 32, mmio: 0xf0000000
bttv0: using: MIRO PCTV [card=1,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00ff07ff [init]
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: miro: id=1 tuner=0 radio=no stereo=no
bttv0: using tuner=0
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
tvaudio: TV audio decoder + audio/video mux driver
tvaudio: known chips: 
tda9840,tda9873h,tda9874h/a,tda9850,tda9855,tea6300,tea6420,tda8425,pic16c54 
(PV951),ta8874z
tuner: chip found at addr 0xc0 i2c-bus bt848 #0 [sw]
tuner: type set to 0 (Temic PAL (4002 FH5)) by bt848 #0 [sw]
bttv0: registered device video0
bttv0: registered device vbi0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
EXT3 FS on hdb3, internal journal
ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ohci_hcd: block sizes: ed 80 td 96
ohci_hcd 0000:00:02.0: nVidia Corporation nForce3 USB 1.1
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: irq 11, pci mem ffffff00010ee000
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ohci_hcd 0000:00:02.1: nVidia Corporation nForce3 USB 1.1 (#2)
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: irq 11, pci mem ffffff00010f0000
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ehci_hcd 0000:00:02.2: nVidia Corporation nForce3 USB 2.0
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: irq 11, pci mem ffffff00010f2000
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: USB 2.0 enabled, EHCI 1.00, driver 2003-Dec-29
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
DC390_init: No EEPROM found! Trying default settings ...
DC390: Used defaults: AdaptID=7, SpeedIdx=1 (8.0 MHz), DevMode=0x1f, 
AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
DC390: 1 adapters found
scsi1 : Tekram DC390/AM53C974 V2.0f 2000-12-20
usb 2-1: new low speed USB device using address 2
input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with 
IntelliEye(TM)] on usb-0000:00:02.1-1
drivers/usb/core/usb.c: registered new driver hid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
Disabled Privacy Extensions on device ffffffff8043f940(lo)
usb 2-2: new full speed USB device using address 3
drivers/usb/core/usb.c: registered new driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 
proto 2 vid 0x03F0 pid 0x3004
DC390: DMA Blast aborted unfinished!
  Vendor:           Model:                   Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 00
Attached scsi generic sg1 at scsi1, channel 0, id 4, lun 0,  type 0
DC390: DMA Blast aborted unfinished!
CAPI Subsystem Rev 1.1.2.7
b1: revision 1.1.2.2
b1dma: revision 1.1.2.3
b1pci: PCI BIOS reports AVM-B1 at i/o 0x9c00, irq 11
DC390: DMA Blast aborted unfinished!
DC390: RESET ... done
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 4 
lun 0
kcapi: Controller 1: b1pci-9c00 attached
b1pci: AVM B1 PCI at i/o 0x9c00, irq 11, revision 2
b1pci: revision 1.1.2.2
libata version 1.02 loaded.
sata_sil version 0.54
ata1: SATA max UDMA/100 cmd 0xFFFFFF00010F6080 ctl 0xFFFFFF00010F608A bmdma 
0xFFFFFF00010F6000 irq 9
ata2: SATA max UDMA/100 cmd 0xFFFFFF00010F60C0 ctl 0xFFFFFF00010F60CA bmdma 
0xFFFFFF00010F6008 irq 9
parport0: PC-style at 0x278 (0x678) [PCSPP,TRISTATE]
parport0: irq 5 detected
ata1: no device found (phy stat 00000000)
scsi2 : sata_sil
ata1: thread exiting
ata2: no device found (phy stat 00000000)
scsi3 : sata_sil
ata2: thread exiting
lp0: using parport0 (polling).
USB Universal Host Controller Interface driver v2.2
DC390: DMA Blast aborted unfinished!
DC390: DMA Blast aborted unfinished!
sda: Unit Not Ready, sense:
: sense =  0  0
Non-extended sense class 0 code 0x0
Raw sense data:0x00 0x00 0x00 0x00
DC390: DMA Blast aborted unfinished!
DC390: DMA Blast aborted unfinished!
ip_tables: (C) 2000-2002 Netfilter core team
DC390: DMA Blast aborted unfinished!
ip_conntrack version 2.1 (2047 buckets, 16376 max) - 432 bytes per conntrack
DC390: DMA Blast aborted unfinished!
DC390: DMA Blast aborted unfinished!
DC390: DMA Blast aborted unfinished!
sda : READ CAPACITY failed.
sda : status=1, message=00, host=0, driver=08
sd: sense =  0  0
Non-extended sense class 0 code 0x0
Raw sense data:0x00 0x00 0x00 0x00
DC390: DMA Blast aborted unfinished!
sda: asking for cache data failed
sda: assuming drive cache: write through
Attached scsi disk sda at scsi1, channel 0, id 4, lun 0
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
eth1: no IPv6 routers present
bootsplash 3.1.4-2004/02/19: looking for picture.... found (1024x768, 16923 
bytes, v3).
bootsplash: status on console 0 changed to on
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:02:00.0 into 8x mode
eth0: no IPv6 routers present

And: I have 500Mb RAM

Regards

Christian
