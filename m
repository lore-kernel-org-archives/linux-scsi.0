From: Russell King <rmk@arm.linux.org.uk>
Subject: Fwd: Kernel Oops with Adaptec 1460D (PCMCIA SCSI-Controller) and Kernel 2.6.0
Date: Thu, 8 Jan 2004 11:29:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108112905.B14674@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:33293 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S264288AbUAHL3J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 06:29:09 -0500
Received: from flint.arm.linux.org.uk ([2002:d412:e8ba:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.30)
	id 1AeYLa-0006De-4Z
	for linux-scsi@vger.kernel.org; Thu, 08 Jan 2004 11:29:06 +0000
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.30)
	id 1AeYLZ-0004Ch-B2
	for linux-scsi@vger.kernel.org; Thu, 08 Jan 2004 11:29:05 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Could someone look into this - it seems that it's more of a scsi
bug than a pcmcia bug.

Thanks.

----- Forwarded message from Lars Otte <turbo-desktop-environment@t-online.de> -----
Date: Thu, 08 Jan 2004 12:02:43 +0100
From: turbo-desktop-environment@t-online.de (Lars Otte)
Subject: Kernel Oops with Adaptec 1460D (PCMCIA SCSI-Controller) and Kernel 2.6.0

Hello Russell King,

Russell King wrote:

>On Wed, Jan 07, 2004 at 12:37:13PM +0100, Lars Otte wrote:
>  
>
>>On my IBM Thinkpad 390e i have Problems with the Adaptec 1460D PCMCIA 
>>SCSI-Controller and Linux-Kernel 2.6.0.
>>It don't work and Oops at boottime. Everythink worked fine with 
>>Linux-Kernel 2.4.x
>>My NE2000 compatible PCMCIA Networkcard work fine with Kernel-2.6.0
>>    
>>
>
>Apparantly this (scsi) problem is fixed in 2.6.1-rc - could you confirm
>whether that is the case for your situation please?
>
>Thanks.
>
>  
>
I have tested Linux-Kernel 2.6.1-rc2 yesterday, and the Bug is still 
alive, It make an Oops and don't work.
remember that everything work fine with Linux-Kernel 2.4.23 and separate 
PCMCIA-drivers.

regards

Lars Otte


Linux version 2.6.1-rc2 (root@TDE-XP) (gcc version 2.95.4 20011002 
(Debian prerelease)) #2 Wed Jan 7 23:35:04 CET 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8c00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000ffffc00 (ACPI data)
 BIOS-e820: 000000000ffffc00 - 0000000010000000 (ACPI NVS)
 BIOS-e820: 00000000fffe8c00 - 0000000100000000 (reserved)
