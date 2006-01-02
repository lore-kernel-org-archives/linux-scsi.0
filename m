From: Peter Bosgraaf <peter.bosgraaf@wiaf.nl>
Subject: AACRAID with Supermicro AOC-SOZCR1 (Adaptec 2025s)
Date: Mon, 2 Jan 2006 12:34:09 +0100
Message-ID: <20060102113409.GA30847@ams-ix.shells.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s001.servers.shells.nl ([213.206.83.2]:32974 "EHLO
	s001.servers.shells.nl") by vger.kernel.org with ESMTP
	id S932295AbWABLga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jan 2006 06:36:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majordomo@vger.kernel.org

Hi everyone,

I just joined this mailing list after reading for some time.
Because i couldn't find the answer to my question either on google
or on this list i thought i'd give posting a go.

Here's my problem, 

We bought a dozen of Supermicro servers at the DC i work for.
The server models are all the same, Superserver 6014P-T with an AOC-SOZCR1 snap-in
mini-pci raid card. (The raidcard is a rebranded Adaptec 2025s)

After building the raid 1 configuration the usual way, through the h/w
bios, i tried to boot linux. It seems the kernel detects an compatible
controller, but instead of just showing my logical drives it also
detects detects and lists my physical drives. (See kernel output below)
I tried this with kernel 2.6.14.4 and 2.6.14.5.

Does anyone else experience the same problems as i do? Or may be this is normal
behavior of the driver?

I included the output of the kernel, i'm willing to test and contribute
in any way i can. Any help would be greatly appriciated!


--kernel output--
Bridge: 0000:01:00.2
  IO window: disabled.
  MEM window: d4400000-d5ffffff
  PREFETCH window: dc000000-dfffffff
PCI: Bridge: 0000:00:02.0
  IO window: 2000-2fff
  MEM window: d4100000-d5ffffff
  PREFETCH window: dc000000-dfffffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: d6000000-d7ffffff
  PREFETCH window: d1000000-d10fffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:01:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
Simple Boot Flag at 0x39 set to 0x1
IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Initializing Cryptographic API
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1])
ACPI: CPU1 (power states: C1[C1])
Real Time Clock Driver v1.12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 1 RAM disks of 12000K size 1024 blocksize
loop: loaded (max 8 devices)
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 2.6.8)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 6.0.60-k2-NAPI
Copyright (c) 1999-2005 Intel Corporation.
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 30 (level, low) -> IRQ 17
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:02:03.1[B] -> GSI 31 (level, low) -> IRQ 18
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.4.14-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
ICH5: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 19
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x14a0-0x14a7, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x14a8-0x14af, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: CD-224E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide0...
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Adaptec aacraid driver (1.1-4 Jan  2 2006 10:37:11)
ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 58 (level, low) -> IRQ 20
AAC0: kernel 4.2-1[7373] 
AAC0: monitor 4.2-1[7373]
AAC0: bios 4.2-1[7373]
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
scsi0 : aacraid
  Vendor: ADAPTEC   Model: ASR-2025ZCR Mirr  Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: MAXTOR    Model: ATLAS10K5_73SCA   Rev: JNZH
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: MAXTOR    Model: ATLAS10K5_73SCA   Rev: JNZH
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SUPER     Model: GEM318            Rev: 0   
  Type:   Processor                          ANSI SCSI revision: 02
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
QLogic Fibre Channel HBA Driver
megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.6 (Release Date: Mon Mar 07 12:27:22 EST 2005)
GDT-HA: Storage RAID Controller Driver. Version: 3.04 
GDT-HA: Found 0 PCI Storage RAID Controllers
libata version 1.12 loaded.
SCSI device sda: 143552512 512-byte hdwr sectors (73499 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
SCSI device sda: 143552512 512-byte hdwr sectors (73499 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
 sda: unknown partition table
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 143666192 512-byte hdwr sectors (73557 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 143666192 512-byte hdwr sectors (73557 MB)
SCSI device sdb: drive cache: write back
 sdb: unknown partition table
Attached scsi disk sdb at scsi0, channel 1, id 0, lun 0
SCSI device sdc: 143666192 512-byte hdwr sectors (73557 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 143666192 512-byte hdwr sectors (73557 MB)
SCSI device sdc: drive cache: write back
 sdc: unknown partition table
Attached scsi disk sdc at scsi0, channel 1, id 1, lun 0
mice: PS/2 mouse device common for all mice
I2O subsystem v1.288
i2o: max drivers = 8
I2O Configuration OSM v1.248
I2O Bus Adapter OSM v$Rev$
I2O Block Device OSM v1.287
I2O SCSI Peripheral OSM v1.282
I2O ProcFS OSM v1.145
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  4857.000 MB/sec
raid5: using function: pIII_sse (4857.000 MB/sec)
raid6: int32x1    835 MB/s
raid6: int32x2    922 MB/s
input: AT Translated Set 2 keyboard on isa0060/serio0
raid6: int32x4    617 MB/s
raid6: int32x8    552 MB/s
raid6: mmxx1     1829 MB/s
raid6: mmxx2     2113 MB/s
raid6: sse1x1    1060 MB/s
raid6: sse1x2    1194 MB/s
raid6: sse2x1    2099 MB/s
raid6: sse2x2    2249 MB/s
raid6: using algorithm sse2x2 (2249 MB/s)
md: raid6 personality registered as nr 8
md: md driver 0.90.2 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 3.39
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
ip_tables: (C) 2000-2002 Netfilter core team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
Netfilter messages via NETLINK v0.30.
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
ip6_tables: (C) 2000-2002 Netfilter core team
registering ipv6 mark target
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
EXT2-fs warning: checktime reached, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 292k freed
VFS: Can't find an ext2 filesystem on dev fd0.
--kernel-output--


-- 
Met vriendelijke groet / With kind regards,

Peter Bosgraaf		//	Wireless Internet Access Friesland
Tel: +31-627-070-596	//	http://www.wiaf.nl

