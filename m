From: Andrew Morton <akpm@osdl.org>
Subject: Re: SCSI-hdd bug
Date: Fri, 23 Jan 2004 00:48:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040123004848.2f696e10.akpm@osdl.org>
References: <4010D8C3.9080902@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:12984 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266550AbUAWIsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2004 03:48:20 -0500
In-Reply-To: <4010D8C3.9080902@freemail.hu>
List-Id: linux-scsi@vger.kernel.org
To: Gabriel <gabrie1@freemail.hu>
Cc: linux-scsi@vger.kernel.org

Gabriel <gabrie1@freemail.hu> wrote:
>
> Hi!
> 
> I cant use my SCSI-hdd.
> /mnt/scsi/sda1# tar -xjf /home/gabriel/linux-2.6.x.tar.bz2
> working..., after 3minute: OOPS 0000
> I attach my patrial messages.log and config.gz
> 

That's one for the SCSI guys.  2.6.2-rc1, aha152x0 died in busfree_run().

Is it repeatable?



Jan 22 16:50:45 pisztacia syslogd 1.4.1#10: restart.
Jan 22 16:50:46 pisztacia kernel: klogd 1.4.1#10, log source = /proc/kmsg started.
Jan 22 16:50:46 pisztacia kernel: Cannot find map file.
Jan 22 16:50:46 pisztacia kernel: No module symbols loaded - kernel modules not enabled. 
Jan 22 16:50:46 pisztacia kernel: Linux version 2.6.2-rc1 (root@pIsztacia) (gcc version 3.0.4) #1 Thu Jan 22 16:34:01 CET 2004
Jan 22 16:50:46 pisztacia kernel: BIOS-provided physical RAM map:
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 0000000000100000 - 0000000009ff0000 (usable)
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 0000000009ff0000 - 0000000009ff3000 (ACPI NVS)
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 0000000009ff3000 - 000000000a000000 (ACPI data)
Jan 22 16:50:46 pisztacia kernel:  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Jan 22 16:50:46 pisztacia kernel: 159MB LOWMEM available.
Jan 22 16:50:46 pisztacia kernel: On node 0 totalpages: 40944
Jan 22 16:50:46 pisztacia kernel:   DMA zone: 4096 pages, LIFO batch:1
Jan 22 16:50:46 pisztacia kernel:   Normal zone: 36848 pages, LIFO batch:8
Jan 22 16:50:46 pisztacia kernel:   HighMem zone: 0 pages, LIFO batch:1
Jan 22 16:50:46 pisztacia kernel: DMI 2.2 present.
Jan 22 16:50:46 pisztacia kernel: Building zonelist for node : 0
Jan 22 16:50:46 pisztacia kernel: Kernel command line: auto BOOT_IMAGE=Linux-2.6.x ro root=1603
Jan 22 16:50:46 pisztacia kernel: Initializing CPU#0
Jan 22 16:50:46 pisztacia kernel: PID hash table entries: 1024 (order 10: 8192 bytes)
Jan 22 16:50:46 pisztacia kernel: Detected 567.917 MHz processor.
Jan 22 16:50:46 pisztacia kernel: Using tsc for high-res timesource
Jan 22 16:50:46 pisztacia kernel: Console: colour VGA+ 80x25
Jan 22 16:50:46 pisztacia kernel: Memory: 158200k/163776k available (2105k kernel code, 4996k reserved, 713k data, 384k init, 0k highmem)
Jan 22 16:50:46 pisztacia kernel: Checking if this processor honours the WP bit even in supervisor mode... Ok.
Jan 22 16:50:46 pisztacia kernel: Calibrating delay loop... 1114.11 BogoMIPS
Jan 22 16:50:46 pisztacia kernel: Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Jan 22 16:50:46 pisztacia kernel: Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Jan 22 16:50:46 pisztacia kernel: Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
Jan 22 16:50:46 pisztacia kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Jan 22 16:50:46 pisztacia kernel: CPU: L2 cache: 128K
Jan 22 16:50:46 pisztacia kernel: Intel machine check architecture supported.
Jan 22 16:50:46 pisztacia kernel: Intel machine check reporting enabled on CPU#0.
Jan 22 16:50:46 pisztacia kernel: CPU: Intel Celeron (Coppermine) stepping 06
Jan 22 16:50:46 pisztacia kernel: Enabling fast FPU save and restore... done.
Jan 22 16:50:46 pisztacia kernel: Enabling unmasked SIMD FPU exception support... done.
Jan 22 16:50:46 pisztacia kernel: Checking 'hlt' instruction... OK.
Jan 22 16:50:46 pisztacia kernel: POSIX conformance testing by UNIFIX
Jan 22 16:50:46 pisztacia kernel: NET: Registered protocol family 16
Jan 22 16:50:46 pisztacia kernel: EISA bus registered
Jan 22 16:50:46 pisztacia kernel: PCI: PCI BIOS revision 2.10 entry at 0xfb160, last bus=1
Jan 22 16:50:46 pisztacia kernel: PCI: Using configuration type 1
Jan 22 16:50:46 pisztacia kernel: mtrr: v2.0 (20020519)
Jan 22 16:50:46 pisztacia kernel: SCSI subsystem initialized
Jan 22 16:50:46 pisztacia kernel: drivers/usb/core/usb.c: registered new driver usbfs
Jan 22 16:50:46 pisztacia kernel: drivers/usb/core/usb.c: registered new driver hub
Jan 22 16:50:46 pisztacia kernel: PCI: Probing PCI hardware
Jan 22 16:50:46 pisztacia kernel: PCI: Probing PCI hardware (bus 00)
Jan 22 16:50:46 pisztacia kernel: PCI: Using IRQ router VIA [1106/0596] at 0000:00:07.0
Jan 22 16:50:46 pisztacia kernel: Machine check exception polling timer started.
Jan 22 16:50:46 pisztacia kernel: apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
Jan 22 16:50:46 pisztacia kernel: ikconfig 0.7 with /proc/config*
Jan 22 16:50:46 pisztacia kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Jan 22 16:50:46 pisztacia kernel: NTFS driver 2.1.6 [Flags: R/W DEBUG].
Jan 22 16:50:46 pisztacia kernel: Activating ISA DMA hang workarounds.
Jan 22 16:50:46 pisztacia kernel: pty: 256 Unix98 ptys configured
Jan 22 16:50:46 pisztacia kernel: Linux agpgart interface v0.100 (c) Dave Jones
Jan 22 16:50:46 pisztacia kernel: agpgart: Detected VIA Apollo Pro 133 chipset
Jan 22 16:50:46 pisztacia kernel: agpgart: Maximum main memory to use for agp memory: 122M
Jan 22 16:50:46 pisztacia kernel: agpgart: AGP aperture is 64M @ 0xd8000000
Jan 22 16:50:46 pisztacia kernel: Hangcheck: starting hangcheck timer 0.5.0 (tick is 180 seconds, margin is 60 seconds).
Jan 22 16:50:46 pisztacia kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
Jan 22 16:50:46 pisztacia kernel: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jan 22 16:50:46 pisztacia kernel: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jan 22 16:50:46 pisztacia kernel: parport0: PC-style at 0x378 (0x778) [PCSPP(,...)]
Jan 22 16:50:46 pisztacia kernel: parport0: irq 7 detected
Jan 22 16:50:46 pisztacia kernel: Using anticipatory io scheduler
Jan 22 16:50:46 pisztacia kernel: Floppy drive(s): fd0 is 1.44M, fd1 is 1.44M
Jan 22 16:50:46 pisztacia kernel: floppy0: no floppy controllers found
Jan 22 16:50:46 pisztacia kernel: loop: loaded (max 8 devices)
Jan 22 16:50:46 pisztacia kernel: 0000:00:09.0: DE434/5 at 0xe800, h/w address 00:80:c8:0c:05:5c,
Jan 22 16:50:46 pisztacia kernel:       and requires IRQ10 (provided by PCI BIOS).
Jan 22 16:50:46 pisztacia kernel: de4x5.c:V0.546 2001/02/22 davies@maniac.ultranet.com
Jan 22 16:50:46 pisztacia kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Jan 22 16:50:46 pisztacia kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jan 22 16:50:46 pisztacia kernel: VP_IDE: IDE controller at PCI slot 0000:00:07.1
Jan 22 16:50:46 pisztacia kernel: VP_IDE: chipset revision 16
Jan 22 16:50:46 pisztacia kernel: VP_IDE: not 100%% native mode: will probe irqs later
Jan 22 16:50:46 pisztacia kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jan 22 16:50:46 pisztacia kernel: VP_IDE: VIA vt82c596b (rev 23) IDE UDMA66 controller on pci0000:00:07.1
Jan 22 16:50:46 pisztacia kernel:     ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:DMA
Jan 22 16:50:46 pisztacia kernel: hdc: WDC AC21200H, ATA DISK drive
Jan 22 16:50:46 pisztacia kernel: hdd: CR-4802TE, ATAPI CD/DVD-ROM drive
Jan 22 16:50:46 pisztacia kernel: ide1 at 0x170-0x177,0x376 on irq 15
Jan 22 16:50:46 pisztacia kernel: hdc: max request size: 128KiB
Jan 22 16:50:46 pisztacia kernel: hdc: 2503872 sectors (1281 MB) w/128KiB Cache, CHS=2484/16/63, DMA
Jan 22 16:50:46 pisztacia kernel:  hdc: hdc1 hdc2 hdc3
Jan 22 16:50:46 pisztacia kernel: hdd: ATAPI 8X CD-ROM CD-R/RW drive, 2048kB Cache, DMA
Jan 22 16:50:46 pisztacia kernel: Uniform CD-ROM driver Revision: 3.20
Jan 22 16:50:46 pisztacia kernel: ide-floppy driver 0.99.newide
Jan 22 16:50:46 pisztacia kernel: aha152x: BIOS test: passed, auto configuration: ok, detected 1 controller(s)
Jan 22 16:50:46 pisztacia kernel: aha152x: resetting bus...
Jan 22 16:50:46 pisztacia kernel: aha152x0: vital data: rev=1, io=0x340 (0x340/0x340), irq=9, scsiid=7, reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000, extended translation=disabled
Jan 22 16:50:46 pisztacia kernel: aha152x0: trying software interrupt, ok.
Jan 22 16:50:46 pisztacia kernel: scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
Jan 22 16:50:46 pisztacia kernel: (scsi0:0:0) Synchronous Data Transfer Request period = 200 ns, offset = 8
Jan 22 16:50:46 pisztacia kernel:   Vendor: QUANTUM   Model: LPS540S           Rev: 5900
Jan 22 16:50:46 pisztacia kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jan 22 16:50:46 pisztacia kernel: SCSI device sda: 1057616 512-byte hdwr sectors (541 MB)
Jan 22 16:50:46 pisztacia kernel: SCSI device sda: drive cache: write back
Jan 22 16:50:46 pisztacia kernel:  sda: sda1
Jan 22 16:50:46 pisztacia kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Jan 22 16:50:46 pisztacia kernel: Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
Jan 22 16:50:46 pisztacia kernel: drivers/usb/host/uhci-hcd.c: USB Universal Host Controller Interface driver v2.1
Jan 22 16:50:46 pisztacia kernel: PCI: Found IRQ 11 for device 0000:00:07.2
Jan 22 16:50:46 pisztacia kernel: uhci_hcd 0000:00:07.2: UHCI Host Controller
Jan 22 16:50:46 pisztacia kernel: uhci_hcd 0000:00:07.2: irq 11, io base 0000e400
Jan 22 16:50:46 pisztacia kernel: uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
Jan 22 16:50:46 pisztacia kernel: drivers/usb/host/uhci-hcd.c: detected 2 ports
Jan 22 16:50:46 pisztacia kernel: usb usb1: Product: UHCI Host Controller
Jan 22 16:50:46 pisztacia kernel: usb usb1: Manufacturer: Linux 2.6.2-rc1 uhci_hcd
Jan 22 16:50:46 pisztacia kernel: usb usb1: SerialNumber: 0000:00:07.2
Jan 22 16:50:46 pisztacia kernel: hub 1-0:1.0: USB hub found
Jan 22 16:50:46 pisztacia kernel: hub 1-0:1.0: 2 ports detected
Jan 22 16:50:46 pisztacia kernel: Initializing USB Mass Storage driver...
Jan 22 16:50:46 pisztacia kernel: drivers/usb/core/usb.c: registered new driver usb-storage
Jan 22 16:50:46 pisztacia kernel: USB Mass Storage support registered.
Jan 22 16:50:46 pisztacia kernel: mice: PS/2 mouse device common for all mice
Jan 22 16:50:46 pisztacia kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 22 16:50:46 pisztacia kernel: input: PS/2 Generic Mouse on isa0060/serio1
Jan 22 16:50:46 pisztacia kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 22 16:50:46 pisztacia kernel: input: AT Translated Set 2 keyboard on isa0060/serio0
Jan 22 16:50:46 pisztacia kernel: EISA: Probing bus 0 at eisa0
Jan 22 16:50:46 pisztacia kernel: Advanced Linux Sound Architecture Driver Version 0.9.7 (Thu Sep 25 19:16:36 2003 UTC).
Jan 22 16:50:46 pisztacia kernel: PCI: Found IRQ 14 for device 0000:00:0a.0
Jan 22 16:50:46 pisztacia kernel: ALSA device list:
Jan 22 16:50:46 pisztacia kernel:   #0: Ensoniq AudioPCI ENS1371 at 0xec00, irq 14
Jan 22 16:50:46 pisztacia kernel: NET: Registered protocol family 2
Jan 22 16:50:46 pisztacia kernel: IP: routing cache hash table of 1024 buckets, 8Kbytes
Jan 22 16:50:46 pisztacia kernel: TCP: Hash tables configured (established 16384 bind 32768)
Jan 22 16:50:46 pisztacia kernel: NET: Registered protocol family 1
Jan 22 16:50:46 pisztacia kernel: NET: Registered protocol family 17
Jan 22 16:50:46 pisztacia kernel: kjournald starting.  Commit interval 5 seconds
Jan 22 16:50:46 pisztacia kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan 22 16:50:46 pisztacia kernel: VFS: Mounted root (ext3 filesystem) readonly.
Jan 22 16:50:46 pisztacia kernel: Freeing unused kernel memory: 384k freed
Jan 22 16:50:46 pisztacia kernel: Adding 31240k swap on /dev/hdc2.  Priority:-1 extents:1
Jan 22 16:50:46 pisztacia kernel: EXT3 FS on hdc3, internal journal
Jan 22 16:50:46 pisztacia kernel: warning: process `update' used the obsolete bdflush system call
Jan 22 16:50:46 pisztacia kernel: Fix your initscripts?
Jan 22 16:50:46 pisztacia kernel: eth0: media is TP.
Jan 22 16:50:47 pisztacia lpd[214]: restarted
Jan 22 16:50:58 pisztacia kernel: atkbd.c: Unknown key released (translated set 2, code 0x7a on isa0060/serio0).
Jan 22 16:50:58 pisztacia kernel: atkbd.c: Unknown key released (translated set 2, code 0x7a on isa0060/serio0).
Jan 22 16:56:55 pisztacia kernel: SysRq : Emergency Sync
Jan 22 16:56:55 pisztacia kernel: Emergency Sync complete
Jan 22 17:00:38 pisztacia kernel:  printing eip:
Jan 22 17:00:38 pisztacia kernel: c024914a
Jan 22 17:00:38 pisztacia kernel: Oops: 0000 [#1]
Jan 22 17:00:38 pisztacia kernel: CPU:    0
Jan 22 17:00:38 pisztacia kernel: EIP:    0060:[<c024914a>]    Not tainted
Jan 22 17:00:38 pisztacia kernel: EFLAGS: 00010082
Jan 22 17:00:38 pisztacia kernel: EIP is at busfree_run+0x1ba/0x4d0
Jan 22 17:00:38 pisztacia kernel: eax: 00000000   ebx: c975ac80   ecx: 00000000   edx: c9d70ce0
Jan 22 17:00:38 pisztacia kernel: esi: c9d71800   edi: 00000202   ebp: 00000002   esp: c9f9df38
Jan 22 17:00:38 pisztacia kernel: ds: 007b   es: 007b   ss: 0068
Jan 22 17:00:38 pisztacia kernel: Process events/0 (pid: 3, threadinfo=c9f9c000 task=c119ec80)
Jan 22 17:00:38 pisztacia kernel: Stack: c01174dc c9f9df84 00000046 0000034c 00000005 c9d71800 00000008 00000000 
Jan 22 17:00:38 pisztacia kernel:        c024b4c6 c9d71800 c9f9c000 0004c8d4 00000000 c0439fa4 00000293 c9fedc20 
Jan 22 17:00:38 pisztacia kernel:        c0248ea3 c9d71800 c0439fa0 c0129234 00000000 c9f9c000 00000000 c0248e70 
Jan 22 17:00:38 pisztacia kernel: Call Trace:
Jan 22 17:00:38 pisztacia kernel:  [<c01174dc>] schedule+0x2cc/0x5d0
Jan 22 17:00:38 pisztacia kernel:  [<c024b4c6>] is_complete+0x136/0x2f0
Jan 22 17:00:38 pisztacia kernel:  [<c0248ea3>] run+0x33/0x40
Jan 22 17:00:38 pisztacia kernel:  [<c0129234>] worker_thread+0x1c4/0x240
Jan 22 17:00:38 pisztacia kernel:  [<c0248e70>] run+0x0/0x40
Jan 22 17:00:38 pisztacia kernel:  [<c0117840>] default_wake_function+0x0/0x20
Jan 22 17:00:38 pisztacia kernel:  [<c01090f6>] ret_from_fork+0x6/0x14
Jan 22 17:00:38 pisztacia kernel:  [<c0117840>] default_wake_function+0x0/0x20
Jan 22 17:00:38 pisztacia kernel:  [<c0129070>] worker_thread+0x0/0x240
Jan 22 17:00:38 pisztacia kernel:  [<c0107275>] kernel_thread_helper+0x5/0x10
Jan 22 17:00:38 pisztacia kernel: 
Jan 22 17:00:38 pisztacia kernel: Code: 8b 00 89 86 c0 01 00 00 8b 82 28 01 00 00 c7 00 00 00 00 00 
Jan 22 17:00:38 pisztacia kernel:  <6>note: events/0[3] exited with preempt_count 1
Jan 22 17:01:08 pisztacia kernel:  printing eip:
Jan 22 17:01:08 pisztacia kernel: c02487ed
Jan 22 17:01:08 pisztacia kernel: Oops: 0000 [#2]
Jan 22 17:01:08 pisztacia kernel: CPU:    0
Jan 22 17:01:08 pisztacia kernel: EIP:    0060:[<c02487ed>]    Not tainted
Jan 22 17:01:08 pisztacia kernel: EFLAGS: 00010046
Jan 22 17:01:08 pisztacia kernel: EIP is at aha152x_abort+0x14d/0x1b0
Jan 22 17:01:08 pisztacia kernel: eax: 00000000   ebx: c9d70ce0   ecx: c9d70ce0   edx: 00000000
Jan 22 17:01:08 pisztacia kernel: esi: c9d71800   edi: 00000086   ebp: c9d719c0   esp: c9d51f4c
Jan 22 17:01:08 pisztacia kernel: ds: 007b   es: 007b   ss: 0068
Jan 22 17:01:08 pisztacia kernel: Process scsi_eh_0 (pid: 11, threadinfo=c9d50000 task=c9d53900)
Jan 22 17:01:08 pisztacia kernel: Stack: c9d50000 00000206 00002003 c9d51f9c c0242e51 c9d70ce0 c9d70ce0 c9d70cf8 
Jan 22 17:01:08 pisztacia kernel:        c9d51f9c c0242f6f c9d70ce0 c9d71830 c9d50000 00000282 c9d51f9c c0243894 
Jan 22 17:01:08 pisztacia kernel:        c9d51f9c c9d51f94 c9d51f94 c9d51f94 c9d70cf8 c9d70cf8 c9d51f94 c9d51f94 
Jan 22 17:01:08 pisztacia kernel: Call Trace:
Jan 22 17:01:08 pisztacia kernel:  [<c0242e51>] scsi_try_to_abort_cmd+0x41/0x70
Jan 22 17:01:08 pisztacia kernel:  [<c0242f6f>] scsi_eh_abort_cmds+0x2f/0x80
Jan 22 17:01:08 pisztacia kernel:  [<c0243894>] scsi_unjam_host+0xa4/0x100
Jan 22 17:01:08 pisztacia kernel:  [<c02439e6>] scsi_error_handler+0xf6/0x140
Jan 22 17:01:08 pisztacia kernel:  [<c02438f0>] scsi_error_handler+0x0/0x140
Jan 22 17:01:08 pisztacia kernel:  [<c0107275>] kernel_thread_helper+0x5/0x10
Jan 22 17:01:08 pisztacia kernel: 
Jan 22 17:01:08 pisztacia kernel: Code: 8b 00 89 45 00 e9 11 ff ff ff 53 85 db ba ff ff ff ff 74 06 
Jan 22 17:01:08 pisztacia kernel:  <6>note: scsi_eh_0[11] exited with preempt_count 2



