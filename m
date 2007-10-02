From: Burton Windle <bwindle@fint.org>
Subject: 2.6.23-rc9 boot failure (megaraid?) (fwd)
Date: Tue, 2 Oct 2007 12:53:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710021252360.6275@postal>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ispmxmta09-srv.windstream.net ([166.102.165.170]:47198 "EHLO
	ispmxmta09-srv.windstream.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbXJBRDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 13:03:21 -0400
Received: from postal ([75.90.60.105]) by ispmxfep02-srv.windstream.net
          with ESMTP
          id <20071002165309.XNAQ21107.ispmxfep02-srv.windstream.net@postal>
          for <linux-scsi@vger.kernel.org>; Tue, 2 Oct 2007 11:53:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I should have CC'ed this to linux-scsi.


-- 
Burton Windle                           bwindle@fint.org


---------- Forwarded message ----------
Date: Tue, 2 Oct 2007 12:48:26 -0400 (EDT)
From: Burton Windle <bwindle@fint.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc9 boot failure (megaraid?)

2.6.23-rc9 fails to boot for me; 2.6.22.9 works fine.

System is a Dell Poweredge with PERC 2/DC with RAID1 volume.

>From 2.6.23-rc9:

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
eth1: Optical link UP (Full Duplex, Flow Control: )
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hdc: SAMSUNG SC-140B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 40X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
ACPI: PCI Interrupt 0000:00:0d.1[A] -> GSI 17 (level, low) -> IRQ 18
megaraid: found 0x8086:0x1960:bus 0:slot 13:func 1
scsi0:Found MegaRAID controller at 0xf8812000, IRQ:18
megaraid: [1.06:1p00] detected 1 logical drives.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
scsi0 : LSI Logic MegaRAID 1.06 254 commands 16 targs 5 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
scsi 0:0:0:0: Direct-Access     MegaRAID LD0 RAID1  8568R 1.06 PQ: 0 ANSI: 2
scsi0: scanning scsi channel 4 [P0] for physical devices.
scsi0: scanning scsi channel 5 [P1] for physical devices.
st: Version 20070203, fixed bufsize 32768, s/g segs 256
sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Asking for cache data failed
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
sd 0:0:0:0: [sda] 1 512-byte hardware sectors (0 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Asking for cache data failed
sd 0:0:0:0: [sda] Assuming drive cache: write through
  sda: sda1
  sda: p1 exceeds device capacity
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input1
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
NET: Registered protocol family 26
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
attempt to access beyond end of device
sda: rw=0, want=67, limit=1
EXT3-fs: unable to read superblock
attempt to access beyond end of device
sda: rw=0, want=67, limit=1
EXT2-fs: unable to read superblock
attempt to access beyond end of device
sda: rw=0, want=129, limit=1
isofs_fill_super: bread failed, dev=sda1, iso_blknum=16, block=32
attempt to access beyond end of device
sda: rw=0, want=131, limit=1
attempt to access beyond end of device
sda: rw=0, want=17542979, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541955, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541731, limit=1
attempt to access beyond end of device
sda: rw=0, want=17542971, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541947, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541723, limit=1
attempt to access beyond end of device
sda: rw=0, want=17542379, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541355, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541131, limit=1
attempt to access beyond end of device
sda: rw=0, want=17542371, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541347, limit=1
attempt to access beyond end of device
sda: rw=0, want=17541123, limit=1
attempt to access beyond end of device
sda: rw=0, want=14394267, limit=1
attempt to access beyond end of device
sda: rw=0, want=14393243, limit=1
attempt to access beyond end of device
sda: rw=0, want=14393019, limit=1
attempt to access beyond end of device
sda: rw=0, want=14394259, limit=1
attempt to access beyond end of device
sda: rw=0, want=14393235, limit=1
attempt to access beyond end of device
sda: rw=0, want=14393011, limit=1
attempt to access beyond end of device
sda: rw=0, want=14393667, limit=1
attempt to access beyond end of device
sda: rw=0, want=14392643, limit=1
attempt to access beyond end of device
sda: rw=0, want=14392419, limit=1
attempt to access beyond end of device
sda: rw=0, want=14393659, limit=1
attempt to access beyond end of device
sda: rw=0, want=14392635, limit=1
attempt to access beyond end of device
sda: rw=0, want=14392411, limit=1
attempt to access beyond end of device
sda: rw=0, want=1315, limit=1
attempt to access beyond end of device
sda: rw=0, want=1091, limit=1
UDF-fs: No partition found (1)
List of all partitions:
1600    4194302 hdc driver: ide-cdrom
0800          0 sda driver: sd
   0801    8771458 sda1
No filesystem could mount root, tried:  ext3 ext2 iso9660 udf
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)


>From 2.6.22.9:

megaraid: found 0x8086:0x1960:bus 0:slot 13:func 1
scsi0:Found MegaRAID controller at 0xf8812000, IRQ:18
megaraid: [1.06:1p00] detected 1 logical drives.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
scsi0 : LSI Logic MegaRAID 1.06 254 commands 16 targs 5 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
scsi 0:0:0:0: Direct-Access     MegaRAID LD0 RAID1  8568R 1.06 PQ: 0 ANSI: 2
scsi0: scanning scsi channel 4 [P0] for physical devices.
scsi0: scanning scsi channel 5 [P1] for physical devices.
st: Version 20070203, fixed bufsize 32768, s/g segs 256
sd 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Asking for cache data failed
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 17547264 512-byte hardware sectors (8984 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Asking for cache data failed
sd 0:0:0:0: [sda] Assuming drive cache: write through
  sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input1
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
NET: Registered protocol family 26
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 260k freed
EXT3 FS on sda1, internal journal




00:0d.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 02) 
(prog-if 01)
         Subsystem: Dell PowerEdge Expandable RAID Controller 2/DC
         Flags: bus master, medium devsel, latency 64, IRQ 18
         Memory at f7000000 (32-bit, prefetchable) [size=4M]
         [virtual] Expansion ROM at 50000000 [disabled] [size=32K]
         Capabilities: <access denied>




CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_MEGARAID_LEGACY=y


-- 
Burton Windle                           bwindle@fint.org

