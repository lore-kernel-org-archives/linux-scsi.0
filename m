From: Raffael Himmelreich <raffi@raffi.at>
Subject: Fwd: [SCSI timeouts (was: Re: RS/6000 7017-S7A hangs on boot)]
Date: Sun, 5 Jun 2005 23:34:34 +0200
Message-ID: <20050605213434.GE9906@exception.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.exception.at ([80.252.41.3]:1687 "EHLO mail.exception.at")
	by vger.kernel.org with ESMTP id S261608AbVFEVeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2005 17:34:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I experience problems when I try to get linux running on
PPC64. I've sent the appended mail to the linuxppc64-dev mailinglist
but nobody answedered.
Maybe my problem is more on-topic here? :-)

regards,
raffi

Ps: Please include me in Cc

----- Forwarded message from Raffael Himmelreich <raffi@raffi.at> -----

Date: Tue, 31 May 2005 23:26:38 +0200
From: Raffael Himmelreich <raffi@raffi.at>
To: linuxppc64-dev@ozlabs.org
User-Agent: Mutt/1.4.1i
Subject: SCSI timeouts (was: Re: RS/6000 7017-S7A hangs on boot)


[...] But now I am facing strange SCSI
timeouts. Any ideas? (these SCSI devices work well under AIX)

[...]

                        Boot log goes here:
zImage starting: loaded at 0x400000
Allocating 0x80a000 bytes for kernel ...
gunzipping (0x1c00000 <- 0x407000:0x695dc7)...done 0x6b5bd8 bytes
0xde98 bytes of heap consumed, max in use 0xa294
OF stdout device is: /pci@f8400000/isa@f/serial@i3f8
command line: root=/dev/fd0
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 000000000231e000
  alloc_top    : 0000000040000000
  alloc_top_hi : 0000000140000000
  rmo_top      : 0000000040000000
  ram_top      : 0000000140000000
Looking for displays
opening PHB /pci@f8400000... done
opening PHB /pci@f8500000... done
opening PHB /pci@f8600000... done
opening PHB /pci@f8700000... done
instantiating rtas at 0x000000003ffd7000... done
0000000000000001 : starting cpu hw idx 0000000000000001... done
0000000000000002 : starting cpu hw idx 0000000000000002... done
0000000000000003 : starting cpu hw idx 0000000000000003... done
WARNING: maximum CPUs (1) exceeded: ignoring extras
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x000000000241f000 -> 0x000000000241fd7c
Device tree struct  0x0000000002420000 -> 0x0000000002429000
Calling quiesce ...
returning from prom_init
firmware_features = 0x0
Starting Linux PPC64 2.6.12-rc5
-----------------------------------------------------
ppc64_pft_size                = 0x1a
ppc64_debug_switch            = 0x0
ppc64_interrupt_controller    = 0x1
systemcfg                     = 0xc0000000004d0000
systemcfg->platform           = 0x100
systemcfg->processorCount     = 0x0
systemcfg->physicalMemorySize = 0xc0000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc000000138000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
[boot]0100 MM Init
IO Hole assumed to be 80000000 -> ffffffff
[boot]0100 MM Init Done
Linux version 2.6.12-rc5 (root@localhost.localdomain) (gcc version 3.4.3) #2 Wed May 25 14:20:01 CEST 2005
[boot]0012 Setup Arch
Syscall map setup, 236 32 bits and 212 64 bits syscalls
mpic: Setting up MPIC " MPIC     " version <unknown> at ffc00000, max 1 CPUs
mpic: ISU size: 16, shift: 4, mask: f
No ramdisk, default root is /dev/sda2
Python workaround: reg0: 218e3b88
Python workaround: reg0: 218e3b88
Python workaround: reg0: 218e3b88
Python workaround: reg0: 218e3b88
PPC64 nvram contains 122880 bytes
Using default idle loop
Top of RAM: 0x140000000, Total RAM: 0xc0000000
Memory hole size: 2048MB
[boot]0015 Setup Done
Built 1 zonelists
Kernel command line: root=/dev/fd0
mpic: Initializing for 64 sources
PID hash table entries: 4096 (order: 12, 131072 bytes)
time_init: decrementer frequency = 262.731521 MHz
time_init: processor frequency   = 251.781200 MHz
firmware_features = 0x0
Starting Linux PPC64 2.6.12-rc5
-----------------------------------------------------
ppc64_pft_size                = 0x1a
ppc64_debug_switch            = 0x0
ppc64_interrupt_controller    = 0x1
systemcfg                     = 0xc0000000004d0000
systemcfg->platform           = 0x100
systemcfg->processorCount     = 0x0
systemcfg->physicalMemorySize = 0xc0000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc000000138000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
[boot]0100 MM Init
IO Hole assumed to be 80000000 -> ffffffff
[boot]0100 MM Init Done
Linux version 2.6.12-rc5 (root@localhost.localdomain) (gcc version 3.4.3) #2 Wed May 25 14:20:01 CEST 2005
[boot]0012 Setup Arch
Syscall map setup, 236 32 bits and 212 64 bits syscalls
mpic: Setting up MPIC " MPIC     " version <unknown> at ffc00000, max 1 CPUs
mpic: ISU size: 16, shift: 4, mask: f
No ramdisk, default root is /dev/sda2
Python workaround: reg0: 218e3b88
Python workaround: reg0: 218e3b88
Python workaround: reg0: 218e3b88
Python workaround: reg0: 218e3b88
PPC64 nvram contains 122880 bytes
Using default idle loop
Top of RAM: 0x140000000, Total RAM: 0xc0000000
Memory hole size: 2048MB
[boot]0015 Setup Done
Built 1 zonelists
Kernel command line: root=/dev/fd0
mpic: Initializing for 64 sources
PID hash table entries: 4096 (order: 12, 131072 bytes)
time_init: decrementer frequency = 262.731521 MHz
time_init: processor frequency   = 251.781200 MHz
Console: colour dummy device 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 2961152k/5242880k available (4040k kernel code, 2281068k reserved, 1880k data, 415k bss, 316k init)
Mount-cache hash table entries: 256
NET: Registered protocol family 16
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
mapping IO e0000000 -> e000000000000000, size: 2000000
mapping IO e2000000 -> e000000002000000, size: 800000
mapping IO e2800000 -> e000000002800000, size: 800000
mapping IO e3000000 -> e000000003000000, size: 800000
ISA bridge at 0000:00:0f.0
PCI: Probing PCI hardware done
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
i/pSeries Real Time Clock Driver v1.1
RTAS daemon started
audit: initializing netlink socket (disabled)
audit(343277964121.727:0): initialized
Total HugeTLB memory allocated, 0
Initializing Cryptographic API
HVSI: registered 0 devices
Initializing IBM hvcs (Hypervisor Virtual Console Server) Driver
HVCS: driver module inserted.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Floppy drive(s): fd0 is 2.88M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 5.7.6-k2
Copyright (c) 1999-2004 Intel Corporation.
pcnet32.c:v1.30i 06.28.2004 tsbogend@alpha.franken.de
pcnet32: PCnet/PCI II 79C970A at 0x1fff400, warning: CSR address invalid,
    using instead PROM address of 02 07 01 23 fc e8 assigned IRQ 22.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: PCnet/FAST 79C971 at 0x27ff400, 00 20 35 35 74 a5
    tx_start_pt(0x0c00):~220 bytes, BCR18(68e2):BurstWrEn BurstRdEn DWordIO NoUFlow 
    SRAMSIZE=0x7f00, SRAM_BND=0x4000, assigned IRQ 38.
