From: joshuam@gravityedge.com
Subject: Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup
Date: Mon, 25 Jul 2005 12:49:25 -0700 (PDT)
Message-ID: <1671.206.173.47.7.1122320965.squirrel@mail.gravityedge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from limelyte.com ([207.170.253.138]:60080 "EHLO mail.limelyte.com")
	by vger.kernel.org with ESMTP id S261389AbVGYTt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 15:49:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1. Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup

2. I can get this to panic on every bootup, I have included the Kernel
boot output below.

3. Linux SCSI panic Adaptec 2015 bootup

4. Kernel version: 2.6.12.3

5. Kernel Output/Oops

Linux version 2.6.12.3 (root@graviton.krk0) (gcc version 3.3.5 (Debian
1:3.3.5-
)) #2 SMP Fri Jul 22 14:52:48 PDT 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
 BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001fef8000 (ACPI data)
 BIOS-e820: 000000001fef8000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 000000001ff80000 (usable)
 BIOS-e820: 000000001ff80000 - 0000000
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
found SMP MP-table at 000f6ca0
DMI present.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID:   Product ID: Kings Canyon APIC at: 0xFEE00000
Processor #0 15:2 APIC version 20
Processor #1 15:2 APIC ve
I/O APIC #2 Version 32 at 0xFEC00000.
I/O APIC #3 Version 32 at 0xFEC80000.
I/O APIC #4 Version 32 at 0xFEC80400.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Processors: 2
Allocating PCI resources starting at 20000000 (gap: 20000000:dec00000)
Built 1 zonelists
Kernel command line: vga=normal initrd=/install/initrd.gz
ramdisk_size=10240 roo
t=/dev/ram0 devfs=mount,dall rw -- BOOT_IMAGE=/install/vmlinuz
console=ttyS0,576
00
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 32768 bytes)
Detected 2399.779
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 505948k/523776k available (4467k kernel code, 17108k reserved,
2100k dat
a, 296k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
Checking for popad bug... OK.
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 05
Booting processor 1/1 eip 2000
Initializing CPU#1
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 05
Total of 2 processors activated (9519.10 BogoMIPS).
ENABLING IO-APIC
..TIMER: vector=0x31 pin1=2 pin2=0
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
checking if image is initramfs...it isn't (no cpio magic); looks like an
initrd
Freeing initrd memory: 3874k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd8c5, last bus=4
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Transparent bridge - 0000:00:1e.0
PCI: Discovered primary peer bus 10 [IRQ]
PCI: Discovered primary peer bus 11 [IRQ]
PCI: Discovered primary peer bus 12 [IRQ]
PCI: Using IRQ router PIIX/ICH [8086/2480] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:1d.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1d.1[B] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1d.2[C] -> IRQ 18
PCI->APIC IRQ transform: 000
PCI->APIC IRQ transform: 0000:02:03.1[B] -> IRQ 55
PCI->APIC IRQ transform: 0000:03:03.0[A] -> IRQ 30
PCI->APIC IRQ transform: 0000:04:01.0[A] -> IRQ 16
apm: BIOS not found.
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)
devfs: boot_options: 0x1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.22 [Flags: R/W].
SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Initializing Cryptographic API
vga16fb: mapped to 0xc00a0000
fb0: VGA16 VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
lp: driver loaded but no devices found
Real Time Clock Driver v1.12
hw_random hardware driver 1.0.0 loaded
Linux agpgart interface v0.101 (c) Dave Jones
[drm] Initialized drm 1.0.0 20040925
ipmi message handler version v33
ipmi device interface version v33
IPMI System Interface driver version v33, KCS version v33, SM
version v33
ipmi_si: Trying "kcs" at I/O port 0xca2
ipmi_si: Trying "smic" at I/O port 0xca9
ipmi_si: Trying "bt" at I/O port 0xe4
ipmi_si: Unable to find any System Interface(s)
IPMI Watchdog: driver version v33
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot
version v
33.
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G
chipset
s
intelfb: Version 0.9.2
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 10240K size 1024 blocksize
loop: loaded (max 8 devices)
pktcdvd: v0.2.0a 2004-07-14 Jens Axboe (axboe@suse.de) and petero2@telia.com
Intel(R) PRO/1000 Network Driver - version 6.0.54-k2
Copyright (c) 1999-2004 Intel Corporation.
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.4.8-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Cronyx Ltd, Synchronous PPP and CISCO HDLC (c) 1994
Linux port (c) 1998 Building Number Three Ltd & Jan "Yenya" Kasprzak.
DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
HDLC support module revision 1.17
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH3: IDE controller at PCI slot 0000:00:
ICH3: chipset revision 2
ICH3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x2060-0x2067, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x2068-0x206f, BIOS settings: hdc:pio, hdd:pio
hdc: CD-224E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec I2O RAID controller 0 irq=30
     BAR0 e0900000 -
     BAR1 e0a80000 - size= 1000000
