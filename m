From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Fri, 12 Sep 2003 13:46:46 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309120447.NAA04636@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:29654 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S261669AbTILErl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 00:47:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Alan,

Thank you for your help!!

Alan wrote;

Alan> What did the system log show?  Try turning on verbose usb 
Alan> debugging and run your test again.
Alan> This time post a copy of the system log.
 
USB DEBUG was not confirmed. The log is as follows.

</var/log/messages>
Sep 12 12:53:44 Andromeda syslogd 1.4.1: restart.
Sep 12 12:53:44 Andromeda syslog: syslogd startup succeeded
Sep 12 12:53:44 Andromeda kernel: klogd 1.4.1, log source = /proc/kmsg started.
Sep 12 12:53:44 Andromeda kernel: Linux version 2.4.22-10smp (root@Andromeda) (gcc version 2.96 20000731 (Red Hat Linux 7.3 2.96-110)) #1 SMP Fri Sep 12 11:36:55 JST 2003
Sep 12 12:53:44 Andromeda kernel: BIOS-provided physical RAM map:
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 0000000000000000 - 0000000000099000 (usable)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 0000000000099000 - 000000000009c000 (reserved)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 00000000000e4400 - 0000000000100000 (reserved)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 0000000000100000 - 000000008fef0000 (usable)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 000000008fef0000 - 000000008feff000 (ACPI data)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 000000008feff000 - 000000008ff00000 (ACPI NVS)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 000000008ff00000 - 0000000090000000 (usable)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Sep 12 12:53:44 Andromeda kernel:  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
Sep 12 12:53:44 Andromeda syslog: klogd startup succeeded
Sep 12 12:53:44 Andromeda kernel: 1408MB HIGHMEM available.
Sep 12 12:53:44 Andromeda kernel: 896MB LOWMEM available.
Sep 12 12:53:44 Andromeda kernel: found SMP MP-table at 000f6cb0
Sep 12 12:53:44 Andromeda kernel: hm, page 000f6000 reserved twice.
Sep 12 12:53:44 Andromeda kernel: hm, page 000f7000 reserved twice.
Sep 12 12:53:44 Andromeda kernel: hm, page 0009a000 reserved twice.
Sep 12 12:53:44 Andromeda kernel: hm, page 0009b000 reserved twice.
Sep 12 12:53:44 Andromeda kernel: On node 0 totalpages: 589824
Sep 12 12:53:44 Andromeda kernel: zone(0): 4096 pages.
Sep 12 12:53:44 Andromeda kernel: zone(1): 225280 pages.
Sep 12 12:53:44 Andromeda kernel: zone(2): 360448 pages.
Sep 12 12:53:44 Andromeda kernel: Intel MultiProcessor Specification v1.4
Sep 12 12:53:44 Andromeda kernel:     Virtual Wire compatibility mode.
Sep 12 12:53:44 Andromeda kernel: OEM ID: VIA    Product ID: VIA_694T APIC at: 0xFEE00000
Sep 12 12:53:44 Andromeda kernel: Processor #3 Pentium(tm) Pro APIC version 17
Sep 12 12:53:44 Andromeda kernel: Processor #0 Pentium(tm) Pro APIC version 17
Sep 12 12:53:44 Andromeda kernel: I/O APIC #1 Version 17 at 0xFEC00000.
Sep 12 12:53:44 Andromeda kernel: Enabling APIC mode: Flat.^IUsing 1 I/O APICs
Sep 12 12:53:44 Andromeda kernel: Processors: 2
Sep 12 12:53:44 Andromeda kernel: Kernel command line: ro root=/dev/hdc5
Sep 12 12:53:44 Andromeda kernel: Initializing CPU#0
Sep 12 12:53:44 Andromeda kernel: Detected 1263.480 MHz processor.
Sep 12 12:53:44 Andromeda kernel: Console: colour VGA+ 80x25
Sep 12 12:53:44 Andromeda kernel: Calibrating delay loop... 2523.13 BogoMIPS
Sep 12 12:53:44 Andromeda kernel: Memory: 2328484k/2359296k available (1272k kernel code, 30336k reserved, 512k data, 140k init, 1441728k highmem)
Sep 12 12:53:44 Andromeda kernel: Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Sep 12 12:53:44 Andromeda kernel: Inode cache hash table entries: 262144 (order: 9, 2097152 bytes)
Sep 12 12:53:44 Andromeda kernel: Mount cache hash table entries: 512 (order: 0, 4096 bytes)
Sep 12 12:53:44 Andromeda kernel: Buffer cache hash table entries: 262144 (order: 8, 1048576 bytes)
Sep 12 12:53:44 Andromeda kernel: Page-cache hash table entries: 524288 (order: 9, 2097152 bytes)
Sep 12 12:53:44 Andromeda kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Sep 12 12:53:44 Andromeda kernel: CPU: L2 cache: 512K
Sep 12 12:53:44 Andromeda kernel: Intel machine check architecture supported.
Sep 12 12:53:44 Andromeda kernel: Intel machine check reporting enabled on CPU#0.
Sep 12 12:53:44 Andromeda kernel: Enabling fast FPU save and restore... done.
Sep 12 12:53:44 Andromeda portmap: portmap startup succeeded
Sep 12 12:53:44 Andromeda kernel: Enabling unmasked SIMD FPU exception support... done.
Sep 12 12:53:44 Andromeda kernel: Checking 'hlt' instruction... OK.
Sep 12 12:53:44 Andromeda kernel: POSIX conformance testing by UNIFIX
Sep 12 12:53:44 Andromeda kernel: mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
Sep 12 12:53:44 Andromeda kernel: mtrr: detected mtrr type: Intel
Sep 12 12:53:44 Andromeda kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Sep 12 12:53:44 Andromeda kernel: CPU: L2 cache: 512K
Sep 12 12:53:44 Andromeda kernel: Intel machine check reporting enabled on CPU#0.
Sep 12 12:53:44 Andromeda kernel: CPU0: Intel(R) Pentium(R) III CPU family      1266MHz stepping 01
Sep 12 12:53:44 Andromeda kernel: per-CPU timeslice cutoff: 1462.38 usecs.
Sep 12 12:53:44 Andromeda kernel: enabled ExtINT on CPU#0
Sep 12 12:53:44 Andromeda kernel: ESR value before enabling vector: 00000000
Sep 12 12:53:44 Andromeda kernel: ESR value after enabling vector: 00000000
Sep 12 12:53:44 Andromeda kernel: Booting processor 1/0 eip 2000
Sep 12 12:53:44 Andromeda kernel: Initializing CPU#1
Sep 12 12:53:44 Andromeda kernel: masked ExtINT on CPU#1
Sep 12 12:53:44 Andromeda kernel: ESR value before enabling vector: 00000000
Sep 12 12:53:44 Andromeda kernel: ESR value after enabling vector: 00000000
Sep 12 12:53:44 Andromeda kernel: Calibrating delay loop... 2523.13 BogoMIPS
Sep 12 12:53:44 Andromeda kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Sep 12 12:53:44 Andromeda kernel: CPU: L2 cache: 512K
Sep 12 12:53:44 Andromeda kernel: Intel machine check reporting enabled on CPU#1.
Sep 12 12:53:44 Andromeda kernel: CPU1: Intel(R) Pentium(R) III CPU family      1266MHz stepping 01
Sep 12 12:53:44 Andromeda kernel: Total of 2 processors activated (5046.27 BogoMIPS).
Sep 12 12:53:44 Andromeda kernel: ENABLING IO-APIC IRQs
Sep 12 12:53:44 Andromeda kernel: Setting 1 in the phys_id_present_map
Sep 12 12:53:44 Andromeda kernel: ...changing IO-APIC physical APIC ID to 1 ... ok.
Sep 12 12:53:44 Andromeda kernel: ..TIMER: vector=0x31 pin1=2 pin2=0
Sep 12 12:53:44 Andromeda kernel: testing the IO APIC.......................
Sep 12 12:53:44 Andromeda kernel: 
Sep 12 12:53:44 Andromeda kernel: .................................... done.
Sep 12 12:53:44 Andromeda kernel: Using local APIC timer interrupts.
Sep 12 12:53:44 Andromeda kernel: calibrating APIC timer ...
Sep 12 12:53:44 Andromeda kernel: ..... CPU clock speed is 1263.5086 MHz.
Sep 12 12:53:44 Andromeda kernel: ..... host bus clock speed is 133.0008 MHz.
Sep 12 12:53:44 Andromeda kernel: cpu: 0, clocks: 1330008, slice: 443336
Sep 12 12:53:44 Andromeda kernel: CPU0<T0:1330000,T1:886656,D:8,S:443336,C:1330008>
Sep 12 12:53:44 Andromeda kernel: cpu: 1, clocks: 1330008, slice: 443336
Sep 12 12:53:44 Andromeda kernel: CPU1<T0:1330000,T1:443328,D:0,S:443336,C:1330008>
Sep 12 12:53:44 Andromeda kernel: checking TSC synchronization across CPUs: passed.
Sep 12 12:53:44 Andromeda kernel: Waiting on wait_init_idle (map = 0x2)
Sep 12 12:53:44 Andromeda kernel: All processors have done init_idle
Sep 12 12:53:44 Andromeda kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd7f5, last bus=2
Sep 12 12:53:44 Andromeda kernel: PCI: Using configuration type 1
Sep 12 12:53:44 Andromeda kernel: PCI: Probing PCI hardware
Sep 12 12:53:44 Andromeda kernel: PCI: Probing PCI hardware (bus 00)
Sep 12 12:53:44 Andromeda kernel: PCI: Using IRQ router VIA [1106/0686] at 00:07.0
Sep 12 12:53:44 Andromeda kernel: PCI: Enabling Via external APIC routing
Sep 12 12:53:44 Andromeda kernel: isapnp: Scanning for PnP cards...
Sep 12 12:53:44 Andromeda kernel: isapnp: No Plug & Play device found
Sep 12 12:53:44 Andromeda kernel: Linux NET4.0 for Linux 2.4
Sep 12 12:53:44 Andromeda kernel: Based upon Swansea University Computer Society NET3.039
Sep 12 12:53:44 Andromeda kernel: Initializing RT netlink socket
Sep 12 12:53:44 Andromeda kernel: apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16)
Sep 12 12:53:44 Andromeda kernel: apm: disabled - APM is not SMP safe.
Sep 12 12:53:44 Andromeda kernel: Starting kswapd
Sep 12 12:53:44 Andromeda kernel: allocated 32 pages and 32 bhs reserved for the highmem bounces
Sep 12 12:53:44 Andromeda kernel: VFS: Disk quotas vdquot_6.5.1
Sep 12 12:53:44 Andromeda kernel: pty: 2048 Unix98 ptys configured
Sep 12 12:53:44 Andromeda kernel: Serial driver version 5.05c (2001-07-08) with MANY_PORTS MULTIPORT SHARE_IRQ SERIAL_PCI ISAPNP enabled
Sep 12 12:53:44 Andromeda kernel: ttyS00 at 0x03f8 (irq = 4) is a 16550A
Sep 12 12:53:44 Andromeda kernel: Real Time Clock Driver v1.10e
Sep 12 12:53:44 Andromeda kernel: floppy0: no floppy controllers found
Sep 12 12:53:44 Andromeda kernel: RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Sep 12 12:53:44 Andromeda kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
Sep 12 12:53:44 Andromeda kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Sep 12 12:53:44 Andromeda kernel: VP_IDE: IDE controller at PCI slot 00:07.1
Sep 12 12:53:44 Andromeda kernel: VP_IDE: chipset revision 6
Sep 12 12:53:44 Andromeda kernel: VP_IDE: not 100%% native mode: will probe irqs later
Sep 12 12:53:44 Andromeda kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Sep 12 12:53:44 Andromeda kernel: VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci00:07.1
Sep 12 12:53:44 Andromeda kernel:     ide0: BM-DMA at 0x10a0-0x10a7, BIOS settings: hda:DMA, hdb:pio
Sep 12 12:53:44 Andromeda kernel: CMD649: IDE controller at PCI slot 00:0b.0
Sep 12 12:53:44 Andromeda kernel: CMD649: chipset revision 2
Sep 12 12:53:44 Andromeda kernel: CMD649: not 100%% native mode: will probe irqs later
Sep 12 12:53:44 Andromeda kernel:     ide1: BM-DMA at 0x10b0-0x10b7, BIOS settings: hdc:pio, hdd:pio
Sep 12 12:53:44 Andromeda kernel:     ide2: BM-DMA at 0x10b8-0x10bf, BIOS settings: hde:pio, hdf:pio
Sep 12 12:53:44 Andromeda kernel: hda: CD-224E, ATAPI CD/DVD-ROM drive
Sep 12 12:53:44 Andromeda kernel: hdc: IC35L040AVER07-0, ATA DISK drive
Sep 12 12:53:44 Andromeda kernel: blk: queue c032ba8c, I/O limit 4095Mb (mask 0xffffffff)
Sep 12 12:53:44 Andromeda kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Sep 12 12:53:44 Andromeda kernel: ide1 at 0x10d0-0x10d7,0x10c6 on irq 11
Sep 12 12:53:44 Andromeda kernel: hdc: attached ide-disk driver.
Sep 12 12:53:44 Andromeda kernel: hdc: host protected area => 1
Sep 12 12:53:44 Andromeda kernel: hdc: 80418240 sectors (41174 MB) w/1916KiB Cache, CHS=79780/16/63, UDMA(100)
Sep 12 12:53:44 Andromeda kernel: Partition check:
Sep 12 12:53:44 Andromeda kernel:  hdc: hdc1 hdc2 < hdc5 hdc6 hdc7 hdc8 hdc9 >
Sep 12 12:53:44 Andromeda kernel: ide: late registration of driver.
Sep 12 12:53:44 Andromeda kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Sep 12 12:53:44 Andromeda kernel: md: Autodetecting RAID arrays.
Sep 12 12:53:44 Andromeda kernel: md: autorun ...
Sep 12 12:53:44 Andromeda kernel: md: ... autorun DONE.
Sep 12 12:53:44 Andromeda kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Sep 12 12:53:44 Andromeda kernel: Initializing Cryptographic API
Sep 12 12:53:44 Andromeda kernel: NET4: Linux TCP/IP 1.0 for NET4.0
Sep 12 12:53:44 Andromeda kernel: IP Protocols: ICMP, UDP, TCP, IGMP
Sep 12 12:53:44 Andromeda kernel: IP: routing cache hash table of 32768 buckets, 256Kbytes
Sep 12 12:53:44 Andromeda kernel: TCP: Hash tables configured (established 262144 bind 65536)
Sep 12 12:53:44 Andromeda kernel: Linux IP multicast router 0.06 plus PIM-SM
Sep 12 12:53:44 Andromeda kernel: NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
Sep 12 12:53:44 Andromeda kernel: RAMDISK: Compressed image found at block 0
Sep 12 12:53:44 Andromeda kernel: Freeing initrd memory: 256k freed
Sep 12 12:53:44 Andromeda kernel: VFS: Mounted root (ext2 filesystem).
Sep 12 12:53:44 Andromeda kernel: SCSI subsystem driver Revision: 1.00
Sep 12 12:53:44 Andromeda kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
Sep 12 12:53:44 Andromeda kernel:         <Adaptec aic7892 Ultra160 SCSI adapter>
Sep 12 12:53:44 Andromeda kernel:         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Sep 12 12:53:44 Andromeda kernel: 
Sep 12 12:53:44 Andromeda kernel: blk: queue f7fcb218, I/O limit 4095Mb (mask 0xffffffff)
Sep 12 12:53:44 Andromeda kernel: Journalled Block Device driver loaded
Sep 12 12:53:44 Andromeda kernel: kjournald starting.  Commit interval 5 seconds
Sep 12 12:53:44 Andromeda kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep 12 12:53:44 Andromeda kernel: Freeing unused kernel memory: 140k freed
Sep 12 12:53:44 Andromeda kernel: Adding Swap: 2097104k swap-space (priority -1)
Sep 12 12:53:44 Andromeda kernel: usb.c: registered new driver usbdevfs
Sep 12 12:53:44 Andromeda kernel: usb.c: registered new driver hub
Sep 12 12:53:44 Andromeda kernel: usb-uhci.c: $Revision: 1.275 $ time 11:55:35 Sep 12 2003
Sep 12 12:53:44 Andromeda kernel: usb-uhci.c: High bandwidth mode enabled
Sep 12 12:53:44 Andromeda keytable: Loading keymap:  succeeded
Sep 12 12:53:44 Andromeda kernel: usb-uhci.c: USB UHCI at I/O 0x1080, IRQ 11
Sep 12 12:53:44 Andromeda kernel: usb-uhci.c: Detected 2 ports
Sep 12 12:53:44 Andromeda kernel: usb.c: new USB bus registered, assigned bus number 1
Sep 12 12:53:44 Andromeda kernel: Product: USB UHCI Root Hub
Sep 12 12:53:44 Andromeda kernel: SerialNumber: 1080
Sep 12 12:53:44 Andromeda kernel: hub.c: USB hub found
Sep 12 12:53:44 Andromeda kernel: hub.c: 2 ports detected
Sep 12 12:53:44 Andromeda keytable: Loading system font:  succeeded
Sep 12 12:53:44 Andromeda kernel: usb-uhci.c: v1.275:USB Universal Host Controller Interface driver
Sep 12 12:53:44 Andromeda kernel: hub.c: new USB device 00:07.2-1, assigned address 2
Sep 12 12:53:44 Andromeda kernel: Manufacturer: TEAC    
Sep 12 12:53:44 Andromeda kernel: Product: TEAC FD-05PUB   
Sep 12 12:53:44 Andromeda kernel: usb.c: USB device 2 (vend/prod 0x644/0x0) is not claimed by any active driver.
Sep 12 12:53:44 Andromeda kernel:   Length              = 18
Sep 12 12:53:44 Andromeda kernel:   DescriptorType      = 01
Sep 12 12:53:44 Andromeda kernel:   USB version         = 1.10
Sep 12 12:53:44 Andromeda kernel:   Vendor:Product      = 0644:0000
Sep 12 12:53:44 Andromeda kernel:   MaxPacketSize0      = 8
Sep 12 12:53:44 Andromeda kernel:   NumConfigurations   = 1
Sep 12 12:53:44 Andromeda kernel:   Device version      = 0.00
Sep 12 12:53:44 Andromeda kernel:   Device Class:SubClass:Protocol = 00:00:00
Sep 12 12:53:44 Andromeda kernel:     Per-interface classes
Sep 12 12:53:44 Andromeda kernel: Configuration:
Sep 12 12:53:44 Andromeda kernel:   bLength             =    9
Sep 12 12:53:44 Andromeda kernel:   bDescriptorType     =   02
Sep 12 12:53:44 Andromeda kernel:   wTotalLength        = 0027
Sep 12 12:53:44 Andromeda kernel:   bNumInterfaces      =   01
Sep 12 12:53:44 Andromeda kernel:   bConfigurationValue =   01
Sep 12 12:53:44 Andromeda kernel:   iConfiguration      =   00
Sep 12 12:53:44 Andromeda kernel:   bmAttributes        =   80
Sep 12 12:53:44 Andromeda kernel:   MaxPower            =  500mA
Sep 12 12:53:44 Andromeda kernel: 
Sep 12 12:53:44 Andromeda kernel:   Interface: 0
Sep 12 12:53:44 Andromeda kernel:   Alternate Setting:  0
Sep 12 12:53:44 Andromeda kernel:     bLength             =    9
Sep 12 12:53:44 Andromeda kernel:     bDescriptorType     =   04
Sep 12 12:53:44 Andromeda kernel:     bInterfaceNumber    =   00
Sep 12 12:53:44 Andromeda kernel:     bAlternateSetting   =   00
Sep 12 12:53:44 Andromeda kernel:     bNumEndpoints       =   03
Sep 12 12:53:44 Andromeda kernel:     bInterface Class:SubClass:Protocol =   08:04:00
Sep 12 12:53:44 Andromeda kernel:     iInterface          =   00
Sep 12 12:53:44 Andromeda kernel:     Endpoint:
Sep 12 12:53:44 Andromeda kernel:       bLength             =    7
Sep 12 12:53:44 Andromeda kernel:       bDescriptorType     =   05
Sep 12 12:53:44 Andromeda kernel:       bEndpointAddress    =   81 (in)
Sep 12 12:53:44 Andromeda kernel:       bmAttributes        =   02 (Bulk)
Sep 12 12:53:44 Andromeda kernel:       wMaxPacketSize      = 0040
Sep 12 12:53:44 Andromeda kernel:       bInterval           =   00
Sep 12 12:53:44 Andromeda kernel:     Endpoint:
Sep 12 12:53:44 Andromeda kernel:       bLength             =    7
Sep 12 12:53:44 Andromeda kernel:       bDescriptorType     =   05
Sep 12 12:53:44 Andromeda kernel:       bEndpointAddress    =   02 (out)
Sep 12 12:53:44 Andromeda kernel:       bmAttributes        =   02 (Bulk)
Sep 12 12:53:44 Andromeda kernel:       wMaxPacketSize      = 0040
Sep 12 12:53:44 Andromeda kernel:       bInterval           =   00
Sep 12 12:53:44 Andromeda kernel:     Endpoint:
Sep 12 12:53:44 Andromeda kernel:       bLength             =    7
Sep 12 12:53:44 Andromeda kernel:       bDescriptorType     =   05
Sep 12 12:53:44 Andromeda kernel:       bEndpointAddress    =   83 (in)
Sep 12 12:53:44 Andromeda kernel:       bmAttributes        =   03 (Interrupt)
Sep 12 12:53:44 Andromeda kernel:       wMaxPacketSize      = 0002
Sep 12 12:53:44 Andromeda kernel:       bInterval           =   ff
Sep 12 12:53:44 Andromeda kernel: Initializing USB Mass Storage driver...
Sep 12 12:53:44 Andromeda kernel: usb.c: registered new driver usb-storage
Sep 12 12:53:44 Andromeda kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Sep 12 12:53:44 Andromeda kernel:   Vendor: TEAC      Model: FD-05PUB          Rev: 1026
Sep 12 12:53:44 Andromeda kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Sep 12 12:53:44 Andromeda kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Sep 12 12:53:44 Andromeda kernel: usb-uhci.c: interrupt, status 3, frame# 1860
Sep 12 12:53:44 Andromeda kernel: sda: Unit Not Ready, sense:
Sep 12 12:53:44 Andromeda kernel: Current 00:00: sense key Not Ready
Sep 12 12:53:44 Andromeda kernel: Additional sense indicates Medium not present
Sep 12 12:53:44 Andromeda kernel: sda : READ CAPACITY failed.
Sep 12 12:53:44 Andromeda kernel: sda : status = 1, message = 00, host = 0, driver = 08 
Sep 12 12:53:44 Andromeda kernel: Current sd00:00: sense key Not Ready
Sep 12 12:53:44 Andromeda kernel: Additional sense indicates Medium not present
Sep 12 12:53:44 Andromeda kernel: sda : block size assumed to be 512 bytes, disk size 1GB.  
Sep 12 12:53:44 Andromeda kernel:  sda: I/O error: dev 08:00, sector 0
Sep 12 12:53:44 Andromeda kernel:  I/O error: dev 08:00, sector 0
Sep 12 12:53:44 Andromeda kernel:  unable to read partition table
Sep 12 12:53:44 Andromeda kernel: USB Mass Storage support registered.
Sep 12 12:53:44 Andromeda kernel: EXT3 FS 2.4-0.9.19, 19 August 2002 on ide1(22,5), internal journal
Sep 12 12:53:44 Andromeda kernel: kjournald starting.  Commit interval 5 seconds
Sep 12 12:53:44 Andromeda kernel: EXT3 FS 2.4-0.9.19, 19 August 2002 on ide1(22,1), internal journal
Sep 12 12:53:44 Andromeda kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep 12 12:53:44 Andromeda kernel: hda: attached ide-cdrom driver.
Sep 12 12:53:44 Andromeda kernel: hda: ATAPI 24X CD-ROM drive, 128kB Cache, UDMA(33)
Sep 12 12:53:44 Andromeda kernel: Uniform CD-ROM driver Revision: 3.12
Sep 12 12:53:44 Andromeda kernel: hda: DMA disabled
Sep 12 12:53:44 Andromeda kernel: parport_pc: Via 686A parallel port disabled in BIOS
Sep 12 12:53:44 Andromeda kernel: eepro100.c:v1.09j-t 9/29/99 Donald Becker http://www.scyld.com/network/eepro100.html
Sep 12 12:53:44 Andromeda kernel: eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
Sep 12 12:53:44 Andromeda kernel: eth0: OEM i82557/i82558 10/100 Ethernet, 00:00:39:72:30:2F, IRQ 7.
Sep 12 12:53:44 Andromeda kernel:   Board assembly a32076-002, Physical connectors present: RJ45
Sep 12 12:53:44 Andromeda kernel:   Primary interface chip i82555 PHY #1.
Sep 12 12:53:44 Andromeda kernel:   General self-test: passed.
Sep 12 12:53:44 Andromeda kernel:   Serial sub-system self-test: passed.
Sep 12 12:53:44 Andromeda kernel:   Internal registers self-test: passed.
Sep 12 12:53:44 Andromeda kernel:   ROM checksum self-test: passed (0xb874c1d3).
Sep 12 12:53:44 Andromeda kernel: eth1: OEM i82557/i82558 10/100 Ethernet, 00:00:39:73:30:2F, IRQ 5.
Sep 12 12:53:44 Andromeda random: Initializing random number generator:  succeeded
Sep 12 12:53:44 Andromeda kernel:   Board assembly a32076-002, Physical connectors present: RJ45
Sep 12 12:53:44 Andromeda kernel:   Primary interface chip i82555 PHY #1.
Sep 12 12:53:44 Andromeda kernel:   General self-test: passed.
Sep 12 12:53:44 Andromeda kernel:   Serial sub-system self-test: passed.
Sep 12 12:53:44 Andromeda kernel:   Internal registers self-test: passed.
Sep 12 12:53:44 Andromeda kernel:   ROM checksum self-test: passed (0xb874c1d3).
Sep 12 12:53:44 Andromeda pcmcia: Starting PCMCIA services:
Sep 12 12:53:44 Andromeda pcmcia:  modules
Sep 12 12:53:44 Andromeda kernel: Linux Kernel Card Services 3.1.22
Sep 12 12:53:44 Andromeda kernel:   options:  [pci] [cardbus] [pm]
Sep 12 12:53:44 Andromeda kernel: PCI: No IRQ known for interrupt pin A of device 00:0c.0. Probably buggy MP table.
Sep 12 12:53:45 Andromeda kernel: ds: no socket drivers loaded!
Sep 12 12:53:45 Andromeda kernel: Yenta IRQ list 0008, PCI irq0
Sep 12 12:53:45 Andromeda kernel: Socket status: 30000007
Sep 12 12:53:45 Andromeda pcmcia: Hint: insmod errors can be caused by incorrect module parameters, including invalid IO or IRQ parameters
Sep 12 12:53:45 Andromeda pcmcia: /lib/modules/2.4.22-10smp/pcmcia/ds.o: init_module: Operation not permitted
Sep 12 12:53:45 Andromeda pcmcia:  cardmgr.
Sep 12 12:53:45 Andromeda cardmgr[708]: starting, version is 3.1.22
Sep 12 12:53:45 Andromeda rc: Starting pcmcia:  succeeded
Sep 12 12:53:45 Andromeda cardmgr[708]: config error, file './config.opts' line 8: no function bindings
Sep 12 12:53:45 Andromeda cardmgr[708]: no pcmcia driver in /proc/devices
Sep 12 12:53:45 Andromeda cardmgr[708]: exiting
Sep 12 12:53:45 Andromeda xinetd[727]: xinetd Version 2002.03.28 started with libwrap options compiled in.
Sep 12 12:53:45 Andromeda xinetd[727]: Started working: 2 available services
Sep 12 12:53:41 Andromeda sysctl: net.ipv4.conf.default.rp_filter = 1 
Sep 12 12:53:41 Andromeda sysctl: kernel.sysrq = 0 
Sep 12 12:53:41 Andromeda sysctl: kernel.core_uses_pid = 1 
Sep 12 12:53:41 Andromeda sysctl: vm.bdflush = 40^I0 0 0 3600 3000 60 0 0 
Sep 12 12:53:41 Andromeda network: Setting network parameters:  succeeded 
Sep 12 12:53:41 Andromeda network: Bringing up loopback interface:  succeeded 
Sep 12 12:53:48 Andromeda xinetd: xinetd startup succeeded
Sep 12 12:53:48 Andromeda gpm: gpm startup succeeded
Sep 12 12:53:48 Andromeda FreeWnn: Starting FreeWnn: 
Sep 12 12:53:48 Andromeda FreeWnn: ^[[60G[  
Sep 12 12:53:48 Andromeda FreeWnn: 
Sep 12 12:53:48 Andromeda rc: Starting FreeWnn:  succeeded
Sep 12 12:53:49 Andromeda xfs: xfs startup succeeded
Sep 12 12:53:49 Andromeda xfs: listening on port 7100 
Sep 12 12:53:49 Andromeda wine: Registering binary handler for Windows applications
Sep 12 12:53:49 Andromeda rc: Starting wine:  succeeded
Sep 12 12:53:50 Andromeda xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/cyrillic (unreadable) 
Sep 12 12:53:50 Andromeda xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/CID (unreadable) 
Sep 12 12:53:50 Andromeda xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/local (unreadable) 
Sep 12 12:53:50 Andromeda xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/latin2/Type1 (unreadable) 
Sep 12 12:53:54 Andromeda login(pam_unix)[846]: session opened for user root by LOGIN(uid=0)
Sep 12 12:53:54 Andromeda  -- root[846]: ROOT LOGIN ON tty1
Sep 12 12:54:11 Andromeda kernel: usb-uhci.c: interrupt, status 3, frame# 1994
Sep 12 12:54:11 Andromeda kernel: SCSI device sda: 2880 512-byte hdwr sectors (1 MB)
Sep 12 12:54:11 Andromeda kernel: sda: Write Protect is off
Sep 12 12:54:11 Andromeda kernel:  sda:<7>usb-storage: queuecommand() called
Sep 12 12:54:12 Andromeda kernel:  sda1 sda2 sda4
Sep 12 12:54:16 Andromeda kernel: usb.c: USB disconnect on device 00:07.2-1 address 2
Sep 12 12:54:16 Andromeda /sbin/hotplug: arguments (usb) env (PWD=/etc/hotplug DEVICE=/proc/bus/usb/001/002 INTERFACE=8/4/0 ACTION=remove DEBUG=kernel OLDPWD=/ DEVFS=/proc/bus/usb TYPE=0/0/0 SHLVL=1 HOME=/ PATH=/bin:/sbin:/usr/sbin:/usr/bin PRODUCT=644/0/0 _=/usr/bin/env)
Sep 12 12:54:16 Andromeda /sbin/hotplug: invoke /etc/hotplug/usb.agent ()

<dmesg>
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
usb-storage: Illegal Request: invalid field in CDB
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 00 00 00 08 00 82 f8
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 4096 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 4096/4096
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 00 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage: 00 00 00 00 00 00 00 00 00 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 00 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 13 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 14 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 15 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 16 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 17 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 18 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 19 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 1a 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 1b 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 1c 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 1d 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 1e 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 1f 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand() called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage: 28 00 00 00 00 20 00 00 01 00 00 00
usb-storage: Call to usb_stor_control_msg() returned 12
usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
usb-storage: usb_stor_bulk_msg() returned 0 xferred 512/512
usb-storage: usb_stor_transfer_partial(): transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: Current value of ip_waitq is: 0
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is 0
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: -- Current value of ip_waitq is: -1
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
hub.c: port 1, portstatus 110, change 3, 12 Mb/s
hub.c: port 1 connection change
hub.c: port 1, portstatus 110, change 3, 12 Mb/s
usb.c: USB disconnect on device 00:07.2-1 address 2
usb-storage: storage_disconnect() called
usb-storage: -- releasing irq URB
usb-storage: USB IRQ received for device on host 1
usb-storage: -- IRQ data length is 2
usb-storage: -- IRQ state is -2
usb-storage: -- Interrupt Status (0x0, 0x0)
usb-storage: ERROR: Unwanted interrupt received!
usb-storage: -- usb_unlink_urb() returned 0
usb-storage: -- releasing main URB
usb-storage: -- usb_unlink_urb() returned -19
usb.c: kusbd: /sbin/hotplug remove 2
hub.c: port 1, portstatus 103, change 0, 12 Mb/s
usb.c: ignoring set_interface for dev 2, iface 0, alt 0
hub.c: port 2, portstatus 100, change 0, 12 Mb/s
hub.c: port 1, portstatus 103, change 0, 12 Mb/s
hub.c: port 2, portstatus 100, change 0, 12 Mb/s

</proc/bus/devices>  It is in the state mounted without testing.
T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc= 12/900 us ( 1%), #Int=  1, #Iso=  0
D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 0.00
S:  Product=USB UHCI Root Hub
S:  SerialNumber=1080
C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0644 ProdID=0000 Rev= 0.00
S:  Manufacturer=TEAC    
S:  Product=TEAC FD-05PUB   
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=08(stor.) Sub=04 Prot=00 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

Thanks again,
Haruo
