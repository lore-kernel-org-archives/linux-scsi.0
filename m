From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 6061] scsi unknown opcode message
Date: Sun, 12 Feb 2006 15:43:05 -0800
Message-ID: <20060212154305.455feca6.akpm@osdl.org>
References: <200602122300.k1CN0E9K027290@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <200602122300.k1CN0E9K027290@fire-2.osdl.org>
Sender: linux-acpi-owner@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6061
> 
> 
> 
> 
> 
> ------- Additional Comments From collinm@laboiteaprog.com  2006-02-12 15:00 -------
> ok it's the info

Thanks.

scsi problem: this aic79xx machine emits "scsi: unknown opcode 0xfa"
sometimes.

There's an unpleasant-looking ACPI warning in there as well.

Kernel is 2.6.13++.

> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> 512MB LOWMEM available.
> On node 0 totalpages: 131072
>   DMA zone: 4096 pages, LIFO batch:1
>   Normal zone: 126976 pages, LIFO batch:31
>   HighMem zone: 0 pages, LIFO batch:1
> DMI 2.3 present.
> ACPI: Unable to locate RSDP
> Allocating PCI resources starting at 20000000 (gap: 20000000:dec00000)
> Built 1 zonelists
> Kernel command line: root=/dev/sda6 vga=0x317 selinux=0    resume=/dev/sda9  
> splash=silent
> bootsplash: silent mode.
> Initializing CPU#0
> CPU 0 irqstacks, hard=c03f3000 soft=c03f2000
> PID hash table entries: 4096 (order: 12, 65536 bytes)
> Detected 1534.121 MHz processor.
> Using tsc for high-res timesource
> Console: colour dummy device 80x25
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 513580k/524288k available (2113k kernel code, 10156k reserved, 675k 
> data, 200k init, 0k highmem)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Calibrating delay using timer specific routine.. 3070.54 BogoMIPS (lpj=1535271)
> Security Framework v1.0.0 initialized
> SELinux:  Disabled at boot.
> Mount-cache hash table entries: 512
> CPU: After generic identify, caps: 0383f9ff c1c3f9ff 00000000 00000000 00000000 
> 00000000 00000000
> CPU: After vendor identify, caps: 0383f9ff c1c3f9ff 00000000 00000000 00000000 
> 00000000 00000000
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 256K (64 bytes/line)
> CPU: After all inits, caps: 0383f9ff c1c3f9ff 00000000 00000020 00000000 
> 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> mtrr: v2.0 (20020519)
> CPU: AMD Athlon(tm) XP 1800+ stepping 02
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Checking 'hlt' instruction... OK.
> checking if image is initramfs... it is
> Freeing initrd memory: 1819k freed
> NET: Registered protocol family 16
> PCI: PCI BIOS revision 2.10 entry at 0xfdaf1, last bus=1
> PCI: Using configuration type 1
> ACPI: Subsystem revision 20050408
> ACPI: Interpreter disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI: disabled
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware (bus 00)
> Boot video device is 0000:01:00.0
> PCI: Using IRQ router default [1106/3074] at 0000:00:11.0
> PCI: IRQ 0 for device 0000:00:11.1 doesn't match PIRQ mask - try 
> pci=usepirqmask
> PCI: Hardcoded IRQ 14 for device 0000:00:11.1
> TC classifier action (bugs to netdev@vger.kernel.org cc hadi@cyberus.ca)
> PCI: Bridge: 0000:00:01.0
>   IO window: disabled.
>   MEM window: dde00000-dfefffff
>   PREFETCH window: cdb00000-ddcfffff
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
> audit: initializing netlink socket (disabled)
> audit(1139755236.579:1): initialized
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Initializing Cryptographic API
> vesafb: framebuffer at 0xd0000000, mapped to 0xe0880000, using 6144k, total 
> 131072k
> vesafb: mode is 1024x768x16, linelength=2048, pages=1
> vesafb: protected mode interface info at c000:e910
> vesafb: scrolling: redraw
> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> bootsplash 3.1.6-2004/03/31: looking for picture...<6> silentjpeg size 76011 
> bytes,<6>...found (1024x768, 12703 bytes, v3).
> Console: switching to colour frame buffer device 127x44
> fb0: VESA VGA frame buffer device
> Real Time Clock Driver v1.12
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 AUX port at 0x60,0x64 irq 12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
> ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
> loop: loaded (max 8 devices)
> mice: PS/2 mouse device common for all mice
> input: PC Speaker
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> Using IPI Shortcut mode
> Freeing unused kernel memory: 200k freed
> input: AT Translated Set 2 keyboard on isa0060/serio0
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> SCSI subsystem initialized
> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 3960D Ultra160 SCSI adapter>
>         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
> input: ImExPS/2 Generic Explorer Mouse on isa0060/serio1
> scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 3960D Ultra160 SCSI adapter>
>         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
> 
>   Vendor: IBM-ESXS  Model: MAP3367NP     FN  Rev: B109
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> scsi1:A:2:0: Tagged Queuing enabled.  Depth 32
>  target1:0:2: Beginning Domain Validation
>  target1:0:2: wide asynchronous.
>  target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
>  target1:0:2: Ending Domain Validation
> SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
> SCSI device sda: drive cache: write back
> SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
> SCSI device sda: drive cache: write back
>  sda: sda1 < sda5 sda6 sda7 sda8 sda9 >
> Attached scsi disk sda at scsi1, channel 0, id 2, lun 0
> Attached scsi generic sg0 at scsi1, channel 0, id 2, lun 0,  type 0
> VP_IDE: IDE controller at PCI slot 0000:00:11.1
> PCI: Hardcoded IRQ 14 for device 0000:00:11.1
> PCI: Via IRQ fixup for 0000:00:11.1, from 255 to 14
> VP_IDE: chipset revision 6
> VP_IDE: not 100% native mode: will probe irqs later
> VP_IDE: VIA vt8233 (rev 00) IDE UDMA100 controller on pci0000:00:11.1
>     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, hdb:pio
>     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:pio
> Probing IDE interface ide0...
> Probing IDE interface ide1...
> hdc: HL-DT-ST DVDRAM GSA-4167B, ATAPI CD/DVD-ROM drive
> ide1 at 0x170-0x177,0x376 on irq 15
> hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
> Uniform CD-ROM driver Revision: 3.20
> Attempting manual resume
> swsusp: Suspend partition has wrong signature?
> ReiserFS: sda6: found reiserfs format "3.6" with standard journal
> ReiserFS: sda6: using ordered data mode
> ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, 
> max trans len 1024, max batch 900, max commit age 30, max trans age 30
> ReiserFS: sda6: checking transaction log (sda6)
> ReiserFS: sda6: Using r5 hash to sort names
> bootsplash: status on console 0 changed to on
> spurious 8259A interrupt: IRQ7.
> Adding 891568k swap on /dev/sda9.  Priority:-1 extents:1
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda5, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> ReiserFS: sda7: found reiserfs format "3.6" with standard journal
> ReiserFS: sda7: using ordered data mode
> ReiserFS: sda7: journal params: device sda7, size 8192, journal first block 18, 
> max trans len 1024, max batch 900, max commit age 30, max trans age 30
> ReiserFS: sda7: checking transaction log (sda7)
> ReiserFS: sda7: Using r5 hash to sort names
> ReiserFS: sda8: found reiserfs format "3.6" with standard journal
> ReiserFS: sda8: using ordered data mode
> ReiserFS: sda8: journal params: device sda8, size 8192, journal first block 18, 
> max trans len 1024, max batch 900, max commit age 30, max trans age 30
> ReiserFS: sda8: checking transaction log (sda8)
> ReiserFS: sda8: Using r5 hash to sort names
> parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
> parport0: irq 7 detected
> lp0: using parport0 (polling).
> ip_tables: (C) 2000-2002 Netfilter core team
> ip_conntrack version 2.1 (4096 buckets, 32768 max) - 248 bytes per conntrack
> bootsplash: status on console 0 changed to on
> NET: Registered protocol family 23
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>     ACPI-0768: *** Warning: Thread 9F6 could not acquire Mutex [<NULL>] 
> AE_BAD_PARAMETER
> shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x1001
> usbcore: registered new driver usbfs
> usbcore: registered new driver hub
> USB Universal Host Controller Interface driver v2.3
> uhci_hcd 0000:00:11.2: UHCI Host Controller
> uhci_hcd 0000:00:11.2: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:11.2: irq 11, io base 0x0000d400
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> uhci_hcd 0000:00:11.3: UHCI Host Controller
> uhci_hcd 0000:00:11.3: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:11.3: irq 11, io base 0x0000d800
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> uhci_hcd 0000:00:11.4: UHCI Host Controller
> uhci_hcd 0000:00:11.4: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:11.4: irq 11, io base 0x0000dc00
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> Linux agpgart interface v0.101 (c) Dave Jones
> agpgart: Detected VIA PM266/KM266 chipset
> agpgart: AGP aperture is 64M @ 0xe0000000
> via-rhine.c:v1.10-LK1.2.0-2.6 June-10-2004 Written by Donald Becker
> eth0: VIA Rhine II at 0x1d000, 00:07:95:46:91:f3, IRQ 9.
> eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 41e1.
> usb 3-1: new full speed USB device using uhci_hcd and address 2
> PCI: Setting latency timer of device 0000:00:11.5 to 64
> BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
> IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
> IA-32 Microcode Update Driver v1.14 unregistered
> bootsplash: status on console 0 changed to on
> bootsplash: status on console 0 changed to on
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
