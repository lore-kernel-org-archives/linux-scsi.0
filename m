From: Zoltan HERPAI <wigyori@uid0.hu>
Subject: Re: LSI 53c1030 speed issue
Date: Fri, 14 Jul 2006 00:04:18 +0200
Message-ID: <44B6C362.90209@uid0.hu>
References: <664A4EBB07F29743873A87CF62C26D701F6810@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postahivatal.bpcl.broadband.hu ([195.184.181.19]:13982 "EHLO
	postahivatal.bpcl.broadband.hu") by vger.kernel.org with ESMTP
	id S1030371AbWGMWEU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 18:04:20 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701F6810@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Moore, Eric wrote:
> Whats linux os and kernel verion is running on your desktop?
>   
2.6.17.1 unpatched.

> Did you create IR volume?
>   
No, I left the card unconfigured, since the VTrak does the RAID 
functions, it is seen from the HBA as a single drive. (Of course, the 8 
disk can be configured into two or more arrays, but that's not the case 
now.)

> Can you send dmesg boot log?
>   
You will find the complete dmesg below.

> Can you try with 2.6.17 kernel?  The -17 kernel is using spi transport
> layer,
> which is using generic domain validation.
>   
I will do a test tomorrow, thank you for your time.

Regards,
Zoltan HERPAI

---- CUT HERE ----
Jun 27 19:06:02 ivymike syslogd 1.4.1#17ubuntu7: restart.
Jun 27 19:06:02 ivymike kernel: Cannot find map file.
Jun 27 19:06:02 ivymike kernel: No module symbols loaded - kernel 
modules not enabled.
Jun 27 19:06:02 ivymike kernel: [    0.000000] Bootdata ok (command line 
is root=/dev/sda1 ro quiet splash)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Linux version 
2.6.16.16-grsec (root@ivymike) (gcc version 4.0.3 (Ubuntu 
4.0.3-1ubuntu5)) #1 SMP Tue Jun 27 19:01:53 CEST 2006
Jun 27 19:06:02 ivymike kernel: [    0.000000] BIOS-provided physical 
RAM map:
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
0000000000000000 - 000000000009dc00 (usable)
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
000000000009dc00 - 00000000000a0000 (reserved)
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
00000000000e0000 - 0000000000100000 (reserved)
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
0000000000100000 - 00000000f7ff0000 (usable)
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
00000000f7ff0000 - 00000000f7fff000 (ACPI data)
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
00000000f7fff000 - 00000000f8000000 (ACPI NVS)
Jun 27 19:06:02 ivymike kernel: [    0.000000]  BIOS-e820: 
00000000ffb00000 - 0000000100000000 (reserved)
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: PXM 0 -> APIC 0 -> 
Node 0
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: PXM 0 -> APIC 1 -> 
Node 0
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: PXM 1 -> APIC 2 -> 
Node 1
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: PXM 1 -> APIC 3 -> 
Node 1
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: Node 0 PXM 0 
100000-80000000
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: Node 1 PXM 1 
80000000-f8000000
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: Node 1 PXM 1 
80000000-100000000
Jun 27 19:06:02 ivymike kernel: [    0.000000] SRAT: Node 0 PXM 0 0-80000000
Jun 27 19:06:02 ivymike kernel: [    0.000000] Bootmem setup node 0 
0000000000000000-0000000080000000
Jun 27 19:06:02 ivymike kernel: [    0.000000] Bootmem setup node 1 
0000000080000000-00000000f7ff0000
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: PM-Timer IO Port: 
0x5008
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x01] lapic_id[0x00] enabled)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Processor #0 15:1 APIC 
version 16
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x02] lapic_id[0x01] enabled)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Processor #1 15:1 APIC 
version 16
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x03] lapic_id[0x02] enabled)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Processor #2 15:1 APIC 
version 16
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: LAPIC 
(acpi_id[0x04] lapic_id[0x03] enabled)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Processor #3 15:1 APIC 
version 16
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: IOAPIC (id[0x04] 
address[0xfec00000] gsi_base[0])
Jun 27 19:06:02 ivymike kernel: [    0.000000] IOAPIC[0]: apic_id 4, 
version 17, address 0xfec00000, GSI 0-23
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: IOAPIC (id[0x05] 
address[0xfdcff000] gsi_base[24])
Jun 27 19:06:02 ivymike kernel: [    0.000000] IOAPIC[1]: apic_id 5, 
version 17, address 0xfdcff000, GSI 24-27
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: IOAPIC (id[0x06] 
address[0xfdcfe000] gsi_base[28])
Jun 27 19:06:02 ivymike kernel: [    0.000000] IOAPIC[2]: apic_id 6, 
version 17, address 0xfdcfe000, GSI 28-31
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: IOAPIC (id[0x07] 
address[0xfe9ff000] gsi_base[32])
Jun 27 19:06:02 ivymike kernel: [    0.000000] IOAPIC[3]: apic_id 7, 
version 17, address 0xfe9ff000, GSI 32-35
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: IOAPIC (id[0x08] 
address[0xfe9fe000] gsi_base[36])
Jun 27 19:06:02 ivymike kernel: [    0.000000] IOAPIC[4]: apic_id 8, 
version 17, address 0xfe9fe000, GSI 36-39
Jun 27 19:06:02 ivymike kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 0 global_irq 2 dfl dfl)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Setting APIC routing to 
physical flat
Jun 27 19:06:02 ivymike kernel: [    0.000000] Using ACPI (MADT) for SMP 
configuration information
Jun 27 19:06:02 ivymike kernel: [    0.000000] Allocating PCI resources 
starting at f8800000 (gap: f8000000:7b00000)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Checking aperture...
Jun 27 19:06:02 ivymike kernel: [    0.000000] CPU 0: aperture @ 
c00000000 size 32 MB
Jun 27 19:06:02 ivymike kernel: [    0.000000] Aperture from northbridge 
cpu 0 too small (32 MB)
Jun 27 19:06:02 ivymike kernel: [    0.000000] No AGP bridge found
Jun 27 19:06:02 ivymike kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 
hotplug CPUs
Jun 27 19:06:02 ivymike kernel: [    0.000000] Built 2 zonelists
Jun 27 19:06:02 ivymike kernel: [    0.000000] Kernel command line: 
root=/dev/sda1 ro quiet splash
Jun 27 19:06:02 ivymike kernel: [    0.000000] Initializing CPU#0
Jun 27 19:06:02 ivymike kernel: [    0.000000] PID hash table entries: 
4096 (order: 12, 131072 bytes)
Jun 27 19:06:02 ivymike kernel: [    0.000000] Disabling vsyscall due to 
use of PM timer
Jun 27 19:06:02 ivymike kernel: [    0.000000] time.c: Using 3.579545 
MHz WALL PM GTOD PM timer.
Jun 27 19:06:02 ivymike kernel: [    0.000000] time.c: Detected 2193.783 
MHz processor.
Jun 27 19:06:02 ivymike kernel: [   86.326026] Console: colour VGA+ 80x25
Jun 27 19:06:02 ivymike kernel: [   86.329819] Dentry cache hash table 
entries: 524288 (order: 10, 4194304 bytes)
Jun 27 19:06:02 ivymike kernel: [   86.334636] Inode-cache hash table 
entries: 262144 (order: 9, 2097152 bytes)
Jun 27 19:06:02 ivymike kernel: [   86.365049] Memory: 3996320k/4063168k 
available (2504k kernel code, 66452k reserved, 778k data, 168k init)
Jun 27 19:06:02 ivymike kernel: [   86.444454] Calibrating delay using 
timer specific routine.. 4399.32 BogoMIPS (lpj=8798640)
Jun 27 19:06:02 ivymike kernel: [   86.444545] Mount-cache hash table 
entries: 256
Jun 27 19:06:02 ivymike kernel: [   86.444653] CPU: L1 I Cache: 64K (64 
bytes/line), D cache 64K (64 bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.444655] CPU: L2 Cache: 1024K (64 
bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.444658] CPU 0(2) -> Node 0 -> Core 0
Jun 27 19:06:02 ivymike kernel: [   86.487641] Using local APIC timer 
interrupts.
Jun 27 19:06:02 ivymike kernel: [   86.533151] result 12464698
Jun 27 19:06:02 ivymike kernel: [   86.533153] Detected 12.464 MHz APIC 
timer.
Jun 27 19:06:02 ivymike kernel: [   86.536541] Booting processor 1/4 
APIC 0x1
Jun 27 19:06:02 ivymike kernel: [   86.546841] Initializing CPU#1
Jun 27 19:06:02 ivymike kernel: [   86.624153] Calibrating delay using 
timer specific routine.. 4387.77 BogoMIPS (lpj=8775558)
Jun 27 19:06:02 ivymike kernel: [   86.624159] CPU: L1 I Cache: 64K (64 
bytes/line), D cache 64K (64 bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.624161] CPU: L2 Cache: 1024K (64 
bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.624163] CPU 1(2) -> Node 0 -> Core 1
Jun 27 19:06:02 ivymike kernel: [   86.624268] Dual Core AMD Opteron(tm) 
Processor 275 stepping 02
Jun 27 19:06:02 ivymike kernel: [   86.628153] CPU 1: Syncing TSC to CPU 0.
Jun 27 19:06:02 ivymike kernel: [   86.628250] CPU 1: synchronized TSC 
with CPU 0 (last diff -1 cycles, maxerr 592 cycles)
Jun 27 19:06:02 ivymike kernel: [   86.628442] Booting processor 2/4 
APIC 0x2
Jun 27 19:06:02 ivymike kernel: [   86.638747] Initializing CPU#2
Jun 27 19:06:02 ivymike kernel: [   86.716005] Calibrating delay using 
timer specific routine.. 4364.09 BogoMIPS (lpj=8728192)
Jun 27 19:06:02 ivymike kernel: [   86.716011] CPU: L1 I Cache: 64K (64 
bytes/line), D cache 64K (64 bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.716014] CPU: L2 Cache: 1024K (64 
bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.716016] CPU 2(2) -> Node 1 -> Core 0
Jun 27 19:06:02 ivymike kernel: [   86.716130] Dual Core AMD Opteron(tm) 
Processor 275 stepping 02
Jun 27 19:06:02 ivymike kernel: [   86.719999] CPU 2: Syncing TSC to CPU 0.
Jun 27 19:06:02 ivymike kernel: [   86.720174] CPU 2: synchronized TSC 
with CPU 0 (last diff 8 cycles, maxerr 1077 cycles)
Jun 27 19:06:02 ivymike kernel: [   86.720355] Booting processor 3/4 
APIC 0x3
Jun 27 19:06:02 ivymike kernel: [   86.730660] Initializing CPU#3
Jun 27 19:06:02 ivymike kernel: [   86.807862] Calibrating delay using 
timer specific routine.. 4388.08 BogoMIPS (lpj=8776163)
Jun 27 19:06:02 ivymike kernel: [   86.807869] CPU: L1 I Cache: 64K (64 
bytes/line), D cache 64K (64 bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.807871] CPU: L2 Cache: 1024K (64 
bytes/line)
Jun 27 19:06:02 ivymike kernel: [   86.807874] CPU 3(2) -> Node 1 -> Core 1
Jun 27 19:06:02 ivymike kernel: [   86.807988] Dual Core AMD Opteron(tm) 
Processor 275 stepping 02
Jun 27 19:06:02 ivymike kernel: [   86.811869] CPU 3: Syncing TSC to CPU 0.
Jun 27 19:06:02 ivymike kernel: [   86.812041] CPU 3: synchronized TSC 
with CPU 0 (last diff 142 cycles, maxerr 1086 cycles)
Jun 27 19:06:02 ivymike kernel: [   86.812046] Brought up 4 CPUs
Jun 27 19:06:02 ivymike kernel: [   86.812106] testing NMI watchdog ... OK.
Jun 27 19:06:02 ivymike kernel: [   87.205132] migration_cost=477,440
Jun 27 19:06:02 ivymike kernel: [   87.205562] DMI 2.3 present.
Jun 27 19:06:02 ivymike kernel: [   87.205660] NET: Registered protocol 
family 16
Jun 27 19:06:02 ivymike kernel: [   87.205683] ACPI: bus type pci registered
Jun 27 19:06:02 ivymike kernel: [   87.206016] PCI: Using configuration 
type 1
Jun 27 19:06:02 ivymike kernel: [   87.206690] ACPI: Subsystem revision 
20060127
Jun 27 19:06:02 ivymike kernel: [   87.211147] ACPI: Interpreter enabled
Jun 27 19:06:02 ivymike kernel: [   87.211149] ACPI: Using IOAPIC for 
interrupt routing
Jun 27 19:06:02 ivymike kernel: [   87.212068] ACPI: PCI Root Bridge 
[PCI0] (0000:00)
Jun 27 19:06:02 ivymike kernel: [   87.218872] ACPI: PCI Root Bridge 
[PCIB] (0000:04)
Jun 27 19:06:02 ivymike kernel: [   87.221002] ACPI: PCI Interrupt Link 
[LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Jun 27 19:06:02 ivymike kernel: [   87.221253] ACPI: PCI Interrupt Link 
[LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Jun 27 19:06:02 ivymike kernel: [   87.221503] ACPI: PCI Interrupt Link 
[LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Jun 27 19:06:02 ivymike kernel: [   87.221752] ACPI: PCI Interrupt Link 
[LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Jun 27 19:06:02 ivymike kernel: [   87.221832] Linux Plug and Play 
Support v0.97 (c) Adam Belay
Jun 27 19:06:02 ivymike kernel: [   87.221843] pnp: PnP ACPI init
Jun 27 19:06:02 ivymike kernel: [   87.225292] pnp: PnP ACPI: found 13 
devices
Jun 27 19:06:02 ivymike kernel: [   87.225455] SCSI subsystem initialized
Jun 27 19:06:02 ivymike kernel: [   87.225461] PCI: Using ACPI for IRQ 
routing
Jun 27 19:06:02 ivymike kernel: [   87.225464] PCI: If a device doesn't 
work, try "pci=routeirq".  If it helps, post a report
Jun 27 19:06:02 ivymike kernel: [   87.225596] PCI-DMA: Disabling IOMMU.
Jun 27 19:06:02 ivymike kernel: [   87.226255] pnp: 00:07: ioport range 
0x680-0x6ff has been reserved
Jun 27 19:06:02 ivymike kernel: [   87.226262] pnp: 00:0a: ioport range 
0xca0-0xcbf has been reserved
Jun 27 19:06:02 ivymike kernel: [   87.226265] pnp: 00:0a: ioport range 
0x4700-0x4700 has been reserved
Jun 27 19:06:02 ivymike kernel: [   87.226609] PCI: Bridge: 0000:00:01.0
Jun 27 19:06:02 ivymike kernel: [   87.226612]   IO window: 8000-8fff
Jun 27 19:06:02 ivymike kernel: [   87.226616]   MEM window: 
fb500000-fb5fffff
Jun 27 19:06:02 ivymike kernel: [   87.226619]   PREFETCH window: 
fdd00000-fddfffff
Jun 27 19:06:02 ivymike kernel: [   87.226623] PCI: Bridge: 0000:00:02.0
Jun 27 19:06:02 ivymike kernel: [   87.226625]   IO window: 9000-9fff
Jun 27 19:06:02 ivymike kernel: [   87.226629]   MEM window: 
fb600000-fbafffff
Jun 27 19:06:02 ivymike kernel: [   87.226632]   PREFETCH window: 
fde00000-fdefffff
Jun 27 19:06:02 ivymike kernel: [   87.226635] PCI: Bridge: 0000:00:06.0
Jun 27 19:06:02 ivymike kernel: [   87.226638]   IO window: a000-afff
Jun 27 19:06:02 ivymike kernel: [   87.226643]   MEM window: 
fbb00000-fdbfffff
Jun 27 19:06:02 ivymike kernel: [   87.226646]   PREFETCH window: disabled.
Jun 27 19:06:02 ivymike kernel: [   87.226672] PCI: Bridge: 0000:04:01.0
Jun 27 19:06:02 ivymike kernel: [   87.226673]   IO window: disabled.
Jun 27 19:06:02 ivymike kernel: [   87.226676]   MEM window: disabled.
Jun 27 19:06:02 ivymike kernel: [   87.226678]   PREFETCH window: disabled.
Jun 27 19:06:02 ivymike kernel: [   87.226682] PCI: Bridge: 0000:04:02.0
Jun 27 19:06:02 ivymike kernel: [   87.226684]   IO window: c000-cfff
Jun 27 19:06:02 ivymike kernel: [   87.226688]   MEM window: 
fe000000-fe8fffff
Jun 27 19:06:02 ivymike kernel: [   87.226691]   PREFETCH window: 
fea00000-feafffff
Jun 27 19:06:02 ivymike kernel: [   87.227615] IA32 emulation $Id: 
sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
Jun 27 19:06:02 ivymike kernel: [   87.229074] Total HugeTLB memory 
allocated, 0
Jun 27 19:06:02 ivymike kernel: [   87.229383] SGI XFS with large 
block/inode numbers, no debug enabled
Jun 27 19:06:02 ivymike kernel: [   87.229718] Initializing 
Cryptographic API
Jun 27 19:06:02 ivymike kernel: [   87.229722] io scheduler noop registered
Jun 27 19:06:02 ivymike kernel: [   87.229734] io scheduler deadline 
registered
Jun 27 19:06:02 ivymike kernel: [   87.229766] io scheduler cfq 
registered (default)
Jun 27 19:06:02 ivymike kernel: [   87.229770] PCI: MSI quirk detected. 
pci_msi_quirk set.
Jun 27 19:06:02 ivymike kernel: [   87.229774] PCI: MSI quirk detected. 
pci_msi_quirk set.
Jun 27 19:06:02 ivymike kernel: [   87.291224] PCI: MSI quirk detected. 
pci_msi_quirk set.
Jun 27 19:06:02 ivymike kernel: [   87.291230] PCI: MSI quirk detected. 
pci_msi_quirk set.
Jun 27 19:06:02 ivymike kernel: [   87.291493] ACPI: Power Button (FF) 
[PWRF]
Jun 27 19:06:02 ivymike kernel: [   87.291507] ACPI: Power Button (CM) 
[PWRB]
Jun 27 19:06:02 ivymike kernel: [   87.291785] ACPI: Processor [CPU1] 
(supports 8 throttling states)
Jun 27 19:06:02 ivymike kernel: [   87.312860] Real Time Clock Driver 
v1.12ac
Jun 27 19:06:02 ivymike kernel: [   87.312919] hpet_acpi_add: no address 
or irqs in _CRS
Jun 27 19:06:02 ivymike kernel: [   87.312962] Non-volatile memory 
driver v1.2
Jun 27 19:06:02 ivymike kernel: [   87.312978] hw_random: AMD768 system 
management I/O registers at 0x5000.
Jun 27 19:06:02 ivymike kernel: [   87.313013] hw_random hardware driver 
1.0.0 loaded
Jun 27 19:06:02 ivymike kernel: [   87.313052] Software Watchdog Timer: 
0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
Jun 27 19:06:02 ivymike kernel: [   87.313055] Linux agpgart interface 
v0.101 (c) Dave Jones
Jun 27 19:06:02 ivymike kernel: [   87.313177] PNP: PS/2 Controller 
[PNP0303:PS2K] at 0x60,0x64 irq 1
Jun 27 19:06:02 ivymike kernel: [   87.313179] PNP: PS/2 controller 
doesn't have AUX irq; using default 12
Jun 27 19:06:02 ivymike kernel: [   87.315392] serio: i8042 AUX port at 
0x60,0x64 irq 12
Jun 27 19:06:02 ivymike kernel: [   87.315560] serio: i8042 KBD port at 
0x60,0x64 irq 1
Jun 27 19:06:02 ivymike kernel: [   87.315569] Serial: 8250/16550 driver 
$Revision: 1.90 $ 4 ports, IRQ sharing disabled
Jun 27 19:06:02 ivymike kernel: [   87.315732] serial8250: ttyS0 at I/O 
0x3f8 (irq = 4) is a 16550A
Jun 27 19:06:02 ivymike kernel: [   87.316261] 00:06: ttyS0 at I/O 0x3f8 
(irq = 4) is a 16550A
Jun 27 19:06:02 ivymike kernel: [   87.316416] Intel(R) PRO/1000 Network 
Driver - version 6.3.9-k4-NAPI
Jun 27 19:06:02 ivymike kernel: [   87.316419] Copyright (c) 1999-2005 
Intel Corporation.
Jun 27 19:06:02 ivymike kernel: [   87.316475] GSI 16 sharing vector 
0xA9 and IRQ 16
Jun 27 19:06:02 ivymike kernel: [   87.316478] ACPI: PCI Interrupt 
0000:01:01.0[A] -> GSI 26 (level, low) -> IRQ 169
Jun 27 19:06:02 ivymike kernel: [   87.596296] e1000: 0000:01:01.0: 
e1000_probe: (PCI-X:100MHz:64-bit) 00:14:4f:28:30:50
Jun 27 19:06:02 ivymike kernel: [   87.635575] e1000: eth0: e1000_probe: 
Intel(R) PRO/1000 Network Connection
Jun 27 19:06:02 ivymike kernel: [   87.635586] GSI 17 sharing vector 
0xB1 and IRQ 17
Jun 27 19:06:02 ivymike kernel: [   87.635588] ACPI: PCI Interrupt 
0000:01:01.1[B] -> GSI 27 (level, low) -> IRQ 177
Jun 27 19:06:02 ivymike kernel: [   87.915741] e1000: 0000:01:01.1: 
e1000_probe: (PCI-X:100MHz:64-bit) 00:14:4f:28:30:51
Jun 27 19:06:02 ivymike kernel: [   87.955024] e1000: eth1: e1000_probe: 
Intel(R) PRO/1000 Network Connection
Jun 27 19:06:02 ivymike kernel: [   87.955035] GSI 18 sharing vector 
0xB9 and IRQ 18
Jun 27 19:06:02 ivymike kernel: [   87.955037] ACPI: PCI Interrupt 
0000:01:02.0[A] -> GSI 24 (level, low) -> IRQ 185
Jun 27 19:06:02 ivymike kernel: [   88.235224] e1000: 0000:01:02.0: 
e1000_probe: (PCI-X:100MHz:64-bit) 00:14:4f:28:30:56
Jun 27 19:06:02 ivymike kernel: [   88.274489] e1000: eth2: e1000_probe: 
Intel(R) PRO/1000 Network Connection
Jun 27 19:06:02 ivymike kernel: [   88.274500] GSI 19 sharing vector 
0xC1 and IRQ 19
Jun 27 19:06:02 ivymike kernel: [   88.274502] ACPI: PCI Interrupt 
0000:01:02.1[B] -> GSI 25 (level, low) -> IRQ 193
Jun 27 19:06:02 ivymike kernel: [   88.554640] e1000: 0000:01:02.1: 
e1000_probe: (PCI-X:100MHz:64-bit) 00:14:4f:28:30:57
Jun 27 19:06:02 ivymike kernel: [   88.593946] e1000: eth3: e1000_probe: 
Intel(R) PRO/1000 Network Connection
Jun 27 19:06:02 ivymike kernel: [   88.593998] e100: Intel(R) PRO/100 
Network Driver, 3.5.10-k2-NAPI
Jun 27 19:06:02 ivymike kernel: [   88.594000] e100: Copyright(c) 
1999-2005 Intel Corporation
Jun 27 19:06:02 ivymike kernel: [   88.594089] forcedeth.c: Reverse 
Engineered nForce ethernet driver. Version 0.49.
Jun 27 19:06:02 ivymike kernel: [   88.594202] tun: Universal TUN/TAP 
device driver, 1.6
Jun 27 19:06:02 ivymike kernel: [   88.594204] tun: (C) 1999-2004 Max 
Krasnyansky <maxk@qualcomm.com>
Jun 27 19:06:02 ivymike kernel: [   88.594243] netconsole: not 
configured, aborting
Jun 27 19:06:02 ivymike kernel: [   88.594245] Uniform Multi-Platform 
E-IDE driver Revision: 7.00alpha2
Jun 27 19:06:02 ivymike kernel: [   88.594248] ide: Assuming 33MHz 
system bus speed for PIO modes; override with idebus=xx
Jun 27 19:06:02 ivymike kernel: [   88.594273] AMD8111: IDE controller 
at PCI slot 0000:00:07.1
Jun 27 19:06:02 ivymike kernel: [   88.594281] AMD8111: chipset revision 3
Jun 27 19:06:02 ivymike kernel: [   88.594283] AMD8111: not 100%% native 
mode: will probe irqs later
Jun 27 19:06:02 ivymike kernel: [   88.594291] AMD8111: 0000:00:07.1 
(rev 03) UDMA133 controller
Jun 27 19:06:02 ivymike kernel: [   88.594298]     ide0: BM-DMA at 
0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
Jun 27 19:06:02 ivymike kernel: [   89.331751] hda: DV-28SL, ATAPI 
CD/DVD-ROM drive
Jun 27 19:06:02 ivymike kernel: [   89.672333] isa bounce pool size: 16 
pages
Jun 27 19:06:02 ivymike kernel: [   89.672342] ide0 at 0x1f0-0x1f7,0x3f6 
on irq 14
Jun 27 19:06:02 ivymike kernel: [   90.241761] hda: ATAPI 24X DVD-ROM 
drive, 256kB Cache, UDMA(33)
Jun 27 19:06:02 ivymike kernel: [   90.241766] Uniform CD-ROM driver 
Revision: 3.20
Jun 27 19:06:02 ivymike kernel: [   90.250065] megaraid cmm: 2.20.2.6 
(Release Date: Mon Mar 7 00:01:03 EST 2005)
Jun 27 19:06:02 ivymike kernel: [   90.250070] megasas: 00.00.02.04 Fri 
Feb 03 14:31:44 PST 2006
Jun 27 19:06:02 ivymike kernel: [   90.250154] Fusion MPT base driver 
3.03.07
Jun 27 19:06:02 ivymike kernel: [   90.250156] Copyright (c) 1999-2005 
LSI Logic Corporation
Jun 27 19:06:02 ivymike kernel: [   90.250160] Fusion MPT SAS Host 
driver 3.03.07
Jun 27 19:06:02 ivymike kernel: [   90.250205] GSI 20 sharing vector 
0xC9 and IRQ 20
Jun 27 19:06:02 ivymike kernel: [   90.250207] ACPI: PCI Interrupt 
0000:02:03.0[A] -> GSI 28 (level, low) -> IRQ 201
Jun 27 19:06:02 ivymike kernel: [   90.250223] mptbase: Initiating ioc0 
bringup
Jun 27 19:06:02 ivymike kernel: [   90.936945] ioc0: SAS1064: 
Capabilities={Initiator}
Jun 27 19:06:02 ivymike kernel: [   96.830310] scsi0 : ioc0: LSISAS1064, 
FwRev=01080100h, Ports=1, MaxQ=511, IRQ=201
Jun 27 19:06:02 ivymike kernel: [   96.848527]   Vendor: LSILOGIC  
Model: Logical Volume    Rev: 3000
Jun 27 19:06:02 ivymike kernel: [   96.848535]   Type:   
Direct-Access                      ANSI SCSI revision: 02
Jun 27 19:06:02 ivymike kernel: [   96.849021] SCSI device sda: 
142577664 512-byte hdwr sectors (73000 MB)
Jun 27 19:06:02 ivymike kernel: [   96.849293] sda: Write Protect is off
Jun 27 19:06:02 ivymike kernel: [   96.849764] SCSI device sda: drive 
cache: write through
Jun 27 19:06:02 ivymike kernel: [   96.850246] SCSI device sda: 
142577664 512-byte hdwr sectors (73000 MB)
Jun 27 19:06:02 ivymike kernel: [   96.850516] sda: Write Protect is off
Jun 27 19:06:02 ivymike kernel: [   96.850986] SCSI device sda: drive 
cache: write through
Jun 27 19:06:02 ivymike kernel: [   96.850990]  sda: sda1 sda2 sda3 sda4 
< sda5 sda6 sda7 sda8 >
Jun 27 19:06:02 ivymike kernel: [   96.880614] sd 0:4:2:0: Attached scsi 
disk sda
Jun 27 19:06:02 ivymike kernel: [   96.880781] ieee1394: raw1394: 
/dev/raw1394 device initialized
Jun 27 19:06:02 ivymike kernel: [   96.880883] mice: PS/2 mouse device 
common for all mice
Jun 27 19:06:02 ivymike kernel: [   96.880987] oprofile: using NMI 
interrupt.
Jun 27 19:06:02 ivymike kernel: [   96.881294] NET: Registered protocol 
family 2
Jun 27 19:06:02 ivymike kernel: [   96.927074] IP route cache hash table 
entries: 131072 (order: 8, 1048576 bytes)
Jun 27 19:06:02 ivymike kernel: [   96.927907] TCP established hash 
table entries: 262144 (order: 10, 4194304 bytes)
Jun 27 19:06:02 ivymike kernel: [   96.930609] TCP bind hash table 
entries: 65536 (order: 8, 1048576 bytes)
Jun 27 19:06:02 ivymike kernel: [   96.931070] TCP: Hash tables 
configured (established 262144 bind 65536)
Jun 27 19:06:02 ivymike kernel: [   96.931073] TCP reno registered
Jun 27 19:06:02 ivymike kernel: [   96.931122] TCP bic registered
Jun 27 19:06:02 ivymike kernel: [   96.931146] NET: Registered protocol 
family 1
Jun 27 19:06:02 ivymike kernel: [   96.931152] NET: Registered protocol 
family 17
Jun 27 19:06:02 ivymike kernel: [   96.931248] powernow-k8: Found 4 AMD 
Athlon 64 / Opteron processors (version 1.60.0)
Jun 27 19:06:02 ivymike kernel: [   96.931797] ACPI wakeup devices:
Jun 27 19:06:02 ivymike kernel: [   96.931799] PCI1 USB0 ETHR USB1
Jun 27 19:06:02 ivymike kernel: [   96.931803] ACPI: (supports S0 S1 S4 S5)
Jun 27 19:06:02 ivymike kernel: [   96.952293] kjournald starting.  
Commit interval 5 seconds
Jun 27 19:06:02 ivymike kernel: [   96.952303] EXT3-fs: mounted 
filesystem with ordered data mode.
Jun 27 19:06:02 ivymike kernel: [   96.952365] VFS: Mounted root (ext3 
filesystem) readonly.
Jun 27 19:06:02 ivymike kernel: [   96.952548] Freeing unused kernel 
memory: 168k freed
Jun 27 19:06:02 ivymike kernel: [   98.290423] e1000: eth1: 
e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
Jun 27 19:06:02 ivymike kernel: [   98.302592] e1000: eth0: 
e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
Jun 27 19:06:02 ivymike kernel: [   98.599673] usbcore: registered new 
driver usbfs
Jun 27 19:06:02 ivymike kernel: [   98.599948] usbcore: registered new 
driver hub
Jun 27 19:06:02 ivymike kernel: [   98.686802] Fusion MPT SPI Host 
driver 3.03.07
Jun 27 19:06:02 ivymike kernel: [   98.686844] GSI 21 sharing vector 
0xD1 and IRQ 21
Jun 27 19:06:02 ivymike kernel: [   98.686847] ACPI: PCI Interrupt 
0000:06:01.0[A] -> GSI 37 (level, low) -> IRQ 209
Jun 27 19:06:02 ivymike kernel: [   98.686868] mptbase: Initiating ioc1 
bringup
Jun 27 19:06:02 ivymike kernel: [   98.700361] GSI 22 sharing vector 
0xD9 and IRQ 22
Jun 27 19:06:02 ivymike kernel: [   98.700367] ACPI: PCI Interrupt 
0000:03:00.0[D] -> GSI 19 (level, low) -> IRQ 217
Jun 27 19:06:02 ivymike kernel: [   98.700726] ohci_hcd 0000:03:00.0: 
OHCI Host Controller
Jun 27 19:06:02 ivymike kernel: [   98.701024] ohci_hcd 0000:03:00.0: 
new USB bus registered, assigned bus number 1
Jun 27 19:06:02 ivymike kernel: [   98.701036] ohci_hcd 0000:03:00.0: 
irq 217, io mem 0xfdbfe000
Jun 27 19:06:02 ivymike kernel: [   98.761933] usb usb1: configuration 
#1 chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [   98.761955] hub 1-0:1.0: USB hub found
Jun 27 19:06:02 ivymike kernel: [   98.761965] hub 1-0:1.0: 3 ports detected
Jun 27 19:06:02 ivymike kernel: [   98.867716] ACPI: PCI Interrupt 
0000:03:00.1[D] -> GSI 19 (level, low) -> IRQ 217
Jun 27 19:06:02 ivymike kernel: [   98.867942] ohci_hcd 0000:03:00.1: 
OHCI Host Controller
Jun 27 19:06:02 ivymike kernel: [   98.867994] ohci_hcd 0000:03:00.1: 
new USB bus registered, assigned bus number 2
Jun 27 19:06:02 ivymike kernel: [   98.868001] ohci_hcd 0000:03:00.1: 
irq 217, io mem 0xfdbfd000
Jun 27 19:06:02 ivymike kernel: [   98.925661] usb usb2: configuration 
#1 chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [   98.925680] hub 2-0:1.0: USB hub found
Jun 27 19:06:02 ivymike kernel: [   98.925690] hub 2-0:1.0: 3 ports detected
Jun 27 19:06:02 ivymike kernel: [   99.123257] usb 1-1: new full speed 
USB device using ohci_hcd and address 2
Jun 27 19:06:02 ivymike kernel: [   99.151203] ioc1: 53C1030: 
Capabilities={Initiator}
Jun 27 19:06:02 ivymike kernel: [   99.298895] usb 1-1: configuration #1 
chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [   99.558522] usb 1-2: new full speed 
USB device using ohci_hcd and address 3
Jun 27 19:06:02 ivymike kernel: [   99.734093] usb 1-2: configuration #1 
chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [   99.993793] usb 1-3: new full speed 
USB device using ohci_hcd and address 4
Jun 27 19:06:02 ivymike kernel: [  100.169291] usb 1-3: configuration #1 
chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [  100.437053] usb 2-1: new full speed 
USB device using ohci_hcd and address 2
Jun 27 19:06:02 ivymike kernel: [  100.612500] usb 2-1: configuration #1 
chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [  100.876317] usb 2-2: new full speed 
USB device using ohci_hcd and address 3
Jun 27 19:06:02 ivymike kernel: [  101.051691] usb 2-2: configuration #1 
chosen from 1 choice
Jun 27 19:06:02 ivymike kernel: [  107.329489] scsi1 : ioc1: LSI53C1030, 
FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=209
Jun 27 19:06:02 ivymike kernel: [  111.307635]   Vendor: Promise   
Model: RAID Console      Rev: V0.0
Jun 27 19:06:02 ivymike kernel: [  111.307643]   Type:   
Processor                          ANSI SCSI revision: 04
Jun 27 19:06:02 ivymike kernel: [  111.308980]   Vendor: Promise   
Model:  3 Disk RAID5     Rev: V0.0
Jun 27 19:06:02 ivymike kernel: [  111.308987]   Type:   
Direct-Access                      ANSI SCSI revision: 04
Jun 27 19:06:02 ivymike kernel: [  111.309818] SCSI device sdb: 
972655872 512-byte hdwr sectors (498000 MB)
Jun 27 19:06:02 ivymike kernel: [  111.309949] sdb: Write Protect is off
Jun 27 19:06:02 ivymike kernel: [  111.310205] SCSI device sdb: drive 
cache: write through
Jun 27 19:06:02 ivymike kernel: [  111.310563] SCSI device sdb: 
972655872 512-byte hdwr sectors (498000 MB)
Jun 27 19:06:02 ivymike kernel: [  111.310678] sdb: Write Protect is off
Jun 27 19:06:02 ivymike kernel: [  111.310905] SCSI device sdb: drive 
cache: write through
Jun 27 19:06:02 ivymike kernel: [  111.310908]  sdb: sdb1
Jun 27 19:06:02 ivymike kernel: [  111.332909] sd 1:0:0:1: Attached scsi 
disk sdb
Jun 27 19:06:02 ivymike kernel: [  114.866501] usbcore: registered new 
driver usbserial
Jun 27 19:06:02 ivymike kernel: [  114.866505] 
drivers/usb/serial/usb-serial.c: USB Serial Driver core
Jun 27 19:06:02 ivymike kernel: [  114.877405] pl2303: Unknown symbol 
usb_serial_disconnect
Jun 27 19:06:02 ivymike kernel: [  114.877558] pl2303: Unknown symbol 
usb_serial_probe
Jun 27 19:06:02 ivymike kernel: [  114.877578] pl2303: Unknown symbol 
usb_serial_register
Jun 27 19:06:02 ivymike kernel: [  114.877597] pl2303: Unknown symbol 
usb_serial_deregister
Jun 27 19:06:02 ivymike kernel: [  114.879670] 
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
Jun 27 19:06:02 ivymike kernel: [  114.879682] pl2303 1-1:1.0: pl2303 
converter detected
Jun 27 19:06:02 ivymike kernel: [  114.879781] usb 1-1: pl2303 converter 
now attached to ttyUSB0
Jun 27 19:06:02 ivymike kernel: [  114.879791] pl2303 1-2:1.0: pl2303 
converter detected
Jun 27 19:06:02 ivymike kernel: [  114.879828] usb 1-2: pl2303 converter 
now attached to ttyUSB1
Jun 27 19:06:02 ivymike kernel: [  114.886236] input: American 
Megatrends Inc. Virtual Keyboard and Mouse as /class/input/input0
Jun 27 19:06:02 ivymike kernel: [  114.886256] input: USB HID v1.10 
Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on 
usb-0000:03:00.0-3
Jun 27 19:06:02 ivymike kernel: [  114.895202] input: American 
Megatrends Inc. Virtual Keyboard and Mouse as /class/input/input1
Jun 27 19:06:02 ivymike kernel: [  114.895215] input: USB HID v1.10 
Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on 
usb-0000:03:00.0-3
Jun 27 19:06:02 ivymike kernel: [  114.895225] usbcore: registered new 
driver usbhid
Jun 27 19:06:02 ivymike kernel: [  114.895227] 
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Jun 27 19:06:02 ivymike kernel: [  114.896917] usbcore: registered new 
driver pl2303
Jun 27 19:06:02 ivymike kernel: [  114.896922] 
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
Jun 27 19:06:02 ivymike kernel: [  114.910717] Initializing USB Mass 
Storage driver...
Jun 27 19:06:02 ivymike kernel: [  114.910797] scsi2 : SCSI emulation 
for USB Mass Storage devices
Jun 27 19:06:02 ivymike kernel: [  114.910881] scsi3 : SCSI emulation 
for USB Mass Storage devices
Jun 27 19:06:02 ivymike kernel: [  114.910923] usbcore: registered new 
driver usb-storage
Jun 27 19:06:02 ivymike kernel: [  114.910925] USB Mass Storage support 
registered.
Jun 27 19:06:02 ivymike kernel: [  115.381842] ipmi message handler 
version 38.0
Jun 27 19:06:02 ivymike kernel: [  115.382978] IPMI System Interface driver.
Jun 27 19:06:02 ivymike kernel: [  115.383041] ipmi_si: Found 
SMBIOS-specified state machine at I/O address 0xca2, slave address 0x20
Jun 27 19:06:02 ivymike kernel: [  115.518294]  IPMI kcs interface 
initialized
Jun 27 19:06:02 ivymike kernel: [  115.524590] ipmi device interface
Jun 27 19:06:02 ivymike kernel: [  115.603729] Adding 3903784k swap on 
/dev/sda2.  Priority:-1 extents:1 across:3903784k
Jun 27 19:06:02 ivymike kernel: [  115.676322] EXT3 FS on sda1, internal 
journal
Jun 27 19:06:02 ivymike kernel: [  115.795674] md: md driver 0.90.3 
MAX_MD_DEVS=256, MD_SB_DISKS=27
Jun 27 19:06:02 ivymike kernel: [  115.795677] md: bitmap version 4.39
Jun 27 19:06:02 ivymike kernel: [  116.297673] device-mapper: 
4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
Jun 27 19:06:02 ivymike kernel: [  116.842292] kjournald starting.  
Commit interval 5 seconds
Jun 27 19:06:02 ivymike kernel: [  116.852016] EXT3 FS on sda7, internal 
journal
Jun 27 19:06:02 ivymike kernel: [  116.852022] EXT3-fs: mounted 
filesystem with ordered data mode.
Jun 27 19:06:02 ivymike kernel: [  116.869282] kjournald starting.  
Commit interval 5 seconds
Jun 27 19:06:02 ivymike kernel: [  116.871931] EXT3 FS on sda6, internal 
journal
Jun 27 19:06:02 ivymike kernel: [  116.871934] EXT3-fs: mounted 
filesystem with ordered data mode.
Jun 27 19:06:02 ivymike kernel: [  116.888061] kjournald starting.  
Commit interval 5 seconds
Jun 27 19:06:02 ivymike kernel: [  116.895825] EXT3 FS on sda3, internal 
journal
Jun 27 19:06:02 ivymike kernel: [  116.895829] EXT3-fs: mounted 
filesystem with ordered data mode.
Jun 27 19:06:02 ivymike kernel: [  116.909640] kjournald starting.  
Commit interval 5 seconds
Jun 27 19:06:02 ivymike kernel: [  116.917458] EXT3 FS on sda5, internal 
journal
Jun 27 19:06:02 ivymike kernel: [  116.917461] EXT3-fs: mounted 
filesystem with ordered data mode.
Jun 27 19:06:02 ivymike kernel: [  116.933544] XFS mounting filesystem dm-0
Jun 27 19:06:02 ivymike kernel: [  119.912961]   Vendor: AMI       
Model: Virtual CDROM     Rev: 1.00
Jun 27 19:06:02 ivymike kernel: [  119.912969]   Type:   
CD-ROM                             ANSI SCSI revision: 00
Jun 27 19:06:02 ivymike kernel: [  119.940903]   Vendor: AMI       
Model: Virtual Floppy    Rev: 1.00
Jun 27 19:06:02 ivymike kernel: [  119.940910]   Type:   
Direct-Access                      ANSI SCSI revision: 00
Jun 27 19:06:02 ivymike kernel: [  121.236619] ip_tables: (C) 2000-2006 
Netfilter Core Team
Jun 27 19:06:03 ivymike kernel: [  121.417794] Netfilter messages via 
NETLINK v0.30.
Jun 27 19:06:03 ivymike kernel: [  121.425440] ip_conntrack version 2.4 
(8192 buckets, 65536 max) - 312 bytes per conntrack
Jun 27 19:06:05 ivymike kernel: [  123.678063] sd 3:0:0:0: Attached scsi 
removable disk sdc
Jun 27 19:06:58 ivymike kernel: [  176.280499] kjournald starting.  
Commit interval 5 seconds
Jun 27 19:06:58 ivymike kernel: [  176.281985] EXT3 FS on sdb1, internal 
journal
Jun 27 19:06:58 ivymike kernel: [  176.281992] EXT3-fs: mounted 
filesystem with ordered data mode.