eth1: registered as PCnet/FAST 79C971
pcnet32: PCnet/FAST 79C971 at 0x2ffec00, warning: CSR address invalid,
    using instead PROM address of 00 04 ac de 92 54
    tx_start_pt(0x0c00):~220 bytes, BCR18(6861):BurstWrEn BurstRdEn NoUFlow 
    SRAMSIZE=0x7f00, SRAM_BND=0x4000, assigned IRQ 54.
eth2: registered as PCnet/FAST 79C971
pcnet32: 3 cards_found.
e100: Intel(R) PRO/100 Network Driver, 3.3.6-k2-NAPI
e100: Copyright(c) 1999-2004 Intel Corporation
drivers/net/ibmveth.c: ibmveth: IBM i/pSeries Virtual Ethernet Driver 1.03
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
sym0: <825a> rev 0x13 at pci 0000:00:0b.0 irq 25
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.0
 0:0:0:0: ABORT operation started.
 0:0:0:0: ABORT operation timed-out.
 0:0:0:0: DEVICE RESET operation started.
 0:0:0:0: DEVICE RESET operation timed-out.
 0:0:0:0: BUS RESET operation started.
 0:0:0:0: BUS RESET operation timed-out.
 0:0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
 0:0:1:0: ABORT operation started.
 0:0:1:0: ABORT operation timed-out.
 0:0:1:0: DEVICE RESET operation started.
 0:0:1:0: DEVICE RESET operation timed-out.
 0:0:1:0: BUS RESET operation started.
 0:0:1:0: BUS RESET operation timed-out.
 0:0:1:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:1:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 1 lun 0
 0:0:2:0: ABORT operation started.
 0:0:2:0: ABORT operation timed-out.
 0:0:2:0: DEVICE RESET operation started.
 0:0:2:0: DEVICE RESET operation timed-out.
 0:0:2:0: BUS RESET operation started.
 0:0:2:0: BUS RESET operation timed-out.
 0:0:2:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:2:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 2 lun 0
 0:0:3:0: ABORT operation started.
 0:0:3:0: ABORT operation timed-out.
 0:0:3:0: DEVICE RESET operation started.
 0:0:3:0: DEVICE RESET operation timed-out.
 0:0:3:0: BUS RESET operation started.
 0:0:3:0: BUS RESET operation timed-out.
 0:0:3:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:3:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 3 lun 0
 0:0:4:0: ABORT operation started.
 0:0:4:0: ABORT operation timed-out.
 0:0:4:0: DEVICE RESET operation started.
 0:0:4:0: DEVICE RESET operation timed-out.
 0:0:4:0: BUS RESET operation started.
 0:0:4:0: BUS RESET operation timed-out.
 0:0:4:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:4:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 4 lun 0
 0:0:5:0: ABORT operation started.
 0:0:5:0: ABORT operation timed-out.
 0:0:5:0: DEVICE RESET operation started.
 0:0:5:0: DEVICE RESET operation timed-out.
 0:0:5:0: BUS RESET operation started.
 0:0:5:0: BUS RESET operation timed-out.
 0:0:5:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:5:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 5 lun 0
 0:0:6:0: ABORT operation started.
 0:0:6:0: ABORT operation timed-out.
 0:0:6:0: DEVICE RESET operation started.
 0:0:6:0: DEVICE RESET operation timed-out.
 0:0:6:0: BUS RESET operation started.
 0:0:6:0: BUS RESET operation timed-out.
 0:0:6:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:6:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 6 lun 0
 0:0:8:0: ABORT operation started.
 0:0:8:0: ABORT operation timed-out.
 0:0:8:0: DEVICE RESET operation started.
 0:0:8:0: DEVICE RESET operation timed-out.
 0:0:8:0: BUS RESET operation started.
 0:0:8:0: BUS RESET operation timed-out.
 0:0:8:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:8:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 8 lun 0
 0:0:9:0: ABORT operation started.
 0:0:9:0: ABORT operation timed-out.
 0:0:9:0: DEVICE RESET operation started.
 0:0:9:0: DEVICE RESET operation timed-out.
 0:0:9:0: BUS RESET operation started.
 0:0:9:0: BUS RESET operation timed-out.
 0:0:9:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:9:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 9 lun 0
 0:0:10:0: ABORT operation started.
 0:0:10:0: ABORT operation timed-out.
 0:0:10:0: DEVICE RESET operation started.
 0:0:10:0: DEVICE RESET operation timed-out.
 0:0:10:0: BUS RESET operation started.
 0:0:10:0: BUS RESET operation timed-out.
 0:0:10:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:10:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 10 lun 0
 0:0:11:0: ABORT operation started.
 0:0:11:0: ABORT operation timed-out.
 0:0:11:0: DEVICE RESET operation started.
 0:0:11:0: DEVICE RESET operation timed-out.
 0:0:11:0: BUS RESET operation started.
 0:0:11:0: BUS RESET operation timed-out.
 0:0:11:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:11:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 11 lun 0
 0:0:12:0: ABORT operation started.
 0:0:12:0: ABORT operation timed-out.
 0:0:12:0: DEVICE RESET operation started.
 0:0:12:0: DEVICE RESET operation timed-out.
 0:0:12:0: BUS RESET operation started.
 0:0:12:0: BUS RESET operation timed-out.
 0:0:12:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:12:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 12 lun 0
 0:0:13:0: ABORT operation started.
 0:0:13:0: ABORT operation timed-out.
 0:0:13:0: DEVICE RESET operation started.
 0:0:13:0: DEVICE RESET operation timed-out.
 0:0:13:0: BUS RESET operation started.
 0:0:13:0: BUS RESET operation timed-out.
 0:0:13:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:13:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 13 lun 0
 0:0:14:0: ABORT operation started.
 0:0:14:0: ABORT operation timed-out.
 0:0:14:0: DEVICE RESET operation started.
 0:0:14:0: DEVICE RESET operation timed-out.
 0:0:14:0: BUS RESET operation started.
 0:0:14:0: BUS RESET operation timed-out.
 0:0:14:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:14:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 14 lun 0
 0:0:15:0: ABORT operation started.
 0:0:15:0: ABORT operation timed-out.
 0:0:15:0: DEVICE RESET operation started.
 0:0:15:0: DEVICE RESET operation timed-out.
 0:0:15:0: BUS RESET operation started.
 0:0:15:0: BUS RESET operation timed-out.
 0:0:15:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:15:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 15 lun 0
