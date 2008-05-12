From: "sean bruno" <seanwbruno@gmail.com>
Subject: [2.6.25.1] QLA1040 Panic on startup
Date: Mon, 12 May 2008 14:37:25 -0700
Message-ID: <c457bfbf0805121437m355f2931p7d1a32fd5e40eb8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.250]:15603 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYELVh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 17:37:27 -0400
Received: by hs-out-0708.google.com with SMTP id 4so1987589hsl.5
        for <linux-scsi@vger.kernel.org>; Mon, 12 May 2008 14:37:26 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm seeing a panic with a QLA1040 SCSI board.  Kind of old school, but
it used to work.
I checked back to 2.6.22 and I still see the panic:

Linux version 2.6.25.1 (root@RIPLinuX) (gcc version 3.4.6) #7 Wed May
7 11:02:41 UTC 2008
BIOS-provided physical RAM map:
 BIOS-e801: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e801: 0000000000100000 - 000000001ce60000 (usable)
0MB HIGHMEM available.
462MB LOWMEM available.
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   118368
  HighMem    118368 ->   118368
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   118368
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 1DEFE038, 002C (r1 INTEL  DG965CO        89       1000013)
ACPI: FACP 1DEFD000, 0074 (r1 INTEL  DG965CO        89 MSFT  1000013)
ACPI: DSDT 1DEF9000, 312C (r1 INTEL  DG965CO        89 MSFT  1000013)
ACPI: FACS 1DEBC000, 0040
ACPI: APIC 1DEF8000, 006C (r1 INTEL  DG965CO        89 MSFT  1000013)
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 20000000 (gap: 1ce60000:e31a0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 117444
Kernel command line: initrd=rootfs.cgz root=/dev/ram0 rw console=tty1
console=ttyS0,115200 BOOT_IMAGE=kernel
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1200.079 MHz processor.
Console: colour VGA+ 80x25
console [tty1] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 425476k/473472k available (5522k kernel code, 47404k reserved,
2555k data, 332k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffe8000 - 0xfffff000   (  92 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdd800000 - 0xff7fe000   ( 543 MB)
    lowmem  : 0xc0000000 - 0xdce60000   ( 462 MB)
      .init : 0xc08e6000 - 0xc0939000   ( 332 kB)
      .data : 0xc066497f - 0xc08e3774   (2555 kB)
      .text : 0xc0100000 - 0xc066497f   (5522 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay using timer specific routine.. 2401.72 BogoMIPS (lpj=4803451)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 512K
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Celeron(R) CPU          220  @ 1.20GHz stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 152 bytes
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  4277.000 MB/sec
xor: using function: pIII_sse (4277.000 MB/sec)
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:05: ioport range 0x800-0x8fe has been reserved
system 00:05: ioport range 0x8ff-0x8ff has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:05: ioport range 0x4d6-0x4d6 has been reserved
system 00:05: ioport range 0x295-0x29e has been reserved
system 00:05: ioport range 0x2e8-0x2ef has been reserved
system 00:05: ioport range 0x481-0x48f has been reserved
system 00:06: iomem range 0x0-0x9ffff could not be reserved
system 00:06: iomem range 0xec000-0xfffff could not be reserved
system 00:06: iomem range 0x100000-0x1dffffff could not be reserved
system 00:06: iomem range 0xe0000000-0xefffffff has been reserved
system 00:06: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 1000-1fff
  MEM window: 0x2a000000-0x2a0fffff
  PREFETCH window: 0x0000000020000000-0x0000000027ffffff
PCI: Bridge: 0000:00:1f.0
  IO window: disabled.
  MEM window: 0x1e000000-0x1e0fffff
  PREFETCH window: disabled.
PCI: Enabling device 0000:00:1f.0 (0000 -> 0002)
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Overmounted tmpfs
Freeing initrd memory: 34338k freed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
JFS: nTxBlock = 3593, nTxLock = 28751
SGI XFS with realtime, large block numbers, no debug enabled
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered (default)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
Intel(R) Gigabit Ethernet Network Driver - version 1.0.8-k2
Copyright (c) 2007 Intel Corporation.
ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.1.18
ixgbe: Copyright (c) 1999-2007 Intel Corporation.
Intel(R) PRO/10GbE Network Driver - version 1.0.126-k4
Copyright (c) 1999-2006 Intel Corporation.
tehuti: Tehuti Networks(R) Network Driver, 7.29.3
tehuti: Options: hw_csum
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ThunderLAN driver v1.15
TLAN: 0 devices installed, PCI: 0  EISA: 0
sis900.c: v1.08.10 Apr. 2 2006
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 19 (level, low) -> IRQ 19
0000:00:04.0: SiS 900 on Foxconn 661 7MI transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x2400, IRQ 19, 00:1c:c0:1e:dc:6b
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
eth%d: i82596 initialization timed out
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver kaweth
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27)
usbcore: registered new interface driver rtl8150
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: IDE controller (0x1039:0x5513 rev 0x01) at  PCI slot 0000:00:02.5
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
    ide0: BM-DMA at 0x2890-0x2897, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0x2898-0x289f, BIOS settings: hdc:PIO, hdd:PIO
hda: TRANSCEND, ATA DISK drive
hda: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 1000944 sectors (512 MB) w/2KiB Cache, CHS=993/16/63
 hda: hda1 hda2 hda3
 hda1: <bsd:bad subpartition - ignored
 >
 hda2: <bsd:bad subpartition - ignored
 >
ide-floppy driver 1.00
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2455]-ms
scsi: <fdomain> Detection failed (no card)
qla1280: QLA1040 found on PCI bus 0, dev 6
ACPI: Unable to derive IRQ for device 0000:00:06.0
ACPI: PCI Interrupt 0000:00:06.0[A]: no GSI - using IRQ 11
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 1, comm: swapper Not tainted 2.6.25.1 #7
 [<c0130283>] __report_bad_irq+0x2b/0x60
 [<c013036b>] note_interrupt+0x9a/0xc9
 [<c013076e>] handle_level_irq+0x64/0x85
 [<c0105d3c>] do_IRQ+0x46/0x5a
 [<c0104893>] common_interrupt+0x23/0x30
 [<c04b007b>] ips_init_copperhead+0x130/0x165
 [<c011899c>] __do_softirq+0x2c/0x73
 [<c0118a05>] do_softirq+0x22/0x26
 [<c0105d41>] do_IRQ+0x4b/0x5a
 [<c0104893>] common_interrupt+0x23/0x30
 [<c02e007b>] elv_requeue_request+0x1/0x3a
 [<c0130027>] setup_irq+0x125/0x150
 [<c04b78c2>] qla1280_intr_handler+0x0/0x65
 [<c0130169>] request_irq+0x7b/0x92
 [<c065a0b0>] qla1280_probe_one+0x248/0x336
 [<c0338edf>] __driver_attach+0x0/0x75
 [<c02f45e4>] pci_call_probe+0xa/0xc
 [<c02f4614>] __pci_device_probe+0x2e/0x3f
 [<c02f4643>] pci_device_probe+0x1e/0x30
 [<c0338da9>] really_probe+0x70/0xea
 [<c0338e66>] driver_probe_device+0x34/0x3c
 [<c0338f23>] __driver_attach+0x44/0x75
 [<c03382ca>] bus_for_each_dev+0x36/0x5a
 [<c02e89f8>] kobject_init_and_add+0x23/0x25
 [<c0338f65>] driver_attach+0x11/0x13
 [<c0338edf>] __driver_attach+0x0/0x75
 [<c0338819>] bus_add_driver+0x8a/0x132
 [<c0339292>] driver_register+0x40/0x62
 [<c02f47af>] __pci_register_driver+0x2e/0x51
 [<c08e6970>] kernel_init+0x0/0x66
 [<c08e6970>] kernel_init+0x0/0x66
 [<c08e6828>] do_initcalls+0x6d/0x178
 [<c0130df4>] register_irq_proc+0x6d/0x85
 [<c08e6970>] kernel_init+0x0/0x66
 [<c08e6994>] kernel_init+0x24/0x66
 [<c01049b7>] kernel_thread_helper+0x7/0x10
 =======================
handlers:
[<c04b78c2>] (qla1280_intr_handler+0x0/0x65)
Disabling IRQ #11
~
[EOT]