255MB LOWMEM available.
On node 0 totalpages: 65520
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 61424 pages, LIFO batch:14
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.1 present.
ACPI disabled because your bios is from 99 and too old
You can enable it with acpi=force
IBM machine detected. Enabling interrupts during APM calls.
IBM machine detected. Disabling SMBus accesses.
ACPI: RSDP (v000 PTLTD                                     ) @ 0x000f71a0
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x0fffaf8f
ACPI: FADT (v001 IBM    430BX    0x06040000 PTL  0x000f4240) @ 0x0ffffb65
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x0ffffbd9
ACPI: DSDT (v001    IBM      BT2 0x06040000 MSFT 0x01000007) @ 0x00000000
Building zonelist for node : 0
Kernel command line: auto BOOT_IMAGE=Linux ro root=301
Local APIC disabled by BIOS -- reenabling.
Could not enable APIC!
Initializing CPU#0
PID hash table entries: 1024 (order 10: 8192 bytes)
Detected 331.729 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Memory: 254828k/262080k available (2340k kernel code, 6528k reserved, 
1137k data, 200k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay loop... 653.31 BogoMIPS
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU:     After generic identify, caps: 0183f9ff 00000000 00000000 00000000
CPU:     After vendor identify, caps: 0183f9ff 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU:     After all inits, caps: 0183f9ff 00000000 00000000 00000040
CPU: Intel Mobile Pentium II stepping 0a
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd9c5, last bus=4
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20031002
ACPI: Interpreter disabled.
SCSI subsystem initialized
ACPI: ACPI tables contain no PCI IRQ routing entries
PCI: Invalid ACPI-PCI IRQ routing table
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:02.0
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb0: VGA16 VGA frame buffer device
SBF: ACPI BOOT descriptor is wrong length (39)
SBF: Simple Boot Flag extension found and enabled.
SBF: Setting boot flags 0x1
VFS: Disk quotas dquot_6.5.1
Limiting direct PCI/PCI transfers.
Console: switching to colour frame buffer device 80x30
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.12
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ttyS3 at I/O 0x2e8 (irq = 3) is a NS16550A
Using anticipatory io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Compaq CISS Driver (v 2.5.0)
pcnet32.c:v1.27b 01.10.2002 tsbogend@alpha.franken.de
HDLC support module revision 1.16
Cronyx Ltd, Synchronous PPP and CISCO HDLC (c) 1994
Linux port (c) 1998 Building Number Three Ltd & Jan "Yenya" Kasprzak.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:02.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc90-0xfc97, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xfc98-0xfc9f, BIOS settings: hdc:pio, hdd:pio
hda: IC25N040ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: CRN-8241B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 78140160 sectors (40007 MB) w/1768KiB Cache, CHS=65535/16/63, UDMA(33)
 hda: hda1 hda2 hda3 hda4
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, DMA
Uniform CD-ROM driver Revision: 3.12
ide-floppy driver 0.99.newide
Red Hat/Adaptec aacraid driver (1.1.2-lk1 Jan  7 2004)
3ware Storage Controller device driver for Linux v1.02.00.037.
3w-xxxx: No cards found.
Console: switching to colour frame buffer device 80x30
mice: PS/2 mouse device common for all mice
serio: i8042 AUX port at 0x60,0x64 irq 12
input: PS/2 Generic Mouse on isa0060/serio1
serio: i8042 KBD port at 0x60,0x64 irq 1
input: AT Translated Set 2 keyboard on isa0060/serio0
I2O Core - (C) Copyright 1999 Red Hat Software
I2O: Event thread created as pid 10
i2o: Checking for PCI I2O controllers...
I2O configuration manager v 0.04.
  (C) Copyright 1999 Red Hat Software
i2o_scsi.c: Version 0.1.2
  chain_pool: 0 bytes @ c1373340
  (512 byte buffers X 4 can_queue X 0 i2o controllers)
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 16384)
NET: Registered protocol family 1
NET: Registered protocol family 17
found reiserfs format "3.6" with standard journal
Reiserfs journal params: device hda1, size 8192, journal first block 18, 
max trans len 1024, max batch 900, max commit age 30, max trans age 30
reiserfs: checking transaction log (hda1) for (hda1)
reiserfs: replayed 11 transactions in 4 seconds
Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 200k freed
Adding 224900k swap on /dev/hda3.  Priority:-1 extents:1
Removing [123883 118032 0x0 SD]..done
Removing [791 877 0x0 SD]..done
There were 2 uncompleted unlinks/truncates. Completed
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
parport0: cpp_daisy: aa5500ff(38)
parport0: assign_addrs: aa5500ff(38)
parport0: cpp_daisy: aa5500ff(38)
parport0: assign_addrs: aa5500ff(38)
lp0: using parport0 (polling).
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
drivers/usb/core/usb.c: registered new driver usbfs
drivers/usb/core/usb.c: registered new driver hub
ohci_hcd: 2003 Oct 13 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ohci_hcd: block sizes: ed 64 td 64
drivers/usb/host/uhci-hcd.c: USB Universal Host Controller Interface 
driver v2.1
PCI: Found IRQ 11 for device 0000:00:02.2
uhci_hcd 0000:00:02.2: UHCI Host Controller
uhci_hcd 0000:00:02.2: irq 11, io base 0000fca0
uhci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Linux Kernel Card Services
  options:  [pci] [cardbus] [pm]