sym1: <875> rev 0x3 at pci 0000:00:0d.0 irq 23
sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.0
 1:0:0:0: ABORT operation started.
 1:0:0:0: ABORT operation timed-out.
 1:0:0:0: DEVICE RESET operation started.
 1:0:0:0: DEVICE RESET operation timed-out.
 1:0:0:0: BUS RESET operation started.
 1:0:0:0: BUS RESET operation timed-out.
 1:0:0:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
 1:0:1:0: ABORT operation started.
 1:0:1:0: ABORT operation timed-out.
 1:0:1:0: DEVICE RESET operation started.
 1:0:1:0: DEVICE RESET operation timed-out.
 1:0:1:0: BUS RESET operation started.
 1:0:1:0: BUS RESET operation timed-out.
 1:0:1:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:1:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 1 lun 0
 1:0:2:0: ABORT operation started.
 1:0:2:0: ABORT operation timed-out.
 1:0:2:0: DEVICE RESET operation started.
 1:0:2:0: DEVICE RESET operation timed-out.
 1:0:2:0: BUS RESET operation started.
 1:0:2:0: BUS RESET operation timed-out.
 1:0:2:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:2:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 2 lun 0
 1:0:3:0: ABORT operation started.
 1:0:3:0: ABORT operation timed-out.
 1:0:3:0: DEVICE RESET operation started.
 1:0:3:0: DEVICE RESET operation timed-out.
 1:0:3:0: BUS RESET operation started.
 1:0:3:0: BUS RESET operation timed-out.
 1:0:3:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:3:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 3 lun 0
 1:0:4:0: ABORT operation started.
 1:0:4:0: ABORT operation timed-out.
 1:0:4:0: DEVICE RESET operation started.
 1:0:4:0: DEVICE RESET operation timed-out.
 1:0:4:0: BUS RESET operation started.
 1:0:4:0: BUS RESET operation timed-out.
 1:0:4:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:4:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 4 lun 0
 1:0:5:0: ABORT operation started.
 1:0:5:0: ABORT operation timed-out.
 1:0:5:0: DEVICE RESET operation started.
 1:0:5:0: DEVICE RESET operation timed-out.
 1:0:5:0: BUS RESET operation started.
 1:0:5:0: BUS RESET operation timed-out.
 1:0:5:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:5:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 5 lun 0
 1:0:6:0: ABORT operation started.
 1:0:6:0: ABORT operation timed-out.
 1:0:6:0: DEVICE RESET operation started.
 1:0:6:0: DEVICE RESET operation timed-out.
 1:0:6:0: BUS RESET operation started.
 1:0:6:0: BUS RESET operation timed-out.
 1:0:6:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:6:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 6 lun 0
 1:0:8:0: ABORT operation started.
 1:0:8:0: ABORT operation timed-out.
 1:0:8:0: DEVICE RESET operation started.
 1:0:8:0: DEVICE RESET operation timed-out.
 1:0:8:0: BUS RESET operation started.
 1:0:8:0: BUS RESET operation timed-out.
 1:0:8:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:8:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 8 lun 0
 1:0:9:0: ABORT operation started.
 1:0:9:0: ABORT operation timed-out.
 1:0:9:0: DEVICE RESET operation started.
 1:0:9:0: DEVICE RESET operation timed-out.
 1:0:9:0: BUS RESET operation started.
 1:0:9:0: BUS RESET operation timed-out.
 1:0:9:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:9:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 9 lun 0
 1:0:10:0: ABORT operation started.
 1:0:10:0: ABORT operation timed-out.
 1:0:10:0: DEVICE RESET operation started.
 1:0:10:0: DEVICE RESET operation timed-out.
 1:0:10:0: BUS RESET operation started.
 1:0:10:0: BUS RESET operation timed-out.
 1:0:10:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:10:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 10 lun 0
 1:0:11:0: ABORT operation started.
 1:0:11:0: ABORT operation timed-out.
 1:0:11:0: DEVICE RESET operation started.
 1:0:11:0: DEVICE RESET operation timed-out.
 1:0:11:0: BUS RESET operation started.
 1:0:11:0: BUS RESET operation timed-out.
 1:0:11:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:11:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 11 lun 0
 1:0:12:0: ABORT operation started.
 1:0:12:0: ABORT operation timed-out.
 1:0:12:0: DEVICE RESET operation started.
 1:0:12:0: DEVICE RESET operation timed-out.
 1:0:12:0: BUS RESET operation started.
 1:0:12:0: BUS RESET operation timed-out.
 1:0:12:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:12:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 12 lun 0
 1:0:13:0: ABORT operation started.
 1:0:13:0: ABORT operation timed-out.
 1:0:13:0: DEVICE RESET operation started.
 1:0:13:0: DEVICE RESET operation timed-out.
 1:0:13:0: BUS RESET operation started.
 1:0:13:0: BUS RESET operation timed-out.
 1:0:13:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:13:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 13 lun 0
 1:0:14:0: ABORT operation started.
 1:0:14:0: ABORT operation timed-out.
 1:0:14:0: DEVICE RESET operation started.
 1:0:14:0: DEVICE RESET operation timed-out.
 1:0:14:0: BUS RESET operation started.
 1:0:14:0: BUS RESET operation timed-out.
 1:0:14:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:14:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 14 lun 0
 1:0:15:0: ABORT operation started.
 1:0:15:0: ABORT operation timed-out.
 1:0:15:0: DEVICE RESET operation started.
 1:0:15:0: DEVICE RESET operation timed-out.
 1:0:15:0: BUS RESET operation started.
 1:0:15:0: BUS RESET operation timed-out.
 1:0:15:0: HOST RESET operation started.