dpti: If you have a lot of devices this could take a few minutes.
dpti0: Reading the hardware resource table.
TID 008  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001
TID 009  Vendor: ADAPTEC      Device: AIC-7902     Rev: 00000001
TID 513  Vendor: SUPER   G    Device: GEM318       Rev: 0   0
scsi0 : Vendor: Adaptec  Model: 2015S            FW:3B0A
  Vendor: SUPER     Model: GEM318            Rev: 0
  Type:   Processor                          ANSI SCSI revision: 02
megaraid cmm: 2.20.2.5 (Release Date: Fri Jan 21 00:01:03 EST 2005)
megaraid: 2.20.4.5 (Release Date: Thu Feb 03 12:27:22 EST 2005)
3ware Storage Controller device driver for Linux v1.26.02.001.
3ware 9000 Storage Controller device driver for Linux v2.26.02.002.
Attached scsi generic sg0 at scsi0, channel 0, id 6, lun 0,  type 3
I2O subsystem v$Rev$
i2o: max drivers = 8
i2o: Checking for PCI I2O controllers...
i2o: I2O controller found on bus 3 at 24.
iop0: PCI I2O controller
     BAR0 at 0xF8300000 size=1048576
     BAR1 at 0xFB000000 size=16777216
iop0: using write combining MTRR
iop0: Installed at IRQ 30
iop0: Activating I2O controller...
iop0: This may take a few minutes if there are many devices
Unable to handle kernel paging request at virtual address 8000002c
 printing eip:
c03f1037
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in:
CPU:    0
EIP:    0060:[<c03f1037>]    Not tainted VLI
EFLAGS: 00010086   (2.6.12.3)
EIP is at adpt_isr+0x12f/0x1f8
eax: 80000000   ebx: dfcd0000   ecx: c17e0000   edx: c17e0000
esi: c17e0000   edi: 00000000   ebp: 1fcd0000   esp: c076df48
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c076c000 task=c0673bc0)
Stack: 00000000 00000286 00000000 dfc48ec0 00000000 c076dfac 0000001e
c01358ff
       0000001e c17e0000 c076dfac 00000000 0000001e c07687b0 000003c0
c07687cc
       c01359f5 dfc48ec0 c076dfac ffffe000 c076c000 c07b4380 c07b4300
c0104dd5
Call Trace:
 [<c01358ff>] handle_IRQ_event+0x23/0x58
 [<c01359f5>] __do_IRQ+0xc1/0x10c
 [<c0104dd5>] do_IRQ+0x19/0x24
 [<c01037d2>] common_interrupt+0x1a/0x20
 [<c01009e0>] default_idle+0x0/0x2c
 [<c0100a03>] default_idle+0x23/0x2c
 [<c0100aa2>] cpu_idle+0x62/0x74
 [<c076e81b>] start_kernel+0x17f/0x1b4
Code: 00 00 00 40 89 44 24 08 74 12 8b 7b 0c 85 ff 74 0b b9 11 00 00 00 89
de f3
 a5 89 f6 8b 7c 24 08 85 ff 78 34 8b 43 0c 85 c0 74 07 <8b> 70 2c 85 f6 75
1a 8b
 54 24 24 8b 82 88 00 00 00 89 28 0f ae
 <0>Kernel panic - not syncing: Fatal exception in interrupt


Joshua McClintock



