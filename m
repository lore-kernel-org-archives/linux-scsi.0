From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Tue, 12 Aug 2003 03:28:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308120328.38835.gene.heskett@verizon.net>
References: <20030810224402.5c7fa063.rddunlap@osdl.org> <200308111729.04184.gene.heskett@verizon.net> <20030811143402.1df9184c.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mcJO/+srPSTWJbS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out001pub.verizon.net ([206.46.170.140]:24726 "EHLO
	out001.verizon.net") by vger.kernel.org with ESMTP id S275092AbTHLH2q
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 03:28:46 -0400
In-Reply-To: <20030811143402.1df9184c.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, willy@debian.org


--Boundary-00=_mcJO/+srPSTWJbS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 11 August 2003 17:34, Randy.Dunlap wrote:
>On Mon, 11 Aug 2003 17:29:04 -0400 Gene Heskett 
<gene.heskett@verizon.net> wrote:
>| On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
>| >Gene,
>| >
>| >This patch should make the advansys driver build on 2.6.0-test3
>| >after you #define ADVANSYS_DEBUG so that run-time debug output
>| >can be generated.
>| >
>| >--
>|
>| Ok Randy, I have some logs, stripped down to about 1650 lines from
>| just under half a million.
>|
>| Should I send them privately?
>
>How many bytes?  If <= roughly 60 KB, I'd say just post them here.

I've done some more trimming, taking it down to a single bootup as a 
module, and its now 58k, so its attached.

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

--Boundary-00=_mcJO/+srPSTWJbS
Content-Type: text/plain;
  charset="us-ascii";
  name="massages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="massages"

[lockup total crash as I exited X, *&%$#^&nvidia driver is a POS]
[This reboot has the advansys as a module, and ide-scsi was put back in]
Aug 11 11:30:38 coyote syslogd 1.4.1: restart.
Aug 11 11:30:38 coyote syslog: syslogd startup succeeded
Aug 11 11:30:38 coyote kernel: klogd 1.4.1, log source = /proc/kmsg started.
Aug 11 11:30:38 coyote kernel: Linux version 2.6.0-test3 (root@coyote.coyote.den) (gcc version 3.2 20020903 (Red Hat Linux 8.0 3.2-7)) #8 Mon Aug 11 10:24:48 EDT 2003
Aug 11 11:30:38 coyote kernel: Video mode to be used for restore is ffff
Aug 11 11:30:38 coyote kernel: BIOS-provided physical RAM map:
Aug 11 11:30:38 coyote kernel:  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
Aug 11 11:30:38 coyote kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Aug 11 11:30:38 coyote kernel:  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
Aug 11 11:30:38 coyote kernel:  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Aug 11 11:30:38 coyote kernel:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Aug 11 11:30:38 coyote kernel:  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Aug 11 11:30:38 coyote kernel: 512MB LOWMEM available.
Aug 11 11:30:38 coyote kernel: On node 0 totalpages: 131072
Aug 11 11:30:38 coyote syslog: klogd startup succeeded
Aug 11 11:30:38 coyote kernel:   DMA zone: 4096 pages, LIFO batch:1
Aug 11 11:30:38 coyote kernel:   Normal zone: 126976 pages, LIFO batch:16
Aug 11 11:30:38 coyote portmap: portmap startup succeeded
Aug 11 11:30:38 coyote kernel:   HighMem zone: 0 pages, LIFO batch:1
Aug 11 11:30:38 coyote kernel: Building zonelist for node : 0
Aug 11 11:30:38 coyote keytable: Loading keymap:
Aug 11 11:30:38 coyote kernel: Kernel command line: ro root=/dev/hda3 hdc=ide-scsi
Aug 11 11:30:39 coyote keytable:
Aug 11 11:30:39 coyote kernel: ide_setup: hdc=ide-scsi
Aug 11 11:30:39 coyote keytable:
Aug 11 11:30:39 coyote kernel: Found and enabled local APIC!
Aug 11 11:30:39 coyote rc: Starting keytable:  succeeded
Aug 11 11:30:39 coyote kernel: Initializing CPU#0
Aug 11 11:30:39 coyote kernel: PID hash table entries: 4096 (order 12: 32768 bytes)
Aug 11 11:30:39 coyote random: Initializing random number generator:  succeeded
Aug 11 11:30:39 coyote kernel: Detected 1399.913 MHz processor.
Aug 11 11:30:39 coyote kernel: Console: colour VGA+ 80x25
Aug 11 11:30:39 coyote kernel: Calibrating delay loop... 2752.51 BogoMIPS
Aug 11 11:30:39 coyote kernel: Memory: 514652k/524288k available (2338k kernel code, 8892k reserved, 925k data, 168k init, 0k highmem)
Aug 11 11:30:39 coyote kernel: Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Aug 11 11:30:39 coyote kernel: Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Aug 11 11:30:39 coyote kernel: Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
Aug 11 11:30:39 coyote kernel: -> /dev
Aug 11 11:30:39 coyote kernel: -> /dev/console
Aug 11 11:30:39 coyote kernel: -> /root
Aug 11 11:30:39 coyote kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Aug 11 11:30:39 coyote kernel: CPU: L2 Cache: 256K (64 bytes/line)
Aug 11 11:30:39 coyote kernel: CPU: AMD Athlon(tm) XP 1600+ stepping 02
Aug 11 11:30:39 coyote kernel: Enabling fast FPU save and restore... done.
Aug 11 11:30:39 coyote kernel: Enabling unmasked SIMD FPU exception support... done.
Aug 11 11:30:39 coyote kernel: Checking 'hlt' instruction... OK.
Aug 11 11:30:39 coyote netfs: Mounting other filesystems:  succeeded
Aug 11 11:30:39 coyote kernel: POSIX conformance testing by UNIFIX
Aug 11 11:30:39 coyote kernel: enabled ExtINT on CPU#0
Aug 11 11:30:39 coyote kernel: ESR value before enabling vector: 00000000
Aug 11 11:30:39 coyote kernel: ESR value after enabling vector: 00000000
Aug 11 11:30:39 coyote kernel: Using local APIC timer interrupts.
Aug 11 11:30:39 coyote kernel: calibrating APIC timer ...
Aug 11 11:30:39 coyote kernel: ..... CPU clock speed is 1399.0481 MHz.
Aug 11 11:30:39 coyote kernel: ..... host bus clock speed is 266.0568 MHz.
Aug 11 11:30:39 coyote rc: Starting lm_sensors:  succeeded
Aug 11 11:30:39 coyote kernel: Initializing RT netlink socket

[what is this?, I've been looking at it for years]
Aug 11 11:30:39 coyote kernel: spurious 8259A interrupt: IRQ7.

Aug 11 11:30:39 coyote kernel: PCI: PCI BIOS revision 2.10 entry at 0xfb4e0, last bus=1
Aug 11 11:30:39 coyote kernel: PCI: Using configuration type 1
Aug 11 11:30:39 coyote kernel: mtrr: v2.0 (20020519)
Aug 11 11:30:39 coyote kernel: BIO: pool of 256 setup, 15Kb (60 bytes/bio)
Aug 11 11:30:39 coyote kernel: biovec pool[0]:   1 bvecs: 256 entries (12 bytes)
Aug 11 11:30:39 coyote autofs: automount startup succeeded
Aug 11 11:30:39 coyote kernel: biovec pool[1]:   4 bvecs: 256 entries (48 bytes)
Aug 11 11:30:39 coyote kernel: biovec pool[2]:  16 bvecs: 256 entries (192 bytes)
Aug 11 11:30:39 coyote kernel: biovec pool[3]:  64 bvecs: 256 entries (768 bytes)
Aug 11 11:30:39 coyote kernel: biovec pool[4]: 128 bvecs: 256 entries (1536 bytes)
Aug 11 11:30:39 coyote kernel: biovec pool[5]: 256 bvecs: 256 entries (3072 bytes)
Aug 11 11:30:39 coyote sshd: Starting sshd:
Aug 11 11:30:39 coyote kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Aug 11 11:30:39 coyote kernel: PnPBIOS: Scanning system for PnP BIOS support...
Aug 11 11:30:39 coyote kernel: PnPBIOS: Found PnP BIOS installation structure at 0xc00fbf40
Aug 11 11:30:39 coyote kernel: PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbf70, dseg 0xf0000
Aug 11 11:30:39 coyote kernel: PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
Aug 11 11:30:40 coyote kernel: SCSI subsystem initialized
Aug 11 11:30:40 coyote kernel: drivers/usb/core/usb.c: registered new driver usbfs
Aug 11 11:30:40 coyote kernel: drivers/usb/core/usb.c: registered new driver hub
Aug 11 11:30:40 coyote kernel: PCI: Probing PCI hardware
Aug 11 11:30:40 coyote kernel: PCI: Probing PCI hardware (bus 00)
Aug 11 11:30:40 coyote kernel: PCI: Using IRQ router default [1106/3099] at 0000:00:00.0
Aug 11 11:30:40 coyote kernel: rivafb: nVidia device/chipset 10DE0111
Aug 11 11:30:40 coyote kernel: rivafb: Detected CRTC controller 0 being used
Aug 11 11:30:40 coyote kernel: rivafb: RIVA MTRR set to ON
Aug 11 11:30:40 coyote kernel: rivafb: PCI nVidia NV10 framebuffer ver 0.9.5b (nVidiaGeForce2-M, 32MB @ 0xE0000000)
Aug 11 11:30:40 coyote kernel: Console: switching to colour frame buffer device 80x30
Aug 11 11:30:40 coyote kernel: pty: 256 Unix98 ptys configured
Aug 11 11:30:40 coyote kernel: apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
Aug 11 11:30:40 coyote kernel: Journalled Block Device driver loaded
Aug 11 11:30:40 coyote kernel: udf: registering filesystem
Aug 11 11:30:40 coyote kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Aug 11 11:30:40 coyote kernel: isapnp: Scanning for PnP cards...
Aug 11 11:30:40 coyote kernel: isapnp: No Plug & Play device found
Aug 11 11:30:40 coyote kernel: lp: driver loaded but no devices found
Aug 11 11:30:40 coyote kernel: ipmi: message handler initialized
Aug 11 11:30:40 coyote kernel: ipmi: device interface at char major 254
Aug 11 11:30:40 coyote kernel: Serial: 8250/16550 driver $Revision: 1.90 $ IRQ sharing enabled
Aug 11 11:30:40 coyote kernel: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug 11 11:30:40 coyote kernel: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Aug 11 11:30:40 coyote kernel: parport0: PC-style at 0x378 [PCSPP,TRISTATE,EPP]
Aug 11 11:30:40 coyote kernel: parport0: irq 7 detected
Aug 11 11:30:40 coyote sshd:  succeeded
Aug 11 11:30:40 coyote sshd:
Aug 11 11:30:40 coyote kernel: lp0: using parport0 (polling).
Aug 11 11:30:40 coyote rc: Starting sshd:  succeeded
Aug 11 11:30:40 coyote kernel: Using anticipatory scheduling elevator
Aug 11 11:30:40 coyote kernel: Floppy drive(s): fd0 is 1.44M
Aug 11 11:30:40 coyote kernel: FDC 0 is a post-1991 82077
Aug 11 11:30:40 coyote kernel: loop: loaded (max 8 devices)
Aug 11 11:30:40 coyote kernel: 8139too Fast Ethernet driver 0.9.26
Aug 11 11:30:40 coyote kernel: eth0: D-Link DFE-538TX (RealTek RTL8139) at 0xe3823000, 00:50:ba:5d:eb:7d, IRQ 12
Aug 11 11:30:40 coyote kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Aug 11 11:30:40 coyote kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Aug 11 11:30:40 coyote kernel: VP_IDE: IDE controller at PCI slot 0000:00:11.1
Aug 11 11:30:40 coyote kernel: VP_IDE: chipset revision 6
Aug 11 11:30:40 coyote kernel: VP_IDE: not 100%% native mode: will probe irqs later
Aug 11 11:30:40 coyote kernel: VP_IDE: VIA vt8233 (rev 00) IDE UDMA100 controller on pci0000:00:11.1
Aug 11 11:30:40 coyote kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:DMA, hdb:pio
Aug 11 11:30:40 coyote kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings: hdc:DMA, hdd:DMA
Aug 11 11:30:40 coyote kernel: hda: Maxtor 54610H6, ATA DISK drive
Aug 11 11:30:40 coyote kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Aug 11 11:30:40 coyote kernel: hdc: CREATIVE CD-RW RW1210E, ATAPI CD/DVD-ROM drive
Aug 11 11:30:40 coyote kernel: hdd: Maxtor 6Y060L0, ATA DISK drive
Aug 11 11:30:40 coyote kernel: ide1 at 0x170-0x177,0x376 on irq 15
Aug 11 11:30:40 coyote kernel: hda: max request size: 128KiB
Aug 11 11:30:40 coyote kernel: hda: 90045648 sectors (46103 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
Aug 11 11:30:40 coyote kernel:  hda: hda1 hda2 hda3 hda4
Aug 11 11:30:40 coyote kernel: hdd: max request size: 128KiB
Aug 11 11:30:38 coyote network: Bringing up interface eth0:  succeeded
Aug 11 11:30:40 coyote kernel: hdd: 120103200 sectors (61492 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
Aug 11 11:30:40 coyote kernel:  hdd: hdd1 hdd2 hdd3 hdd4 < hdd5 hdd6 hdd7 hdd8 >
Aug 11 11:30:40 coyote kernel: scsi0 : SCSI host adapter emulation for IDE ATAPI devices
Aug 11 11:30:40 coyote kernel:   Vendor: CREATIVE  Model: CD-RW RW1210E     Rev: LCS6
Aug 11 11:30:40 coyote kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Aug 11 11:30:40 coyote kernel: st: Version 20030622, fixed bufsize 32768, s/g segs 256
Aug 11 11:30:40 coyote kernel: Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 5
Aug 11 11:30:40 coyote kernel: Console: switching to colour frame buffer device 80x30
Aug 11 11:30:40 coyote kernel: drivers/usb/host/uhci-hcd.c: USB Universal Host Controller Interface driver v2.1
Aug 11 11:30:40 coyote kernel: uhci-hcd 0000:00:11.2: UHCI Host Controller
Aug 11 11:30:40 coyote kernel: uhci-hcd 0000:00:11.2: irq 9, io base 0000dc00
Aug 11 11:30:40 coyote kernel: uhci-hcd 0000:00:11.2: new USB bus registered, assigned bus number 1
Aug 11 11:30:40 coyote kernel: hub 1-0:0: USB hub found
Aug 11 11:30:40 coyote kernel: hub 1-0:0: 2 ports detected
Aug 11 11:30:40 coyote kernel: uhci-hcd 0000:00:11.3: UHCI Host Controller
Aug 11 11:30:40 coyote kernel: uhci-hcd 0000:00:11.3: irq 9, io base 0000e000
Aug 11 11:30:40 coyote kernel: uhci-hcd 0000:00:11.3: new USB bus registered, assigned bus number 2
Aug 11 11:30:41 coyote kernel: hub 2-0:0: USB hub found
Aug 11 11:30:41 coyote kernel: hub 2-0:0: 2 ports detected
Aug 11 11:30:41 coyote kernel: uhci-hcd 0000:00:11.4: UHCI Host Controller
Aug 11 11:30:41 coyote kernel: uhci-hcd 0000:00:11.4: irq 9, io base 0000e400
Aug 11 11:30:41 coyote kernel: uhci-hcd 0000:00:11.4: new USB bus registered, assigned bus number 3
Aug 11 11:30:41 coyote kernel: hub 3-0:0: USB hub found
Aug 11 11:30:41 coyote kernel: hub 3-0:0: 2 ports detected
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver usblp
Aug 11 11:30:41 coyote kernel: drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Aug 11 11:30:41 coyote kernel: Initializing USB Mass Storage driver...
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver usb-storage
Aug 11 11:30:41 coyote kernel: USB Mass Storage support registered.
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver hiddev
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver hid
Aug 11 11:30:41 coyote kernel: drivers/usb/input/hid-core.c: v2.0:USB HID core driver
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver usbscanner
Aug 11 11:30:41 coyote kernel: drivers/usb/image/scanner.c: 0.4.14:USB Scanner Driver
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver usbserial
Aug 11 11:30:41 coyote kernel: drivers/usb/serial/usb-serial.c: USB Serial Driver core v2.0
Aug 11 11:30:41 coyote kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for PL-2303
Aug 11 11:30:41 coyote kernel: drivers/usb/core/usb.c: registered new driver pl2303
Aug 11 11:30:41 coyote kernel: drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver v0.10
Aug 11 11:30:41 coyote kernel: mice: PS/2 mouse device common for all mice
Aug 11 11:30:41 coyote kernel: input: PC Speaker
Aug 11 11:30:41 coyote kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 11 11:30:41 coyote kernel: input: AT Set 2 keyboard on isa0060/serio0
Aug 11 11:30:41 coyote kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 11 11:30:41 coyote kernel: i2c /dev entries driver module version 2.7.0 (20021208)
Aug 11 11:30:41 coyote kernel: btaudio: driver version 0.7 loaded [digital+analog]
Aug 11 11:30:41 coyote kernel: btaudio: Bt878 (rev 17) at 00:09.1, irq: 5, latency: 32, mmio: 0xef005000
Aug 11 11:30:41 coyote kernel: btaudio: using card config "default"
Aug 11 11:30:41 coyote kernel: btaudio: registered device dsp0 [digital]
Aug 11 11:30:41 coyote kernel: btaudio: registered device dsp1 [analog]
Aug 11 11:30:41 coyote kernel: btaudio: registered device mixer0
Aug 11 11:30:41 coyote kernel: Advanced Linux Sound Architecture Driver Version 0.9.6 (Mon Jul 28 11:08:42 2003 UTC).
Aug 11 11:30:41 coyote kernel: hub 3-0:0: debounce: port 2: delay 100ms stable 4 status 0x101
Aug 11 11:30:41 coyote kernel: hub 3-0:0: new USB device on port 2, assigned address 2
Aug 11 11:30:41 coyote kernel: hub 3-2:0: USB hub found
Aug 11 11:30:41 coyote kernel: hub 3-2:0: 4 ports detected
Aug 11 11:30:41 coyote kernel: ALSA device list:
Aug 11 11:30:41 coyote kernel:   #0: Virtual MIDI Card 1
Aug 11 11:30:41 coyote kernel:   #1: VIA 8233-Pre at 0xe800, irq 12
Aug 11 11:30:41 coyote kernel: NET4: Linux TCP/IP 1.0 for NET4.0
Aug 11 11:30:41 coyote kernel: hub 3-2:0: debounce: port 1: delay 100ms stable 4 status 0x101
Aug 11 11:30:41 coyote kernel: IP: routing cache hash table of 4096 buckets, 32Kbytes
Aug 11 11:30:41 coyote kernel: TCP: Hash tables configured (established 131072 bind 65536)
Aug 11 11:30:41 coyote kernel: NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
Aug 11 11:30:41 coyote kernel: hub 3-2:0: new USB device on port 1, assigned address 3
Aug 11 11:30:41 coyote kernel: EXT3-fs: INFO: recovery required on readonly filesystem.
Aug 11 11:30:41 coyote kernel: EXT3-fs: write access will be enabled during recovery.
Aug 11 11:30:41 coyote kernel: drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
Aug 11 11:30:41 coyote kernel: kjournald starting.  Commit interval 5 seconds
Aug 11 11:30:41 coyote kernel: EXT3-fs: recovery complete.
Aug 11 11:30:41 coyote kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 11 11:30:41 coyote kernel: VFS: Mounted root (ext3 filesystem) readonly.
Aug 11 11:30:41 coyote kernel: Freeing unused kernel memory: 168k freed
Aug 11 11:30:41 coyote kernel: hub 3-2:0: debounce: port 2: delay 100ms stable 4 status 0x101
Aug 11 11:30:41 coyote kernel: hub 3-2:0: new USB device on port 2, assigned address 4
Aug 11 11:30:41 coyote kernel: pl2303 3-2.2:0: PL-2303 converter detected
Aug 11 11:30:41 coyote kernel: usb 3-2.2: PL-2303 converter now attached to ttyUSB0 (or usb/tts/0 for devfs)
Aug 11 11:30:41 coyote kernel: hub 3-2:0: debounce: port 4: delay 100ms stable 4 status 0x101
Aug 11 11:30:41 coyote kernel: hub 3-2:0: new USB device on port 4, assigned address 5
Aug 11 11:30:41 coyote kernel: hub 2-0:0: debounce: port 2: delay 100ms stable 4 status 0x101
Aug 11 11:30:41 coyote kernel: hub 2-0:0: new USB device on port 2, assigned address 2
Aug 11 11:30:41 coyote kernel: drivers/usb/image/scanner.c: USB scanner device (0x04b8/0x010f) now attached to usb/scanner0
Aug 11 11:30:41 coyote kernel: hub 1-0:0: debounce: port 1: delay 100ms stable 4 status 0x301
Aug 11 11:30:41 coyote kernel: hub 1-0:0: new USB device on port 1, assigned address 2
Aug 11 11:30:41 coyote kernel: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:11.2-1
Aug 11 11:30:41 coyote kernel: hub 1-0:0: debounce: port 2: delay 100ms stable 4 status 0x101
Aug 11 11:30:41 coyote kernel: hub 1-0:0: new USB device on port 2, assigned address 3
Aug 11 11:30:41 coyote kernel: drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
Aug 11 11:30:41 coyote kernel: EXT3 FS on hda3, internal journal
Aug 11 11:30:41 coyote kernel: Adding 3857104k swap on /dev/hda4.  Priority:-1 extents:1
Aug 11 11:30:41 coyote kernel: kjournald starting.  Commit interval 5 seconds
Aug 11 11:30:41 coyote kernel: EXT3 FS on hda1, internal journal
Aug 11 11:30:41 coyote kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 11 11:30:41 coyote kernel: kjournald starting.  Commit interval 5 seconds
Aug 11 11:30:41 coyote kernel: EXT3 FS on hdd7, internal journal
Aug 11 11:30:41 coyote kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 11 11:30:41 coyote kernel: kjournald starting.  Commit interval 5 seconds
Aug 11 11:30:41 coyote kernel: EXT3 FS on hdd8, internal journal
Aug 11 11:30:41 coyote kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 11 11:30:41 coyote kernel: kjournald starting.  Commit interval 5 seconds
Aug 11 11:30:41 coyote kernel: EXT3 FS on hdd6, internal journal
Aug 11 11:30:41 coyote kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 11 11:30:41 coyote kernel: kjournald starting.  Commit interval 5 seconds
Aug 11 11:30:41 coyote kernel: EXT3 FS on hdd5, internal journal
Aug 11 11:30:41 coyote kernel: EXT3-fs: mounted filesystem with ordered data mode.
[another oddity, kudzu finds a generic 3 button phantom mouse at every 2.6 boot]
Aug 11 11:30:41 coyote kernel: updfstab: numerical sysctl 1 23 is obsolete.
Aug 11 11:30:41 coyote kernel: kudzu: numerical sysctl 1 23 is obsolete.
Aug 11 11:30:41 coyote kernel: eth0: Setting 100mbps full-duplex based on auto-negotiated partner ability 45e1.
Aug 11 11:30:42 coyote xinetd[782]: xinetd Version 2.3.11 started with libwrap loadavg options compiled in.
Aug 11 11:30:42 coyote xinetd[782]: Started working: 9 available services
Aug 11 11:30:43 coyote xinetd: xinetd startup succeeded
Aug 11 11:30:43 coyote asmb: Starting share gene:
Aug 11 11:30:44 coyote asmb: Starting share dlds:
Aug 11 11:30:44 coyote rc: Starting asmb:  succeeded
Aug 11 11:30:45 coyote sendmail: sendmail startup succeeded
Aug 11 11:30:45 coyote sendmail: sm-client startup succeeded
Aug 11 11:30:45 coyote gpm: gpm startup succeeded
Aug 11 11:30:49 coyote httpd: httpd startup succeeded
Aug 11 11:30:49 coyote canna: cannaserver startup failed
[the above is a crapshoot, sometimes it works, sometimes it fails but only for 2.6.x]
Aug 11 11:30:50 coyote crond: crond startup succeeded
Aug 11 11:30:51 coyote xfs: listening on port 7100
Aug 11 11:30:51 coyote xfs: xfs startup succeeded
Aug 11 11:30:52 coyote smb: smbd startup succeeded
Aug 11 11:30:52 coyote xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/CID (unreadable)
Aug 11 11:30:52 coyote xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/local (unreadable)
Aug 11 11:30:52 coyote xfs: ignoring font path element /usr/X11R6/lib/X11/fonts/latin2/Type1 (unreadable)
Aug 11 11:30:52 coyote xfs: ignoring font path element /usr/share/fonts/default/TrueType (unreadable)
Aug 11 11:30:52 coyote smb: nmbd startup succeeded
Aug 11 11:30:52 coyote vncserver: Starting VNC server:
Aug 11 11:30:52 coyote vncserver: vncserver startup succeeded
Aug 11 11:30:52 coyote vncserver: ^[[60G
Aug 11 11:30:52 coyote vncserver:
Aug 11 11:30:52 coyote rc: Starting vncserver:  succeeded
Aug 11 11:30:52 coyote anacron: anacron startup succeeded
Aug 11 11:30:52 coyote atd: atd startup succeeded
Aug 11 11:30:52 coyote wine: Registering binary handler for Windows applications
Aug 11 11:30:52 coyote wine: /etc/rc3.d/S98wine: line 16: /proc/sys/fs/binfmt_misc/register: No such file or directory
Aug 11 11:30:52 coyote wine: /etc/rc3.d/S98wine: line 17: /proc/sys/fs/binfmt_misc/register: No such file or directory
Aug 11 11:30:52 coyote rc: Starting wine:  succeeded
Aug 11 11:30:52 coyote bulldog: Bulldog Plus : Copyright (c) 2001, Belkin Components.
Aug 11 11:30:52 coyote bulldog: Starting upsd ...
Aug 11 11:30:52 coyote bulldog: done.
Aug 11 11:30:52 coyote rc: Starting bulldog:  succeeded
Aug 11 11:30:56 coyote cups: ^[[60G
Aug 11 11:30:56 coyote cups: cups: started scheduler.
Aug 11 11:30:56 coyote rc: Starting cups:  succeeded
Aug 11 11:30:57 coyote rc: Starting linuxconf-setup:  succeeded
Aug 11 11:30:57 coyote heyu_relay: relay setting up-
Aug 11 11:31:03 coyote kernel: No module found in object
Aug 11 11:31:11 coyote kernel: warning: process `update' used the obsolete bdflush system call
Aug 11 11:31:11 coyote kernel: Fix your initscripts?
Aug 11 11:31:16 coyote kernel: warning: process `update' used the obsolete bdflush system call
Aug 11 11:31:16 coyote kernel: Fix your initscripts?
Aug 11 13:46:35 coyote login(pam_unix)[1266]: session opened for user root by LOGIN(uid=0)
Aug 11 13:46:35 coyote  -- root[1266]: ROOT LOGIN ON tty1
[ console, "modprobe advansys" ]
Aug 11 13:48:21 coyote kernel: advansys_detect: begin
Aug 11 13:48:21 coyote kernel: advansys_detect: bus search type 0 (ASC_IS_ISA)
Aug 11 13:48:21 coyote kernel: advansys_detect: asc_board_count 0
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x100
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x100) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x110
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x110) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x120
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x120) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x130
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x130) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x140
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x140) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x150
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x150) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x190
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x190) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x210
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x210) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x230
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x230) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x250
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x250) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x330
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x330) 0x80
Aug 11 13:48:21 coyote kernel: advansys_detect: iop 0x0
Aug 11 13:48:21 coyote kernel: advansys_detect: bus search type 1 (ASC_IS_VL)
Aug 11 13:48:21 coyote kernel: advansys_detect: asc_board_count 0
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x100
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x100) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x110
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x110) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x120
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x120) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x130
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x130) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x140
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x140) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x150
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x150) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x190
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x190) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x210
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x210) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x230
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x230) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x250
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x250) 0xff
Aug 11 13:48:21 coyote kernel: AscSearchIOPortAddr11: probing I/O port 0x330
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0x330) 0x80
Aug 11 13:48:21 coyote kernel: advansys_detect: iop 0x0
Aug 11 13:48:21 coyote kernel: advansys_detect: bus search type 2 (ASC_IS_EISA)
Aug 11 13:48:21 coyote kernel: advansys_detect: asc_board_count 0
Aug 11 13:48:21 coyote kernel: advansys_detect: iop 0x0
Aug 11 13:48:21 coyote kernel: advansys_detect: bus search type 3 (ASC_IS_PCI)
Aug 11 13:48:21 coyote kernel: advansys_detect: asc_board_count 0
Aug 11 13:48:21 coyote kernel: advansys_detect: devfn 64, bus number 0
Aug 11 13:48:21 coyote kernel: advansys_detect: vendorID 10CD, deviceID 1300
Aug 11 13:48:21 coyote kernel: advansys_detect: iop D000, irqLine 11
Aug 11 13:48:21 coyote kernel: advansys_detect: iop 0xd000
Aug 11 13:48:21 coyote kernel: advansys_detect: scsi_register()
Aug 11 13:48:21 coyote kernel: advansys_detect: narrow board
Aug 11 13:48:21 coyote kernel: advansys_detect: AscInitGetConfig()
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0xd000) 0x25
Aug 11 13:48:21 coyote kernel: AscFindSignature: AscGetChipSignatureWord(0xd000) 0x4c1
Aug 11 13:48:21 coyote kernel: AscInitFromEEP: chksum 0x4470
Aug 11 13:48:22 coyote kernel: AscInitFromEEP: eep_config->chksum 0x4470
Aug 11 13:48:22 coyote kernel: advansys_detect: AscInitSetConfig()
Aug 11 13:48:22 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0xd000) 0x25
Aug 11 13:48:22 coyote kernel: AscFindSignature: AscGetChipSignatureWord(0xd000) 0x4c1
Aug 11 13:48:22 coyote kernel: advansys_detect: sg_tablesize: 255
Aug 11 13:48:22 coyote kernel: advansys_detect: request_region port 0xd000, len 0x10
Aug 11 13:48:22 coyote kernel: advansys_detect: request_irq() 11
Aug 11 13:48:22 coyote kernel: advansys_detect: AscInitAsc1000Driver()
Aug 11 13:48:25 coyote kernel: AscFindSignature: AscGetChipSignatureByte(0xd000) 0x25
Aug 11 13:48:25 coyote kernel: AscFindSignature: AscGetChipSignatureWord(0xd000) 0x4c1
Aug 11 13:48:25 coyote kernel: AscInitAsc1000Driver: _asc_mcode_chksum 0x12c453f
Aug 11 13:48:25 coyote kernel: AscLoadMicroCode: chksum 0x12c453f
Aug 11 13:48:25 coyote kernel: AscLoadMicroCode: mcode_chksum 0xa240
Aug 11 13:48:25 coyote kernel: Scsi_Host at addr 0xc0d95000
Aug 11 13:48:25 coyote kernel:  host_busy 0, host_no 1, last_reset 0,
Aug 11 13:48:25 coyote kernel:  hostt 0xe3aaf5a0
Aug 11 13:48:25 coyote kernel:  base 0x0, io_port 0xd000, n_io_port 16, irq 0xb,
Aug 11 13:48:25 coyote kernel:  dma_channel 255, this_id 7, can_queue 240,
Aug 11 13:48:25 coyote kernel:  cmd_per_lun 1, sg_tablesize 255, unchecked_isa_dma 0
Aug 11 13:48:25 coyote kernel: ASC_DVC_VAR at addr 0xc0d951b8
Aug 11 13:48:25 coyote kernel:  iop_base 0xd000, err_code 0x0, dvc_cntl 0xffff, bug_fix_cntl 0,
Aug 11 13:48:25 coyote kernel:  bus_type 260, isr_callback 0xe3a9df00, exe_callback 0x0, init_sdtr 0x0,
Aug 11 13:48:25 coyote kernel:  sdtr_done 0x0, use_tagged_qng 0x0, unit_not_ready 0x0, chip_no 0x0,
Aug 11 13:48:25 coyote kernel:  queue_full_or_busy 0x0, start_motor 0x0, scsi_reset_wait 3,
Aug 11 13:48:25 coyote kernel:  is_in_int 0, max_total_qng 240, cur_total_qng 0, in_critical_cnt 0,
Aug 11 13:48:25 coyote kernel:  last_q_shortage 0, init_state 0x3f, no_scam 0x0, pci_fix_asyn_xfer 0x0,
Aug 11 13:48:25 coyote kernel:  cfg 0xc0d9525c, irq_no 0xb
Aug 11 13:48:25 coyote kernel: ASC_DVC_CFG at addr 0xc0d9525c
Aug 11 13:48:25 coyote kernel:  can_tagged_qng 0x0, cmd_qng_enabled 0xff,
Aug 11 13:48:25 coyote kernel:  disc_enable 0xff, sdtr_enable 0xff,
Aug 11 13:48:25 coyote kernel:  chip_scsi_id 7, isa_dma_speed 4, isa_dma_channel 0, chip_version 11,
Aug 11 13:48:25 coyote kernel:  pci_device_id 4864, lib_serial_no 123, lib_version 280, mcode_date 0x12c3,
Aug 11 13:48:25 coyote kernel:  mcode_version 1293, overrun_buf 0xe3aaecc0
Aug 11 13:48:25 coyote kernel: advansys_detect: asc_board_count 1
Aug 11 13:48:25 coyote kernel: advansys_detect: iop 0x0
Aug 11 13:48:25 coyote kernel: advansys_detect: done: asc_board_count 1
Aug 11 13:48:25 coyote kernel: advansys_info: begin
Aug 11 13:48:25 coyote kernel: advansys_info: end
[version string needs fixed, no way to tell its been patched by this]
Aug 11 13:48:25 coyote kernel: scsi1 : AdvanSys SCSI 3.3GJ: PCI Ultra: IO 0xD000-0xD00F, IRQ 0xB
Aug 11 13:48:25 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:25 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:25 coyote kernel:  target_ix 0x0, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:25 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:25 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:25 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:25 coyote kernel:  12000000 2400
Aug 11 13:48:25 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:25 coyote kernel:  00000100 0000803E D9002400 00003C8D D9004000 0000808C D9000000 06000000
Aug 11 13:48:25 coyote kernel:  0000
Aug 11 13:48:25 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:25 coyote kernel: asc_enqueue: new q_max_cnt[0] 1
Aug 11 13:48:25 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:25 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:25 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:25 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:25 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:25 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:25 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:25 coyote kernel:  808CD900 00000600 0000AAE3 04110000
Aug 11 13:48:25 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdaabfed4
Aug 11 13:48:25 coyote kernel: ASC_QDONE_INFO at addr 0xdaabfed4
Aug 11 13:48:25 coyote kernel:  srb_ptr 0xd98c80, target_ix 0, cdb_len 6, tag_code 0,
Aug 11 13:48:25 coyote kernel:  done_stat 0x4, host_stat 0x11, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:25 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:25 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:25 coyote kernel:  12000000 2400
Aug 11 13:48:25 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:25 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:25 coyote kernel: asc_rmqueue: new q_min_tim[0] 226
Aug 11 13:48:25 coyote kernel: asc_rmqueue: new q_max_tim[0] 226
Aug 11 13:48:25 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:25 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:25 coyote kernel: asc_isr_callback: host_stat 0x11
Aug 11 13:48:25 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:25 coyote kernel: asc_enqueue: new q_max_cnt[0] 1
Aug 11 13:48:25 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:25 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:25 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:25 coyote kernel: asc_dequeue_list: new q_min_tim[0] 0
Aug 11 13:48:25 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:25 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:25 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:25 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:25 coyote kernel: advansys_interrupt: end
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:26 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:26 coyote kernel:  target_ix 0x1, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:26 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:26 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:26 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:26 coyote kernel:  12000000 2400
Aug 11 13:48:26 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:26 coyote kernel:  00000200 0000803E D9002400 00003C8D D9004000 0000808C D9000100 06000000
Aug 11 13:48:26 coyote kernel:  0000
Aug 11 13:48:26 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:26 coyote kernel: asc_enqueue: new q_max_cnt[1] 1
Aug 11 13:48:26 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:26 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:26 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:26 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:26 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:26 coyote kernel:  808CD900 01000600 0000AAE3 01000000
Aug 11 13:48:26 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdac03c4c
Aug 11 13:48:26 coyote kernel: ASC_QDONE_INFO at addr 0xdac03c4c
Aug 11 13:48:26 coyote kernel:  srb_ptr 0xd98c80, target_ix 1, cdb_len 6, tag_code 0,
Aug 11 13:48:26 coyote kernel:  done_stat 0x1, host_stat 0x0, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:26 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:26 coyote kernel:  12000000 2400
Aug 11 13:48:26 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:26 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_rmqueue: new q_min_tim[1] 18
Aug 11 13:48:26 coyote kernel: asc_rmqueue: new q_max_tim[1] 18
Aug 11 13:48:26 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:26 coyote kernel: asc_isr_callback: QD_NO_ERROR
Aug 11 13:48:26 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:26 coyote kernel: asc_enqueue: new q_max_cnt[1] 1
Aug 11 13:48:26 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: new q_min_tim[1] 0
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:26 coyote kernel: advansys_interrupt: end
Aug 11 13:48:26 coyote kernel:   Vendor: ARCHIVE   Model: Python 28849-XXX  Rev: 4.CM
Aug 11 13:48:26 coyote kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Aug 11 13:48:26 coyote kernel: advansys_slave_configure: device 0xdf7cc400, boardp 0xc0d951b0, id 1, depth 1
Aug 11 13:48:26 coyote kernel: Attached scsi tape st0 at scsi1, channel 0, id 1, lun 0
Aug 11 13:48:26 coyote kernel: st0: try direct i/o: yes, max page reachable by HBA 131072
Aug 11 13:48:26 coyote kernel: Attached scsi generic sg1 at scsi1, channel 0, id 1, lun 0,  type 1
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:26 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:26 coyote kernel:  target_ix 0x9, target_lun 1, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:26 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:26 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:26 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:26 coyote kernel:  12200000 2400
Aug 11 13:48:26 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:26 coyote kernel:  40000201 0000803E D9002400 00003C8D D9004000 0000808C D9000900 06000000
Aug 11 13:48:26 coyote kernel:  0000
Aug 11 13:48:26 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:26 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:26 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:26 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:26 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:26 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: firstp 0x0
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:26 coyote kernel: advansys_interrupt: end
Aug 11 13:48:26 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:26 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:26 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:26 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:26 coyote kernel:  808CD900 09000600 0000AAE3 01000000
Aug 11 13:48:26 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdac03c20
Aug 11 13:48:26 coyote kernel: ASC_QDONE_INFO at addr 0xdac03c20
Aug 11 13:48:26 coyote kernel:  srb_ptr 0xd98c80, target_ix 9, cdb_len 6, tag_code 0,
Aug 11 13:48:26 coyote kernel:  done_stat 0x1, host_stat 0x0, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:26 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:26 coyote kernel:  12200000 2400
Aug 11 13:48:26 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:26 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_rmqueue: new q_max_tim[1] 33
Aug 11 13:48:26 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:26 coyote kernel: asc_isr_callback: QD_NO_ERROR
Aug 11 13:48:26 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:26 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:26 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:26 coyote kernel: advansys_interrupt: end
Aug 11 13:48:26 coyote kernel:   Vendor: ARCHIVE   Model: Python 28849-XXX  Rev: 4.CM
Aug 11 13:48:26 coyote kernel:   Type:   Medium Changer                     ANSI SCSI revision: 02
Aug 11 13:48:26 coyote kernel: advansys_slave_configure: device 0xdf7bbc00, boardp 0xc0d951b0, id 1, depth 1
Aug 11 13:48:26 coyote kernel: Attached scsi generic sg2 at scsi1, channel 0, id 1, lun 1,  type 8
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:26 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:26 coyote kernel:  target_ix 0x11, target_lun 2, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:26 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:26 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:26 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:26 coyote kernel:  12400000 2400
Aug 11 13:48:26 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:26 coyote kernel:  00000202 0000803E D9002400 00003C8D D9004000 0000808C D9001100 06000000
Aug 11 13:48:26 coyote kernel:  0000
Aug 11 13:48:26 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:26 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:26 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:26 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:26 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:26 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:26 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:26 coyote kernel:  808CD900 11000600 0000AAE3 01000000
Aug 11 13:48:26 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdac03c20
Aug 11 13:48:27 coyote kernel: ASC_QDONE_INFO at addr 0xdac03c20
Aug 11 13:48:27 coyote kernel:  srb_ptr 0xd98c80, target_ix 17, cdb_len 6, tag_code 0,
Aug 11 13:48:27 coyote kernel:  done_stat 0x1, host_stat 0x0, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:27 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12400000 2400
Aug 11 13:48:27 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:27 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:27 coyote kernel: asc_isr_callback: QD_NO_ERROR
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:27 coyote kernel: advansys_interrupt: end
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:27 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:27 coyote kernel:  target_ix 0x2, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:27 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:27 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12000000 2400
Aug 11 13:48:27 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:27 coyote kernel:  00000400 0000803E D9002400 00003C8D D9004000 0000808C D9000200 06000000
Aug 11 13:48:27 coyote kernel:  0000
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: new q_max_cnt[2] 1
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:27 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:27 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:27 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:27 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:27 coyote kernel:  808CD900 02000600 0000AAE3 04110000
Aug 11 13:48:27 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdaabfed4
Aug 11 13:48:27 coyote kernel: ASC_QDONE_INFO at addr 0xdaabfed4
Aug 11 13:48:27 coyote kernel:  srb_ptr 0xd98c80, target_ix 2, cdb_len 6, tag_code 0,
Aug 11 13:48:27 coyote kernel:  done_stat 0x4, host_stat 0x11, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:27 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12000000 2400
Aug 11 13:48:27 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:27 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_rmqueue: new q_min_tim[2] 222
Aug 11 13:48:27 coyote kernel: asc_rmqueue: new q_max_tim[2] 222
Aug 11 13:48:27 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:27 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:27 coyote kernel: asc_isr_callback: host_stat 0x11
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: new q_max_cnt[2] 1
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: new q_min_tim[2] 0
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:27 coyote kernel: advansys_interrupt: end
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:27 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:27 coyote kernel:  target_ix 0x3, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:27 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:27 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12000000 2400
Aug 11 13:48:27 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:27 coyote kernel:  00000800 0000803E D9002400 00003C8D D9004000 0000808C D9000300 06000000
Aug 11 13:48:27 coyote kernel:  0000
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: new q_max_cnt[3] 1
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:27 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:27 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:27 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:27 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:27 coyote kernel:  808CD900 03000600 0000AAE3 04110000
Aug 11 13:48:27 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdaabfed4
Aug 11 13:48:27 coyote kernel: ASC_QDONE_INFO at addr 0xdaabfed4
Aug 11 13:48:27 coyote kernel:  srb_ptr 0xd98c80, target_ix 3, cdb_len 6, tag_code 0,
Aug 11 13:48:27 coyote kernel:  done_stat 0x4, host_stat 0x11, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:27 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12000000 2400
Aug 11 13:48:27 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:27 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_rmqueue: new q_min_tim[3] 221
Aug 11 13:48:27 coyote kernel: asc_rmqueue: new q_max_tim[3] 221
Aug 11 13:48:27 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:27 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:27 coyote kernel: asc_isr_callback: host_stat 0x11
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: new q_max_cnt[3] 1
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: new q_min_tim[3] 0
Aug 11 13:48:27 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:27 coyote kernel: advansys_interrupt: end
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:27 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:27 coyote kernel:  target_ix 0x4, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:27 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:27 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12000000 2400
Aug 11 13:48:27 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:27 coyote kernel:  00001000 0000803E D9002400 00003C8D D9004000 0000808C D9000400 06000000
Aug 11 13:48:27 coyote kernel:  0000
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: new q_max_cnt[4] 1
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:27 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:27 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:27 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:27 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:27 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:27 coyote kernel:  808CD900 04000600 0000AAE3 04110000
Aug 11 13:48:27 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdf5dbc30
Aug 11 13:48:27 coyote kernel: ASC_QDONE_INFO at addr 0xdf5dbc30
Aug 11 13:48:27 coyote kernel:  srb_ptr 0xd98c80, target_ix 4, cdb_len 6, tag_code 0,
Aug 11 13:48:27 coyote kernel:  done_stat 0x4, host_stat 0x11, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:27 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:27 coyote kernel:  12000000 2400
Aug 11 13:48:27 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:27 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:27 coyote kernel: asc_rmqueue: new q_min_tim[4] 221
Aug 11 13:48:27 coyote kernel: asc_rmqueue: new q_max_tim[4] 221
Aug 11 13:48:27 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:27 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:27 coyote kernel: asc_isr_callback: host_stat 0x11
Aug 11 13:48:27 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:27 coyote kernel: asc_enqueue: new q_max_cnt[4] 1
Aug 11 13:48:27 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: new q_min_tim[4] 0
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:28 coyote kernel: advansys_interrupt: end
Aug 11 13:48:28 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:28 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:28 coyote kernel:  target_ix 0x5, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:28 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:28 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:28 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:28 coyote kernel:  12000000 2400
Aug 11 13:48:28 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:28 coyote kernel:  00002000 0000803E D9002400 00003C8D D9004000 0000808C D9000500 06000000
Aug 11 13:48:28 coyote kernel:  0000
Aug 11 13:48:28 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:28 coyote kernel: asc_enqueue: new q_max_cnt[5] 1
Aug 11 13:48:28 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:28 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:28 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:28 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:28 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:28 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:28 coyote kernel:  808CD900 05000600 0000AAE3 04110000
Aug 11 13:48:28 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdaabfed4
Aug 11 13:48:28 coyote kernel: ASC_QDONE_INFO at addr 0xdaabfed4
Aug 11 13:48:28 coyote kernel:  srb_ptr 0xd98c80, target_ix 5, cdb_len 6, tag_code 0,
Aug 11 13:48:28 coyote kernel:  done_stat 0x4, host_stat 0x11, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:28 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:28 coyote kernel:  12000000 2400
Aug 11 13:48:28 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:28 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_rmqueue: new q_min_tim[5] 221
Aug 11 13:48:28 coyote kernel: asc_rmqueue: new q_max_tim[5] 221
Aug 11 13:48:28 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11
Aug 11 13:48:28 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:28 coyote kernel: asc_enqueue: new q_max_cnt[5] 1
Aug 11 13:48:28 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: new q_min_tim[5] 0
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:28 coyote kernel: advansys_interrupt: end
Aug 11 13:48:28 coyote kernel: asc_execute_scsi_cmnd: scp 0xc0d98c80, done 0xc024e190
Aug 11 13:48:28 coyote kernel: ASC_SCSI_Q at addr 0xe3aaed20
Aug 11 13:48:28 coyote kernel:  target_ix 0x6, target_lun 0, srb_ptr 0xd98c80, tag_code 0x20,
Aug 11 13:48:28 coyote kernel:  data_addr 0xd93e80, data_cnt 36, sense_addr 0xd98d3c, sense_len 64,
Aug 11 13:48:28 coyote kernel:  cdbptr 0xc0d98cd4, cdb_len 6, sg_head 0x0, sg_queue_cnt 0
Aug 11 13:48:28 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:28 coyote kernel:  12000000 2400
Aug 11 13:48:28 coyote kernel: DvcPutScsiQ: (34 bytes)
Aug 11 13:48:28 coyote kernel:  00004000 0000803E D9002400 00003C8D D9004000 0000808C D9000600 06000000
Aug 11 13:48:28 coyote kernel:  0000
Aug 11 13:48:28 coyote kernel: asc_enqueue: ascq 0xc0d95290, reqp 0xc0d98c80, flag 2
Aug 11 13:48:28 coyote kernel: asc_enqueue: new q_max_cnt[6] 1
Aug 11 13:48:28 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR
Aug 11 13:48:28 coyote kernel: asc_execute_scsi_cmnd: end
Aug 11 13:48:28 coyote kernel: advansys_interrupt: begin
Aug 11 13:48:28 coyote kernel: advansys_interrupt: i 0, boardp 0xc0d951b0
Aug 11 13:48:28 coyote kernel: advansys_interrupt: before AscISR()
Aug 11 13:48:28 coyote kernel: DvcGetQinfo: (16 bytes)
Aug 11 13:48:28 coyote kernel:  808CD900 06000600 0000AAE3 04110000
Aug 11 13:48:28 coyote kernel: asc_isr_callback: asc_dvc_varp 0xc0d951b8, qdonep 0xdaabfed4
Aug 11 13:48:28 coyote kernel: ASC_QDONE_INFO at addr 0xdaabfed4
Aug 11 13:48:28 coyote kernel:  srb_ptr 0xd98c80, target_ix 6, cdb_len 6, tag_code 0,
Aug 11 13:48:28 coyote kernel:  done_stat 0x4, host_stat 0x11, scsi_stat 0x0, scsi_msg 0x0
Aug 11 13:48:28 coyote kernel: asc_isr_callback: scp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: CDB: (6 bytes)
Aug 11 13:48:28 coyote kernel:  12000000 2400
Aug 11 13:48:28 coyote kernel: asc_isr_callback: shp 0xc0d95000
Aug 11 13:48:28 coyote kernel: asc_rmqueue: ascq 0xc0d95290, reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_rmqueue: new q_min_tim[6] 221
Aug 11 13:48:28 coyote kernel: asc_rmqueue: new q_max_tim[6] 221
Aug 11 13:48:28 coyote kernel: asc_rmqueue: reqp 0xc0d98c80, ret 1
Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11
Aug 11 13:48:28 coyote kernel: asc_enqueue: ascq 0xc0d95598, reqp 0xc0d98c80, flag 2
Aug 11 13:48:28 coyote kernel: asc_enqueue: new q_max_cnt[6] 1
Aug 11 13:48:28 coyote kernel: asc_enqueue: reqp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: advansys_interrupt: done_scp 0x0, last_scp 0x0
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: ascq 0xc0d95598, tid -1
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: new q_min_tim[6] 0
Aug 11 13:48:28 coyote kernel: asc_dequeue_list: firstp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: begin
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: scp 0xc0d98c80
Aug 11 13:48:28 coyote kernel: asc_scsi_done_list: done
Aug 11 13:48:28 coyote kernel: advansys_interrupt: end
Aug 11 13:57:25 coyote login(pam_unix)[1267]: session opened for user root by LOGIN(uid=0)
Aug 11 13:57:25 coyote  -- root[1267]: ROOT LOGIN ON tty2

--Boundary-00=_mcJO/+srPSTWJbS--