sym1: SCSI BUS has been reset.
 1:0:15:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 15 lun 0
sym2: <825a> rev 0x13 at pci 0001:10:0d.0 irq 39
sym2: No NVRAM, ID 7, Fast-10, SE, parity checking
sym2: SCSI BUS has been reset.
scsi2 : sym-2.2.0
 2:0:0:0: ABORT operation started.
 2:0:0:0: ABORT operation timed-out.
 2:0:0:0: DEVICE RESET operation started.
 2:0:0:0: DEVICE RESET operation timed-out.
 2:0:0:0: BUS RESET operation started.
 2:0:0:0: BUS RESET operation timed-out.
 2:0:0:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 0 lun 0
 2:0:1:0: ABORT operation started.
 2:0:1:0: ABORT operation timed-out.
 2:0:1:0: DEVICE RESET operation started.
 2:0:1:0: DEVICE RESET operation timed-out.
 2:0:1:0: BUS RESET operation started.
 2:0:1:0: BUS RESET operation timed-out.
 2:0:1:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:1:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 1 lun 0
 2:0:2:0: ABORT operation started.
 2:0:2:0: ABORT operation timed-out.
 2:0:2:0: DEVICE RESET operation started.
 2:0:2:0: DEVICE RESET operation timed-out.
 2:0:2:0: BUS RESET operation started.
 2:0:2:0: BUS RESET operation timed-out.
 2:0:2:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:2:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 2 lun 0
 2:0:3:0: ABORT operation started.
 2:0:3:0: ABORT operation timed-out.
 2:0:3:0: DEVICE RESET operation started.
 2:0:3:0: DEVICE RESET operation timed-out.
 2:0:3:0: BUS RESET operation started.
 2:0:3:0: BUS RESET operation timed-out.
 2:0:3:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:3:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 3 lun 0
 2:0:4:0: ABORT operation started.
 2:0:4:0: ABORT operation timed-out.
 2:0:4:0: DEVICE RESET operation started.
 2:0:4:0: DEVICE RESET operation timed-out.
 2:0:4:0: BUS RESET operation started.
 2:0:4:0: BUS RESET operation timed-out.
 2:0:4:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:4:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 4 lun 0
 2:0:5:0: ABORT operation started.
 2:0:5:0: ABORT operation timed-out.
 2:0:5:0: DEVICE RESET operation started.
 2:0:5:0: DEVICE RESET operation timed-out.
 2:0:5:0: BUS RESET operation started.
 2:0:5:0: BUS RESET operation timed-out.
 2:0:5:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:5:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 5 lun 0
 2:0:6:0: ABORT operation started.
 2:0:6:0: ABORT operation timed-out.
 2:0:6:0: DEVICE RESET operation started.
 2:0:6:0: DEVICE RESET operation timed-out.
 2:0:6:0: BUS RESET operation started.
 2:0:6:0: BUS RESET operation timed-out.
 2:0:6:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:6:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 6 lun 0
 2:0:8:0: ABORT operation started.
 2:0:8:0: ABORT operation timed-out.
 2:0:8:0: DEVICE RESET operation started.
 2:0:8:0: DEVICE RESET operation timed-out.
 2:0:8:0: BUS RESET operation started.
 2:0:8:0: BUS RESET operation timed-out.
 2:0:8:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:8:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 8 lun 0
 2:0:9:0: ABORT operation started.
 2:0:9:0: ABORT operation timed-out.
 2:0:9:0: DEVICE RESET operation started.
 2:0:9:0: DEVICE RESET operation timed-out.
 2:0:9:0: BUS RESET operation started.
 2:0:9:0: BUS RESET operation timed-out.
 2:0:9:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:9:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 9 lun 0
 2:0:10:0: ABORT operation started.
 2:0:10:0: ABORT operation timed-out.
 2:0:10:0: DEVICE RESET operation started.
 2:0:10:0: DEVICE RESET operation timed-out.
 2:0:10:0: BUS RESET operation started.
 2:0:10:0: BUS RESET operation timed-out.
 2:0:10:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:10:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 10 lun 0
 2:0:11:0: ABORT operation started.
 2:0:11:0: ABORT operation timed-out.
 2:0:11:0: DEVICE RESET operation started.
 2:0:11:0: DEVICE RESET operation timed-out.
 2:0:11:0: BUS RESET operation started.
 2:0:11:0: BUS RESET operation timed-out.
 2:0:11:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:11:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 11 lun 0
 2:0:12:0: ABORT operation started.
 2:0:12:0: ABORT operation timed-out.
 2:0:12:0: DEVICE RESET operation started.
 2:0:12:0: DEVICE RESET operation timed-out.
 2:0:12:0: BUS RESET operation started.
 2:0:12:0: BUS RESET operation timed-out.
 2:0:12:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:12:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 12 lun 0
 2:0:13:0: ABORT operation started.
 2:0:13:0: ABORT operation timed-out.
 2:0:13:0: DEVICE RESET operation started.
 2:0:13:0: DEVICE RESET operation timed-out.
 2:0:13:0: BUS RESET operation started.
 2:0:13:0: BUS RESET operation timed-out.
 2:0:13:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:13:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 13 lun 0
 2:0:14:0: ABORT operation started.
 2:0:14:0: ABORT operation timed-out.
 2:0:14:0: DEVICE RESET operation started.
 2:0:14:0: DEVICE RESET operation timed-out.
 2:0:14:0: BUS RESET operation started.
 2:0:14:0: BUS RESET operation timed-out.
 2:0:14:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:14:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 14 lun 0
 2:0:15:0: ABORT operation started.
 2:0:15:0: ABORT operation timed-out.
 2:0:15:0: DEVICE RESET operation started.
 2:0:15:0: DEVICE RESET operation timed-out.
 2:0:15:0: BUS RESET operation started.
 2:0:15:0: BUS RESET operation timed-out.
 2:0:15:0: HOST RESET operation started.
