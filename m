From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 3/3] faster workaround
Date: Mon, 15 Oct 2007 12:18:37 +0200
Message-ID: <200710151218.38311.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <200710111718.43159.bs@q-leap.de> <470FE245.5040702@garzik.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+5zEHNo0XtvPKzz"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <470FE245.5040702@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_+5zEHNo0XtvPKzz
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 12 October 2007 23:08:21 Jeff Garzik wrote:
> Bernd Schubert wrote:
> > a) 2.6.23 + sil-patch I posted, this is on a customer system (though my
> > former group), I wouldn't like to use -mm there.
> >
> > b) .config is attached
> >
> > c) attached
> >
> > d) attached (don't get irritaded by those machine check events, thats
> > "GART TLB errorr", harmless warnings, just not disabled in the bios).
>
> Any chance you could provide dmesg on 2.6.23 without the sil patch?

Its attached.


Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH

--Boundary-00=_+5zEHNo0XtvPKzz
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.out"

[    0.000000] Linux version 2.6.23-l162 (bschubert@lanczos) (gcc version 3.4.6 (Ubuntu 3.4.6-5ubuntu1)) #7 SMP Mon Oct 15 11:50:28 CEST 2007
[    0.000000] Command line:  root=/dev/ram0 ramdisk_size=110592 console=tty0 console=ttyS0,115200  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000fbff0000 (usable)
[    0.000000]  BIOS-e820: 00000000fbff0000 - 00000000fbfff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fbfff000 - 00000000fc000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000400000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 1032176) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 4194304) 2 entries of 3200 used
[    0.000000] end_pfn_map = 4194304
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6F20, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT FBFF0000, 0038 (r1 A M I  OEMRSDT   7000626 MSFT       97)
[    0.000000] ACPI: FACP FBFF0200, 0081 (r1 A M I  OEMFACP   7000626 MSFT       97)
[    0.000000] ACPI: DSDT FBFF0410, 3751 (r1  0AAAA 0AAAA000        0 INTL  2002026)
[    0.000000] ACPI: FACS FBFFF000, 0040
[    0.000000] ACPI: APIC FBFF0380, 0084 (r1 A M I  OEMAPIC   7000626 MSFT       97)
[    0.000000] ACPI: OEMB FBFFF040, 0041 (r1 A M I  OEMBIOS   7000626 MSFT       97)
[    0.000000] ACPI: SRAT FBFF3B70, 0110 (r1 A M I  OEMSRAT   7000626 MSFT       97)
[    0.000000] ACPI: ASF! FBFF3C80, 0086 (r1 AMIASF AMDSTRET        1 INTL  2002026)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 1 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 100000-fc000000
[    0.000000] Entering add_active_range(0, 256, 1032176) 0 entries of 3200 used
[    0.000000] SRAT: Node 1 PXM 1 200000000-400000000
[    0.000000] Entering add_active_range(1, 2097152, 4194304) 1 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 100000-200000000
[    0.000000] Entering add_active_range(0, 256, 1032176) 2 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 0-200000000
[    0.000000] Entering add_active_range(0, 0, 159) 3 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 1032176) 4 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 2097152) 4 entries of 3200 used
[    0.000000] NUMA: Using 33 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000200000000
[    0.000000] Bootmem setup node 1 0000000200000000-0000000400000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  4194304
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->  1032176
[    0.000000]     0:  1048576 ->  2097152
[    0.000000]     1:  2097152 ->  4194304
[    0.000000] On node 0 totalpages: 2080655
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1451 pages reserved
[    0.000000]   DMA zone: 2492 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 1013800 pages, LIFO batch:31
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfebff000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, address 0xfebff000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfebfe000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 4, address 0xfebfe000, GSI 28-31
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at fc400000 (gap: fc000000:3780000)
[    0.000000] .eh_frame_hdr for 'kernel' present but unusable
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PERCPU: Allocating 32872 bytes of per cpu data
[    0.000000] Built 2 zonelists in Zone order.  Total pages: 4119012
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:  root=/dev/ram0 ramdisk_size=110592 console=tty0 console=ttyS0,115200  
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[  114.643908] time.c: Detected 1992.367 MHz processor.
[  114.648062] Console: colour VGA+ 80x25
[  114.648065] console [tty0] enabled
[  114.660503] console [ttyS0] enabled
[  115.061441] Checking aperture...
[  115.064821] CPU 0: aperture @ 4000000 size 32 MB
[  115.069609] Aperture too small (32 MB)
[  115.080187] No AGP bridge found
[  115.083491] Your BIOS doesn't leave a aperture memory hole
[  115.089157] Please enable the IOMMU option in the BIOS setup
[  115.094996] This costs you 64 MB of RAM
[  115.129197] Mapping aperture over 65536 KB of RAM @ 4000000
[  115.657704] Memory: 16368744k/16777216k available (3104k kernel code, 342484k reserved, 1703k data, 320k init)
[  115.668042] SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=2
[  115.751854] Calibrating delay using timer specific routine.. 3988.62 BogoMIPS (lpj=7977257)
[  115.761773] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[  115.781701] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[  115.795079] Mount-cache hash table entries: 256
[  115.799928] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  115.807258] CPU: L2 Cache: 1024K (64 bytes/line)
[  115.812046] CPU 0/0 -> Node 0
[  115.815186] SMP alternatives: switching to UP code
[  115.820804] ACPI: Core revision 20070126
[  115.866967] Using local APIC timer interrupts.
[  115.921673] result 12452292
[  115.924622] Detected 12.452 MHz APIC timer.
[  115.931591] SMP alternatives: switching to SMP code
[  115.937126] Booting processor 1/2 APIC 0x1
[  115.951486] Initializing CPU#1
[  116.031323] Calibrating delay using timer specific routine.. 3984.78 BogoMIPS (lpj=7969570)
[  116.031332] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  116.031334] CPU: L2 Cache: 1024K (64 bytes/line)
[  116.031337] CPU 1/1 -> Node 1
[  116.031467] AMD Opteron(tm) Processor 246 stepping 0a
[  116.035345] Brought up 2 CPUs
[  116.073142] NET: Registered protocol family 16
[  116.077915] ACPI: bus type pci registered
[  116.082208] PCI: Using configuration type 1
[  116.091900] ACPI: EC: Look up EC in DSDT
[  116.095037] ACPI: Interpreter enabled
[  116.098858] ACPI: (supports S0 S1 S5)
[  116.102917] ACPI: Using IOAPIC for interrupt routing
[  116.113996] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  116.119869] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  116.119937] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[  116.120018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLA._PRT]
[  116.120113] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLB._PRT]
[  116.122439] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[  116.130993] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[  116.139545] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[  116.148099] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[  116.156662] Linux Plug and Play Support v0.97 (c) Adam Belay
[  116.162529] pnp: PnP ACPI init
[  116.165778] ACPI: bus type pnp registered
[  116.173458] pnp: PnP ACPI: found 15 devices
[  116.177812] ACPI: ACPI bus type pnp unregistered
[  116.182789] SCSI subsystem initialized
[  116.186738] libata version 2.21 loaded.
[  116.186886] PCI: Using ACPI for IRQ routing
[  116.191261] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[  116.231015] PCI-DMA: Disabling AGP.
[  116.235147] PCI-DMA: aperture base @ 4000000 size 65536 KB
[  116.240820] PCI-DMA: using GART IOMMU.
[  116.244738] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[  116.267017] pnp: 00:0a: ioport range 0x680-0x6ff has been reserved
[  116.273381] pnp: 00:0a: ioport range 0x295-0x296 has been reserved
[  116.279745] pnp: 00:0a: ioport range 0x778-0x77f has been reserved
[  116.286109] pnp: 00:0a: ioport range 0xb78-0xb7f has been reserved
[  116.292466] pnp: 00:0a: ioport range 0xf78-0xf7f has been reserved
[  116.298834] pnp: 00:0d: ioport range 0xca0-0xcaf has been reserved
[  116.305199] pnp: 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
[  116.312350] pnp: 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
[  116.319916] pnp: 00:0d: iomem range 0xfff80000-0xffffffff could not be reserved
[  116.327484] pnp: 00:0d: iomem range 0xff780000-0xff7fffff could not be reserved
[  116.335054] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[  116.341680] pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved
[  116.348307] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[  116.355281] pnp: 00:0e: iomem range 0x100000-0xfbffffff could not be reserved
[  116.362943] PCI: Bridge: 0000:00:06.0
[  116.366718] Time: acpi_pm clocksource has been installed.
[  116.372341]   IO window: 9000-bfff
[  116.375907]   MEM window: fc900000-feafffff
[  116.380256]   PREFETCH window: disabled.
[  116.384344] PCI: Bridge: 0000:00:0a.0
[  116.388169]   IO window: disabled.
[  116.391730]   MEM window: fc800000-fc8fffff
[  116.396081]   PREFETCH window: ff500000-ff5fffff
[  116.400869] PCI: Bridge: 0000:00:0b.0
[  116.404691]   IO window: disabled.
[  116.408250]   MEM window: disabled.
[  116.411900]   PREFETCH window: disabled.
[  116.416058] NET: Registered protocol family 2
[  116.462865] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[  116.476537] TCP established hash table entries: 2097152 (order: 13, 50331648 bytes)
[  116.519246] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[  116.526767] TCP: Hash tables configured (established 2097152 bind 65536)
[  116.533653] TCP reno registered
[  116.546520] checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
[  118.007208] Freeing initrd memory: 41021k freed
[  118.037873] VFS: Disk quotas dquot_6.5.1
[  118.042028] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  118.049125] io scheduler noop registered
[  118.053215] io scheduler deadline registered (default)
[  118.058587] io scheduler cfq registered
[  118.062599] PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:00:0a.0 subordinate bus.
[  118.071598] AMD8131 rev 12 detected, disabling PCI-X MMRBC
[  118.077277] PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:00:0b.0 subordinate bus.
[  118.086269] AMD8131 rev 12 detected, disabling PCI-X MMRBC
[  118.092882] Boot video device is 0000:03:06.0
[  118.119406] hpet_acpi_add: no address or irqs in _CRS
[  118.124703] AMD768 RNG detected
[  118.128499] Linux agpgart interface v0.102
[  118.132759] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[  118.140906] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  118.147480] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[  118.154102] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  118.160032] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[  118.166014] Floppy drive(s): fd0 is 1.44M
[  118.191199] FDC 0 is a post-1991 82077
[  118.196725] RAMDISK driver initialized: 16 RAM disks of 110592K size 1024 blocksize
[  118.204932] loop: module loaded
[  118.208235] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[  118.214417] Copyright (c) 1999-2006 Intel Corporation.
[  118.219799] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[  118.226078] e100: Copyright(c) 1999-2006 Intel Corporation
[  118.231832] tg3.c:v3.81 (September 5, 2007)
[  118.236202] ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 24 (level, low) -> IRQ 24
[  118.270915] eth0: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:2b:91:4a
[  118.283405] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[  118.291152] eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[  118.296570] ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 25 (level, low) -> IRQ 25
[  118.337338] eth1: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:2b:91:4b
[  118.349827] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[  118.357567] eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[  118.363091] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
[  118.371119] sata_sil 0000:03:05.0: version 2.3
[  118.371171] ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 19 (level, low) -> IRQ 19
[  118.379382] scsi0 : sata_sil
[  118.382496] scsi1 : sata_sil
[  118.385586] scsi2 : sata_sil
[  118.388685] scsi3 : sata_sil
[  118.391789] ata1: SATA max UDMA/100 cmd 0xffffc20004d4ac80 ctl 0xffffc20004d4ac8a bmdma 0xffffc20004d4ac00 irq 19
[  118.402344] ata2: SATA max UDMA/100 cmd 0xffffc20004d4acc0 ctl 0xffffc20004d4acca bmdma 0xffffc20004d4ac08 irq 19
[  118.412886] ata3: SATA max UDMA/100 cmd 0xffffc20004d4ae80 ctl 0xffffc20004d4ae8a bmdma 0xffffc20004d4ae00 irq 19
[  118.423428] ata4: SATA max UDMA/100 cmd 0xffffc20004d4aec0 ctl 0xffffc20004d4aeca bmdma 0xffffc20004d4ae08 irq 19
[  118.746253] ata1: SATA link down (SStatus 0 SControl 310)
[  119.065650] ata2: SATA link down (SStatus 0 SControl 310)
[  119.540775] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  119.715051] ata3.00: ATA-7: ST3250820AS, 3.AAC, max UDMA/133
[  119.720896] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[  119.789857] ata3.00: configured for UDMA/100
[  120.107695] ata4: SATA link down (SStatus 0 SControl 310)
[  120.113359] scsi 2:0:0:0: Direct-Access     ATA      ST3250820AS      3.AA PQ: 0 ANSI: 5
[  120.121823] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[  120.129153] sd 2:0:0:0: [sda] Write Protect is off
[  120.134117] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  120.134131] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  120.143487] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[  120.150816] sd 2:0:0:0: [sda] Write Protect is off
[  120.155772] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  120.155785] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  120.165105]  sda: sda1 sda2 sda3
[  120.188930] sd 2:0:0:0: [sda] Attached SCSI disk
[  120.193959] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[  120.200324] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[  120.210587] serio: i8042 KBD port at 0x60,0x64 irq 1
[  120.215763] mice: PS/2 mouse device common for all mice
[  120.221239] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[  120.230097] oprofile: using NMI interrupt.
[  120.234372] TCP cubic registered
[  120.237762] NET: Registered protocol family 1
[  120.242285] NET: Registered protocol family 17
[  120.275750] input: AT Translated Set 2 keyboard as /class/input/input0
[  120.351314] RAMDISK: Compressed image found at block 0
[  122.022214] VFS: Mounted root (ext2 filesystem) readonly.
[  122.027810] Freeing unused kernel memory: 320k freed
[  122.411934] ACPI: Processor [CPU1] (supports 8 throttling states)
[  122.418811] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[  122.429596] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[  122.512126] EDAC MC: Ver: 2.1.0 Oct 15 2007
[  122.535388] pata_amd 0000:00:07.1: version 0.3.9
[  122.551700] scsi4 : pata_amd
[  122.556552] usbcore: registered new interface driver usbfs
[  122.557169] scsi5 : pata_amd
[  122.557220] ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001ffa0 irq 14
[  122.557223] ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001ffa8 irq 15
[  122.587473] usbcore: registered new interface driver hub
[  122.601842] usbcore: registered new device driver usb
[  122.617149] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[  122.870859] ata5.00: ATAPI: QSI CD-ROM SCR-242, CXAC, max UDMA/33
[  123.034541] ata5.00: configured for UDMA/33
[  123.209599] scsi 4:0:0:0: CD-ROM            QSI      CD-ROM SCR-242   CXAC PQ: 0 ANSI: 5
[  123.219087] EDAC MC0: Giving out device to 'k8_edac' 'Athlon64/Opteron': DEV 0000:00:18.2
[  123.228109] EDAC PCI0: Giving out device to module 'k8_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[  123.240297] EDAC MC1: Giving out device to 'k8_edac' 'Athlon64/Opteron': DEV 0000:00:19.2
[  123.249295] ACPI: PCI Interrupt 0000:03:00.0[D] -> GSI 19 (level, low) -> IRQ 19
[  123.257796] ohci_hcd 0000:03:00.0: OHCI Host Controller
[  123.265955] ohci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 1
[  123.274154] ohci_hcd 0000:03:00.0: irq 19, io mem 0xfeafc000
[  123.339774] usb usb1: configuration #1 chosen from 1 choice
[  123.345952] hub 1-0:1.0: USB hub found
[  123.350140] hub 1-0:1.0: 3 ports detected
[  123.461475] ACPI: PCI Interrupt 0000:03:00.1[D] -> GSI 19 (level, low) -> IRQ 19
[  123.469952] ohci_hcd 0000:03:00.1: OHCI Host Controller
[  123.475794] ohci_hcd 0000:03:00.1: new USB bus registered, assigned bus number 2
[  123.483993] ohci_hcd 0000:03:00.1: irq 19, io mem 0xfeafd000
[  123.551350] usb usb2: configuration #1 chosen from 1 choice
[  123.557509] hub 2-0:1.0: USB hub found
[  123.561690] hub 2-0:1.0: 3 ports detected
[  123.687627] sd 2:0:0:0: Attached scsi generic sg0 type 0
[  123.693485] scsi 4:0:0:0: Attached scsi generic sg1 type 5
[  123.932540] usb 2-2: new full speed USB device using ohci_hcd and address 2
[  123.998960] Real Time Clock Driver v1.12ac
[  124.113162] usb 2-2: configuration #1 chosen from 1 choice
[  124.128282] usbcore: registered new interface driver usbserial
[  124.134695] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[  124.143496] usbcore: registered new interface driver usbserial_generic
[  124.150640] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[  124.158844] w83627hf: Found W83627HF chip at 0x290
[  124.167540] drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
[  124.176218] pl2303 2-2:1.0: pl2303 converter detected
[  124.182958] usb 2-2: pl2303 converter now attached to ttyUSB0
[  124.190363] usbcore: registered new interface driver pl2303
[  124.196580] drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
[  127.525919] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[  127.531978] tg3: eth0: Flow control is off for TX and off for RX.
[  136.766030] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[  136.773917] sd 2:0:0:0: [sda] Write Protect is off
[  136.779229] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  136.779247] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  136.789232]  sda: sda1 sda2 sda3
[  139.812179] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[  139.820030] sd 2:0:0:0: [sda] Write Protect is off
[  139.825347] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  139.825365] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  139.835312]  sda: sda1 sda2 sda3
[  142.861469] ReiserFS: sda1: found reiserfs format "3.6" with standard journal
[  142.870083] ReiserFS: sda1: using ordered data mode
[  142.880261] ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[  142.896826] ReiserFS: sda1: checking transaction log (sda1)
[  142.919220] ReiserFS: sda1: Using r5 hash to sort names
[  143.330225] ReiserFS: sda1: found reiserfs format "3.6" with standard journal
[  143.337841] ReiserFS: sda1: using ordered data mode
[  143.343314] ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[  143.359638] ReiserFS: sda1: checking transaction log (sda1)
[  143.376333] ReiserFS: sda1: Using r5 hash to sort names
[  143.396521] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[  143.407882] SGI XFS Quota Management subsystem
[  143.461049] XFS mounting filesystem sda3
[  143.562173] Ending clean XFS mount for filesystem: sda3
[  147.325573] fuse init (API version 7.8)

--Boundary-00=_+5zEHNo0XtvPKzz--
