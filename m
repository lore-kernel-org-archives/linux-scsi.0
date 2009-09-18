From: Allan Wind <allan_wind@lifeintegrity.com>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 22:47:58 -0400
Message-ID: <20090918024758.GC5156@lifeintegrity.com>
References: <20090917115728.GA13854@arachsys.com> <4AB2596D.10809@kernel.org> <20090917163647.GA6663@lifeintegrity.com> <4AB2D15E.3090809@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AB2D15E.3090809@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2009-09-18T09:16:30, Tejun Heo wrote:
> Can you please post full log?

The sense key errors starting at 3964586 happened when I disabled 
the write cache (`hdparm -W0 /dev/sd{a,b}`).

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.30.4 (root@pawan) (gcc version 4.3.3 (Debian 4.3.3-13) ) #1 SMP Sat Aug 1 13:46:07 EDT 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30.4 root=/dev/md0 ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000640000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x640000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x100000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009bc00 (usable)
[    0.000000]  modified: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000640000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf790000 page 4k
[    0.000000] kernel direct mapping tables up to bf790000 @ 10000-15000
[    0.000000] init_memory_mapping: 0000000100000000-0000000640000000
[    0.000000]  0100000000 - 0640000000 page 2M
[    0.000000] kernel direct mapping tables up to 640000000 @ 13000-2d000
[    0.000000] ACPI: RSDP 00000000000f9da0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 00054 (v01 033009 XSDT1608 20090330 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v03 033009 FACP1608 20090330 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7904b0 05A14 (v01  1XDT3 1XDT3003 00000003 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 000D2 (v01 033009 APIC1608 20090330 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf790470 0003C (v01 033009 OEMMCFG  20090330 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 0007A (v01 033009 OEMB1608 20090330 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf79e0c0 00130 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79fbf0 0249F (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000640000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000640000000
[    0.000000]   NODE_DATA [0000000000028000 - 000000000002cfff]
[    0.000000]   bootmap [0000000000100000 -  00000000001c7fff] pages c8
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0640000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001737608]    TEXT DATA BSS ==> [0001000000 - 0001737608]
[    0.000000]   #3 [000009bc00 - 0000100000]    BIOS reserved ==> [000009bc00 - 0000100000]
[    0.000000]   #4 [0001738000 - 0001738178]              BRK ==> [0001738000 - 0001738178]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #6 [0000013000 - 0000028000]          PGTABLE ==> [0000013000 - 0000028000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffe20000000000-ffffe20015dfffff] PMD -> [ffff880028200000-ffff88003d1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00640000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00640000
[    0.000000] On node 0 totalpages: 6289179
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 127 pages reserved
[    0.000000]   DMA zone: 3796 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765896 pages, LIFO batch:31
[    0.000000]   Normal zone: 75264 pages used for memmap
[    0.000000]   Normal zone: 5429760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff88003d200000, static data 72800 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 6199452
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30.4 root=/dev/md0 ro quiet
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:536
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2261.190 MHz processor.
[   83.997162] Console: colour VGA+ 80x25
[   83.997164] console [tty0] enabled
[   83.997449] Checking aperture...
[   84.003246] No AGP bridge found
[   84.003284] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   84.009681] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[   84.009684] software IO TLB at phys 0x20000000 - 0x24000000
[   84.191210] Memory: 24737232k/26214400k available (3823k kernel code, 1057684k absent, 419484k reserved, 2177k data, 524k init)
[   84.191236] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[   84.191278] Calibrating delay loop (skipped), value calculated using timer frequency.. 4522.38 BogoMIPS (lpj=2261190)
[   84.191295] Security Framework initialized
[   84.193407] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[   84.200318] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[   84.203228] Mount-cache hash table entries: 256
[   84.203353] Initializing cgroup subsys ns
[   84.203356] Initializing cgroup subsys cpuacct
[   84.203361] Initializing cgroup subsys freezer
[   84.203374] CPU: Physical Processor ID: 1
[   84.203375] CPU: Processor Core ID: 0
[   84.203378] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.203380] CPU: L2 cache: 256K
[   84.203381] CPU: L3 cache: 8192K
[   84.203383] CPU 0/0x10 -> Node 0
[   84.203393] CPU0: Thermal monitoring enabled (TM1)
[   84.203397] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[   84.203403] using mwait in idle threads.
[   84.203418] ACPI: Core revision 20090320
[   84.234438] Setting APIC routing to physical flat
[   84.234756] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[   84.244739] CPU0: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.346017] Booting processor 1 APIC 0x12 ip 0x6000
[   84.356480] Initializing CPU#1
[   84.416780] Calibrating delay using timer specific routine.. 4520.67 BogoMIPS (lpj=2260337)
[   84.416786] CPU: Physical Processor ID: 1
[   84.416787] CPU: Processor Core ID: 1
[   84.416789] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.416790] CPU: L2 cache: 256K
[   84.416791] CPU: L3 cache: 8192K
[   84.416793] CPU 1/0x12 -> Node 0
[   84.416802] CPU1: Thermal monitoring enabled (TM1)
[   84.416805] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[   84.417429] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[   84.418109] CPU1: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.418130] Skipping synchronization checks as TSC is reliable.
[   84.418186] Booting processor 2 APIC 0x14 ip 0x6000
[   84.428533] Initializing CPU#2
[   84.488616] Calibrating delay using timer specific routine.. 4520.67 BogoMIPS (lpj=2260338)
[   84.488622] CPU: Physical Processor ID: 1
[   84.488623] CPU: Processor Core ID: 2
[   84.488625] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.488626] CPU: L2 cache: 256K
[   84.488627] CPU: L3 cache: 8192K
[   84.488629] CPU 2/0x14 -> Node 0
[   84.488638] CPU2: Thermal monitoring enabled (TM1)
[   84.488641] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[   84.489267] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[   84.489966] CPU2: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.489986] Skipping synchronization checks as TSC is reliable.
[   84.490043] Booting processor 3 APIC 0x16 ip 0x6000
[   84.500390] Initializing CPU#3
[   84.560451] Calibrating delay using timer specific routine.. 4520.67 BogoMIPS (lpj=2260335)
[   84.560458] CPU: Physical Processor ID: 1
[   84.560459] CPU: Processor Core ID: 3
[   84.560461] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.560462] CPU: L2 cache: 256K
[   84.560463] CPU: L3 cache: 8192K
[   84.560465] CPU 3/0x16 -> Node 0
[   84.560474] CPU3: Thermal monitoring enabled (TM1)
[   84.560477] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[   84.561102] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[   84.561735] CPU3: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.561755] Skipping synchronization checks as TSC is reliable.
[   84.561811] Booting processor 4 APIC 0x11 ip 0x6000
[   84.572159] Initializing CPU#4
[   84.632287] Calibrating delay using timer specific routine.. 4520.66 BogoMIPS (lpj=2260333)
[   84.632295] CPU: Physical Processor ID: 1
[   84.632296] CPU: Processor Core ID: 0
[   84.632298] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.632300] CPU: L2 cache: 256K
[   84.632302] CPU: L3 cache: 8192K
[   84.632304] CPU 4/0x11 -> Node 0
[   84.632314] CPU4: Thermal monitoring enabled (TM1)
[   84.632317] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[   84.633069] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[   84.633910] CPU4: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.633935] Skipping synchronization checks as TSC is reliable.
[   84.633995] Booting processor 5 APIC 0x13 ip 0x6000
[   84.644242] Initializing CPU#5
[   84.704123] Calibrating delay using timer specific routine.. 4520.67 BogoMIPS (lpj=2260335)
[   84.704129] CPU: Physical Processor ID: 1
[   84.704130] CPU: Processor Core ID: 1
[   84.704132] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.704134] CPU: L2 cache: 256K
[   84.704135] CPU: L3 cache: 8192K
[   84.704136] CPU 5/0x13 -> Node 0
[   84.704145] CPU5: Thermal monitoring enabled (TM1)
[   84.704148] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[   84.704965] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[   84.705929] CPU5: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.705950] Skipping synchronization checks as TSC is reliable.
[   84.706005] Booting processor 6 APIC 0x15 ip 0x6000
[   84.716352] Initializing CPU#6
[   84.776956] Calibrating delay using timer specific routine.. 4520.67 BogoMIPS (lpj=2260336)
[   84.776963] CPU: Physical Processor ID: 1
[   84.776964] CPU: Processor Core ID: 2
[   84.776966] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.776967] CPU: L2 cache: 256K
[   84.776968] CPU: L3 cache: 8192K
[   84.776970] CPU 6/0x15 -> Node 0
[   84.776978] CPU6: Thermal monitoring enabled (TM1)
[   84.776981] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[   84.777797] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[   84.778697] CPU6: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.778718] Skipping synchronization checks as TSC is reliable.
[   84.778771] Booting processor 7 APIC 0x17 ip 0x6000
[   84.789118] Initializing CPU#7
[   84.848792] Calibrating delay using timer specific routine.. 4520.67 BogoMIPS (lpj=2260336)
[   84.848798] CPU: Physical Processor ID: 1
[   84.848799] CPU: Processor Core ID: 3
[   84.848801] CPU: L1 I cache: 32K, L1 D cache: 32K
[   84.848803] CPU: L2 cache: 256K
[   84.848804] CPU: L3 cache: 8192K
[   84.848805] CPU 7/0x17 -> Node 0
[   84.848815] CPU7: Thermal monitoring enabled (TM1)
[   84.848817] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[   84.849633] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[   84.850565] CPU7: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[   84.850585] Skipping synchronization checks as TSC is reliable.
[   84.850593] Brought up 8 CPUs
[   84.850595] Total of 8 processors activated (36167.08 BogoMIPS).
[   84.850860] khelper used greatest stack depth: 5952 bytes left
[   84.850921] net_namespace: 1832 bytes
[   84.851122] NET: Registered protocol family 16
[   84.851378] ACPI: bus type pci registered
[   84.851458] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[   84.851460] PCI: MCFG area at e0000000 reserved in E820
[   84.859888] PCI: Using MMCONFIG at e0000000 - efffffff
[   84.859890] PCI: Using configuration type 1 for base access
[   84.862988] bio: create slab <bio-0> at 0
[   84.863725] ACPI: EC: Look up EC in DSDT
[   84.875150] ACPI: Interpreter enabled
[   84.875152] ACPI: (supports S0 S1 S3 S4 S5)
[   84.875176] ACPI: Using IOAPIC for interrupt routing
[   84.886282] ACPI: No dock devices found.
[   84.886359] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   84.886446] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[   84.886449] pci 0000:00:00.0: PME# disabled
[   84.886499] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[   84.886502] pci 0000:00:01.0: PME# disabled
[   84.886553] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[   84.886556] pci 0000:00:03.0: PME# disabled
[   84.886606] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[   84.886609] pci 0000:00:05.0: PME# disabled
[   84.886661] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[   84.886664] pci 0000:00:07.0: PME# disabled
[   84.886714] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[   84.886717] pci 0000:00:08.0: PME# disabled
[   84.886768] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[   84.886771] pci 0000:00:09.0: PME# disabled
[   84.887421] pci 0000:00:16.0: reg 10 64bit mmio: [0xfaff0000-0xfaff3fff]
[   84.887476] pci 0000:00:16.1: reg 10 64bit mmio: [0xfafec000-0xfafeffff]
[   84.887531] pci 0000:00:16.2: reg 10 64bit mmio: [0xfafe8000-0xfafebfff]
[   84.887586] pci 0000:00:16.3: reg 10 64bit mmio: [0xfafe4000-0xfafe7fff]
[   84.887640] pci 0000:00:16.4: reg 10 64bit mmio: [0xfafe0000-0xfafe3fff]
[   84.887695] pci 0000:00:16.5: reg 10 64bit mmio: [0xfafdc000-0xfafdffff]
[   84.887751] pci 0000:00:16.6: reg 10 64bit mmio: [0xfafd8000-0xfafdbfff]
[   84.887806] pci 0000:00:16.7: reg 10 64bit mmio: [0xfafd4000-0xfafd7fff]
[   84.887882] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
[   84.887945] pci 0000:00:1a.1: reg 20 io port: [0xa480-0xa49f]
[   84.888008] pci 0000:00:1a.2: reg 20 io port: [0xa400-0xa41f]
[   84.888075] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfaff6000-0xfaff63ff]
[   84.888126] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[   84.888130] pci 0000:00:1a.7: PME# disabled
[   84.888166] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfaff8000-0xfaffbfff]
[   84.888204] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[   84.888208] pci 0000:00:1b.0: PME# disabled
[   84.888254] pci 0000:00:1d.0: reg 20 io port: [0xb000-0xb01f]
[   84.888318] pci 0000:00:1d.1: reg 20 io port: [0xac00-0xac1f]
[   84.888382] pci 0000:00:1d.2: reg 20 io port: [0xa880-0xa89f]
[   84.888450] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfaffc000-0xfaffc3ff]
[   84.888500] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[   84.888504] pci 0000:00:1d.7: PME# disabled
[   84.888618] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[   84.888622] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[   84.888626] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[   84.888629] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 164c (mask 0007)
[   84.888632] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 03e8 (mask 0007)
[   84.888636] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[   84.888639] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[   84.888686] pci 0000:00:1f.2: reg 10 io port: [0xcc00-0xcc07]
[   84.888691] pci 0000:00:1f.2: reg 14 io port: [0xc880-0xc883]
[   84.888696] pci 0000:00:1f.2: reg 18 io port: [0xc800-0xc807]
[   84.888701] pci 0000:00:1f.2: reg 1c io port: [0xc480-0xc483]
[   84.888706] pci 0000:00:1f.2: reg 20 io port: [0xc400-0xc40f]
[   84.888711] pci 0000:00:1f.2: reg 24 io port: [0xc080-0xc08f]
[   84.888755] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfaffe000-0xfaffe0ff]
[   84.888767] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[   84.888807] pci 0000:00:1f.5: reg 10 io port: [0xbc00-0xbc07]
[   84.888812] pci 0000:00:1f.5: reg 14 io port: [0xb880-0xb883]
[   84.888817] pci 0000:00:1f.5: reg 18 io port: [0xb800-0xb807]
[   84.888822] pci 0000:00:1f.5: reg 1c io port: [0xb480-0xb483]
[   84.888827] pci 0000:00:1f.5: reg 20 io port: [0xb400-0xb40f]
[   84.888832] pci 0000:00:1f.5: reg 24 io port: [0xb080-0xb08f]
[   84.888895] pci 0000:07:00.0: reg 10 32bit mmio: [0xfbee0000-0xfbefffff]
[   84.888901] pci 0000:07:00.0: reg 14 32bit mmio: [0xfbec0000-0xfbedffff]
[   84.888906] pci 0000:07:00.0: reg 18 io port: [0xec00-0xec1f]
[   84.888912] pci 0000:07:00.0: reg 1c 32bit mmio: [0xfbebc000-0xfbebffff]
[   84.888926] pci 0000:07:00.0: reg 30 32bit mmio: [0xfbe80000-0xfbe9ffff]
[   84.888953] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[   84.888957] pci 0000:07:00.0: PME# disabled
[   84.889007] pci 0000:07:00.1: reg 10 32bit mmio: [0xfbe60000-0xfbe7ffff]
[   84.889013] pci 0000:07:00.1: reg 14 32bit mmio: [0xfbe40000-0xfbe5ffff]
[   84.889019] pci 0000:07:00.1: reg 18 io port: [0xe880-0xe89f]
[   84.889024] pci 0000:07:00.1: reg 1c 32bit mmio: [0xfbeb8000-0xfbebbfff]
[   84.889038] pci 0000:07:00.1: reg 30 32bit mmio: [0xfbe20000-0xfbe3ffff]
[   84.889065] pci 0000:07:00.1: PME# supported from D0 D3hot D3cold
[   84.889069] pci 0000:07:00.1: PME# disabled
[   84.889118] pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
[   84.889121] pci 0000:00:01.0: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
[   84.889224] pci 0000:03:00.0: reg 10 io port: [0xd000-0xd0ff]
[   84.889233] pci 0000:03:00.0: reg 14 64bit mmio: [0xfbdfc000-0xfbdfffff]
[   84.889242] pci 0000:03:00.0: reg 1c 64bit mmio: [0xfbde0000-0xfbdeffff]
[   84.889251] pci 0000:03:00.0: reg 30 32bit mmio: [0xfba00000-0xfbbfffff]
[   84.889271] pci 0000:03:00.0: supports D1 D2
[   84.889299] pci 0000:00:08.0: bridge io port: [0xd000-0xdfff]
[   84.889302] pci 0000:00:08.0: bridge 32bit mmio: [0xfba00000-0xfbdfffff]
[   84.889364] pci 0000:01:03.0: reg 10 32bit mmio: [0xf9800000-0xf9ffffff]
[   84.889370] pci 0000:01:03.0: reg 14 32bit mmio: [0xfb9fc000-0xfb9fffff]
[   84.889376] pci 0000:01:03.0: reg 18 32bit mmio: [0xfb000000-0xfb7fffff]
[   84.889448] pci 0000:00:1e.0: transparent bridge
[   84.889453] pci 0000:00:1e.0: bridge 32bit mmio: [0xfb000000-0xfb9fffff]
[   84.889459] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf9800000-0xf9ffffff]
[   84.889486] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   84.889798] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   84.889925] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[   84.889991] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[   84.890056] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
[   84.890121] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[   84.890186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[   84.901004] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[   84.901147] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12 14 15)
[   84.901285] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[   84.901425] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[   84.901564] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[   84.901702] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *6 7 10 11 12 14 15)
[   84.901843] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
[   84.901980] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[   84.902198] SCSI subsystem initialized
[   84.902293] libata version 3.00 loaded.
[   84.902392] usbcore: registered new interface driver usbfs
[   84.902418] usbcore: registered new interface driver hub
[   84.902454] usbcore: registered new device driver usb
[   84.902601] PCI: Using ACPI for IRQ routing
[   84.906718] NetLabel: Initializing
[   84.906720] NetLabel:  domain hash size = 128
[   84.906722] NetLabel:  protocols = UNLABELED CIPSOv4
[   84.906736] NetLabel:  unlabeled traffic allowed by default
[   84.906875] hpet clockevent registered
[   84.906879] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[   84.906883] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[   84.906887] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[   84.914709] Switched to high resolution mode on CPU 0
[   84.914986] Switched to high resolution mode on CPU 1
[   84.914989] Switched to high resolution mode on CPU 3
[   84.914992] Switched to high resolution mode on CPU 2
[   84.915349] Switched to high resolution mode on CPU 4
[   84.915434] Switched to high resolution mode on CPU 7
[   84.915437] Switched to high resolution mode on CPU 5
[   84.915439] Switched to high resolution mode on CPU 6
[   84.918707] pnp: PnP ACPI init
[   84.918716] ACPI: bus type pnp registered
[   84.923466] pnp: PnP ACPI: found 15 devices
[   84.923468] ACPI: ACPI bus type pnp unregistered
[   84.923476] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
[   84.923478] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
[   84.923481] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
[   84.923483] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[   84.923489] system 00:09: ioport range 0x164e-0x164f has been reserved
[   84.923493] system 00:0a: ioport range 0x680-0x6ff has been reserved
[   84.923495] system 00:0a: ioport range 0x295-0x296 has been reserved
[   84.923500] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[   84.923502] system 00:0b: ioport range 0x800-0x87f has been reserved
[   84.923505] system 00:0b: ioport range 0x500-0x57f could not be reserved
[   84.923507] system 00:0b: iomem range 0xfed1c000-0xfed1ffff has been reserved
[   84.923510] system 00:0b: iomem range 0xfed20000-0xfed3ffff has been reserved
[   84.923512] system 00:0b: iomem range 0xfed40000-0xfed8ffff has been reserved
[   84.923517] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[   84.923519] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
[   84.923523] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[   84.923528] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   84.923530] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[   84.923532] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[   84.923535] system 00:0e: iomem range 0x100000-0xbf8fffff could not be reserved
[   84.923537] system 00:0e: iomem range 0xfed90000-0xffffffff could not be reserved
[   84.928413] pci 0000:00:01.0: PCI bridge, secondary bus 0000:07
[   84.928416] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[   84.928419] pci 0000:00:01.0:   MEM window: 0xfbe00000-0xfbefffff
[   84.928422] pci 0000:00:01.0:   PREFETCH window: disabled
[   84.928427] pci 0000:00:03.0: PCI bridge, secondary bus 0000:06
[   84.928428] pci 0000:00:03.0:   IO window: disabled
[   84.928432] pci 0000:00:03.0:   MEM window: disabled
[   84.928434] pci 0000:00:03.0:   PREFETCH window: disabled
[   84.928439] pci 0000:00:05.0: PCI bridge, secondary bus 0000:05
[   84.928440] pci 0000:00:05.0:   IO window: disabled
[   84.928443] pci 0000:00:05.0:   MEM window: disabled
[   84.928446] pci 0000:00:05.0:   PREFETCH window: disabled
[   84.928450] pci 0000:00:07.0: PCI bridge, secondary bus 0000:04
[   84.928452] pci 0000:00:07.0:   IO window: disabled
[   84.928455] pci 0000:00:07.0:   MEM window: disabled
[   84.928458] pci 0000:00:07.0:   PREFETCH window: disabled
[   84.928462] pci 0000:00:08.0: PCI bridge, secondary bus 0000:03
[   84.928465] pci 0000:00:08.0:   IO window: 0xd000-0xdfff
[   84.928468] pci 0000:00:08.0:   MEM window: 0xfba00000-0xfbdfffff
[   84.928471] pci 0000:00:08.0:   PREFETCH window: disabled
[   84.928475] pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
[   84.928477] pci 0000:00:09.0:   IO window: disabled
[   84.928480] pci 0000:00:09.0:   MEM window: disabled
[   84.928483] pci 0000:00:09.0:   PREFETCH window: disabled
[   84.928488] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[   84.928489] pci 0000:00:1e.0:   IO window: disabled
[   84.928493] pci 0000:00:1e.0:   MEM window: 0xfb000000-0xfb9fffff
[   84.928497] pci 0000:00:1e.0:   PREFETCH window: 0x000000f9800000-0x000000f9ffffff
[   84.928507] pci 0000:00:01.0: setting latency timer to 64
[   84.928513] pci 0000:00:03.0: setting latency timer to 64
[   84.928519] pci 0000:00:05.0: setting latency timer to 64
[   84.928525] pci 0000:00:07.0: setting latency timer to 64
[   84.928530] pci 0000:00:08.0: setting latency timer to 64
[   84.928536] pci 0000:00:09.0: setting latency timer to 64
[   84.928541] pci 0000:00:1e.0: setting latency timer to 64
[   84.928545] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[   84.928547] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[   84.928549] pci_bus 0000:07: resource 0 io:  [0xe000-0xefff]
[   84.928551] pci_bus 0000:07: resource 1 mem: [0xfbe00000-0xfbefffff]
[   84.928553] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[   84.928555] pci_bus 0000:03: resource 1 mem: [0xfba00000-0xfbdfffff]
[   84.928557] pci_bus 0000:01: resource 1 mem: [0xfb000000-0xfb9fffff]
[   84.928559] pci_bus 0000:01: resource 2 pref mem [0xf9800000-0xf9ffffff]
[   84.928561] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[   84.928563] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[   84.928585] NET: Registered protocol family 2
[   84.934998] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   84.936092] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[   84.937542] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   84.937697] TCP: Hash tables configured (established 524288 bind 65536)
[   84.937699] TCP reno registered
[   84.940771] NET: Registered protocol family 1
[   84.942882] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   84.942884] Scanning for low memory corruption every 60 seconds
[   84.950334] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   84.952092] VFS: Disk quotas dquot_6.5.2
[   84.952152] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   84.952558] msgmni has been set to 32768
[   84.952860] alg: No test for stdrng (krng)
[   84.952867] io scheduler noop registered
[   84.952869] io scheduler anticipatory registered
[   84.952870] io scheduler deadline registered
[   84.952917] io scheduler cfq registered (default)
[   84.952957] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[   84.952959] pci 0000:00:1a.0: Performing full reset
[   84.952973] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[   84.952975] pci 0000:00:1a.1: Performing full reset
[   84.952989] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[   84.952990] pci 0000:00:1a.2: Performing full reset
[   84.953023] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[   84.953025] pci 0000:00:1d.0: Performing full reset
[   84.953039] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[   84.953040] pci 0000:00:1d.1: Performing full reset
[   84.953054] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[   84.953055] pci 0000:00:1d.2: Performing full reset
[   84.953094] pci 0000:01:03.0: Boot video device
[   84.953246]   alloc irq_desc for 24 on cpu 0 node 0
[   84.953248]   alloc kstat_irqs on cpu 0 node 0
[   84.953255] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[   84.953264] pcieport-driver 0000:00:01.0: setting latency timer to 64
[   84.953407]   alloc irq_desc for 25 on cpu 0 node 0
[   84.953408]   alloc kstat_irqs on cpu 0 node 0
[   84.953414] pcieport-driver 0000:00:03.0: irq 25 for MSI/MSI-X
[   84.953423] pcieport-driver 0000:00:03.0: setting latency timer to 64
[   84.953560]   alloc irq_desc for 26 on cpu 0 node 0
[   84.953561]   alloc kstat_irqs on cpu 0 node 0
[   84.953567] pcieport-driver 0000:00:05.0: irq 26 for MSI/MSI-X
[   84.953576] pcieport-driver 0000:00:05.0: setting latency timer to 64
[   84.953716]   alloc irq_desc for 27 on cpu 0 node 0
[   84.953718]   alloc kstat_irqs on cpu 0 node 0
[   84.953723] pcieport-driver 0000:00:07.0: irq 27 for MSI/MSI-X
[   84.953732] pcieport-driver 0000:00:07.0: setting latency timer to 64
[   84.953875]   alloc irq_desc for 28 on cpu 0 node 0
[   84.953877]   alloc kstat_irqs on cpu 0 node 0
[   84.953882] pcieport-driver 0000:00:08.0: irq 28 for MSI/MSI-X
[   84.953891] pcieport-driver 0000:00:08.0: setting latency timer to 64
[   84.954029]   alloc irq_desc for 29 on cpu 0 node 0
[   84.954030]   alloc kstat_irqs on cpu 0 node 0
[   84.954035] pcieport-driver 0000:00:09.0: irq 29 for MSI/MSI-X
[   84.954045] pcieport-driver 0000:00:09.0: setting latency timer to 64
[   84.954158] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[   84.954165] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[   84.954169] aer 0000:00:05.0:pcie02: AER service couldn't init device: no _OSC support
[   84.954173] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[   84.954178] aer 0000:00:08.0:pcie02: AER service couldn't init device: no _OSC support
[   84.954182] aer 0000:00:09.0:pcie02: AER service couldn't init device: no _OSC support
[   84.954202] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   84.954375] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   84.954378] ACPI: Power Button [PWRF]
[   84.954439] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[   84.954444] ACPI: Power Button [PWRB]
[   84.955031] ACPI: SSDT 00000000bf79e1f0 0033D (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[   84.956383] processor ACPI_CPU:00: registered as cooling_device0
[   84.956842] ACPI: SSDT 00000000bf79e530 0033D (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[   84.958186] processor ACPI_CPU:01: registered as cooling_device1
[   84.958653] ACPI: SSDT 00000000bf79e870 0033D (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
[   84.959993] processor ACPI_CPU:02: registered as cooling_device2
[   84.960456] ACPI: SSDT 00000000bf79ebb0 0033D (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
[   84.961798] processor ACPI_CPU:03: registered as cooling_device3
[   84.962260] ACPI: SSDT 00000000bf79eef0 0033D (v01 DpgPmm  P005Ist 00000012 INTL 20051117)
[   84.963601] processor ACPI_CPU:04: registered as cooling_device4
[   84.964063] ACPI: SSDT 00000000bf79f230 0033D (v01 DpgPmm  P006Ist 00000012 INTL 20051117)
[   84.965406] processor ACPI_CPU:05: registered as cooling_device5
[   84.965879] ACPI: SSDT 00000000bf79f570 0033D (v01 DpgPmm  P007Ist 00000012 INTL 20051117)
[   84.967221] processor ACPI_CPU:06: registered as cooling_device6
[   84.967689] ACPI: SSDT 00000000bf79f8b0 0033D (v01 DpgPmm  P008Ist 00000012 INTL 20051117)
[   84.969031] processor ACPI_CPU:07: registered as cooling_device7
[   84.973807] Non-volatile memory driver v1.3
[   84.973809] Linux agpgart interface v0.103
[   84.973870] [drm] Initialized drm 1.1.0 20060810
[   84.973903] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   85.217227] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   85.460763] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   85.704300] serial8250: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[   85.704545] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   85.704680] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   85.704815] 00:08: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[   85.705139] Driver 'sd' needs updating - please use bus_type methods
[   85.705161] Driver 'sr' needs updating - please use bus_type methods
[   85.705280] ata_piix 0000:00:1f.2: version 2.13
[   85.705289]   alloc irq_desc for 19 on cpu 0 node 0
[   85.705290]   alloc kstat_irqs on cpu 0 node 0
[   85.705295] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   85.705299] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   85.705327] ata_piix 0000:00:1f.2: setting latency timer to 64
[   85.705367] scsi0 : ata_piix
[   85.705448] scsi1 : ata_piix
[   85.706892] ata1: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[   85.706896] ata2: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[   85.706903] work_for_cpu used greatest stack depth: 5120 bytes left
[   85.706939] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   85.706943] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[   85.706967] ata_piix 0000:00:1f.5: setting latency timer to 64
[   85.706991] scsi2 : ata_piix
[   85.707059] scsi3 : ata_piix
[   85.708352] ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[   85.708355] ata4: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[   85.708491] Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
[   85.708493] Copyright (c) 2007-2009 Intel Corporation.
[   85.708520]   alloc irq_desc for 16 on cpu 0 node 0
[   85.708522]   alloc kstat_irqs on cpu 0 node 0
[   85.708526] igb 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   85.708543] igb 0000:07:00.0: setting latency timer to 64
[   85.708777]   alloc irq_desc for 30 on cpu 0 node 0
[   85.708779]   alloc kstat_irqs on cpu 0 node 0
[   85.708782] igb 0000:07:00.0: irq 30 for MSI/MSI-X
[   85.708783]   alloc irq_desc for 31 on cpu 0 node 0
[   85.708785]   alloc kstat_irqs on cpu 0 node 0
[   85.708787] igb 0000:07:00.0: irq 31 for MSI/MSI-X
[   85.708789]   alloc irq_desc for 32 on cpu 0 node 0
[   85.708790]   alloc kstat_irqs on cpu 0 node 0
[   85.708792] igb 0000:07:00.0: irq 32 for MSI/MSI-X
[   85.708794]   alloc irq_desc for 33 on cpu 0 node 0
[   85.708795]   alloc kstat_irqs on cpu 0 node 0
[   85.708798] igb 0000:07:00.0: irq 33 for MSI/MSI-X
[   85.708799]   alloc irq_desc for 34 on cpu 0 node 0
[   85.708801]   alloc kstat_irqs on cpu 0 node 0
[   85.708803] igb 0000:07:00.0: irq 34 for MSI/MSI-X
[   85.708805]   alloc irq_desc for 35 on cpu 0 node 0
[   85.708806]   alloc kstat_irqs on cpu 0 node 0
[   85.708808] igb 0000:07:00.0: irq 35 for MSI/MSI-X
[   85.708810]   alloc irq_desc for 36 on cpu 0 node 0
[   85.708812]   alloc kstat_irqs on cpu 0 node 0
[   85.708814] igb 0000:07:00.0: irq 36 for MSI/MSI-X
[   85.708815]   alloc irq_desc for 37 on cpu 0 node 0
[   85.708817]   alloc kstat_irqs on cpu 0 node 0
[   85.708819] igb 0000:07:00.0: irq 37 for MSI/MSI-X
[   85.708821]   alloc irq_desc for 38 on cpu 0 node 0
[   85.708822]   alloc kstat_irqs on cpu 0 node 0
[   85.708824] igb 0000:07:00.0: irq 38 for MSI/MSI-X
[   85.880267] igb 0000:07:00.0: Intel(R) Gigabit Ethernet Network Connection
[   85.880270] igb 0000:07:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:c8:61:b4
[   85.880346] igb 0000:07:00.0: eth0: PBA No: 0100ff-0ff
[   85.880348] igb 0000:07:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[   85.880377]   alloc irq_desc for 17 on cpu 0 node 0
[   85.880379]   alloc kstat_irqs on cpu 0 node 0
[   85.880383] igb 0000:07:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   85.880400] igb 0000:07:00.1: setting latency timer to 64
[   85.880622]   alloc irq_desc for 39 on cpu 0 node 0
[   85.880624]   alloc kstat_irqs on cpu 0 node 0
[   85.880626] igb 0000:07:00.1: irq 39 for MSI/MSI-X
[   85.880628]   alloc irq_desc for 40 on cpu 0 node 0
[   85.880629]   alloc kstat_irqs on cpu 0 node 0
[   85.880632] igb 0000:07:00.1: irq 40 for MSI/MSI-X
[   85.880633]   alloc irq_desc for 41 on cpu 0 node 0
[   85.880635]   alloc kstat_irqs on cpu 0 node 0
[   85.880637] igb 0000:07:00.1: irq 41 for MSI/MSI-X
[   85.880639]   alloc irq_desc for 42 on cpu 0 node 0
[   85.880640]   alloc kstat_irqs on cpu 0 node 0
[   85.880642] igb 0000:07:00.1: irq 42 for MSI/MSI-X
[   85.880644]   alloc irq_desc for 43 on cpu 0 node 0
[   85.880646]   alloc kstat_irqs on cpu 0 node 0
[   85.880648] igb 0000:07:00.1: irq 43 for MSI/MSI-X
[   85.880650]   alloc irq_desc for 44 on cpu 0 node 0
[   85.880651]   alloc kstat_irqs on cpu 0 node 0
[   85.880653] igb 0000:07:00.1: irq 44 for MSI/MSI-X
[   85.880655]   alloc irq_desc for 45 on cpu 0 node 0
[   85.880656]   alloc kstat_irqs on cpu 0 node 0
[   85.880659] igb 0000:07:00.1: irq 45 for MSI/MSI-X
[   85.880660]   alloc irq_desc for 46 on cpu 0 node 0
[   85.880662]   alloc kstat_irqs on cpu 0 node 0
[   85.880664] igb 0000:07:00.1: irq 46 for MSI/MSI-X
[   85.880666]   alloc irq_desc for 47 on cpu 0 node 0
[   85.880667]   alloc kstat_irqs on cpu 0 node 0
[   85.880669] igb 0000:07:00.1: irq 47 for MSI/MSI-X
[   86.023331] ata3: SATA link down (SStatus 0 SControl 300)
[   86.038966] igb 0000:07:00.1: Intel(R) Gigabit Ethernet Network Connection
[   86.038969] igb 0000:07:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:c8:61:b5
[   86.039045] igb 0000:07:00.1: eth1: PBA No: 0100ff-0ff
[   86.039047] igb 0000:07:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[   86.039080] Fusion MPT base driver 3.04.07
[   86.039082] Copyright (c) 1999-2008 LSI Corporation
[   86.039087] Fusion MPT SAS Host driver 3.04.07
[   86.039117] mptsas 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   86.039142] mptbase: ioc0: Initiating bringup
[   86.316043] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[   86.316060] mptsas 0000:03:00.0: setting latency timer to 64
[   86.475797] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   86.475808] ata1.01: SATA link down (SStatus 0 SControl 300)
[   86.494922] ata1.00: ATAPI: DV-28S-V, 1.0A, max UDMA/100
[   86.532861] ata1.00: configured for UDMA/100
[   86.582976] scsi 0:0:0:0: CD-ROM            TEAC     DV-28S-V         1.0A PQ: 0 ANSI: 5
[   86.591721] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   86.591724] Uniform CD-ROM driver Revision: 3.20
[   86.591837] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   86.591899] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   87.211097] ata2.00: SATA link down (SStatus 0 SControl 300)
[   87.211105] ata2.01: SATA link down (SStatus 0 SControl 300)
[   87.525474] ata4: SATA link down (SStatus 0 SControl 300)
[   87.589626] async/0 used greatest stack depth: 4992 bytes left
[   98.422283] scsi4 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=478, IRQ=16
[   98.452638] scsi 4:0:0:0: Direct-Access     ATA      WDC WD2002FYPS-0 5G04 PQ: 0 ANSI: 5
[   98.453126] sd 4:0:0:0: Attached scsi generic sg1 type 0
[   98.454592] sd 4:0:0:0: [sda] 3907029168 512-byte hardware sectors: (2.00 TB/1.81 TiB)
[   98.460108] scsi 4:0:1:0: Direct-Access     ATA      WDC WD2002FYPS-0 5G04 PQ: 0 ANSI: 5
[   98.460464] sd 4:0:0:0: [sda] Write Protect is off
[   98.460467] sd 4:0:0:0: [sda] Mode Sense: 73 00 00 08
[   98.460934] sd 4:0:1:0: Attached scsi generic sg2 type 0
[   98.463744] work_for_cpu used greatest stack depth: 4352 bytes left
[   98.463789] Fusion MPT misc device (ioctl) driver 3.04.07
[   98.463817] mptctl: Registered with Fusion MPT base driver
[   98.463818] mptctl: /dev/mptctl @ (major,minor=10,220)
[   98.463905] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   98.463908] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[   98.463935]   alloc irq_desc for 18 on cpu 0 node 0
[   98.463937]   alloc kstat_irqs on cpu 0 node 0
[   98.463941] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   98.463952] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   98.463955] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   98.463994] drivers/usb/core/inode.c: creating file 'devices'
[   98.464004] drivers/usb/core/inode.c: creating file '001'
[   98.464028] sd 4:0:1:0: [sdb] 3907029168 512-byte hardware sectors: (2.00 TB/1.81 TiB)
[   98.464039] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   98.464046] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   98.464049] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[   98.464062] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   98.467956] ehci_hcd 0000:00:1a.7: debug port 1
[   98.467961] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   98.467963] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[   98.467973] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfaff6000
[   98.467977] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   98.470980] sd 4:0:1:0: [sdb] Write Protect is off
[   98.470982] sd 4:0:1:0: [sdb] Mode Sense: 73 00 00 08
[   98.471847] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[   98.472001] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   98.477215] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   98.477940] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   98.477971] usb usb1: default language 0x0409
[   98.477978] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   98.477981] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.477986] usb usb1: Product: EHCI Host Controller
[   98.477987] usb usb1: Manufacturer: Linux 2.6.30.4 ehci_hcd
[   98.477989] usb usb1: SerialNumber: 0000:00:1a.7
[   98.478019] usb usb1: uevent
[   98.478045] usb usb1: usb_probe_device
[   98.478048] usb usb1: configuration #1 chosen from 1 choice
[   98.478053] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   98.478064] usb 1-0:1.0: uevent
[   98.478087] hub 1-0:1.0: usb_probe_interface
[   98.478089] hub 1-0:1.0: usb_probe_interface - got id
[   98.478090] hub 1-0:1.0: USB hub found
[   98.478095] hub 1-0:1.0: 6 ports detected
[   98.478097] hub 1-0:1.0: standalone hub
[   98.478098] hub 1-0:1.0: no power switching (usb 1.0)
[   98.478099] hub 1-0:1.0: individual port over-current protection
[   98.478101] hub 1-0:1.0: power on to power good time: 20ms
[   98.478104] hub 1-0:1.0: local power source is good
[   98.478105] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   98.478188] drivers/usb/core/inode.c: creating file '001'
[   98.478254]   alloc irq_desc for 23 on cpu 0 node 0
[   98.478256]   alloc kstat_irqs on cpu 0 node 0
[   98.478260] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   98.478270] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   98.478273] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   98.478302] drivers/usb/core/inode.c: creating file '002'
[   98.478341] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   98.478347] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   98.478350] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[   98.478363] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   98.482239] ehci_hcd 0000:00:1d.7: debug port 1
[   98.482244] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   98.482246] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   98.482256] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfaffc000
[   98.482260] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   98.486132] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[   98.487659]  sda:<6> sdb:<6>ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   98.492924] usb usb2: default language 0x0409
[   98.492931] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   98.492934] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.492936] usb usb2: Product: EHCI Host Controller
[   98.492938] usb usb2: Manufacturer: Linux 2.6.30.4 ehci_hcd
[   98.492941] usb usb2: SerialNumber: 0000:00:1d.7
[   98.492976] usb usb2: uevent
[   98.493000] usb usb2: usb_probe_device
[   98.493002] usb usb2: configuration #1 chosen from 1 choice
[   98.493006] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   98.493018] usb 2-0:1.0: uevent
[   98.493040] hub 2-0:1.0: usb_probe_interface
[   98.493042] hub 2-0:1.0: usb_probe_interface - got id
[   98.493043] hub 2-0:1.0: USB hub found
[   98.493047] hub 2-0:1.0: 6 ports detected
[   98.493049] hub 2-0:1.0: standalone hub
[   98.493050] hub 2-0:1.0: no power switching (usb 1.0)
[   98.493051] hub 2-0:1.0: individual port over-current protection
[   98.493053] hub 2-0:1.0: power on to power good time: 20ms
[   98.493055] hub 2-0:1.0: local power source is good
[   98.493057] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   98.493111] drivers/usb/core/inode.c: creating file '001'
[   98.493179] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   98.493181] ohci_hcd: block sizes: ed 80 td 96
[   98.493209] uhci_hcd: USB Universal Host Controller Interface driver
[   98.493277] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   98.493282] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   98.493284] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   98.493314] drivers/usb/core/inode.c: creating file '003'
[   98.493349] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   98.493354] uhci_hcd 0000:00:1a.0: detected 2 ports
[   98.493358] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   98.493360] uhci_hcd 0000:00:1a.0: Performing full reset
[   98.493372] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   98.493377] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[   98.493399] usb usb3: default language 0x0409
[   98.493404] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   98.493406] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.493408] usb usb3: Product: UHCI Host Controller
[   98.493409] usb usb3: Manufacturer: Linux 2.6.30.4 uhci_hcd
[   98.493411] usb usb3: SerialNumber: 0000:00:1a.0
[   98.493442] usb usb3: uevent
[   98.493463] usb usb3: usb_probe_device
[   98.493465] usb usb3: configuration #1 chosen from 1 choice
[   98.493472] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   98.493483] usb 3-0:1.0: uevent
[   98.493506] hub 3-0:1.0: usb_probe_interface
[   98.493508] hub 3-0:1.0: usb_probe_interface - got id
[   98.493509] hub 3-0:1.0: USB hub found
[   98.493514] hub 3-0:1.0: 2 ports detected
[   98.493515] hub 3-0:1.0: standalone hub
[   98.493516] hub 3-0:1.0: no power switching (usb 1.0)
[   98.493517] hub 3-0:1.0: individual port over-current protection
[   98.493519] hub 3-0:1.0: power on to power good time: 2ms
[   98.493522] hub 3-0:1.0: local power source is good
[   98.493523] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   98.493561] drivers/usb/core/inode.c: creating file '001'
[   98.493628]   alloc irq_desc for 21 on cpu 0 node 0
[   98.493630]   alloc kstat_irqs on cpu 0 node 0
[   98.493634] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   98.493639] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   98.493642] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   98.493673] drivers/usb/core/inode.c: creating file '004'
[   98.493713] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   98.493719] uhci_hcd 0000:00:1a.1: detected 2 ports
[   98.493722] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   98.493724] uhci_hcd 0000:00:1a.1: Performing full reset
[   98.493736] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[   98.493746] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a480
[   98.493771] usb usb4: default language 0x0409
[   98.493775] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   98.493777] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.493779] usb usb4: Product: UHCI Host Controller
[   98.493781] usb usb4: Manufacturer: Linux 2.6.30.4 uhci_hcd
[   98.493782] usb usb4: SerialNumber: 0000:00:1a.1
[   98.493808] usb usb4: uevent
[   98.493829] usb usb4: usb_probe_device
[   98.493831] usb usb4: configuration #1 chosen from 1 choice
[   98.493836] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   98.493848] usb 4-0:1.0: uevent
[   98.493870] hub 4-0:1.0: usb_probe_interface
[   98.493872] hub 4-0:1.0: usb_probe_interface - got id
[   98.493873] hub 4-0:1.0: USB hub found
[   98.493877] hub 4-0:1.0: 2 ports detected
[   98.493879] hub 4-0:1.0: standalone hub
[   98.493880] hub 4-0:1.0: no power switching (usb 1.0)
[   98.493881] hub 4-0:1.0: individual port over-current protection
[   98.493883] hub 4-0:1.0: power on to power good time: 2ms
[   98.493886] hub 4-0:1.0: local power source is good
[   98.493887] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   98.493929] drivers/usb/core/inode.c: creating file '001'
[   98.494000] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   98.494005] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   98.494007] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   98.494036] drivers/usb/core/inode.c: creating file '005'
[   98.494072] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   98.494078] uhci_hcd 0000:00:1a.2: detected 2 ports
[   98.494082] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[   98.494083] uhci_hcd 0000:00:1a.2: Performing full reset
[   98.494096] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   98.494099] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000a400
[   98.494121] usb usb5: default language 0x0409
[   98.494126] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   98.494128] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.494130] usb usb5: Product: UHCI Host Controller
[   98.494131] usb usb5: Manufacturer: Linux 2.6.30.4 uhci_hcd
[   98.494133] usb usb5: SerialNumber: 0000:00:1a.2
[   98.494160] usb usb5: uevent
[   98.494182] usb usb5: usb_probe_device
[   98.494184] usb usb5: configuration #1 chosen from 1 choice
[   98.494189] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   98.494199] usb 5-0:1.0: uevent
[   98.494221] hub 5-0:1.0: usb_probe_interface
[   98.494223] hub 5-0:1.0: usb_probe_interface - got id
[   98.494224] hub 5-0:1.0: USB hub found
[   98.494228] hub 5-0:1.0: 2 ports detected
[   98.494229] hub 5-0:1.0: standalone hub
[   98.494231] hub 5-0:1.0: no power switching (usb 1.0)
[   98.494232] hub 5-0:1.0: individual port over-current protection
[   98.494233] hub 5-0:1.0: power on to power good time: 2ms
[   98.494236] hub 5-0:1.0: local power source is good
[   98.494238] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   98.494275] drivers/usb/core/inode.c: creating file '001'
[   98.494343] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   98.494348] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   98.494351] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   98.494381] drivers/usb/core/inode.c: creating file '006'
[   98.494420] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   98.494425] uhci_hcd 0000:00:1d.0: detected 2 ports
[   98.494429] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   98.494430] uhci_hcd 0000:00:1d.0: Performing full reset
[   98.494443] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   98.494447] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b000
[   98.494469] usb usb6: default language 0x0409
[   98.494473] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   98.494475] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.494477] usb usb6: Product: UHCI Host Controller
[   98.494479] usb usb6: Manufacturer: Linux 2.6.30.4 uhci_hcd
[   98.494480] usb usb6: SerialNumber: 0000:00:1d.0
[   98.494510] usb usb6: uevent
[   98.494531] usb usb6: usb_probe_device
[   98.494533] usb usb6: configuration #1 chosen from 1 choice
[   98.494538] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   98.494549] usb 6-0:1.0: uevent
[   98.494571] hub 6-0:1.0: usb_probe_interface
[   98.494573] hub 6-0:1.0: usb_probe_interface - got id
[   98.494574] hub 6-0:1.0: USB hub found
[   98.494578] hub 6-0:1.0: 2 ports detected
[   98.494579] hub 6-0:1.0: standalone hub
[   98.494580] hub 6-0:1.0: no power switching (usb 1.0)
[   98.494582] hub 6-0:1.0: individual port over-current protection
[   98.494583] hub 6-0:1.0: power on to power good time: 2ms
[   98.494586] hub 6-0:1.0: local power source is good
[   98.494588] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   98.494627] drivers/usb/core/inode.c: creating file '001'
[   98.494695] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   98.494700] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   98.494702] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   98.494731] drivers/usb/core/inode.c: creating file '007'
[   98.494766] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   98.494772] uhci_hcd 0000:00:1d.1: detected 2 ports
[   98.494775] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   98.494777] uhci_hcd 0000:00:1d.1: Performing full reset
[   98.494789] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   98.494796] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ac00
[   98.494817] usb usb7: default language 0x0409
[   98.494822] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   98.494824] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.494826] usb usb7: Product: UHCI Host Controller
[   98.494827] usb usb7: Manufacturer: Linux 2.6.30.4 uhci_hcd
[   98.494829] usb usb7: SerialNumber: 0000:00:1d.1
[   98.494856] usb usb7: uevent
[   98.494878] usb usb7: usb_probe_device
[   98.494880] usb usb7: configuration #1 chosen from 1 choice
[   98.494884] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   98.494897] usb 7-0:1.0: uevent
[   98.494923] hub 7-0:1.0: usb_probe_interface
[   98.494924] hub 7-0:1.0: usb_probe_interface - got id
[   98.494926] hub 7-0:1.0: USB hub found
[   98.494932] hub 7-0:1.0: 2 ports detected
[   98.494933] hub 7-0:1.0: standalone hub
[   98.494934] hub 7-0:1.0: no power switching (usb 1.0)
[   98.494935] hub 7-0:1.0: individual port over-current protection
[   98.494937] hub 7-0:1.0: power on to power good time: 2ms
[   98.494940] hub 7-0:1.0: local power source is good
[   98.494941] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   98.494982] drivers/usb/core/inode.c: creating file '001'
[   98.495050] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   98.495055] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   98.495057] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   98.495093] drivers/usb/core/inode.c: creating file '008'
[   98.495129] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   98.495135] uhci_hcd 0000:00:1d.2: detected 2 ports
[   98.495138] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   98.495140] uhci_hcd 0000:00:1d.2: Performing full reset
[   98.495152] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   98.495156] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a880
[   98.495180] usb usb8: default language 0x0409
[   98.495185] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   98.495187] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   98.495189] usb usb8: Product: UHCI Host Controller
[   98.495190] usb usb8: Manufacturer: Linux 2.6.30.4 uhci_hcd
[   98.495192] usb usb8: SerialNumber: 0000:00:1d.2
[   98.495222] usb usb8: uevent
[   98.495243] usb usb8: usb_probe_device
[   98.495245] usb usb8: configuration #1 chosen from 1 choice
[   98.495250] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[   98.495262] usb 8-0:1.0: uevent
[   98.495284] hub 8-0:1.0: usb_probe_interface
[   98.495286] hub 8-0:1.0: usb_probe_interface - got id
[   98.495287] hub 8-0:1.0: USB hub found
[   98.495291] hub 8-0:1.0: 2 ports detected
[   98.495292] hub 8-0:1.0: standalone hub
[   98.495293] hub 8-0:1.0: no power switching (usb 1.0)
[   98.495295] hub 8-0:1.0: individual port over-current protection
[   98.495296] hub 8-0:1.0: power on to power good time: 2ms
[   98.495299] hub 8-0:1.0: local power source is good
[   98.495300] hub 8-0:1.0: trying to enable port power on non-switchable hub
[   98.495340] drivers/usb/core/inode.c: creating file '001'
[   98.495446] usbcore: registered new interface driver usblp
[   98.495449] Initializing USB Mass Storage driver...
[   98.495495] usbcore: registered new interface driver usb-storage
[   98.495497] USB Mass Storage support registered.
[   98.495545] usbcore: registered new interface driver libusual
[   98.495636] PNP: No PS/2 controller found. Probing ports directly.
[   98.497673] serio: i8042 KBD port at 0x60,0x64 irq 1
[   98.497677] serio: i8042 AUX port at 0x60,0x64 irq 12
[   98.497720] mice: PS/2 mouse device common for all mice
[   98.497865] rtc_cmos 00:03: RTC can wake from S4
[   98.497906] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   98.497928] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   98.497977] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   98.498042] md: raid1 personality registered for level 1
[   98.498147] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   98.498229] cpuidle: using governor ladder
[   98.498230] cpuidle: using governor menu
[   98.498800] usbcore: registered new interface driver hiddev
[   98.498829] usbcore: registered new interface driver usbhid
[   98.498831] usbhid: v2.6:USB HID core driver
[   98.498857] Netfilter messages via NETLINK v0.30.
[   98.498867] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   98.499043] ctnetlink v0.93: registering with nfnetlink.
[   98.499488] ip_tables: (C) 2000-2006 Netfilter Core Team
[   98.499515] TCP cubic registered
[   98.499516] Initializing XFRM netlink socket
[   98.499670] NET: Registered protocol family 10
[   98.500695] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   98.500742] IPv6 over IPv4 tunneling driver
[   98.501235] NET: Registered protocol family 17
[   98.505175] PM: Resume from disk failed.
[   98.505183] registered taskstats version 1
[   98.577762] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[   98.577766] hub 1-0:1.0: port 6: status 0501 change 0001
[   98.592732] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   98.592738] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   98.592747] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   98.593727] uhci_hcd 0000:00:1a.2: port 2 portsc 008a,00
[   98.593746] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   98.594726] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   98.594734] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   98.677560] hub 1-0:1.0: state 7 ports 6 chg 0040 evt 0000
[   98.677568] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[   98.728621] ehci_hcd 0000:00:1a.7: port 6 full speed --> companion
[   98.728625] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
[   98.728629] hub 1-0:1.0: port 6 not reset yet, waiting 50ms
[   98.779367] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[   98.779384] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   98.779391] uhci_hcd 0000:00:1a.2: port 2 portsc 0093,00
[   98.779397] hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   98.883171] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[   98.883910]  sda1 sda2
[   98.884070] sd 4:0:0:0: [sda] Attached SCSI disk
[   98.893164]  sdb1 sdb2
[   98.893315] sd 4:0:1:0: [sdb] Attached SCSI disk
[   98.909397] md: Waiting for all devices to be available before autodetect
[   98.909400] md: If you don't use raid, use raid=noautodetect
[   98.909505] md: Autodetecting RAID arrays.
[   98.909736] md: Scanned 2 and added 2 devices.
[   98.909738] md: autorun ...
[   98.909739] md: considering sdb2 ...
[   98.909744] md:  adding sdb2 ...
[   98.909748] md:  adding sda2 ...
[   98.909751] md: created md0
[   98.909753] md: bind<sda2>
[   98.909763] md: bind<sdb2>
[   98.909771] md: running: <sdb2><sda2>
[   98.909781] md: kicking non-fresh sdb2 from array!
[   98.909785] md: unbind<sdb2>
[   98.916103] md: export_rdev(sdb2)
[   98.916207] raid1: raid set md0 active with 1 out of 2 mirrors
[   98.916241] md: ... autorun DONE.
[   98.916279]  md0: unknown partition table
[   98.968095] EXT4-fs: barriers enabled
[   98.980525] kjournald2 starting: pid 927, dev md0:8, commit interval 5 seconds
[   98.980530] EXT4-fs: delayed allocation enabled
[   98.980532] EXT4-fs: file extents enabled
[   98.984976] usb 5-2: new full speed USB device using uhci_hcd and address 2
[   99.121464] EXT4-fs: mballoc enabled
[   99.121475] EXT4-fs: mounted filesystem md0 with ordered data mode
[   99.121482] VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
[   99.121499] Freeing unused kernel memory: 524k freed
[   99.121574] Write protecting the kernel read-only data: 5552k
[   99.127891] usb 5-2: skipped 1 descriptor after interface
[   99.127894] usb 5-2: skipped 1 descriptor after interface
[   99.132879] usb 5-2: default language 0x0409
[   99.147855] usb 5-2: New USB device found, idVendor=046b, idProduct=ff10
[   99.147859] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   99.147861] usb 5-2: Product: Virtual Keyboard and Mouse
[   99.147864] usb 5-2: Manufacturer: American Megatrends Inc.
[   99.147866] usb 5-2: SerialNumber: serial
[   99.147918] usb 5-2: uevent
[   99.149710] usb 5-2: usb_probe_device
[   99.149713] usb 5-2: configuration #1 chosen from 1 choice
[   99.182790] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[   99.185783] usb 5-2:1.0: uevent
[   99.185834] usbhid 5-2:1.0: usb_probe_interface
[   99.185836] usbhid 5-2:1.0: usb_probe_interface - got id
[   99.192936] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input2
[   99.192944] uhci_hcd 0000:00:1a.2: reserve dev 2 ep81-INT, period 1, phase 0, 17 us
[   99.193017] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-2/input0
[   99.193062] usb 5-2: adding 5-2:1.1 (config #1, interface 1)
[   99.205745] usb 5-2:1.1: uevent
[   99.205793] usbhid 5-2:1.1: usb_probe_interface
[   99.205795] usbhid 5-2:1.1: usb_probe_interface - got id
[   99.209865] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input3
[   99.209968] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-2/input1
[   99.210012] drivers/usb/core/inode.c: creating file '002'
[   99.210056] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[   99.210062] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   99.707173] usb usb3: uevent
[   99.707194] usb 3-0:1.0: uevent
[   99.707295] usb usb4: uevent
[   99.707314] usb 4-0:1.0: uevent
[   99.707410] usb usb5: uevent
[   99.707424] usb 5-0:1.0: uevent
[   99.707449] usb 5-2: uevent
[   99.707462] usb 5-2:1.0: uevent
[   99.707548] usb 5-2:1.1: uevent
[   99.707683] usb usb1: uevent
[   99.707701] usb 1-0:1.0: uevent
[   99.707778] usb usb6: uevent
[   99.707792] usb 6-0:1.0: uevent
[   99.707885] usb usb7: uevent
[   99.707904] usb 7-0:1.0: uevent
[   99.708001] usb usb8: uevent
[   99.708019] usb 8-0:1.0: uevent
[   99.708113] usb usb2: uevent
[   99.708132] usb 2-0:1.0: uevent
[   99.739546] usb usb3: suspend_rh (auto-stop)
[   99.739567] usb usb4: suspend_rh (auto-stop)
[   99.739586] usb usb6: suspend_rh (auto-stop)
[   99.739604] usb usb7: suspend_rh (auto-stop)
[   99.739623] usb usb8: suspend_rh (auto-stop)
[   99.746101] usb 5-2:1.1: uevent
[   99.746134] usb 5-2:1.0: uevent
[   99.746172] usb 5-2: uevent
[   99.746201] usb 5-2: uevent
[   99.746705] usb 5-2:1.1: uevent
[   99.746805] usb 5-2: uevent
[  100.527651] EXT4 FS on md0, internal journal on md0:8
[  100.972295] hub 2-0:1.0: hub_suspend
[  100.972303] usb usb2: bus auto-suspend
[  100.972306] ehci_hcd 0000:00:1d.7: suspend root hub
[  100.972328] hub 3-0:1.0: hub_suspend
[  100.972331] usb usb3: bus auto-suspend
[  100.972334] usb usb3: suspend_rh
[  100.972355] hub 4-0:1.0: hub_suspend
[  100.972357] usb usb4: bus auto-suspend
[  100.972359] usb usb4: suspend_rh
[  100.972372] hub 6-0:1.0: hub_suspend
[  100.972374] usb usb6: bus auto-suspend
[  100.972376] usb usb6: suspend_rh
[  100.972388] hub 7-0:1.0: hub_suspend
[  100.972391] usb usb7: bus auto-suspend
[  100.972392] usb usb7: suspend_rh
[  100.972405] hub 8-0:1.0: hub_suspend
[  100.972407] usb usb8: bus auto-suspend
[  100.972408] usb usb8: suspend_rh
[  101.293072] loop: module loaded
[  101.985289] hub 1-0:1.0: hub_suspend
[  101.985297] usb usb1: bus auto-suspend
[  101.985300] ehci_hcd 0000:00:1a.7: suspend root hub
[  102.186946] ifup used greatest stack depth: 4208 bytes left
[  102.925932] igb: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[  102.926629] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  102.928012] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  113.633136] eth0: no IPv6 routers present
[ 1663.180526] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[ 3722.685859] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 3724.024295] igb: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[ 3724.025611] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 3734.660305] eth0: no IPv6 routers present
[ 4207.188281] md: bind<sdb2>
[ 4207.232812] RAID1 conf printout:
[ 4207.232815]  --- wd:1 rd:2
[ 4207.232818]  disk 0, wo:0, o:1, dev:sda2
[ 4207.232820]  disk 1, wo:1, o:1, dev:sdb2
[ 4207.232857] md: recovery of RAID array md0
[ 4207.232859] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 4207.232861] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[ 4207.232865] md: using 128k window, over a total of 1953504704 blocks.
[41031.008718] md: md0: recovery done.
[41031.147571] RAID1 conf printout:
[41031.147573]  --- wd:2 rd:2
[41031.147575]  disk 0, wo:0, o:1, dev:sda2
[41031.147577]  disk 1, wo:0, o:1, dev:sdb2
[403024.734049] sum used greatest stack depth: 4072 bytes left
[1328327.346684] tar used greatest stack depth: 4056 bytes left
[1367518.760440] pdflush used greatest stack depth: 3776 bytes left
[2256003.055451] end_request: I/O error, dev sdb, sector 3907028974
[2256003.055674] md: super_written gets error=-5, uptodate=0
[2256003.055677] raid1: Disk failure on sdb2, disabling device.
[2256003.055678] raid1: Operation continuing on 1 devices.
[2256003.437315] RAID1 conf printout:
[2256003.437318]  --- wd:1 rd:2
[2256003.437321]  disk 0, wo:0, o:1, dev:sda2
[2256003.437323]  disk 1, wo:1, o:0, dev:sdb2
[2256003.440542] RAID1 conf printout:
[2256003.440545]  --- wd:1 rd:2
[2256003.440548]  disk 0, wo:0, o:1, dev:sda2
[2257068.333765] md: unbind<sdb2>
[2257068.340466] md: export_rdev(sdb2)
[2257099.392140] md: bind<sdb2>
[2257099.438375] RAID1 conf printout:
[2257099.438378]  --- wd:1 rd:2
[2257099.438381]  disk 0, wo:0, o:1, dev:sda2
[2257099.438383]  disk 1, wo:1, o:1, dev:sdb2
[2257099.438462] md: recovery of RAID array md0
[2257099.438465] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2257099.438466] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[2257099.438470] md: using 128k window, over a total of 1953504704 blocks.
[2289888.698717] md: md0: recovery done.
[2289888.827881] RAID1 conf printout:
[2289888.827884]  --- wd:2 rd:2
[2289888.827887]  disk 0, wo:0, o:1, dev:sda2
[2289888.827889]  disk 1, wo:0, o:1, dev:sdb2
[2310401.950744] end_request: I/O error, dev sdb, sector 3907028974
[2310401.950966] md: super_written gets error=-5, uptodate=0
[2310401.950969] raid1: Disk failure on sdb2, disabling device.
[2310401.950970] raid1: Operation continuing on 1 devices.
[2310402.622529] RAID1 conf printout:
[2310402.622532]  --- wd:1 rd:2
[2310402.622534]  disk 0, wo:0, o:1, dev:sda2
[2310402.622537]  disk 1, wo:1, o:0, dev:sdb2
[2310402.626394] RAID1 conf printout:
[2310402.626396]  --- wd:1 rd:2
[2310402.626398]  disk 0, wo:0, o:1, dev:sda2
[2317942.110788] md: unbind<sdb2>
[2317942.118014] md: export_rdev(sdb2)
[2317948.637723] md: bind<sdb2>
[2317948.685118] RAID1 conf printout:
[2317948.685121]  --- wd:1 rd:2
[2317948.685124]  disk 0, wo:0, o:1, dev:sda2
[2317948.685126]  disk 1, wo:1, o:1, dev:sdb2
[2317948.685166] md: recovery of RAID array md0
[2317948.685168] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2317948.685170] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[2317948.685174] md: using 128k window, over a total of 1953504704 blocks.
[2351418.039840] md: md0: recovery done.
[2351418.222173] RAID1 conf printout:
[2351418.222176]  --- wd:2 rd:2
[2351418.222179]  disk 0, wo:0, o:1, dev:sda2
[2351418.222182]  disk 1, wo:0, o:1, dev:sdb2
[2378343.856005] end_request: I/O error, dev sdb, sector 3907028974
[2378343.856226] md: super_written gets error=-5, uptodate=0
[2378343.856228] raid1: Disk failure on sdb2, disabling device.
[2378343.856229] raid1: Operation continuing on 1 devices.
[2378343.877579] RAID1 conf printout:
[2378343.877583]  --- wd:1 rd:2
[2378343.877587]  disk 0, wo:0, o:1, dev:sda2
[2378343.877591]  disk 1, wo:1, o:0, dev:sdb2
[2378343.881234] RAID1 conf printout:
[2378343.881237]  --- wd:1 rd:2
[2378343.881240]  disk 0, wo:0, o:1, dev:sda2
[2409799.504484] md: unbind<sdb2>
[2409799.511526] md: export_rdev(sdb2)
[2409803.613344] md: bind<sdb2>
[2409803.622694] RAID1 conf printout:
[2409803.622697]  --- wd:1 rd:2
[2409803.622700]  disk 0, wo:0, o:1, dev:sda2
[2409803.622702]  disk 1, wo:1, o:1, dev:sdb2
[2409803.622741] md: recovery of RAID array md0
[2409803.622743] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2409803.622745] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[2409803.622749] md: using 128k window, over a total of 1953504704 blocks.
[2446822.078048] md: md0: recovery done.
[2446822.162361] RAID1 conf printout:
[2446822.162364]  --- wd:2 rd:2
[2446822.162368]  disk 0, wo:0, o:1, dev:sda2
[2446822.162370]  disk 1, wo:0, o:1, dev:sdb2
[2463699.282479] end_request: I/O error, dev sdb, sector 3907028974
[2463699.282699] md: super_written gets error=-5, uptodate=0
[2463699.282702] raid1: Disk failure on sdb2, disabling device.
[2463699.282703] raid1: Operation continuing on 1 devices.
[2463699.303186] RAID1 conf printout:
[2463699.303189]  --- wd:1 rd:2
[2463699.303192]  disk 0, wo:0, o:1, dev:sda2
[2463699.303194]  disk 1, wo:1, o:0, dev:sdb2
[2463699.308035] RAID1 conf printout:
[2463699.308037]  --- wd:1 rd:2
[2463699.308040]  disk 0, wo:0, o:1, dev:sda2
[2499818.688121] md: unbind<sdb2>
[2499818.695024] md: export_rdev(sdb2)
[2499822.032436] md: bind<sdb2>
[2499822.041787] RAID1 conf printout:
[2499822.041790]  --- wd:1 rd:2
[2499822.041793]  disk 0, wo:0, o:1, dev:sda2
[2499822.041796]  disk 1, wo:1, o:1, dev:sdb2
[2499822.041839] md: recovery of RAID array md0
[2499822.041841] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2499822.041843] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[2499822.041847] md: using 128k window, over a total of 1953504704 blocks.
[2537148.835839] md: md0: recovery done.
[2537148.964996] RAID1 conf printout:
[2537148.964999]  --- wd:2 rd:2
[2537148.965003]  disk 0, wo:0, o:1, dev:sda2
[2537148.965005]  disk 1, wo:0, o:1, dev:sdb2
[2545135.278733] end_request: I/O error, dev sdb, sector 3907028974
[2545135.278955] md: super_written gets error=-5, uptodate=0
[2545135.278958] raid1: Disk failure on sdb2, disabling device.
[2545135.278959] raid1: Operation continuing on 1 devices.
[2545135.761917] RAID1 conf printout:
[2545135.761920]  --- wd:1 rd:2
[2545135.761923]  disk 0, wo:0, o:1, dev:sda2
[2545135.761926]  disk 1, wo:1, o:0, dev:sdb2
[2545135.766893] RAID1 conf printout:
[2545135.766896]  --- wd:1 rd:2
[2545135.766899]  disk 0, wo:0, o:1, dev:sda2
[2550667.169302] md: unbind<sdb2>
[2550667.177346] md: export_rdev(sdb2)
[2550667.568787] md: bind<sdb2>
[2550667.614961] RAID1 conf printout:
[2550667.614964]  --- wd:1 rd:2
[2550667.614967]  disk 0, wo:0, o:1, dev:sda2
[2550667.614969]  disk 1, wo:1, o:1, dev:sdb2
[2550667.615008] md: recovery of RAID array md0
[2550667.615010] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2550667.615012] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[2550667.615016] md: using 128k window, over a total of 1953504704 blocks.
[2586150.939539] md: md0: recovery done.
[2586151.142132] RAID1 conf printout:
[2586151.142135]  --- wd:2 rd:2
[2586151.142139]  disk 0, wo:0, o:1, dev:sda2
[2586151.142142]  disk 1, wo:0, o:1, dev:sdb2
[2607474.299114] end_request: I/O error, dev sdb, sector 3907028974
[2607474.299337] md: super_written gets error=-5, uptodate=0
[2607474.299340] raid1: Disk failure on sdb2, disabling device.
[2607474.299341] raid1: Operation continuing on 1 devices.
[2607474.319610] RAID1 conf printout:
[2607474.319613]  --- wd:1 rd:2
[2607474.319616]  disk 0, wo:0, o:1, dev:sda2
[2607474.319619]  disk 1, wo:1, o:0, dev:sdb2
[2607474.323530] RAID1 conf printout:
[2607474.323532]  --- wd:1 rd:2
[2607474.323535]  disk 0, wo:0, o:1, dev:sda2
[2622763.210681] md: unbind<sdb2>
[2622763.217011] md: export_rdev(sdb2)
[2622763.327343] md: bind<sdb2>
[2622763.375661] RAID1 conf printout:
[2622763.375664]  --- wd:1 rd:2
[2622763.375667]  disk 0, wo:0, o:1, dev:sda2
[2622763.375669]  disk 1, wo:1, o:1, dev:sdb2
[2622763.375710] md: recovery of RAID array md0
[2622763.375712] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2622763.375714] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[2622763.375718] md: using 128k window, over a total of 1953504704 blocks.
[2659664.938226] md: md0: recovery done.
[2659665.070862] RAID1 conf printout:
[2659665.070865]  --- wd:2 rd:2
[2659665.070868]  disk 0, wo:0, o:1, dev:sda2
[2659665.070870]  disk 1, wo:0, o:1, dev:sdb2
[2973873.112757] md: data-check of RAID array md0
[2973873.112760] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[2973873.112762] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[2973873.112766] md: using 128k window, over a total of 1953504704 blocks.
[3008265.577682] md: md0: data-check done.
[3058424.467530] end_request: I/O error, dev sdb, sector 3907028974
[3058424.467751] md: super_written gets error=-5, uptodate=0
[3058424.467755] raid1: Disk failure on sdb2, disabling device.
[3058424.467755] raid1: Operation continuing on 1 devices.
[3058424.488444] RAID1 conf printout:
[3058424.488447]  --- wd:1 rd:2
[3058424.488450]  disk 0, wo:0, o:1, dev:sda2
[3058424.488453]  disk 1, wo:1, o:0, dev:sdb2
[3058424.491469] RAID1 conf printout:
[3058424.491471]  --- wd:1 rd:2
[3058424.491473]  disk 0, wo:0, o:1, dev:sda2
[3058529.271920] md: unbind<sdb2>
[3058529.282549] md: export_rdev(sdb2)
[3058529.308832] md: bind<sdb2>
[3058529.683992] RAID1 conf printout:
[3058529.683995]  --- wd:1 rd:2
[3058529.683998]  disk 0, wo:0, o:1, dev:sda2
[3058529.684000]  disk 1, wo:1, o:1, dev:sdb2
[3058529.684039] md: recovery of RAID array md0
[3058529.684041] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[3058529.684043] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[3058529.684047] md: using 128k window, over a total of 1953504704 blocks.
[3095772.403073] md: md0: recovery done.
[3095772.513820] RAID1 conf printout:
[3095772.513823]  --- wd:2 rd:2
[3095772.513826]  disk 0, wo:0, o:1, dev:sda2
[3095772.513829]  disk 1, wo:0, o:1, dev:sdb2
[3111078.923862] end_request: I/O error, dev sdb, sector 3907028974
[3111078.924084] md: super_written gets error=-5, uptodate=0
[3111078.924086] raid1: Disk failure on sdb2, disabling device.
[3111078.924087] raid1: Operation continuing on 1 devices.
[3111078.945144] RAID1 conf printout:
[3111078.945147]  --- wd:1 rd:2
[3111078.945150]  disk 0, wo:0, o:1, dev:sda2
[3111078.945152]  disk 1, wo:1, o:0, dev:sdb2
[3111078.948893] RAID1 conf printout:
[3111078.948896]  --- wd:1 rd:2
[3111078.948899]  disk 0, wo:0, o:1, dev:sda2
[3114305.709565] md: unbind<sdb2>
[3114305.719957] md: export_rdev(sdb2)
[3114305.756401] md: bind<sdb2>
[3114305.807463] RAID1 conf printout:
[3114305.807466]  --- wd:1 rd:2
[3114305.807469]  disk 0, wo:0, o:1, dev:sda2
[3114305.807471]  disk 1, wo:1, o:1, dev:sdb2
[3114305.807512] md: recovery of RAID array md0
[3114305.807515] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[3114305.807516] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[3114305.807520] md: using 128k window, over a total of 1953504704 blocks.
[3150207.473717] md: md0: recovery done.
[3150207.600595] RAID1 conf printout:
[3150207.600598]  --- wd:2 rd:2
[3150207.600601]  disk 0, wo:0, o:1, dev:sda2
[3150207.600604]  disk 1, wo:0, o:1, dev:sdb2
[3161491.894551] end_request: I/O error, dev sdb, sector 3907028974
[3161491.894776] md: super_written gets error=-5, uptodate=0
[3161491.894779] raid1: Disk failure on sdb2, disabling device.
[3161491.894780] raid1: Operation continuing on 1 devices.
[3161492.276178] RAID1 conf printout:
[3161492.276181]  --- wd:1 rd:2
[3161492.276184]  disk 0, wo:0, o:1, dev:sda2
[3161492.276186]  disk 1, wo:1, o:0, dev:sdb2
[3161492.279854] RAID1 conf printout:
[3161492.279856]  --- wd:1 rd:2
[3161492.279859]  disk 0, wo:0, o:1, dev:sda2
[3183730.823542] md: unbind<sdb2>
[3183730.834313] md: export_rdev(sdb2)
[3183731.279881] md: bind<sdb2>
[3183731.304704] RAID1 conf printout:
[3183731.304707]  --- wd:1 rd:2
[3183731.304710]  disk 0, wo:0, o:1, dev:sda2
[3183731.304712]  disk 1, wo:1, o:1, dev:sdb2
[3183731.304752] md: recovery of RAID array md0
[3183731.304754] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[3183731.304756] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[3183731.304759] md: using 128k window, over a total of 1953504704 blocks.
[3218635.462393] md: md0: recovery done.
[3218635.591553] RAID1 conf printout:
[3218635.591557]  --- wd:2 rd:2
[3218635.591560]  disk 0, wo:0, o:1, dev:sda2
[3218635.591562]  disk 1, wo:0, o:1, dev:sdb2
[3391005.325670] end_request: I/O error, dev sdb, sector 3907028974
[3391005.325890] md: super_written gets error=-5, uptodate=0
[3391005.325893] raid1: Disk failure on sdb2, disabling device.
[3391005.325894] raid1: Operation continuing on 1 devices.
[3391006.012141] RAID1 conf printout:
[3391006.012144]  --- wd:1 rd:2
[3391006.012147]  disk 0, wo:0, o:1, dev:sda2
[3391006.012149]  disk 1, wo:1, o:0, dev:sdb2
[3391006.015266] RAID1 conf printout:
[3391006.015269]  --- wd:1 rd:2
[3391006.015272]  disk 0, wo:0, o:1, dev:sda2
[3410193.895569] md: unbind<sdb2>
[3410193.902505] md: export_rdev(sdb2)
[3410193.923767] md: bind<sdb2>
[3410193.970724] RAID1 conf printout:
[3410193.970727]  --- wd:1 rd:2
[3410193.970730]  disk 0, wo:0, o:1, dev:sda2
[3410193.970733]  disk 1, wo:1, o:1, dev:sdb2
[3410193.970773] md: recovery of RAID array md0
[3410193.970775] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[3410193.970777] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[3410193.970781] md: using 128k window, over a total of 1953504704 blocks.
[3445254.592366] md: md0: recovery done.
[3445254.712358] RAID1 conf printout:
[3445254.712361]  --- wd:2 rd:2
[3445254.712364]  disk 0, wo:0, o:1, dev:sda2
[3445254.712367]  disk 1, wo:0, o:1, dev:sdb2
[3880879.007618] end_request: I/O error, dev sda, sector 3907028974
[3880879.007839] md: super_written gets error=-5, uptodate=0
[3880879.007842] raid1: Disk failure on sda2, disabling device.
[3880879.007843] raid1: Operation continuing on 1 devices.
[3880879.028518] RAID1 conf printout:
[3880879.028521]  --- wd:1 rd:2
[3880879.028524]  disk 0, wo:1, o:0, dev:sda2
[3880879.028527]  disk 1, wo:0, o:1, dev:sdb2
[3880879.031607] RAID1 conf printout:
[3880879.031610]  --- wd:1 rd:2
[3880879.031613]  disk 1, wo:0, o:1, dev:sdb2
[3885338.980679] md: cannot remove active disk sdb2 from md0 ...
[3885363.182774] md: unbind<sda2>
[3885363.189328] md: export_rdev(sda2)
[3885363.605459] md: bind<sda2>
[3885363.654632] RAID1 conf printout:
[3885363.654635]  --- wd:1 rd:2
[3885363.654638]  disk 0, wo:1, o:1, dev:sda2
[3885363.654641]  disk 1, wo:0, o:1, dev:sdb2
[3885363.654681] md: recovery of RAID array md0
[3885363.654683] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[3885363.654685] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[3885363.654689] md: using 128k window, over a total of 1953504704 blocks.
[3921168.923151] md: md0: recovery done.
[3921169.040914] RAID1 conf printout:
[3921169.040917]  --- wd:2 rd:2
[3921169.040920]  disk 0, wo:0, o:1, dev:sda2
[3921169.040923]  disk 1, wo:0, o:1, dev:sdb2
[3964586.721298] sd 4:0:0:0: [sda] Sense Key : Recovered Error [current] [descriptor]
[3964586.721304] Descriptor sense data with sense descriptors (in hex):
[3964586.721307]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964586.721315]         00 00 00 00 00 00 
[3964586.721320] sd 4:0:0:0: [sda] Add. Sense: ATA pass through information available
[3964588.909481] sd 4:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
[3964588.909487] Descriptor sense data with sense descriptors (in hex):
[3964588.909489]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964588.909498]         00 00 00 00 00 00 
[3964588.909503] sd 4:0:1:0: [sdb] Add. Sense: ATA pass through information available
[3964616.782366] sd 4:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
[3964616.782372] Descriptor sense data with sense descriptors (in hex):
[3964616.782375]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964616.782384]         00 00 00 00 00 00 
[3964616.782388] sd 4:0:1:0: [sdb] Add. Sense: ATA pass through information available
[3964616.783355] sd 4:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
[3964616.783359] Descriptor sense data with sense descriptors (in hex):
[3964616.783361]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964616.783366]         00 00 00 00 40 50 
[3964616.783370] sd 4:0:1:0: [sdb] Add. Sense: ATA pass through information available
[3964616.786249] sd 4:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
[3964616.786254] Descriptor sense data with sense descriptors (in hex):
[3964616.786256]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964616.786265]         00 00 00 00 40 50 
[3964616.786269] sd 4:0:1:0: [sdb] Add. Sense: ATA pass through information available
[3964616.787231] sd 4:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
[3964616.787235] Descriptor sense data with sense descriptors (in hex):
[3964616.787236]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964616.787242]         00 00 00 00 40 50 
[3964616.787245] sd 4:0:1:0: [sdb] Add. Sense: ATA pass through information available
[3964616.792653] sd 4:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
[3964616.792659] Descriptor sense data with sense descriptors (in hex):
[3964616.792661]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964616.792669]         00 00 00 00 00 00 
[3964616.792674] sd 4:0:1:0: [sdb] Add. Sense: ATA pass through information available
[3964620.527486] sd 4:0:0:0: [sda] Sense Key : Recovered Error [current] [descriptor]
[3964620.527492] Descriptor sense data with sense descriptors (in hex):
[3964620.527495]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964620.527503]         00 00 00 00 00 00 
[3964620.527508] sd 4:0:0:0: [sda] Add. Sense: ATA pass through information available
[3964620.528493] sd 4:0:0:0: [sda] Sense Key : Recovered Error [current] [descriptor]
[3964620.528497] Descriptor sense data with sense descriptors (in hex):
[3964620.528498]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964620.528504]         00 00 00 00 40 50 
[3964620.528508] sd 4:0:0:0: [sda] Add. Sense: ATA pass through information available
[3964620.531094] sd 4:0:0:0: [sda] Sense Key : Recovered Error [current] [descriptor]
[3964620.531099] Descriptor sense data with sense descriptors (in hex):
[3964620.531102]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964620.531110]         00 00 00 00 40 50 
[3964620.531115] sd 4:0:0:0: [sda] Add. Sense: ATA pass through information available
[3964620.532075] sd 4:0:0:0: [sda] Sense Key : Recovered Error [current] [descriptor]
[3964620.532079] Descriptor sense data with sense descriptors (in hex):
[3964620.532080]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964620.532086]         00 00 00 00 40 50 
[3964620.532090] sd 4:0:0:0: [sda] Add. Sense: ATA pass through information available
[3964620.537480] sd 4:0:0:0: [sda] Sense Key : Recovered Error [current] [descriptor]
[3964620.537485] Descriptor sense data with sense descriptors (in hex):
[3964620.537487]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
[3964620.537495]         00 00 00 00 00 00 
[3964620.537500] sd 4:0:0:0: [sda] Add. Sense: ATA pass through information available


/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>