sym2: SCSI BUS has been reset.
 2:0:15:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 15 lun 0
sym3: <825a> rev 0x13 at pci 0001:10:0e.0 irq 41
sym3: No NVRAM, ID 7, Fast-10, SE, parity checking
sym3: SCSI BUS has been reset.
scsi3 : sym-2.2.0
 3:0:0:0: ABORT operation started.
 3:0:0:0: ABORT operation timed-out.
 3:0:0:0: DEVICE RESET operation started.
 3:0:0:0: DEVICE RESET operation timed-out.
 3:0:0:0: BUS RESET operation started.
 3:0:0:0: BUS RESET operation timed-out.
 3:0:0:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 0 lun 0
 3:0:1:0: ABORT operation started.
 3:0:1:0: ABORT operation timed-out.
 3:0:1:0: DEVICE RESET operation started.
 3:0:1:0: DEVICE RESET operation timed-out.
 3:0:1:0: BUS RESET operation started.
 3:0:1:0: BUS RESET operation timed-out.
 3:0:1:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:1:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 1 lun 0
 3:0:2:0: ABORT operation started.
 3:0:2:0: ABORT operation timed-out.
 3:0:2:0: DEVICE RESET operation started.
 3:0:2:0: DEVICE RESET operation timed-out.
 3:0:2:0: BUS RESET operation started.
 3:0:2:0: BUS RESET operation timed-out.
 3:0:2:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:2:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 2 lun 0
 3:0:3:0: ABORT operation started.
 3:0:3:0: ABORT operation timed-out.
 3:0:3:0: DEVICE RESET operation started.
 3:0:3:0: DEVICE RESET operation timed-out.
 3:0:3:0: BUS RESET operation started.
 3:0:3:0: BUS RESET operation timed-out.
 3:0:3:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:3:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 3 lun 0
 3:0:4:0: ABORT operation started.
 3:0:4:0: ABORT operation timed-out.
 3:0:4:0: DEVICE RESET operation started.
 3:0:4:0: DEVICE RESET operation timed-out.
 3:0:4:0: BUS RESET operation started.
 3:0:4:0: BUS RESET operation timed-out.
 3:0:4:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:4:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 4 lun 0
 3:0:5:0: ABORT operation started.
 3:0:5:0: ABORT operation timed-out.
 3:0:5:0: DEVICE RESET operation started.
 3:0:5:0: DEVICE RESET operation timed-out.
 3:0:5:0: BUS RESET operation started.
 3:0:5:0: BUS RESET operation timed-out.
 3:0:5:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:5:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 5 lun 0
 3:0:6:0: ABORT operation started.
 3:0:6:0: ABORT operation timed-out.
 3:0:6:0: DEVICE RESET operation started.
 3:0:6:0: DEVICE RESET operation timed-out.
 3:0:6:0: BUS RESET operation started.
 3:0:6:0: BUS RESET operation timed-out.
 3:0:6:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:6:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 6 lun 0
 3:0:8:0: ABORT operation started.
 3:0:8:0: ABORT operation timed-out.
 3:0:8:0: DEVICE RESET operation started.
 3:0:8:0: DEVICE RESET operation timed-out.
 3:0:8:0: BUS RESET operation started.
 3:0:8:0: BUS RESET operation timed-out.
 3:0:8:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:8:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 8 lun 0
 3:0:9:0: ABORT operation started.
 3:0:9:0: ABORT operation timed-out.
 3:0:9:0: DEVICE RESET operation started.
 3:0:9:0: DEVICE RESET operation timed-out.
 3:0:9:0: BUS RESET operation started.
 3:0:9:0: BUS RESET operation timed-out.
 3:0:9:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:9:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 9 lun 0
 3:0:10:0: ABORT operation started.
 3:0:10:0: ABORT operation timed-out.
 3:0:10:0: DEVICE RESET operation started.
 3:0:10:0: DEVICE RESET operation timed-out.
 3:0:10:0: BUS RESET operation started.
 3:0:10:0: BUS RESET operation timed-out.
 3:0:10:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:10:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 10 lun 0
 3:0:11:0: ABORT operation started.
 3:0:11:0: ABORT operation timed-out.
 3:0:11:0: DEVICE RESET operation started.
 3:0:11:0: DEVICE RESET operation timed-out.
 3:0:11:0: BUS RESET operation started.
 3:0:11:0: BUS RESET operation timed-out.
 3:0:11:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:11:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 11 lun 0
 3:0:12:0: ABORT operation started.
 3:0:12:0: ABORT operation timed-out.
 3:0:12:0: DEVICE RESET operation started.
 3:0:12:0: DEVICE RESET operation timed-out.
 3:0:12:0: BUS RESET operation started.
 3:0:12:0: BUS RESET operation timed-out.
 3:0:12:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:12:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 12 lun 0
 3:0:13:0: ABORT operation started.
 3:0:13:0: ABORT operation timed-out.
 3:0:13:0: DEVICE RESET operation started.
 3:0:13:0: DEVICE RESET operation timed-out.
 3:0:13:0: BUS RESET operation started.
 3:0:13:0: BUS RESET operation timed-out.
 3:0:13:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:13:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 13 lun 0
 3:0:14:0: ABORT operation started.
 3:0:14:0: ABORT operation timed-out.
 3:0:14:0: DEVICE RESET operation started.
 3:0:14:0: DEVICE RESET operation timed-out.
 3:0:14:0: BUS RESET operation started.
 3:0:14:0: BUS RESET operation timed-out.
 3:0:14:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:14:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 14 lun 0
 3:0:15:0: ABORT operation started.
 3:0:15:0: ABORT operation timed-out.
 3:0:15:0: DEVICE RESET operation started.
 3:0:15:0: DEVICE RESET operation timed-out.
 3:0:15:0: BUS RESET operation started.
 3:0:15:0: BUS RESET operation timed-out.
 3:0:15:0: HOST RESET operation started.