Intel ISA PCIC probe: not found.
PCI: Found IRQ 11 for device 0000:00:03.0
PCI: Sharing IRQ 11 with 0000:00:03.1
PCI: Sharing IRQ 11 with 0000:01:00.0
Yenta: CardBus bridge found at 0000:00:03.0 [1014:0138]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta: ISA IRQ mask 0x0698, PCI irq 11
Socket status: 30000010
PCI: Found IRQ 11 for device 0000:00:03.1
PCI: Sharing IRQ 11 with 0000:00:03.0
PCI: Sharing IRQ 11 with 0000:01:00.0
Yenta: CardBus bridge found at 0000:00:03.1 [1014:0138]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta: ISA IRQ mask 0x0698, PCI irq 11
Socket status: 30000010
cs: warning: no high memory space available!
cs: unable to map card memory!
cs: unable to map card memory!
cs: unable to map card memory!
cs: unable to map card memory!
cs: unable to map card memory!
cs: unable to map card memory!
request_module: failed /sbin/modprobe -- eth0. error = 256
cs: IO port probe 0x0c00-0x0cff: clean.
cs: IO port probe 0x0800-0x08ff: clean.
cs: IO port probe 0x0100-0x04ff: excluding 0x3c0-0x3df 0x4d0-0x4d7
cs: IO port probe 0x0a00-0x0aff: clean.
eth0: NE2000 Compatible: io 0x300, irq 3, hw_addr 00:00:B4:4E:25:19
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c028869d
*pde = 00000000
Oops: 0002 [#1]
CPU:    0
EIP:    0060:[<c028869d>]    Not tainted
EFLAGS: 00010286
EIP is at scsi_register+0x51/0x58
eax: cf2331c8   ebx: cf233000   ecx: 00000000   edx: d09c6a34
esi: d09c69c0   edi: cf701a94   ebp: cf701a6c   esp: cf701858
ds: 007b   es: 007b   ss: 0068
Process cardmgr (pid: 339, threadinfo=cf700000 task=cf119370)
Stack: cf701a6c 00000000 d09be843 d09c69c0 00000338 cf701a6c 00000000 
cf701a94
       cf701a94 d09be406 cf701a6c ce676ca0 ce676da0 cf28f344 0000002b 
ce676ca0
       491901c9 ca066555 1f034060 ce1e0030 cf701934 00000000 00000000 
00001050
Call Trace:
 [<d09be843>] aha152x_probe_one+0x17/0x3a0 [aha152x_cs]
 [<d09be406>] aha152x_config_cs+0x24a/0x2d0 [aha152x_cs]
 [<c01d0000>] fix_nodes+0x40c/0x44c
 [<c01d018a>] unfix_nodes+0x14a/0x160
 [<c01c01ca>] balance_leaf+0x11e/0x2b84
 [<c01dadb4>] reiserfs_insert_item+0xdc/0x130
 [<c01c3030>] do_balance_mark_leaf_dirty+0x54/0x64
 [<d09be56a>] aha152x_event+0x7e/0xe4 [aha152x_cs]
 [<c01d52ad>] leaf_delete_items+0x59/0x14c
 [<c01bfdbb>] balance_leaf_when_delete+0x6b/0x35c
 [<c01c0105>] balance_leaf+0x59/0x2b84
 [<c014f003>] __find_get_block+0xbb/0xc4
 [<d09aea6c>] pcmcia_get_next_tuple+0x74/0x214 [pcmcia_core]
 [<d09aea93>] pcmcia_get_next_tuple+0x9b/0x214 [pcmcia_core]
 [<d09ae85a>] pcmcia_get_first_tuple+0xfe/0x108 [pcmcia_core]
 [<d09afec5>] read_tuple+0x89/0x98 [pcmcia_core]
 [<d09b3e8e>] pcmcia_register_client+0x1ca/0x20c [pcmcia_core]
 [<c0125f2b>] update_wall_time+0xb/0x34
 [<c0126213>] do_timer+0x4b/0xc0
 [<c012d447>] rcu_check_quiescent_state+0x5f/0x7c
 [<c012d546>] rcu_process_callbacks+0xe2/0xfc
 [<c01228c1>] tasklet_action+0x3d/0x60
 [<d09b4fce>] CardServices+0x1a6/0x352 [pcmcia_core]
 [<d09be12b>] gcc2_compiled.+0x12b/0x15c [aha152x_cs]
 [<d09be4ec>] aha152x_event+0x0/0xe4 [aha152x_cs]
 [<d0977451>] bind_request+0x181/0x1e4 [ds]
 [<d0977e28>] ds_ioctl+0x498/0x580 [ds]
 [<c01381fd>] buffered_rmqueue+0x101/0x10c
 [<c01382ab>] __alloc_pages+0xa3/0x2dc
 [<c0140bcf>] do_anonymous_page+0x1df/0x1ec
 [<c0140c2f>] do_no_page+0x53/0x33c
 [<c011a4e2>] do_page_fault+0x13a/0x4a8
 [<c011ec55>] __mmdrop+0x31/0x36
 [<c011bfa5>] schedule+0x491/0x4f8
 [<c013f7ad>] zap_pmd_range+0x35/0x50
 [<c013f802>] unmap_page_range+0x3a/0x5c
 [<c013f908>] unmap_vmas+0xe4/0x1dc
 [<c0142abb>] unmap_region+0x83/0xc8
 [<c0142a09>] unmap_vma+0x69/0x70
 [<c0142a2a>] unmap_vma_list+0x1a/0x28
 [<c0142dd0>] do_munmap+0x11c/0x128
 [<c015c699>] sys_ioctl+0x209/0x260
 [<c010af2f>] syscall_call+0x7/0xb

Code: 89 01 89 d8 5b 5e c3 8b 44 24 04 8b 88 cc 01 00 00 8b 90 c8
 blk: queue c1378c00, I/O limit 4095Mb (mask 0xffffffff)
atkbd.c: Unknown key released (translated set 2, code 0x7a on 
isa0060/serio0).
atkbd.c: Unknown key released (translated set 2, code 0x7a on 
isa0060/serio0).
request_module: failed /sbin/modprobe -- sound-slot-0. error = 256
request_module: failed /sbin/modprobe -- sound-slot-0. error = 256


_______________________________________________________________________________________________________________


Linux version 2.6.0-Katerchen (root@debian) (gcc version 2.95.4 20011002 
(Debian prerelease)) #2 Thu Jan 1 01:42:54 CET 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8c00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000ffffc00 (ACPI data)
 BIOS-e820: 000000000ffffc00 - 0000000010000000 (ACPI NVS)
 BIOS-e820: 00000000fffe8c00 - 0000000100000000 (reserved)
0MB HIGHMEM available.
255MB LOWMEM available.
On node 0 totalpages: 65520
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 61424 pages, LIFO batch:14
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.1 present.
ACPI disabled because your bios is from 99 and too old
You can enable it with acpi=force
IBM machine detected. Enabling interrupts during APM calls.
IBM machine detected. Disabling SMBus accesses.
ACPI: RSDP (v000 PTLTD                                     ) @ 0x000f71a0
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x0fffaf8f
ACPI: FADT (v001 IBM    430BX    0x06040000 PTL  0x000f4240) @ 0x0ffffb65
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x0ffffbd9
ACPI: DSDT (v001    IBM      BT2 0x06040000 MSFT 0x01000007) @ 0x00000000
Building zonelist for node : 0
Kernel command line: auto BOOT_IMAGE=Linux ro root=301
Local APIC disabled by BIOS -- reenabling.
Could not enable APIC!
Initializing CPU#0
PID hash table entries: 1024 (order 10: 8192 bytes)
Detected 331.699 MHz processor.
Console: colour VGA+ 80x25
Memory: 254672k/262080k available (2434k kernel code, 6684k reserved, 
1143k data, 228k init, 0k highmem)
Calibrating delay loop... 653.31 BogoMIPS
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU:     After generic identify, caps: 0183f9ff 00000000 00000000 00000000
CPU:     After vendor identify, caps: 0183f9ff 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU:     After all inits, caps: 0183f9ff 00000000 00000000 00000040
CPU: Intel Mobile Pentium II stepping 0a
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd9c5, last bus=4
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20031002
ACPI: Interpreter disabled.
SCSI subsystem initialized
ACPI: ACPI tables contain no PCI IRQ routing entries
PCI: Invalid ACPI-PCI IRQ routing table
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:02.0
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb0: VGA16 VGA frame buffer device
SBF: ACPI BOOT descriptor is wrong length (39)
SBF: Simple Boot Flag extension found and enabled.
SBF: Setting boot flags 0x1
VFS: Disk quotas dquot_6.5.1
Limiting direct PCI/PCI transfers.
Console: switching to colour frame buffer device 80x30
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.12
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ttyS3 at I/O 0x2e8 (irq = 3) is a NS16550A
Using anticipatory io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Compaq CISS Driver (v 2.5.0)
pcnet32.c:v1.27b 01.10.2002 tsbogend@alpha.franken.de
HDLC support module revision 1.16
Cronyx Ltd, Synchronous PPP and CISCO HDLC (c) 1994
Linux port (c) 1998 Building Number Three Ltd & Jan "Yenya" Kasprzak.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:02.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc90-0xfc97, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xfc98-0xfc9f, BIOS settings: hdc:pio, hdd:pio
hda: IC25N040ATCS04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: CRN-8241B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 78140160 sectors (40007 MB) w/1768KiB Cache, CHS=65535/16/63, UDMA(33)
 hda: hda1 hda2 hda3 hda4
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, DMA
Uniform CD-ROM driver Revision: 3.12
ide-floppy driver 0.99.newide
Red Hat/Adaptec aacraid driver (1.1.2 Jan  1 2004)
3ware Storage Controller device driver for Linux v1.02.00.037.
3w-xxxx: No cards found.
Console: switching to colour frame buffer device 80x30
mice: PS/2 mouse device common for all mice
input: PS/2 Generic Mouse on isa0060/serio1
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Translated Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
I2O Core - (C) Copyright 1999 Red Hat Software
I2O: Event thread created as pid 10
i2o: Checking for PCI I2O controllers...
I2O configuration manager v 0.04.
  (C) Copyright 1999 Red Hat Software
i2o_scsi.c: Version 0.1.2
  chain_pool: 0 bytes @ c1369360
  (512 byte buffers X 4 can_queue X 0 i2o controllers)
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 16384)
NET: Registered protocol family 1
NET: Registered protocol family 17
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: hda1: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 227725
EXT3-fs: hda1: 1 orphan inode deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 228k freed
Adding 224900k swap on /dev/hda3.  Priority:-1 extents:1
EXT3 FS on hda1, internal journal
drivers/usb/core/usb.c: registered new driver usbfs
drivers/usb/core/usb.c: registered new driver hub
Initializing USB Mass Storage driver...
drivers/usb/core/usb.c: registered new driver usb-storage
USB Mass Storage support registered.
drivers/usb/core/usb.c: registered new driver usbkbd
drivers/usb/input/usbkbd.c: :USB HID Boot Protocol keyboard driver
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
parport0: cpp_daisy: aa5500ff(38)
parport0: assign_addrs: aa5500ff(38)
parport0: cpp_daisy: aa5500ff(38)
parport0: assign_addrs: aa5500ff(38)
lp0: using parport0 (polling).
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
drivers/usb/host/uhci-hcd.c: USB Universal Host Controller Interface 
driver v2.1
PCI: Found IRQ 11 for device 0000:00:02.2
uhci_hcd 0000:00:02.2: UHCI Host Controller
uhci_hcd 0000:00:02.2: irq 11, io base 0000fca0
uhci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd: 2003 Oct 13 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ohci_hcd: block sizes: ed 64 td 64
drivers/usb/core/usb.c: registered new driver usbmouse
drivers/usb/input/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
PCI: Found IRQ 5 for device 0000:00:07.0
snd_opl3_synth: Unknown parameter `snd-seq-midi'
Linux Kernel Card Services
 options:  [pci] [cardbus] [pm]
Intel PCIC probe: not found.
PCI: Found IRQ 11 for device 0000:00:03.0
PCI: Sharing IRQ 11 with 0000:00:03.1
PCI: Sharing IRQ 11 with 0000:01:00.0
Yenta: CardBus bridge found at 0000:00:03.0 [1014:0138]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta: ISA IRQ list 0698, PCI irq11
Socket status: 30000010
PCI: Found IRQ 11 for device 0000:00:03.1
PCI: Sharing IRQ 11 with 0000:00:03.0
PCI: Sharing IRQ 11 with 0000:01:00.0
Yenta: CardBus bridge found at 0000:00:03.1 [1014:0138]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta: ISA IRQ list 0698, PCI irq11
Socket status: 30000010
cs: IO port probe 0x0c00-0x0cff: clean.
cs: IO port probe 0x0800-0x08ff: clean.
cs: IO port probe 0x0100-0x04ff: excluding 0x3c0-0x3df 0x4d0-0x4d7
cs: IO port probe 0x0a00-0x0aff: clean.
cs: memory probe 0xa0000000-0xa0ffffff: clean.
eth0: NE2000 Compatible: io 0x300, irq 3, hw_addr 00:00:B4:4E:25:19
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c0298211
*pde = 00000000
Oops: 0002 [#1]
CPU:    0
EIP:    0060:[<c0298211>]    Not tainted
EFLAGS: 00010286
EIP is at scsi_register+0x51/0x60
eax: cf53e1c8   ebx: cf53e000   ecx: 00000000   edx: d093fd34
esi: d093fcc0   edi: cf2d5a94   ebp: cf2d5a6c   esp: cf2d5854
ds: 007b   es: 007b   ss: 0068
Process cardmgr (pid: 410, threadinfo=cf2d4000 task=cf665930)
Stack: cf2d5a6c 00000000 d093788a d093fcc0 00000338 cf2d5a6c 00000000 
cf2d5a94
       cf2d5a94 c03f6300 d093740b cf2d5a6c cebc6a40 cebc6b40 cf8082e4 
0000002b
       cebc6a40 491901c9 ca066555 1f034060 c01e0030 cf2d58b8 00000000 
000058c0
Call Trace:
 [<d093788a>] aha152x_probe_one+0x1a/0x3f0 [aha152x_cs]
 [<d093740b>] aha152x_config_cs+0x24b/0x2e0 [aha152x_cs]
 [<c01e0030>] prepare_for_delete_or_cut+0x710/0x770
 [<c011d597>] default_wake_function+0x17/0x20
 [<c011d5d3>] __wake_up_common+0x33/0x50
 [<d09096eb>] yenta_set_mem_map+0x18b/0x1c0 [yenta_socket]
 [<d09096eb>] yenta_set_mem_map+0x18b/0x1c0 [yenta_socket]
 [<d0915235>] read_cis_mem+0x105/0x180 [pcmcia_core]
 [<d09154d7>] read_cis_cache+0xf7/0x150 [pcmcia_core]
 [<d0915cbf>] pcmcia_get_tuple_data+0x6f/0x80 [pcmcia_core]
 [<d0916ee7>] pcmcia_parse_tuple+0xd7/0x170 [pcmcia_core]
 [<d09096eb>] yenta_set_mem_map+0x18b/0x1c0 [yenta_socket]
 [<d093758a>] aha152x_event+0x8a/0xf0 [aha152x_cs]
 [<d0916fb6>] read_tuple+0x36/0x90 [pcmcia_core]
 [<d09154d7>] read_cis_cache+0xf7/0x150 [pcmcia_core]
 [<d0915a96>] pcmcia_get_next_tuple+0x76/0x230 [pcmcia_core]
 [<d0915ab9>] pcmcia_get_next_tuple+0x99/0x230 [pcmcia_core]
 [<d0917142>] pcmcia_validate_cis+0x132/0x180 [pcmcia_core]
 [<c0191a30>] do_get_write_access+0x570/0x5a0
 [<c0191a30>] do_get_write_access+0x570/0x5a0
 [<d091b1dd>] pcmcia_register_client+0x1cd/0x210 [pcmcia_core]
 [<d09096eb>] yenta_set_mem_map+0x18b/0x1c0 [yenta_socket]
 [<d091c3be>] CardServices+0x19e/0x34a [pcmcia_core]
 [<d0915235>] read_cis_mem+0x105/0x180 [pcmcia_core]
 [<d093712b>] gcc2_compiled.+0x12b/0x160 [aha152x_cs]
 [<d0937500>] aha152x_event+0x0/0xf0 [aha152x_cs]
 [<d09054b1>] bind_request+0x181/0x1f0 [ds]
 [<d0905ed8>] ds_ioctl+0x4a8/0x590 [ds]
 [<c011d60c>] __wake_up+0x1c/0x40
 [<c013a6ad>] buffered_rmqueue+0xfd/0x110
 [<c013a74d>] __alloc_pages+0x8d/0x2b0
 [<c011c4f1>] kmap_atomic+0x21/0x80
 [<c01439bf>] do_anonymous_page+0x1ef/0x200
 [<c0143a1b>] do_no_page+0x4b/0x370
 [<c011b795>] do_page_fault+0x135/0x4d0
 [<c014236a>] zap_pte_range+0x5a/0x1a0
 [<c01424e4>] zap_pmd_range+0x34/0x50
 [<c014253e>] unmap_page_range+0x3e/0x60
 [<c014266e>] unmap_vmas+0x10e/0x210
 [<c0145973>] unmap_region+0x83/0xd0
 [<c01458b9>] unmap_vma+0x69/0x70
 [<c01458da>] unmap_vma_list+0x1a/0x30
 [<c0145cb0>] do_munmap+0x120/0x130
 [<c0160429>] sys_ioctl+0x1f9/0x250
 [<c010b077>] syscall_call+0x7/0xb

Code: 89 01 89 d8 5b 5e c3 90 8d b4 26 00 00 00 00 8b 44 24 04 8b
 blk: queue c136fc00, I/O limit 4095Mb (mask 0xffffffff)


----- End forwarded message -----

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
