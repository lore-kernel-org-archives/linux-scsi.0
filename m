From: "Nicholas" <kdev437@nawan.hostinguk.com>
Subject: Linux version 2.6.6 // libata 1.02 // sata_promise version 0.92 // problem with Promise FastTrack S150 SX4
Date: Mon, 17 May 2004 19:42:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAA6/QqhRnc20Gp8M2IBiikcMKAAAAQAAAAoC6hppJpiEatjNFHGy82SgEAAAAA@nawan.hostinguk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.hostinguk.net ([195.224.49.102]:18961 "EHLO
	nawan.hostinguk.com") by vger.kernel.org with ESMTP id S261920AbUEQRnP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 May 2004 13:43:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
 I have compiled SCSI and libata support directly into a 2.6.6 kernel, in
order to try and get the Linux kernel to recognise a two drive RAID0 array
attached to a FastTrack S150 SX4. Unfortunately the drives are seen as two
seperate drives, and the single RAID 0 array appears not to be detected. I
am assuming this is not normal. The RAID0 array works fine under W2k. I have
added below the contents of /var/log/dmesg so you can see the nature of the
problem. There are also PATA ide drives, on the system functioning as
ordinary disks, so no problems there. 
 
Thanks
Nicholas
 
Linux version 2.6.6 (root@localhost.localdomain) (gcc version 3.3.2 20031022
(Red Hat Linux 3.3.2-1)) #4 Sat May 15 19:46:58 CEST 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000098c00 (usable)
 BIOS-e820: 0000000000098c00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffc000 (usable)
 BIOS-e820: 000000003fffc000 - 000000003ffff000 (ACPI data)
 BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
On node 0 totalpages: 262140
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 32764 pages, LIFO batch:7
DMI 2.3 present.
ACPI: RSDP (v000 ASUS                                      ) @ 0x000f6a10
ACPI: RSDT (v001 ASUS   CUV4X_C  0x30303031 MSFT 0x31313031) @ 0x3fffc000
ACPI: FADT (v001 ASUS   CUV4X_C  0x30303031 MSFT 0x31313031) @ 0x3fffc080
ACPI: BOOT (v001 ASUS   CUV4X_C  0x30303031 MSFT 0x31313031) @ 0x3fffc040
ACPI: DSDT (v001   ASUS CUV4X_C  0x00001000 MSFT 0x0100000b) @ 0x00000000
Built 1 zonelists
Kernel command line: BOOT_IMAGE=linux auto
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 803.854 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Memory: 1036468k/1048560k available (1655k kernel code, 11164k reserved,
708k data, 236k init, 131056k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay loop... 1576.96 BogoMIPS
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU:     After generic identify, caps: 0383f9ff 00000000 00000000 00000000
CPU:     After vendor identify, caps: 0383f9ff 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU:     After all inits, caps: 0383f9ff 00000000 00000000 00000040
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium III (Coppermine) stepping 06
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xf0d10, last bus=1
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040326
ACPI: IRQ9 SCI: Level Trigger.
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 9
PCI: Using ACPI for IRQ routing
Simple Boot Flag at 0x3a set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
divert: not allocating divert_blk for non-ethernet device lo
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:04.1
VP_IDE: chipset revision 16
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on pci0000:00:04.1
    ide0: BM-DMA at 0xb800-0xb807, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xb808-0xb80f, BIOS settings: hdc:DMA, hdd:pio
hda: IBM-DTLA-307030, ATA DISK drive
hdb: MAXTOR 6L060J3, ATA DISK drive
Using anticipatory io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: PLEXTOR DVDR PX-708A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 60036480 sectors (30738 MB) w/1916KiB Cache, CHS=59560/16/63, UDMA(66)
 hda: hda1 hda2 < hda5 >
hdb: max request size: 128KiB
hdb: 117266688 sectors (60040 MB) w/1819KiB Cache, CHS=65535/16/63, UDMA(66)
 hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 >
ide-floppy driver 0.99.newide
libata version 1.02 loaded.
sata_promise version 0.92
ata1: SATA max UDMA/133 cmd 0xF88D7200 ctl 0xF88D7238 bmdma 0x0 irq 5
ata2: SATA max UDMA/133 cmd 0xF88D7280 ctl 0xF88D72B8 bmdma 0x0 irq 5
ata3: SATA max UDMA/133 cmd 0xF88D7300 ctl 0xF88D7338 bmdma 0x0 irq 5
ata4: SATA max UDMA/133 cmd 0xF88D7380 ctl 0xF88D73B8 bmdma 0x0 irq 5
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003
88:207f
ata1: dev 0 ATA, max UDMA/133, 160086528 sectors
ata1: dev 0 configured for UDMA/133
scsi0 : sata_promise
ata2: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003
88:207f
ata2: dev 0 ATA, max UDMA/133, 160086528 sectors
ata2: dev 0 configured for UDMA/133
scsi1 : sata_promise
ATA: abnormal status 0x7F on port 0xF88D731C
ata3: thread exiting
scsi2 : sata_promise
ATA: abnormal status 0x7F on port 0xF88D739C
ata4: thread exiting
scsi3 : sata_promise
  Vendor: ATA       Model: Maxtor 6Y080M0    Rev: 1.02
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6Y080M0    Rev: 1.02
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 < >
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 160086528 512-byte hdwr sectors (81964 MB)
SCSI device sdb: drive cache: write through
 sdb: unknown partition table
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
mice: PS/2 mouse device common for all mice
serio: i8042 AUX port at 0x60,0x64 irq 12
input: ImExPS/2 Logitech Explorer Mouse on isa0060/serio1
serio: i8042 KBD port at 0x60,0x64 irq 1
input: AT Translated Set 2 keyboard on isa0060/serio0
EISA: Probing bus 0 at eisa0
NET: Registered protocol family 2
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: (supports S0 S1 S4 S5)
EXT2-fs warning (device hdb7): ext2_fill_super: mounting ext3 filesystem as
ext2

VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 236k freed
ACPI: Power Button (FF) [PWRF]
ACPI: Processor [CPU0] (supports C1 C2, 16 throttling states)
Adding 2104472k swap on /dev/hdb6.  Priority:-1 extents:1
NTFS driver 2.1.8 [Flags: R/O MODULE].
NTFS volume version 3.0.
NTFS volume version 3.0.