sym3: SCSI BUS has been reset.
 3:0:15:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 15 lun 0
sym4: <825a> rev 0x13 at pci 0002:20:0b.0 irq 51
sym4: No NVRAM, ID 7, Fast-10, SE, parity checking
sym4: SCSI BUS has been reset.
scsi4 : sym-2.2.0
 4:0:0:0: ABORT operation started.
 4:0:0:0: ABORT operation timed-out.
 4:0:0:0: DEVICE RESET operation started.
 4:0:0:0: DEVICE RESET operation timed-out.
 4:0:0:0: BUS RESET operation started.
 4:0:0:0: BUS RESET operation timed-out.
 4:0:0:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 0 lun 0
 4:0:1:0: ABORT operation started.
 4:0:1:0: ABORT operation timed-out.
 4:0:1:0: DEVICE RESET operation started.
 4:0:1:0: DEVICE RESET operation timed-out.
 4:0:1:0: BUS RESET operation started.
 4:0:1:0: BUS RESET operation timed-out.
 4:0:1:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:1:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 1 lun 0
 4:0:2:0: ABORT operation started.
 4:0:2:0: ABORT operation timed-out.
 4:0:2:0: DEVICE RESET operation started.
 4:0:2:0: DEVICE RESET operation timed-out.
 4:0:2:0: BUS RESET operation started.
 4:0:2:0: BUS RESET operation timed-out.
 4:0:2:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:2:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 2 lun 0
 4:0:3:0: ABORT operation started.
 4:0:3:0: ABORT operation timed-out.
 4:0:3:0: DEVICE RESET operation started.
 4:0:3:0: DEVICE RESET operation timed-out.
 4:0:3:0: BUS RESET operation started.
 4:0:3:0: BUS RESET operation timed-out.
 4:0:3:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:3:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 3 lun 0
 4:0:4:0: ABORT operation started.
 4:0:4:0: ABORT operation timed-out.
 4:0:4:0: DEVICE RESET operation started.
 4:0:4:0: DEVICE RESET operation timed-out.
 4:0:4:0: BUS RESET operation started.
 4:0:4:0: BUS RESET operation timed-out.
 4:0:4:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:4:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 4 lun 0
 4:0:5:0: ABORT operation started.
 4:0:5:0: ABORT operation timed-out.
 4:0:5:0: DEVICE RESET operation started.
 4:0:5:0: DEVICE RESET operation timed-out.
 4:0:5:0: BUS RESET operation started.
 4:0:5:0: BUS RESET operation timed-out.
 4:0:5:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:5:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 5 lun 0
 4:0:6:0: ABORT operation started.
 4:0:6:0: ABORT operation timed-out.
 4:0:6:0: DEVICE RESET operation started.
 4:0:6:0: DEVICE RESET operation timed-out.
 4:0:6:0: BUS RESET operation started.
 4:0:6:0: BUS RESET operation timed-out.
 4:0:6:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:6:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 6 lun 0
 4:0:8:0: ABORT operation started.
 4:0:8:0: ABORT operation timed-out.
 4:0:8:0: DEVICE RESET operation started.
 4:0:8:0: DEVICE RESET operation timed-out.
 4:0:8:0: BUS RESET operation started.
 4:0:8:0: BUS RESET operation timed-out.
 4:0:8:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:8:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 8 lun 0
 4:0:9:0: ABORT operation started.
 4:0:9:0: ABORT operation timed-out.
 4:0:9:0: DEVICE RESET operation started.
 4:0:9:0: DEVICE RESET operation timed-out.
 4:0:9:0: BUS RESET operation started.
 4:0:9:0: BUS RESET operation timed-out.
 4:0:9:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:9:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 9 lun 0
 4:0:10:0: ABORT operation started.
 4:0:10:0: ABORT operation timed-out.
 4:0:10:0: DEVICE RESET operation started.
 4:0:10:0: DEVICE RESET operation timed-out.
 4:0:10:0: BUS RESET operation started.
 4:0:10:0: BUS RESET operation timed-out.
 4:0:10:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:10:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 10 lun 0
 4:0:11:0: ABORT operation started.
 4:0:11:0: ABORT operation timed-out.
 4:0:11:0: DEVICE RESET operation started.
 4:0:11:0: DEVICE RESET operation timed-out.
 4:0:11:0: BUS RESET operation started.
 4:0:11:0: BUS RESET operation timed-out.
 4:0:11:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:11:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 11 lun 0
 4:0:12:0: ABORT operation started.
 4:0:12:0: ABORT operation timed-out.
 4:0:12:0: DEVICE RESET operation started.
 4:0:12:0: DEVICE RESET operation timed-out.
 4:0:12:0: BUS RESET operation started.
 4:0:12:0: BUS RESET operation timed-out.
 4:0:12:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:12:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 12 lun 0
 4:0:13:0: ABORT operation started.
 4:0:13:0: ABORT operation timed-out.
 4:0:13:0: DEVICE RESET operation started.
 4:0:13:0: DEVICE RESET operation timed-out.
 4:0:13:0: BUS RESET operation started.
 4:0:13:0: BUS RESET operation timed-out.
 4:0:13:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:13:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 13 lun 0
 4:0:14:0: ABORT operation started.
 4:0:14:0: ABORT operation timed-out.
 4:0:14:0: DEVICE RESET operation started.
 4:0:14:0: DEVICE RESET operation timed-out.
 4:0:14:0: BUS RESET operation started.
 4:0:14:0: BUS RESET operation timed-out.
 4:0:14:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:14:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 14 lun 0
 4:0:15:0: ABORT operation started.
 4:0:15:0: ABORT operation timed-out.
 4:0:15:0: DEVICE RESET operation started.
 4:0:15:0: DEVICE RESET operation timed-out.
 4:0:15:0: BUS RESET operation started.
 4:0:15:0: BUS RESET operation timed-out.
 4:0:15:0: HOST RESET operation started.
