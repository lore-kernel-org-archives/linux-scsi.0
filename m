From: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
 udev
Date: Tue, 1 Apr 2008 10:58:28 +0200
Message-ID: <20080401105828.dcaf9404.seraph@xs4all.nl>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	<20080401011518.eb683cff.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__1_Apr_2008_10_58_28_+0200_neMWj2ETpRqp3OiQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearlgates.net ([82.92.180.13]:36975 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbYDAJJ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2008 05:09:26 -0400
In-Reply-To: <20080401011518.eb683cff.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__1_Apr_2008_10_58_28_+0200_neMWj2ETpRqp3OiQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 1 Apr 2008 01:15:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> urgh.  Perhaps it's related to platform IRQ routing or something.
> 
> I'd suggest that the next step would be to send us the `dmesg -s 1000000'
> output for both good and bad kernels.  A comparison might show where things
> went bad.

Alright, here goes. Attached three files.

dmesg-2.6.22.9-good.txt is the dmesg output from 2.6.22.9 where everything works as it should.
dmesg-2.6.24.4-bad.txt is the dmesg output from 2.6.24.4 with sym53cxx loaded by udev and the network not responding.
dmesg-2.6.24.4-good.txt is the dmesg output from 2.6.24.4 with sym53cxx blacklisted and the network working fine.


-- 
Jos van der Ende <seraph@xs4all.nl>

--Multipart=_Tue__1_Apr_2008_10_58_28_+0200_neMWj2ETpRqp3OiQ
Content-Type: text/plain;
 name="dmesg-2.6.22.9-good.txt"
Content-Disposition: attachment;
 filename="dmesg-2.6.22.9-good.txt"
Content-Transfer-Encoding: 7bit

PROMLIB: Sun IEEE Boot Prom 'OBP 4.17.1 2005/04/11 14:31'
PROMLIB: Root node compatible: 
Linux version 2.6.22.9 (angel@phoenix) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #2 Mon Dec 17 22:46:30 CET 2007
ARCH: SUN4U
Ethernet address: 00:03:ba:08:61:7c
PROM: Built device tree with 60215 bytes of memory.
On node 0 totalpages: 130613
  Normal zone: 1567 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 129046 pages, LIFO batch:15
Built 1 zonelists.  Total pages: 129046
Kernel command line: root=/dev/hda4
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: mult[b40001] shift[16]
clockevent: mult[16c16bf] shift[32]
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
Memory: 1028152k available (1816k kernel code, 568k data, 96k init) [fffff80000000000,000000006ff0c000]
SLUB: Genslabs=23, HWalign=32, Order=0-2, MinObjects=8, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 11.12 BogoMIPS (lpj=55625)
Mount-cache hash table entries: 512
NET: Registered protocol family 16
PCI: Probing for controllers.
/pci@1f,0: SABRE PCI Bus Module
/pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
PCI: Scanning PBM /pci@1f,0
PCI quirk: region 0800-083f claimed by ali7101 ACPI
PCI quirk: region 0600-061f claimed by ali7101 SMB
isa0: [dma -> (floppy) (parallel)] [power] [serial] [serial]
ebus0: [flashprom] [eeprom] [idprom]
power: Control reg at 1fe02000800 ... powerd running.
/pci@1f,0/ebus@c/eeprom@1,0: Clock regs at 000001fff1000000
Time: hbtick clocksource has been installed.
Switched to high resolution mode on CPU 0
NET: Registered protocol family 2
IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
TCP established hash table entries: 32768 (order: 6, 524288 bytes)
TCP bind hash table entries: 32768 (order: 5, 262144 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP reno registered
io scheduler noop registered (default)
Activating ISA DMA hang workarounds.
f007d648: ttyS0 at MMIO 0x1fe020003f8 (irq = 9) is a 16550A
Console: ttyS0 (SU)
f007f1a0: ttyS1 at MMIO 0x1fe020002e8 (irq = 9) is a 16550A
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller at PCI slot 0000:00:0d.0
PCI: Enabling device: (0000:00:0d.0), cmd 5
ALI15X3: chipset revision 195
ALI15X3: 100% native mode on irq 15
    ide0: BM-DMA at 0x1fe02000a20-0x1fe02000a27, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1fe02000a28-0x1fe02000a2f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: ST38410A, ATA DISK drive
hdb: HL-DT-ST RW/DVD GCC-4480B, ATAPI CD/DVD-ROM drive
hda: selected mode 0x44
hdb: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdb: selected mode 0x42
ide0 at 0x1fe02000a00-0x1fe02000a07,0x1fe02000a1a on irq 15
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 16841664 sectors (8622 MB) w/512KiB Cache, CHS=16708/16/63, UDMA(66)
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4 hda5
mice: PS/2 mouse device common for all mice
TCP cubic registered
VFS: Mounted root (ext2 filesystem) readonly.
NET: Registered protocol family 1
PCI: Enabling device: (0000:00:08.0), cmd 3
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
hdb: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
SCSI subsystem initialized
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
PHY ID: 437421, addr: 1
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:03:ba:08:61:7c 
eth0: Found Generic MII PHY
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[12]  MMIO=[1ff00420000-1ff004207ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
PCI: Enabling device: (0000:00:0c.3), cmd 2
ohci_hcd 0000:00:0c.3: OHCI Host Controller
ohci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0c.3: irq 13, io mem 0x1ff02000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
PCI: Enabling device: (0000:01:02.0), cmd 147
sym0: <875> rev 0x14 at pci 0000:01:02.0 irq 16
sym0: No NVRAM, ID 7, Fast-20, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0003bafffe08617c]
ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0003bafffe0859fb]
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
udev: renamed network interface eth1 to fw0
eth0: Link is up at 100 Mbps, full-duplex.
scsi 0:0:0:0: Direct-Access     HITACHI  DK32EJ72NSUN72G  PQ0B PQ: 0 ANSI: 3
 target0:0:0: tagged command queuing enabled, command queue depth 16.
 target0:0:0: Beginning Domain Validation
 target0:0:0: asynchronous
 target0:0:0: wide asynchronous
 target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
scsi 0:0:5:0: Sequential-Access EXABYTE  EXB-89008E030203 V41e PQ: 0 ANSI: 2
 target0:0:5: Beginning Domain Validation
 target0:0:5: asynchronous
 target0:0:5: wide asynchronous
 target0:0:5: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
 target0:0:5: Domain Validation skipping write tests
 target0:0:5: Ending Domain Validation
PCI: Enabling device: (0000:01:02.1), cmd 147
sym1: <875> rev 0x14 at pci 0000:01:02.1 irq 17
sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.3
scsi 1:0:0:0: Direct-Access     SEAGATE  ST373307LSUN72G  0507 PQ: 0 ANSI: 3
 target1:0:0: tagged command queuing enabled, command queue depth 16.
 target1:0:0: Beginning Domain Validation
 target1:0:0: asynchronous
 target1:0:0: wide asynchronous
 target1:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target1:0:0: Domain Validation skipping write tests
 target1:0:0: Ending Domain Validation
sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: fb 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
st: Version 20070203, fixed bufsize 32768, s/g segs 256
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: fb 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
st 0:0:5:0: Attached scsi tape st0
st 0:0:5:0: st0: try direct i/o: yes (alignment 512 B)
sd 1:0:0:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: db 00 10 08
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:0:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: db 00 10 08
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
md: raid1 personality registered for level 1
md: md0 stopped.
md: bind<sda1>
md: bind<sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: dm-2: found reiserfs format "3.6" with standard journal
ReiserFS: dm-2: using ordered data mode
ReiserFS: dm-2: journal params: device dm-2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-2: checking transaction log (dm-2)
ReiserFS: dm-2: Using r5 hash to sort names
ReiserFS: dm-3: found reiserfs format "3.6" with standard journal
ReiserFS: dm-3: using ordered data mode
ReiserFS: dm-3: journal params: device dm-3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-3: checking transaction log (dm-3)
ReiserFS: dm-3: Using r5 hash to sort names
Adding 1999856k swap on /dev/hda2.  Priority:-1 extents:1 across:1999856k
rtc_sun_init: Registered Mostek RTC driver.
eth0: Link is up at 100 Mbps, full-duplex.
eth0: Pause is disabled
NET: Registered protocol family 17

--Multipart=_Tue__1_Apr_2008_10_58_28_+0200_neMWj2ETpRqp3OiQ
Content-Type: text/plain;
 name="dmesg-2.6.24.4-bad.txt"
Content-Disposition: attachment;
 filename="dmesg-2.6.24.4-bad.txt"
Content-Transfer-Encoding: 7bit

PROMLIB: Sun IEEE Boot Prom 'OBP 4.17.1 2005/04/11 14:31'
PROMLIB: Root node compatible: 
Linux version 2.6.24.4 (root@seraphim) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #5 Mon Mar 31 23:47:14 CEST 2008
ARCH: SUN4U
Ethernet address: 00:03:ba:08:61:7c
[0000000200000000-fffff80000400000] page_structs=262144 node=0 entry=0/0
[0000000200000000-fffff80000800000] page_structs=262144 node=0 entry=1/0
[0000000200000000-fffff80000c00000] page_structs=262144 node=0 entry=2/0
[0000000200000000-fffff80001000000] page_structs=262144 node=0 entry=3/0
OF stdout device is: /pci@1f,0/isa@7/serial@0,3f8
PROM: Built device tree with 60471 bytes of memory.
On node 0 totalpages: 130606
  Normal zone: 1567 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 129039 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129039
Kernel command line: root=/dev/hda4
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: mult[b40001] shift[16]
clockevent: mult[16c16bf] shift[32]
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
Memory: 1025864k available (1856k kernel code, 616k data, 104k init) [fffff80000000000,000000006ff0c000]
SLUB: Genslabs=12, HWalign=32, Order=0-2, MinObjects=8, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 11.12 BogoMIPS (lpj=55635)
Mount-cache hash table entries: 512
net_namespace: 120 bytes
NET: Registered protocol family 16
PCI: Probing for controllers.
/pci@1f,0: SABRE PCI Bus Module
/pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
PCI: Scanning PBM /pci@1f,0
PCI quirk: region 0800-083f claimed by ali7101 ACPI
PCI quirk: region 0600-061f claimed by ali7101 SMB
isa0: [dma -> (floppy) (parallel)] [power] [serial] [serial]
ebus0: [flashprom] [eeprom] [idprom]
power: Control reg at 1fe02000800
/pci@1f,0/ebus@c/eeprom@1,0: Clock regs at 000001fff1000000
NET: Registered protocol family 2
Time: hbtick clocksource has been installed.
Switched to NOHz mode on CPU #0
IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
TCP established hash table entries: 32768 (order: 6, 524288 bytes)
TCP bind hash table entries: 32768 (order: 5, 262144 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP reno registered
Mini RTC Driver
io scheduler noop registered (default)
Activating ISA DMA hang workarounds.
f007d648: ttyS0 at MMIO 0x1fe020003f8 (irq = 9) is a 16550A
Console: ttyS0 (SU)
console [ttyS0] enabled
f007f1a0: ttyS1 at MMIO 0x1fe020002e8 (irq = 9) is a 16550A
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slot 0000:00:0d.0
PCI: Enabling device: (0000:00:0d.0), cmd 5
ALI15X3: 100% native mode on irq 15
    ide0: BM-DMA at 0x1fe02000a20-0x1fe02000a27, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1fe02000a28-0x1fe02000a2f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hdb: HL-DT-ST RW/DVD GCC-4480B, ATAPI CD/DVD-ROM drive
hda: ST38410A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdb: UDMA/33 mode selected
ide0 at 0x1fe02000a00-0x1fe02000a07,0x1fe02000a1a on irq 15
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 16841664 sectors (8622 MB) w/512KiB Cache, CHS=16708/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4 hda5
mice: PS/2 mouse device common for all mice
TCP cubic registered
VFS: Mounted root (ext2 filesystem) readonly.
NET: Registered protocol family 1
PCI: Enabling device: (0000:00:08.0), cmd 3
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
SCSI subsystem initialized
hdb: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
PHY ID: 437421, addr: 1
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:03:ba:08:61:7c
eth0: Found Generic MII PHY
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[12]  MMIO=[1ff00420000-1ff004207ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
PCI: Enabling device: (0000:00:0c.3), cmd 2
ohci_hcd 0000:00:0c.3: OHCI Host Controller
ohci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0c.3: irq 13, io mem 0x1ff02000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
PCI: Enabling device: (0000:01:02.0), cmd 147
sym0: <875> rev 0x14 at pci 0000:01:02.0 irq 16
sym0: No NVRAM, ID 7, Fast-20, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0003bafffe08617c]
ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0003bafffe0859fb]
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
udev: renamed network interface eth1 to fw0
eth0: Link is up at 100 Mbps, full-duplex.
scsi 0:0:0:0: Direct-Access     HITACHI  DK32EJ72NSUN72G  PQ0B PQ: 0 ANSI: 3
 target0:0:0: tagged command queuing enabled, command queue depth 16.
 target0:0:0: Beginning Domain Validation
 target0:0:0: asynchronous
 target0:0:0: wide asynchronous
 target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
scsi 0:0:5:0: Sequential-Access EXABYTE  EXB-89008E030203 V41e PQ: 0 ANSI: 2
 target0:0:5: Beginning Domain Validation
 target0:0:5: asynchronous
 target0:0:5: wide asynchronous
 target0:0:5: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
 target0:0:5: Domain Validation skipping write tests
 target0:0:5: Ending Domain Validation
PCI: Enabling device: (0000:01:02.1), cmd 147
sym1: <875> rev 0x14 at pci 0000:01:02.1 irq 17
sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.3
scsi 1:0:0:0: Direct-Access     SEAGATE  ST373307LSUN72G  0507 PQ: 0 ANSI: 3
 target1:0:0: tagged command queuing enabled, command queue depth 16.
 target1:0:0: Beginning Domain Validation
 target1:0:0: asynchronous
 target1:0:0: wide asynchronous
 target1:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target1:0:0: Domain Validation skipping write tests
 target1:0:0: Ending Domain Validation
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: fb 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 143374738 512-byte hardware sectors (73408 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: fb 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: db 00 10 08
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:0:0: [sdb] 143374738 512-byte hardware sectors (73408 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: db 00 10 08
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
st: Version 20070203, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
st 0:0:5:0: Attached scsi tape st0
st 0:0:5:0: st0: try direct i/o: yes (alignment 512 B)
md: raid1 personality registered for level 1
md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
md: kicking non-fresh sdb1 from array!
md: unbind<sdb1>
md: export_rdev(sdb1)
raid1: raid set md0 active with 1 out of 2 mirrors
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: dm-2: found reiserfs format "3.6" with standard journal
ReiserFS: dm-2: using ordered data mode
ReiserFS: dm-2: journal params: device dm-2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-2: checking transaction log (dm-2)
ReiserFS: dm-2: Using r5 hash to sort names
ReiserFS: dm-3: found reiserfs format "3.6" with standard journal
ReiserFS: dm-3: using ordered data mode
ReiserFS: dm-3: journal params: device dm-3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-3: checking transaction log (dm-3)
ReiserFS: dm-3: Using r5 hash to sort names
Adding 1999856k swap on /dev/hda2.  Priority:-1 extents:1 across:1999856k
eth0: Link is up at 100 Mbps, full-duplex.
eth0: Pause is disabled
NET: Registered protocol family 17

--Multipart=_Tue__1_Apr_2008_10_58_28_+0200_neMWj2ETpRqp3OiQ
Content-Type: text/plain;
 name="dmesg-2.6.24.4-good.txt"
Content-Disposition: attachment;
 filename="dmesg-2.6.24.4-good.txt"
Content-Transfer-Encoding: 7bit

PROMLIB: Sun IEEE Boot Prom 'OBP 4.17.1 2005/04/11 14:31'
PROMLIB: Root node compatible: 
Linux version 2.6.24.4 (root@seraphim) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #5 Mon Mar 31 23:47:14 CEST 2008
ARCH: SUN4U
Ethernet address: 00:03:ba:08:61:7c
[0000000200000000-fffff80000400000] page_structs=262144 node=0 entry=0/0
[0000000200000000-fffff80000800000] page_structs=262144 node=0 entry=1/0
[0000000200000000-fffff80000c00000] page_structs=262144 node=0 entry=2/0
[0000000200000000-fffff80001000000] page_structs=262144 node=0 entry=3/0
OF stdout device is: /pci@1f,0/isa@7/serial@0,3f8
PROM: Built device tree with 60471 bytes of memory.
On node 0 totalpages: 130606
  Normal zone: 1567 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 129039 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129039
Kernel command line: root=/dev/hda4
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: mult[b40001] shift[16]
clockevent: mult[16c16bf] shift[32]
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
Memory: 1025864k available (1856k kernel code, 616k data, 104k init) [fffff80000000000,000000006ff0c000]
SLUB: Genslabs=12, HWalign=32, Order=0-2, MinObjects=8, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 11.12 BogoMIPS (lpj=55632)
Mount-cache hash table entries: 512
net_namespace: 120 bytes
NET: Registered protocol family 16
PCI: Probing for controllers.
/pci@1f,0: SABRE PCI Bus Module
/pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
PCI: Scanning PBM /pci@1f,0
PCI quirk: region 0800-083f claimed by ali7101 ACPI
PCI quirk: region 0600-061f claimed by ali7101 SMB
isa0: [dma -> (floppy) (parallel)] [power] [serial] [serial]
ebus0: [flashprom] [eeprom] [idprom]
power: Control reg at 1fe02000800
/pci@1f,0/ebus@c/eeprom@1,0: Clock regs at 000001fff1000000
NET: Registered protocol family 2
Time: hbtick clocksource has been installed.
Switched to NOHz mode on CPU #0
IP route cache hash table entries: 8192 (order: 3, 65536 bytes)
TCP established hash table entries: 32768 (order: 6, 524288 bytes)
TCP bind hash table entries: 32768 (order: 5, 262144 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP reno registered
Mini RTC Driver
io scheduler noop registered (default)
Activating ISA DMA hang workarounds.
f007d648: ttyS0 at MMIO 0x1fe020003f8 (irq = 9) is a 16550A
Console: ttyS0 (SU)
console [ttyS0] enabled
f007f1a0: ttyS1 at MMIO 0x1fe020002e8 (irq = 9) is a 16550A
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slot 0000:00:0d.0
PCI: Enabling device: (0000:00:0d.0), cmd 5
ALI15X3: 100% native mode on irq 15
    ide0: BM-DMA at 0x1fe02000a20-0x1fe02000a27, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1fe02000a28-0x1fe02000a2f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hdb: HL-DT-ST RW/DVD GCC-4480B, ATAPI CD/DVD-ROM drive
hda: ST38410A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdb: UDMA/33 mode selected
ide0 at 0x1fe02000a00-0x1fe02000a07,0x1fe02000a1a on irq 15
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 16841664 sectors (8622 MB) w/512KiB Cache, CHS=16708/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4 hda5
mice: PS/2 mouse device common for all mice
TCP cubic registered
VFS: Mounted root (ext2 filesystem) readonly.
NET: Registered protocol family 1
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
PHY ID: 437421, addr: 1
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:03:ba:08:61:7c
eth0: Found Generic MII PHY
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[12]  MMIO=[1ff00420000-1ff004207ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
hdb: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device: (0000:00:0c.3), cmd 2
ohci_hcd 0000:00:0c.3: OHCI Host Controller
ohci_hcd 0000:00:0c.3: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0c.3: irq 13, io mem 0x1ff02000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
PCI: Enabling device: (0000:00:08.0), cmd 3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0003bafffe08617c]
eth0: Link is up at 100 Mbps, full-duplex.
ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0003bafffe0859fb]
eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
udev: renamed network interface eth1 to fw0
md: raid1 personality registered for level 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: dm-2: found reiserfs format "3.6" with standard journal
ReiserFS: dm-2: using ordered data mode
ReiserFS: dm-2: journal params: device dm-2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-2: checking transaction log (dm-2)
ReiserFS: dm-2: Using r5 hash to sort names
ReiserFS: dm-3: found reiserfs format "3.6" with standard journal
ReiserFS: dm-3: using ordered data mode
ReiserFS: dm-3: journal params: device dm-3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-3: checking transaction log (dm-3)
ReiserFS: dm-3: Using r5 hash to sort names
Adding 1999856k swap on /dev/hda2.  Priority:-1 extents:1 across:1999856k
eth0: Link is up at 100 Mbps, full-duplex.
eth0: Pause is disabled
NET: Registered protocol family 17

--Multipart=_Tue__1_Apr_2008_10_58_28_+0200_neMWj2ETpRqp3OiQ--
