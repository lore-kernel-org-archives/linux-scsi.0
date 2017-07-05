From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 13:19:09 +0100
Message-ID: <8834e9d2-3018-ee8f-b40e-ccd8aecc367c@googlemail.com>
References: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
 <20170705073928.GA4076@linux-x5ow.site>
 <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
 <20170705084447.GD4076@linux-x5ow.site>
 <20170705084810.GE4076@linux-x5ow.site>
 <d92e31ed-db7f-aa4b-5dfd-3f6df4a49ea9@googlemail.com>
 <20170705115235.GF4076@linux-x5ow.site>
 <3790b5ad-c02f-6406-173b-f2a0563f642b@googlemail.com>
 <20170705120927.GG4076@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9F94B1BEA076B5BC21313E88"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37740 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdGEMVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:21:13 -0400
Received: by mail-wm0-f46.google.com with SMTP id i127so164857152wma.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:21:12 -0700 (PDT)
In-Reply-To: <20170705120927.GG4076@linux-x5ow.site>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------9F94B1BEA076B5BC21313E88
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On 05/07/17 13:09, Johannes Thumshirn wrote:
> On Wed, Jul 05, 2017 at 01:05:46PM +0100, Chris Clayton wrote:
>> Yes, I get:
>>
>> [chris:~/rpm/build]$ su -c "./nerotest /dev/sg0"
>> Password:
>> write: Invalid argument
>> FAIL
> 
> Awesome, thanks for confirming.
> 
You're welcome. I've attached a dmesg log with logging turned on when I ran "nerocmd --scanbus".
I set the logging level with "scsi_logging_level -s -T4" (i.e.had to add the -s argument to your suggested command.
Sorry, for the delay - had to build a new kernel with scsi logging enabled.

> I'll work on it locally now and hopefully send you something to test soon.
> 

I'm happy to test any patches you may propose.

Thanks,
	Chris
> Thanks,
> 	Johannes
> 

--------------9F94B1BEA076B5BC21313E88
Content-Type: text/x-log;
 name="neroscan.dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="neroscan.dmesg.log"

[    0.000000] Linux version 4.12.0 (chris@laptop) (gcc version 6.4.0 (GCC) ) #2 SMP PREEMPT Wed Jul 5 12:58:07 BST 2017
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.12.0 ro root=/dev/sda2 resume=/dev/sda6 rootfstype=ext4 net.ifnames=0
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000d7216fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7217000-0x00000000d721dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d721e000-0x00000000d7a0cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7a0d000-0x00000000d7ca1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d7ca2000-0x00000000db4dffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db4e0000-0x00000000db82dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000db82e000-0x00000000db88afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db88b000-0x00000000db9bcfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db9bd000-0x00000000dbffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dbfff000-0x00000000dbffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd000000-0x00000000df1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Notebook                         W65_67SZ                        /W65_67SZ                        , BIOS 1.03.05 02/26/2014
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7C00000000 write-back
[    0.000000]   1 base 0400000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   3 base 00DE000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00DD000000 mask 7FFF000000 uncachable
[    0.000000]   5 base 041FE00000 mask 7FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0xdd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdc000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd820-0x000fd82f] mapped at [ffff8800000fd820]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x01df9000, 0x01df9fff] PGTABLE
[    0.000000] BRK [0x01dfa000, 0x01dfafff] PGTABLE
[    0.000000] BRK [0x01dfb000, 0x01dfbfff] PGTABLE
[    0.000000] BRK [0x01dfc000, 0x01dfcfff] PGTABLE
[    0.000000] BRK [0x01dfd000, 0x01dfdfff] PGTABLE
[    0.000000] BRK [0x01dfe000, 0x01dfefff] PGTABLE
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DB993088 00008C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DB99FEA8 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DB9931A8 00CCFA (v02 ALASKA A M I    00000024 INTL 20091112)
[    0.000000] ACPI: FACS 0x00000000DB9BB080 000040
[    0.000000] ACPI: APIC 0x00000000DB99FFB8 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DB9A0050 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: ASF! 0x00000000DB9A0098 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: SSDT 0x00000000DB9A0140 000F92 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DB9A10D8 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DB9A1618 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x00000000DB9A20F0 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DB9A2130 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DB9A2168 000315 (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DB9A2480 001BFB (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DB9A4080 000EA8 (v01 SgRef  SgPeg    00001000 INTL 20091112)
[    0.000000] ACPI: DMAR 0x00000000DB9A4F28 000090 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000041fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000d7216fff]
[    0.000000]   node   0: [mem 0x00000000d721e000-0x00000000d7a0cfff]
[    0.000000]   node   0: [mem 0x00000000d7ca2000-0x00000000db4dffff]
[    0.000000]   node   0: [mem 0x00000000db82e000-0x00000000db88afff]
[    0.000000]   node   0: [mem 0x00000000dbfff000-0x00000000dbffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000041fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000041fdfffff]
[    0.000000] On node 0 totalpages: 4173886
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13963 pages used for memmap
[    0.000000]   DMA32 zone: 893602 pages, LIFO batch:31
[    0.000000]   Normal zone: 51192 pages used for memmap
[    0.000000]   Normal zone: 3276288 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at 0x00000000dd200000-0x00000000df1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7217000-0xd721dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7a0d000-0xd7ca1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb4e0000-0xdb82dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb88b000-0xdb9bcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb9bd000-0xdbffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc000000-0xdcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd000000-0xdf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 35 pages/cpu @ffff88041fa00000 s105560 r8192 d29608 u262144
[    0.000000] pcpu-alloc: s105560 r8192 d29608 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4108646
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.12.0 ro root=/dev/sda2 resume=/dev/sda6 rootfstype=ext4 net.ifnames=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Memory: 16327252K/16695544K available (6424K kernel code, 669K rwdata, 2192K rodata, 848K init, 404K bss, 368292K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:488 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2494.188 MHz processor
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.37 BogoMIPS (lpj=9976752)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20170303
[    0.010566] ACPI: 7 ACPI AML tables successfully acquired and loaded
[    0.010630] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.010682] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.010872] CPU: Physical Processor ID: 0
[    0.010919] CPU: Processor Core ID: 0
[    0.010967] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.011017] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.011071] mce: CPU supports 9 MCE banks
[    0.011123] CPU0: Thermal monitoring enabled (TM1)
[    0.011181] process: using mwait in idle threads
[    0.011230] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.011280] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.011427] Freeing SMP alternatives memory: 24K
[    0.012032] smpboot: Max logical packages: 2
[    0.012447] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053747] TSC deadline timer enabled
[    0.053748] smpboot: CPU0: Intel(R) Core(TM) i7-4710MQ CPU @ 2.50GHz (family: 0x6, model: 0x3c, stepping: 0x3)
[    0.068018] Performance Events: PEBS fmt2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
[    0.068109] ... version:                3
[    0.068155] ... bit width:              48
[    0.068202] ... generic registers:      4
[    0.068249] ... value mask:             0000ffffffffffff
[    0.068297] ... max period:             00007fffffffffff
[    0.068346] ... fixed-purpose events:   3
[    0.068393] ... event mask:             000000070000000f
[    0.092016] smp: Bringing up secondary CPUs ...
[    0.120018] x86: Booting SMP configuration:
[    0.120065] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.848011] smp: Brought up 1 node, 8 CPUs
[    0.848099] smpboot: Total of 8 processors activated (39912.82 BogoMIPS)
[    0.852025] sched_clock: Marking stable (852000000, 0)->(857489680, -5489680)
[    0.852281] devtmpfs: initialized
[    0.852410] PM: Registering ACPI NVS region [mem 0xd7217000-0xd721dfff] (28672 bytes)
[    0.852463] PM: Registering ACPI NVS region [mem 0xdb88b000-0xdb9bcfff] (1253376 bytes)
[    0.852553] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.852623] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.852741] NET: Registered protocol family 16
[    0.852876] cpuidle: using governor ladder
[    0.852947] cpuidle: using governor menu
[    0.852995] PCCT header not found.
[    0.853068] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.853121] ACPI: bus type PCI registered
[    0.853185] PCI: Using configuration type 1 for base access
[    0.853275] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.854562] ACPI: Added _OSI(Module Device)
[    0.854612] ACPI: Added _OSI(Processor Device)
[    0.854672] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.854722] ACPI: Added _OSI(Processor Aggregator Device)
[    0.854885] ACPI: Executed 1 blocks of module-level executable AML code
[    0.857785] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.858191] ACPI: Dynamic OEM Table Load:
[    0.858242] ACPI: SSDT 0xFFFF88040D088400 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.858532] ACPI: Dynamic OEM Table Load:
[    0.859383] ACPI: SSDT 0xFFFF88040D0C8000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.859735] ACPI: Dynamic OEM Table Load:
[    0.859785] ACPI: SSDT 0xFFFF88040D90B200 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.860689] ACPI : EC: EC started
[    0.860735] ACPI : EC: interrupt blocked
[    0.860982] ACPI: \_SB_.PCI0.LPCB.EC__: Used as first EC
[    0.861032] ACPI: \_SB_.PCI0.LPCB.EC__: GPE=0x17, EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.861085] ACPI: \_SB_.PCI0.LPCB.EC__: Used as boot DSDT EC to handle transactions
[    0.861138] ACPI: Interpreter enabled
[    0.861199] ACPI: (supports S0 S3 S4 S5)
[    0.861246] ACPI: Using IOAPIC for interrupt routing
[    0.861308] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.866121] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.866173] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.866303] acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
[    0.866491] PCI host bridge to bus 0000:00
[    0.866539] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.866591] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.866642] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.866695] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.866748] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.866801] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.866854] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.866906] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    0.866959] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.867012] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff window]
[    0.867065] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.867119] pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
[    0.867172] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.867195] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.867246] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.867315] pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
[    0.867322] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.867326] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.867329] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.867378] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.867382] pci 0000:00:03.0: reg 0x10: [mem 0xf7f14000-0xf7f17fff 64bit]
[    0.867453] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.867466] pci 0000:00:14.0: reg 0x10: [mem 0xf7f00000-0xf7f0ffff 64bit]
[    0.867516] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.867541] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.867608] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.867630] pci 0000:00:16.0: reg 0x10: [mem 0xf7f1e000-0xf7f1e00f 64bit]
[    0.867684] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.867734] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.867748] pci 0000:00:1a.0: reg 0x10: [mem 0xf7f1c000-0xf7f1c3ff]
[    0.867821] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.867857] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.867926] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.867937] pci 0000:00:1b.0: reg 0x10: [mem 0xf7f10000-0xf7f13fff 64bit]
[    0.867992] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.868023] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.868091] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.868142] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.868189] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.868257] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    0.868308] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.868353] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.868420] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.868472] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.868515] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.868582] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    0.868634] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.868683] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.868753] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.868768] pci 0000:00:1d.0: reg 0x10: [mem 0xf7f1b000-0xf7f1b3ff]
[    0.868839] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.868873] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.868941] pci 0000:00:1f.0: [8086:8c49] type 00 class 0x060100
[    0.869066] pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
[    0.869077] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.869082] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.869087] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.869093] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.869098] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.869104] pci 0000:00:1f.2: reg 0x24: [mem 0xf7f1a000-0xf7f1a7ff]
[    0.869132] pci 0000:00:1f.2: PME# supported from D3hot
[    0.869169] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.869181] pci 0000:00:1f.3: reg 0x10: [mem 0xf7f19000-0xf7f190ff 64bit]
[    0.869197] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.869259] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.869334] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.869426] pci 0000:03:00.0: [10ec:5229] type 00 class 0xff0000
[    0.869440] pci 0000:03:00.0: reg 0x10: [mem 0xf7e00000-0xf7e00fff]
[    0.869555] pci 0000:03:00.0: supports D1 D2
[    0.869555] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    0.869571] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.880041] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.880096] pci 0000:00:1c.1:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.880150] pci 0000:04:00.0: [8086:08b1] type 00 class 0x028000
[    0.880181] pci 0000:04:00.0: reg 0x10: [mem 0xf7d00000-0xf7d01fff 64bit]
[    0.880341] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.880363] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.892053] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.892108] pci 0000:00:1c.2:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.892153] pci 0000:05:00.0: [10ec:5289] type 00 class 0xff0000
[    0.892167] pci 0000:05:00.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff]
[    0.892292] pci 0000:05:00.0: supports D1 D2
[    0.892293] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.892313] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.892395] pci 0000:05:00.2: [10ec:8168] type 00 class 0x020000
[    0.892409] pci 0000:05:00.2: reg 0x10: [io  0xe000-0xe0ff]
[    0.892436] pci 0000:05:00.2: reg 0x18: [mem 0xf0004000-0xf0004fff 64bit pref]
[    0.892453] pci 0000:05:00.2: reg 0x20: [mem 0xf0000000-0xf0003fff 64bit pref]
[    0.892526] pci 0000:05:00.2: supports D1 D2
[    0.892527] pci 0000:05:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.892547] pci 0000:05:00.2: System wakeup disabled by ACPI
[    0.904061] pci 0000:00:1c.3: PCI bridge to [bus 05]
[    0.904114] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.904117] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.904121] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
[    0.904141] pci_bus 0000:00: on NUMA node 0
[    0.904627] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.904717] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.904804] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.904891] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.904977] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.905066] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.905155] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.905242] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.905463] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.905539] ACPI : EC: interrupt unblocked
[    0.905589] ACPI : EC: event unblocked
[    0.905647] ACPI: \_SB_.PCI0.LPCB.EC__: GPE=0x17, EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.905700] ACPI: \_SB_.PCI0.LPCB.EC__: Used as boot DSDT EC to handle transactions and events
[    0.905798] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.905849] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.905917] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.905966] vgaarb: loaded
[    0.906084] SCSI subsystem initialized
[    0.906134] libata version 3.00 loaded.
[    0.906135] ACPI: bus type USB registered
[    0.906190] usbcore: registered new interface driver usbfs
[    0.906242] usbcore: registered new interface driver hub
[    0.906302] usbcore: registered new device driver usb
[    0.906356] Linux video capture interface: v2.00
[    0.906422] Advanced Linux Sound Architecture Driver Initialized.
[    0.906473] PCI: Using ACPI for IRQ routing
[    0.906519] PCI: pci_cache_line_size set to 64 bytes
[    0.906566] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.906567] e820: reserve RAM buffer [mem 0xd7217000-0xd7ffffff]
[    0.906568] e820: reserve RAM buffer [mem 0xd7a0d000-0xd7ffffff]
[    0.906568] e820: reserve RAM buffer [mem 0xdb4e0000-0xdbffffff]
[    0.906569] e820: reserve RAM buffer [mem 0xdb88b000-0xdbffffff]
[    0.906570] e820: reserve RAM buffer [mem 0x41fe00000-0x41fffffff]
[    0.906611] Bluetooth: Core ver 2.22
[    0.906660] NET: Registered protocol family 31
[    0.906707] Bluetooth: HCI device and connection manager initialized
[    0.906758] Bluetooth: HCI socket layer initialized
[    0.906807] Bluetooth: L2CAP socket layer initialized
[    0.906858] Bluetooth: SCO socket layer initialized
[    0.906944] clocksource: Switched to clocksource hpet
[    0.907021] pnp: PnP ACPI init
[    0.907100] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.907153] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.907311] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.907362] system 00:01: [io  0xffff] has been reserved
[    0.907411] system 00:01: [io  0xffff] has been reserved
[    0.907460] system 00:01: [io  0xffff] has been reserved
[    0.907509] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    0.907560] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    0.907610] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    0.907660] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    0.907710] system 00:01: [io  0x1800-0x18fe] has been reserved
[    0.907760] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.907811] system 00:01: [io  0x3322-0x3323] has been reserved
[    0.907861] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.907871] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.907894] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.907945] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.907956] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.907997] pnp 00:05: Plug and Play ACPI device, IDs SYN1212 PNP0f13 (active)
[    0.908020] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.908085] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.908256] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.908308] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.908360] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.908411] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.908463] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.908514] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.908566] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.908618] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.908669] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.908721] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.908773] system 00:07: [mem 0xf7ffe000-0xf7ffefff] has been reserved
[    0.908824] system 00:07: [mem 0xf7fe0000-0xf7fe0fff] has been reserved
[    0.908876] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.908993] pnp: PnP ACPI: found 8 devices
[    0.914370] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.914461] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.914513] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.914569] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.914620] pci 0000:00:1c.1:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.914676] pci 0000:00:1c.2: PCI bridge to [bus 04]
[    0.914727] pci 0000:00:1c.2:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.914783] pci 0000:00:1c.3: PCI bridge to [bus 05]
[    0.914832] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.914885] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.914939] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
[    0.914999] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.915000] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.915000] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.915001] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff window]
[    0.915002] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff window]
[    0.915002] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff window]
[    0.915003] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff window]
[    0.915004] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff window]
[    0.915004] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff window]
[    0.915005] pci_bus 0000:00: resource 13 [mem 0xdf200000-0xfeafffff window]
[    0.915006] pci_bus 0000:03: resource 1 [mem 0xf7e00000-0xf7efffff]
[    0.915006] pci_bus 0000:04: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    0.915007] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    0.915008] pci_bus 0000:05: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.915008] pci_bus 0000:05: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
[    0.915061] NET: Registered protocol family 2
[    0.915177] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.915330] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.915468] TCP: Hash tables configured (established 131072 bind 65536)
[    0.915535] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.915611] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.915704] NET: Registered protocol family 1
[    0.915767] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.916120] PCI: CLS 64 bytes, default 64
[    0.916128] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.916180] software IO TLB [mem 0xd3217000-0xd7217000] (64MB) mapped at [ffff8800d3217000-ffff8800d7216fff]
[    0.916320] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360 ms ovfl timer
[    0.916374] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    0.916424] RAPL PMU: hw unit of domain package 2^-14 Joules
[    0.916474] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    0.916524] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    0.916943] workingset: timestamp_bits=62 max_order=22 bucket_order=0
[    0.917778] fuse init (API version 7.26)
[    0.918520] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.918574] io scheduler noop registered
[    0.918662] io scheduler cfq registered (default)
[    0.918712] io scheduler mq-deadline registered
[    0.919192] intel_idle: MWAIT substates: 0x42120
[    0.919193] intel_idle: v0.4.1 model 0x3C
[    0.919395] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.919446] ACPI: AC Adapter [AC] (on-line)
[    0.919530] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.919590] ACPI: Power Button [PWRB]
[    0.919664] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.919721] ACPI: Sleep Button [SLPB]
[    0.919799] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    0.919869] ACPI: Lid Switch [LID0]
[    0.919934] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.919989] ACPI: Power Button [PWRF]
[    0.920220] thermal LNXTHERM:00: registered as thermal_zone0
[    0.920272] ACPI: Thermal Zone [TZ0] (14 C)
[    0.920640] ACPI: Battery Slot [BAT0] (battery present)
[    0.922982] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.923153] Linux agpgart interface v0.103
[    0.923365] pmd_set_huge: Cannot satisfy [mem 0xf7800000-0xf7a00000] with a huge-page mapping due to MTRR override.
[    0.923473] [drm] Memory usable by graphics device = 2048M
[    0.923522] [drm] Replacing VGA console driver
[    0.924053] Console: switching to colour dummy device 80x25
[    0.929504] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.929507] [drm] Driver supports precise vblank timestamp query.
[    0.931769] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.956444] [drm] Initialized i915 1.6.0 20170403 for 0000:00:02.0 on minor 0
[    0.956549] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.956707] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    0.958024] ahci 0000:00:1f.2: version 3.0
[    0.958087] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.958111] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x25 impl SATA mode
[    0.958114] ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio slum part ems sxs apst 
[    0.979434] scsi host0: ahci
[    0.979550] scsi host1: ahci
[    0.979591] fbcon: inteldrmfb (fb0) is primary device
[    0.979694] scsi host2: ahci
[    0.979783] scsi host3: ahci
[    0.979879] scsi host4: ahci
[    0.979946] scsi host5: ahci
[    0.979967] ata1: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a100 irq 19
[    0.979967] ata2: DUMMY
[    0.979968] ata3: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a200 irq 19
[    0.979969] ata4: DUMMY
[    0.979969] ata5: DUMMY
[    0.979970] ata6: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a380 irq 19
[    0.979991] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.979994] ehci-pci: EHCI PCI platform driver
[    0.980102] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.980107] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.980117] ehci-pci 0000:00:1a.0: debug port 2
[    0.984024] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.984028] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7f1c000
[    0.998957] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.998981] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.998982] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.998982] usb usb1: Product: EHCI Host Controller
[    0.998983] usb usb1: Manufacturer: Linux 4.12.0 ehci_hcd
[    0.998984] usb usb1: SerialNumber: 0000:00:1a.0
[    0.999059] hub 1-0:1.0: USB hub found
[    0.999062] hub 1-0:1.0: 2 ports detected
[    0.999201] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.999204] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.999212] ehci-pci 0000:00:1d.0: debug port 2
[    1.003098] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.003103] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7f1b000
[    1.018956] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.018974] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.018975] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.018975] usb usb2: Product: EHCI Host Controller
[    1.018976] usb usb2: Manufacturer: Linux 4.12.0 ehci_hcd
[    1.018976] usb usb2: SerialNumber: 0000:00:1d.0
[    1.019050] hub 2-0:1.0: USB hub found
[    1.019053] hub 2-0:1.0: 2 ports detected
[    1.019121] uhci_hcd: USB Universal Host Controller Interface driver
[    1.019197] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.019200] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.020268] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    1.020271] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.020307] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.020307] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.020308] usb usb3: Product: xHCI Host Controller
[    1.020308] usb usb3: Manufacturer: Linux 4.12.0 xhci-hcd
[    1.020309] usb usb3: SerialNumber: 0000:00:14.0
[    1.020393] hub 3-0:1.0: USB hub found
[    1.020406] hub 3-0:1.0: 14 ports detected
[    1.021743] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.021745] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.021766] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.021766] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.021767] usb usb4: Product: xHCI Host Controller
[    1.021767] usb usb4: Manufacturer: Linux 4.12.0 xhci-hcd
[    1.021768] usb usb4: SerialNumber: 0000:00:14.0
[    1.021848] hub 4-0:1.0: USB hub found
[    1.021867] hub 4-0:1.0: 4 ports detected
[    1.022271] usbcore: registered new interface driver usb-storage
[    1.022274] usbcore: registered new interface driver ums-realtek
[    1.022288] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:SYNM] at 0x60,0x64 irq 1,12
[    1.026860] i8042: Detected active multiplexing controller, rev 1.1
[    1.028827] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.028840] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.028858] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.028865] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.028873] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.029008] mousedev: PS/2 mouse device common for all mice
[    1.029241] rtc_cmos 00:02: RTC can wake from S4
[    1.029331] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.029350] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.029356] i2c /dev entries driver
[    1.029509] i801_smbus 0000:00:1f.3: SPD Write Disable is set
[    1.029521] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    1.029986] usbcore: registered new interface driver uvcvideo
[    1.029987] USB Video Class driver (1.1.1)
[    1.029989] intel_pstate: Intel P-state driver initializing
[    1.030328] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.030329] NET: Registered protocol family 17
[    1.030332] NET: Registered protocol family 15
[    1.031483] microcode: sig=0x306c3, pf=0x10, revision=0x17
[    1.031625] microcode: Microcode Update Driver: v2.2.
[    1.031806] registered taskstats version 1
[    1.032099] rtc_cmos 00:02: setting system clock to 2017-07-05 12:06:55 UTC (1499256415)
[    1.033056] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    1.294437] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.296054] ata1.00: ATAPI: MATSHITABD-MLT UJ260AF, 1.00, max UDMA/133
[    1.297504] ata1.00: configured for UDMA/133
[    1.327025] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.347026] usb 3-7: new full-speed USB device number 2 using xhci_hcd
[    1.347034] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.475415] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    1.475417] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.475725] hub 1-1:1.0: USB hub found
[    1.475828] hub 1-1:1.0: 6 ports detected
[    1.488364] usb 3-7: New USB device found, idVendor=8087, idProduct=07dc
[    1.488366] usb 3-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.495407] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    1.495408] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.495836] hub 2-1:1.0: USB hub found
[    1.496056] hub 2-1:1.0: 8 ports detected
[    1.606993] usb 3-8: new high-speed USB device number 3 using xhci_hcd
[    1.817411] usb 3-8: New USB device found, idVendor=04f2, idProduct=b43b
[    1.817412] usb 3-8: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    1.817413] usb 3-8: Product: Chicony USB 2.0 Camera
[    1.817414] usb 3-8: Manufacturer: Chicony Electronics Co.,Ltd.
[    1.817415] usb 3-8: SerialNumber: 0x0001
[    1.821913] uvcvideo: Found UVC 1.00 device Chicony USB 2.0 Camera (04f2:b43b)
[    1.919033] tsc: Refined TSC clocksource calibration: 2494.224 MHz
[    1.919038] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x23f3e9a353a, max_idle_ns: 440795330815 ns
[    2.190321] Console: switching to colour frame buffer device 200x56
[    2.243490] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.245636] scsi 0:0:0:0: CD-ROM            MATSHITA BD-MLT UJ260AF   1.00 PQ: 0 ANSI: 5
[    2.269620] sr 0:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.270337] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.271077] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.271131] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.586503] ata3: SATA link down (SStatus 0 SControl 300)
[    2.901971] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.903891] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    2.903893] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    2.904606] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    2.906484] ata6.00: ATA-8: HGST HTS541010A9E680, JA0OA560, max UDMA/133
[    2.907242] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.909155] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    2.909156] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    2.909912] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    2.911788] ata6.00: configured for UDMA/133
[    2.912706] scsi 5:0:0:0: Direct-Access     ATA      HGST HTS541010A9 A560 PQ: 0 ANSI: 5
[    2.913616] sd 5:0:0:0: Attached scsi generic sg1 type 0
[    2.913752] sd 5:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
[    2.913754] sd 5:0:0:0: [sda] 4096-byte physical blocks
[    2.913785] sd 5:0:0:0: [sda] Write Protect is off
[    2.913786] sd 5:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.913829] sd 5:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.943146] clocksource: Switched to clocksource tsc
[    3.063872]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 >
[    3.065508] sd 5:0:0:0: [sda] Attached SCSI disk
[    3.083989] ALSA device list:
[    3.084787]   No soundcards found.
[    3.132681] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.133513] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    3.156358] random: fast init done
[    3.158024] devtmpfs: mounted
[    3.159277] Freeing unused kernel memory: 848K
[    3.159834] Write protecting the kernel read-only data: 12288k
[    3.160684] Freeing unused kernel memory: 1748K
[    3.163962] Freeing unused kernel memory: 1904K
[    3.165682] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    4.643687] microcode: updated to revision 0x22, date = 2017-01-27
[    4.872280] udevd[248]: starting version 3.2.2
[    5.296751] udevd[249]: starting eudev-3.2.2
[    5.621577] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.622217] r8169 0000:05:00.2: can't disable ASPM; OS doesn't have ASPM control
[    5.623469] r8169 0000:05:00.2 eth0: RTL8411 at 0xffffc9000001e000, 80:fa:5b:08:d0:3d, XID 08800800 IRQ 19
[    5.624105] r8169 0000:05:00.2 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.774913] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops 0xffffffff81870440)
[    5.888181] random: crng init done
[    6.045122] usbcore: registered new interface driver btusb
[    6.053725] snd_hda_codec_via hdaudioC1D0: autoconfig for VT1802: line_outs=1 (0x24/0x0/0x0/0x0/0x0) type:speaker
[    6.054516] snd_hda_codec_via hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    6.055179] snd_hda_codec_via hdaudioC1D0:    hp_outs=1 (0x25/0x0/0x0/0x0/0x0)
[    6.055833] snd_hda_codec_via hdaudioC1D0:    mono: mono_out=0x0
[    6.056480] snd_hda_codec_via hdaudioC1D0:    inputs:
[    6.056770] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    6.056837] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input11
[    6.056887] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input12
[    6.056931] input: HDA Intel HDMI HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:03.0/sound/card0/input13
[    6.056973] input: HDA Intel HDMI HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:03.0/sound/card0/input14
[    6.058005] Bluetooth: hci0: read Intel version: 3707100180012d0d27
[    6.058005] Bluetooth: hci0: Intel device is already patched. patch num: 27
[    6.061654] snd_hda_codec_via hdaudioC1D0:      Internal Mic=0x30
[    6.062273] snd_hda_codec_via hdaudioC1D0:      Mic=0x2b
[    6.068696] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
[    6.069454] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
[    9.097439] Adding 16777212k swap on /dev/sda6.  Priority:1 extents:1 across:16777212k 
[    9.128097] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.262541] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.766164] EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
[    9.821910] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
[    9.877959] EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
[    9.956201] EXT4-fs (sda12): mounted filesystem with ordered data mode. Opts: (null)
[   12.683356] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   12.938045] r8169 0000:05:00.2 eth0: link down
[   12.938046] r8169 0000:05:00.2 eth0: link down
[   14.584201] r8169 0000:05:00.2 eth0: link up
[   16.308103] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   16.308973] Bluetooth: BNEP filters: protocol multicast
[   16.309676] Bluetooth: BNEP socket layer initialized
[   82.313460] Bluetooth: RFCOMM TTY layer initialized
[   82.313464] Bluetooth: RFCOMM socket layer initialized
[   82.313467] Bluetooth: RFCOMM ver 1.11
[  101.583350] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  101.583354] Bluetooth: HIDP socket layer initialized
[  101.583741] hid-generic 0005:0A5C:0001.0001: unknown main item tag 0x0
[  101.583780] input: Bluetooth 3.0 mouse as /devices/pci0000:00/0000:00:14.0/usb3/3-7/3-7:1.0/bluetooth/hci0/hci0:256/0005:0A5C:0001.0001/input/input17
[  101.583861] hid-generic 0005:0A5C:0001.0001: input: BLUETOOTH HID v1.29 Mouse [Bluetooth 3.0 mouse] on 80:19:34:5a:67:51
[  183.858972] sr 0:0:0:0: [sg0] sg_open: flags=0x8802
[  183.858976] sr 0:0:0:0: [sg0] sg_add_sfp: sfp=0xffff880407f4c000
[  183.858979] sr 0:0:0:0: [sg0] sg_add_sfp: bufflen=32768, k_use_sg=1
[  183.858981] sr 0:0:0:0: [sg0] sg_ioctl: cmd=0x5382
[  183.858983] sr 0:0:0:0: [sg0] sg_ioctl: cmd=0x5386
[  183.859013] sr 0:0:0:0: [sg0] sg_ioctl: cmd=0x2203
[  183.859016] sr 0:0:0:0: [sg0] sg_release
[  183.859029] sd 5:0:0:0: [sg1] sg_open: flags=0x8802
[  183.859031] sd 5:0:0:0: [sg1] sg_add_sfp: sfp=0xffff880407f4c000
[  183.859033] sd 5:0:0:0: [sg1] sg_add_sfp: bufflen=32768, k_use_sg=1
[  183.859034] sd 5:0:0:0: [sg1] sg_ioctl: cmd=0x5382
[  183.859035] sd 5:0:0:0: [sg1] sg_ioctl: cmd=0x5386
[  183.859044] sd 5:0:0:0: [sg1] sg_ioctl: cmd=0x2203
[  183.859046] sd 5:0:0:0: [sg1] sg_release
[  183.919567] sr 0:0:0:0: [sg0] sg_open: flags=0x8002
[  183.919570] sr 0:0:0:0: [sg0] sg_add_sfp: sfp=0xffff88040c58c000
[  183.919574] sr 0:0:0:0: [sg0] sg_add_sfp: bufflen=32768, k_use_sg=1
[  183.919577] sr 0:0:0:0: [sg0] sg_ioctl: cmd=0x2275
[  183.919584] sr 0:0:0:0: [sg0] sg_ioctl: cmd=0x2201
[  183.919587] sr 0:0:0:0: [sg0] sg_write: count=42
[  183.919590] sr 0:0:0:0: [sg0] sg_release
[  183.919673] sd 5:0:0:0: [sg1] sg_open: flags=0x8002
[  183.919675] sd 5:0:0:0: [sg1] sg_add_sfp: sfp=0xffff88040c58e000
[  183.919677] sd 5:0:0:0: [sg1] sg_add_sfp: bufflen=32768, k_use_sg=1
[  183.919678] sd 5:0:0:0: [sg1] sg_ioctl: cmd=0x2275
[  183.919685] sd 5:0:0:0: [sg1] sg_ioctl: cmd=0x2201
[  183.919687] sd 5:0:0:0: [sg1] sg_write: count=42
[  183.919689] sd 5:0:0:0: [sg1] sg_release

--------------9F94B1BEA076B5BC21313E88--