sym4: SCSI BUS has been reset.
 4:0:15:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 id 15 lun 0
sym5: <875> rev 0x3 at pci 0002:20:0d.0 irq 55
sym5: No NVRAM, ID 7, Fast-20, SE, parity checking
sym5: SCSI BUS has been reset.
scsi5 : sym-2.2.0
 5:0:0:0: ABORT operation started.
 5:0:0:0: ABORT operation timed-out.
 5:0:0:0: DEVICE RESET operation started.
 5:0:0:0: DEVICE RESET operation timed-out.
 5:0:0:0: BUS RESET operation started.
 5:0:0:0: BUS RESET operation timed-out.
 5:0:0:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 0 lun 0
 5:0:1:0: ABORT operation started.
 5:0:1:0: ABORT operation timed-out.
 5:0:1:0: DEVICE RESET operation started.
 5:0:1:0: DEVICE RESET operation timed-out.
 5:0:1:0: BUS RESET operation started.
 5:0:1:0: BUS RESET operation timed-out.
 5:0:1:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:1:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 1 lun 0
 5:0:2:0: ABORT operation started.
 5:0:2:0: ABORT operation timed-out.
 5:0:2:0: DEVICE RESET operation started.
 5:0:2:0: DEVICE RESET operation timed-out.
 5:0:2:0: BUS RESET operation started.
 5:0:2:0: BUS RESET operation timed-out.
 5:0:2:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:2:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 2 lun 0
 5:0:3:0: ABORT operation started.
 5:0:3:0: ABORT operation timed-out.
 5:0:3:0: DEVICE RESET operation started.
 5:0:3:0: DEVICE RESET operation timed-out.
 5:0:3:0: BUS RESET operation started.
 5:0:3:0: BUS RESET operation timed-out.
 5:0:3:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:3:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 3 lun 0
 5:0:4:0: ABORT operation started.
 5:0:4:0: ABORT operation timed-out.
 5:0:4:0: DEVICE RESET operation started.
 5:0:4:0: DEVICE RESET operation timed-out.
 5:0:4:0: BUS RESET operation started.
 5:0:4:0: BUS RESET operation timed-out.
 5:0:4:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:4:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 4 lun 0
 5:0:5:0: ABORT operation started.
 5:0:5:0: ABORT operation timed-out.
 5:0:5:0: DEVICE RESET operation started.
 5:0:5:0: DEVICE RESET operation timed-out.
 5:0:5:0: BUS RESET operation started.
 5:0:5:0: BUS RESET operation timed-out.
 5:0:5:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:5:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 5 lun 0
 5:0:6:0: ABORT operation started.
 5:0:6:0: ABORT operation timed-out.
 5:0:6:0: DEVICE RESET operation started.
 5:0:6:0: DEVICE RESET operation timed-out.
 5:0:6:0: BUS RESET operation started.
 5:0:6:0: BUS RESET operation timed-out.
 5:0:6:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:6:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 6 lun 0
 5:0:8:0: ABORT operation started.
 5:0:8:0: ABORT operation timed-out.
 5:0:8:0: DEVICE RESET operation started.
 5:0:8:0: DEVICE RESET operation timed-out.
 5:0:8:0: BUS RESET operation started.
 5:0:8:0: BUS RESET operation timed-out.
 5:0:8:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:8:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 8 lun 0
 5:0:9:0: ABORT operation started.
 5:0:9:0: ABORT operation timed-out.
 5:0:9:0: DEVICE RESET operation started.
 5:0:9:0: DEVICE RESET operation timed-out.
 5:0:9:0: BUS RESET operation started.
 5:0:9:0: BUS RESET operation timed-out.
 5:0:9:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:9:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 9 lun 0
 5:0:10:0: ABORT operation started.
 5:0:10:0: ABORT operation timed-out.
 5:0:10:0: DEVICE RESET operation started.
 5:0:10:0: DEVICE RESET operation timed-out.
 5:0:10:0: BUS RESET operation started.
 5:0:10:0: BUS RESET operation timed-out.
 5:0:10:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:10:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 10 lun 0
 5:0:11:0: ABORT operation started.
 5:0:11:0: ABORT operation timed-out.
 5:0:11:0: DEVICE RESET operation started.
 5:0:11:0: DEVICE RESET operation timed-out.
 5:0:11:0: BUS RESET operation started.
 5:0:11:0: BUS RESET operation timed-out.
 5:0:11:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:11:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 11 lun 0
 5:0:12:0: ABORT operation started.
 5:0:12:0: ABORT operation timed-out.
 5:0:12:0: DEVICE RESET operation started.
 5:0:12:0: DEVICE RESET operation timed-out.
 5:0:12:0: BUS RESET operation started.
 5:0:12:0: BUS RESET operation timed-out.
 5:0:12:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:12:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 12 lun 0
 5:0:13:0: ABORT operation started.
 5:0:13:0: ABORT operation timed-out.
 5:0:13:0: DEVICE RESET operation started.
 5:0:13:0: DEVICE RESET operation timed-out.
 5:0:13:0: BUS RESET operation started.
 5:0:13:0: BUS RESET operation timed-out.
 5:0:13:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:13:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 13 lun 0
 5:0:14:0: ABORT operation started.
 5:0:14:0: ABORT operation timed-out.
 5:0:14:0: DEVICE RESET operation started.
 5:0:14:0: DEVICE RESET operation timed-out.
 5:0:14:0: BUS RESET operation started.
 5:0:14:0: BUS RESET operation timed-out.
 5:0:14:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:14:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 14 lun 0
 5:0:15:0: ABORT operation started.
 5:0:15:0: ABORT operation timed-out.
 5:0:15:0: DEVICE RESET operation started.
 5:0:15:0: DEVICE RESET operation timed-out.
 5:0:15:0: BUS RESET operation started.
 5:0:15:0: BUS RESET operation timed-out.
 5:0:15:0: HOST RESET operation started.
sym5: SCSI BUS has been reset.
 5:0:15:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 5 channel 0 id 15 lun 0
ipr: IBM Power RAID SCSI Device Driver version: 2.0.13 (February 21, 2005)
st: Version 20050312, fixed bufsize 32768, s/g segs 256
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.01:USB HID core driver
mice: PS/2 mouse device common for all mice
md: linear personality registered as nr 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :   428.000 MB/sec
   8regs_prefetch:   388.000 MB/sec
   32regs    :   552.000 MB/sec
   32regs_prefetch:   472.000 MB/sec
raid5: using function: 32regs (552.000 MB/sec)
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
oprofile: using ppc64/rs64 performance monitoring.
NET: Registered protocol family 2
atkbd.c: keyboard reset failed on isa0060/serio1
IP: routing cache hash table of 65536 buckets, 512Kbytes
TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
IPv4 over IPv4 tunneling driver
NET: Registered protocol family 1
NET: Registered protocol family 17
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
VFS: Insert root floppy and press ENTER
_______________________________________________
Linuxppc64-dev mailing list
Linuxppc64-dev@ozlabs.org
https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev

----- End forwarded message -----
