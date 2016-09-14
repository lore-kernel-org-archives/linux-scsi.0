From: Matthias Huber <hm10439@gmail.com>
Subject: Re: [vfio-users] aacraid / Adaptec 3805 - AAC: Host adapter dead -1
Date: Wed, 14 Sep 2016 10:19:58 +0200
Message-ID: <cbb849dd-fcc8-db60-4bad-de957260203d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32971 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbcINIUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 04:20:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id b187so1344861wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 01:20:02 -0700 (PDT)
Received: from ?IPv6:2001:a61:9a:b501:8c23:1159:b34b:48a2? ([2001:a61:9a:b501:8c23:1159:b34b:48a2])
        by smtp.googlemail.com with ESMTPSA id f123sm2891062wmf.11.2016.09.14.01.19.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Sep 2016 01:19:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

i am getting same Message with Adaptec 3405:

using Linux 4.7.3 from kernel.org


root@intel:~# lspci -nnvs 02:0e.0
02:0e.0 RAID bus controller [0104]: Adaptec AAC-RAID [9005:0285]
     Subsystem: Adaptec 3405 [9005:02bb]
     Flags: bus master, stepping, 66MHz, medium devsel, latency 32, IRQ 18
     Memory at f7800000 (64-bit, non-prefetchable) [size=2M]
     Expansion ROM at f7a00000 [disabled] [size=256K]
     Capabilities: [c0] Power Management version 2
     Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
     Capabilities: [e0] PCI-X non-bridge device
     Kernel driver in use: aacraid
     Kernel modules: aacraid


Sep 14 09:30:46 intel kernel: [    0.000000] Linux version 4.7.3 
(root@intel) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.2) 
) #1 SMP Wed Sep 7 16:08:54 CEST 2016
Sep 14 09:30:46 intel kernel: [    0.000000] Command line: 
BOOT_IMAGE=/boot/vmlinuz-4.7.3 
root=UUID=3662b4ed-92cc-476b-b7d2-871ee6c0a56f ro
Sep 14 09:30:46 intel kernel: [    0.000000] KERNEL supported cpus:
Sep 14 09:30:46 intel kernel: [    0.000000]   Intel GenuineIntel
Sep 14 09:30:46 intel kernel: [    0.000000]   AMD AuthenticAMD
Sep 14 09:30:46 intel kernel: [    0.000000]   Centaur CentaurHauls
Sep 14 09:30:46 intel kernel: [    0.000000] x86/fpu: xstate_offset[2]:  
576, xstate_sizes[2]:  256
Sep 14 09:30:46 intel kernel: [    0.000000] x86/fpu: Supporting XSAVE 
feature 0x001: 'x87 floating point registers'
Sep 14 09:30:46 intel kernel: [    0.000000] x86/fpu: Supporting XSAVE 
feature 0x002: 'SSE registers'
Sep 14 09:30:46 intel kernel: [    0.000000] x86/fpu: Supporting XSAVE 
feature 0x004: 'AVX registers'
Sep 14 09:30:46 intel kernel: [    0.000000] x86/fpu: Enabled xstate 
features 0x7, context size is 832 bytes, using 'standard' format.
Sep 14 09:30:46 intel kernel: [    0.000000] x86/fpu: Using 'eager' FPU 
context switches.
Sep 14 09:30:46 intel kernel: [    0.000000] e820: BIOS-provided 
physical RAM map:
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000000000000-0x000000000009a3ff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x000000000009a400-0x000000000009ffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000000e0000-0x00000000000fffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000000100000-0x000000001fffffff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000020000000-0x00000000201fffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000020200000-0x000000003fffffff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000040000000-0x00000000401fffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000040200000-0x00000000d9a1ffff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000d9a20000-0x00000000da296fff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000da297000-0x00000000da2a6fff] ACPI data
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000da2a7000-0x00000000da3b9fff] ACPI NVS
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000da3ba000-0x00000000da696fff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000da697000-0x00000000da697fff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000da698000-0x00000000da6dafff] ACPI NVS
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000da6db000-0x00000000daffffff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000db800000-0x00000000df9fffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000f8000000-0x00000000fbffffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fec00000-0x00000000fec00fff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fed00000-0x00000000fed03fff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fed1c000-0x00000000fed1ffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fee00000-0x00000000fee00fff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x00000000ff000000-0x00000000ffffffff] reserved
Sep 14 09:30:46 intel kernel: [    0.000000] BIOS-e820: [mem 
0x0000000100000000-0x000000021f5fffff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] NX (Execute Disable) 
protection: active
Sep 14 09:30:46 intel kernel: [    0.000000] SMBIOS 2.7 present.
Sep 14 09:30:46 intel kernel: [    0.000000] DMI: /DH77EB, BIOS 
EBH7710H.86A.0100.2013.0312.1351 03/12/2013
Sep 14 09:30:46 intel kernel: [    0.000000] e820: update [mem 
0x00000000-0x00000fff] usable ==> reserved
Sep 14 09:30:46 intel kernel: [    0.000000] e820: remove [mem 
0x000a0000-0x000fffff] usable
Sep 14 09:30:46 intel kernel: [    0.000000] e820: last_pfn = 0x21f600 
max_arch_pfn = 0x400000000
Sep 14 09:30:46 intel kernel: [    0.000000] MTRR default type: uncachable
Sep 14 09:30:46 intel kernel: [    0.000000] MTRR fixed ranges enabled:
Sep 14 09:30:46 intel kernel: [    0.000000]   00000-9FFFF write-back
Sep 14 09:30:46 intel kernel: [    0.000000]   A0000-BFFFF uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   C0000-D7FFF write-protect
Sep 14 09:30:46 intel kernel: [    0.000000]   D8000-E7FFF uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   E8000-FFFFF write-protect
Sep 14 09:30:46 intel kernel: [    0.000000] MTRR variable ranges enabled:
Sep 14 09:30:46 intel kernel: [    0.000000]   0 base 000000000 mask 
E00000000 write-back
Sep 14 09:30:46 intel kernel: [    0.000000]   1 base 200000000 mask 
FE0000000 write-back
Sep 14 09:30:46 intel kernel: [    0.000000]   2 base 0E0000000 mask 
FE0000000 uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   3 base 0DC000000 mask 
FFC000000 uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   4 base 0DB800000 mask 
FFF800000 uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   5 base 21F800000 mask 
FFF800000 uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   6 base 21F600000 mask 
FFFE00000 uncachable
Sep 14 09:30:46 intel kernel: [    0.000000]   7 disabled
Sep 14 09:30:46 intel kernel: [    0.000000]   8 disabled
Sep 14 09:30:46 intel kernel: [    0.000000]   9 disabled
Sep 14 09:30:46 intel kernel: [    0.000000] x86/PAT: Configuration 
[0-7]: WB  WC  UC- UC  WB  WC  UC- WT
Sep 14 09:30:46 intel kernel: [    0.000000] total RAM covered: 8110M
Sep 14 09:30:46 intel kernel: [    0.000000] Found optimal setting for 
mtrr clean up
Sep 14 09:30:46 intel kernel: [    0.000000]  gran_size: 64K chunk_size: 
128M     num_reg: 9      lose cover RAM: 0G
Sep 14 09:30:46 intel kernel: [    0.000000] e820: update [mem 
0xdb800000-0xffffffff] usable ==> reserved
Sep 14 09:30:46 intel kernel: [    0.000000] e820: last_pfn = 0xdb000 
max_arch_pfn = 0x400000000
Sep 14 09:30:46 intel kernel: [    0.000000] found SMP MP-table at [mem 
0x000fd780-0x000fd78f] mapped at [ffff8800000fd780]
Sep 14 09:30:46 intel kernel: [    0.000000] Scanning 1 areas for low 
memory corruption
Sep 14 09:30:46 intel kernel: [    0.000000] Base memory trampoline at 
[ffff880000094000] 94000 size 24576
Sep 14 09:30:46 intel kernel: [    0.000000] reserving inaccessible SNB 
gfx pages
Sep 14 09:30:46 intel kernel: [    0.000000] BRK [0x02226000, 
0x02226fff] PGTABLE
Sep 14 09:30:46 intel kernel: [    0.000000] BRK [0x02227000, 
0x02227fff] PGTABLE
Sep 14 09:30:46 intel kernel: [    0.000000] BRK [0x02228000, 
0x02228fff] PGTABLE
Sep 14 09:30:46 intel kernel: [    0.000000] BRK [0x02229000, 
0x02229fff] PGTABLE
Sep 14 09:30:46 intel kernel: [    0.000000] BRK [0x0222a000, 
0x0222afff] PGTABLE
Sep 14 09:30:46 intel kernel: [    0.000000] BRK [0x0222b000, 
0x0222bfff] PGTABLE
Sep 14 09:30:46 intel kernel: [    0.000000] RAMDISK: [mem 
0x0d4e6000-0x1fffefff]
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: Early table checksum 
verification disabled
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: RSDP 
0x00000000000F0490 000024 (v02 INTEL )
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: XSDT 
0x00000000DA29B070 000064 (v01 INTEL  DH77EB   00000064 AMI 00010013)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: FACP 
0x00000000DA2A5158 00010C (v05 INTEL  DH77EB   00000064 AMI 00010013)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: DSDT 
0x00000000DA29B168 009FE9 (v02 INTEL  DH77EB   00000100 INTL 20051117)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: FACS 
0x00000000DA3B8080 000040
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: APIC 
0x00000000DA2A5268 000072 (v03 INTEL  DH77EB   00000064 AMI 00010013)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: FPDT 
0x00000000DA2A52E0 000044 (v01 INTEL  DH77EB   00000064 AMI 00010013)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: MCFG 
0x00000000DA2A5328 00003C (v01 INTEL  DH77EB   00000064 MSFT 00000097)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: HPET 
0x00000000DA2A5368 000038 (v01 INTEL  DH77EB   00000064 AMI. 00000005)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: SSDT 
0x00000000DA2A53A0 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: SSDT 
0x00000000DA2A5710 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: SSDT 
0x00000000DA2A60C0 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Sep 14 09:30:46 intel kernel: [    0.000000] No NUMA configuration found
Sep 14 09:30:46 intel kernel: [    0.000000] Faking a node at [mem 
0x0000000000000000-0x000000021f5fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] NODE_DATA(0) allocated [mem 
0x21f5f4000-0x21f5f8fff]
Sep 14 09:30:46 intel kernel: [    0.000000] Zone ranges:
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA      [mem 
0x0000000000001000-0x0000000000ffffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA32    [mem 
0x0000000001000000-0x00000000ffffffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   Normal   [mem 
0x0000000100000000-0x000000021f5fffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   Device   empty
Sep 14 09:30:46 intel kernel: [    0.000000] Movable zone start for each 
node
Sep 14 09:30:46 intel kernel: [    0.000000] Early memory node ranges
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x0000000000001000-0x0000000000099fff]
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x0000000000100000-0x000000001fffffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x0000000020200000-0x000000003fffffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x0000000040200000-0x00000000d9a1ffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x00000000da697000-0x00000000da697fff]
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x00000000da6db000-0x00000000daffffff]
Sep 14 09:30:46 intel kernel: [    0.000000]   node   0: [mem 
0x0000000100000000-0x000000021f5fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] Initmem setup node 0 [mem 
0x0000000000001000-0x000000021f5fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] On node 0 totalpages: 2069727
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA zone: 64 pages used 
for memmap
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA zone: 153 pages reserved
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA zone: 3993 pages, 
LIFO batch:0
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA32 zone: 13886 pages 
used for memmap
Sep 14 09:30:46 intel kernel: [    0.000000]   DMA32 zone: 888646 pages, 
LIFO batch:31
Sep 14 09:30:46 intel kernel: [    0.000000]   Normal zone: 18392 pages 
used for memmap
Sep 14 09:30:46 intel kernel: [    0.000000]   Normal zone: 1177088 
pages, LIFO batch:31
Sep 14 09:30:46 intel kernel: [    0.000000] Reserving Intel graphics 
stolen memory at 0xdba00000-0xdf9fffff
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0xff] high edge lint[0x1])
Sep 14 09:30:46 intel kernel: [    0.000000] IOAPIC[0]: apic_id 2, 
version 32, address 0xfec00000, GSI 0-23
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 0 global_irq 2 dfl dfl)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 9 global_irq 9 high level)
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: IRQ0 used by override.
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: IRQ9 used by override.
Sep 14 09:30:46 intel kernel: [    0.000000] Using ACPI (MADT) for SMP 
configuration information
Sep 14 09:30:46 intel kernel: [    0.000000] ACPI: HPET id: 0x8086a701 
base: 0xfed00000
Sep 14 09:30:46 intel kernel: [    0.000000] smpboot: Allowing 4 CPUs, 0 
hotplug CPUs
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x00000000-0x00000fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x0009a000-0x0009afff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x0009b000-0x0009ffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x000a0000-0x000dffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x000e0000-0x000fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x20000000-0x201fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0x40000000-0x401fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xd9a20000-0xda296fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xda297000-0xda2a6fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xda2a7000-0xda3b9fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xda3ba000-0xda696fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xda698000-0xda6dafff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xdb000000-0xdb7fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xdb800000-0xdf9fffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xdfa00000-0xf7ffffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xf8000000-0xfbffffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfc000000-0xfebfffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfec00000-0xfec00fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfec01000-0xfecfffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed00000-0xfed03fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed04000-0xfed1bfff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed1c000-0xfed1ffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfed20000-0xfedfffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfee00000-0xfee00fff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xfee01000-0xfeffffff]
Sep 14 09:30:46 intel kernel: [    0.000000] PM: Registered nosave 
memory: [mem 0xff000000-0xffffffff]
Sep 14 09:30:46 intel kernel: [    0.000000] e820: [mem 
0xdfa00000-0xf7ffffff] available for PCI devices
Sep 14 09:30:46 intel kernel: [    0.000000] Booting paravirtualized 
kernel on bare hardware
Sep 14 09:30:46 intel kernel: [    0.000000] clocksource: 
refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 
7645519600211568 ns
Sep 14 09:30:46 intel kernel: [    0.000000] setup_percpu: NR_CPUS:256 
nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
Sep 14 09:30:46 intel kernel: [    0.000000] percpu: Embedded 35 
pages/cpu @ffff88021f200000 s102424 r8192 d32744 u524288
Sep 14 09:30:46 intel kernel: [    0.000000] pcpu-alloc: s102424 r8192 
d32744 u524288 alloc=1*2097152
Sep 14 09:30:46 intel kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
Sep 14 09:30:46 intel kernel: [    0.000000] Built 1 zonelists in Node 
order, mobility grouping on.  Total pages: 2037232
Sep 14 09:30:46 intel kernel: [    0.000000] Policy zone: Normal
Sep 14 09:30:46 intel kernel: [    0.000000] Kernel command line: 
BOOT_IMAGE=/boot/vmlinuz-4.7.3 
root=UUID=3662b4ed-92cc-476b-b7d2-871ee6c0a56f ro
Sep 14 09:30:46 intel kernel: [    0.000000] PID hash table entries: 
4096 (order: 3, 32768 bytes)
Sep 14 09:30:46 intel kernel: [    0.000000] Calgary: detecting Calgary 
via BIOS EBDA area
Sep 14 09:30:46 intel kernel: [    0.000000] Calgary: Unable to locate 
Rio Grande table in EBDA - bailing!
Sep 14 09:30:46 intel kernel: [    0.000000] Memory: 7755428K/8278908K 
available (8525K kernel code, 1291K rwdata, 3748K rodata, 1520K init, 
1392K bss, 523480K reserved, 0K cma-reserved)
Sep 14 09:30:46 intel kernel: [    0.000000] SLUB: HWalign=64, 
Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Sep 14 09:30:46 intel kernel: [    0.000000] Hierarchical RCU 
implementation.
Sep 14 09:30:46 intel kernel: [    0.000000]     Build-time adjustment 
of leaf fanout to 64.
Sep 14 09:30:46 intel kernel: [    0.000000]     RCU restricting CPUs 
from NR_CPUS=256 to nr_cpu_ids=4.
Sep 14 09:30:46 intel kernel: [    0.000000] RCU: Adjusting geometry for 
rcu_fanout_leaf=64, nr_cpu_ids=4
Sep 14 09:30:46 intel kernel: [    0.000000] NR_IRQS:16640 nr_irqs:456 16
Sep 14 09:30:46 intel kernel: [    0.000000] Console: colour dummy 
device 80x25
Sep 14 09:30:46 intel kernel: [    0.000000] console [tty0] enabled
Sep 14 09:30:46 intel kernel: [    0.000000] clocksource: hpet: mask: 
0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
Sep 14 09:30:46 intel kernel: [    0.000000] hpet clockevent registered
Sep 14 09:30:46 intel kernel: [    0.000000] tsc: Fast TSC calibration 
using PIT
Sep 14 09:30:46 intel kernel: [    0.000000] tsc: Detected 3300.130 MHz 
processor
Sep 14 09:30:46 intel kernel: [    0.000021] Calibrating delay loop 
(skipped), value calculated using timer frequency.. 6600.26 BogoMIPS 
(lpj=13200520)
Sep 14 09:30:46 intel kernel: [    0.000027] pid_max: default: 32768 
minimum: 301
Sep 14 09:30:46 intel kernel: [    0.000033] ACPI: Core revision 20160422
Sep 14 09:30:46 intel kernel: [    0.005102] ACPI: 4 ACPI AML tables 
successfully acquired and loaded
Sep 14 09:30:46 intel kernel: [    0.005106]
Sep 14 09:30:46 intel kernel: [    0.005122] Security Framework initialized
Sep 14 09:30:46 intel kernel: [    0.005125] Yama: becoming mindful.
Sep 14 09:30:46 intel kernel: [    0.005134] AppArmor: AppArmor initialized
Sep 14 09:30:46 intel kernel: [    0.005492] Dentry cache hash table 
entries: 1048576 (order: 11, 8388608 bytes)
Sep 14 09:30:46 intel kernel: [    0.006752] Inode-cache hash table 
entries: 524288 (order: 10, 4194304 bytes)
Sep 14 09:30:46 intel kernel: [    0.007330] Mount-cache hash table 
entries: 16384 (order: 5, 131072 bytes)
Sep 14 09:30:46 intel kernel: [    0.007342] Mountpoint-cache hash table 
entries: 16384 (order: 5, 131072 bytes)
Sep 14 09:30:46 intel kernel: [    0.007547] CPU: Physical Processor ID: 0
Sep 14 09:30:46 intel kernel: [    0.007550] CPU: Processor Core ID: 0
Sep 14 09:30:46 intel kernel: [    0.007555] ENERGY_PERF_BIAS: Set to 
'normal', was 'performance'
Sep 14 09:30:46 intel kernel: [    0.007558] ENERGY_PERF_BIAS: View and 
update with x86_energy_perf_policy(8)
Sep 14 09:30:46 intel kernel: [    0.007562] mce: CPU supports 7 MCE banks
Sep 14 09:30:46 intel kernel: [    0.007570] CPU0: Thermal monitoring 
enabled (TM1)
Sep 14 09:30:46 intel kernel: [    0.007581] process: using mwait in 
idle threads
Sep 14 09:30:46 intel kernel: [    0.007585] Last level iTLB entries: 
4KB 512, 2MB 8, 4MB 8
Sep 14 09:30:46 intel kernel: [    0.007588] Last level dTLB entries: 
4KB 512, 2MB 32, 4MB 32, 1GB 0
Sep 14 09:30:46 intel kernel: [    0.007933] Freeing SMP alternatives 
memory: 32K (ffffffff820c0000 - ffffffff820c8000)
Sep 14 09:30:46 intel kernel: [    0.010832] ftrace: allocating 32416 
entries in 127 pages
Sep 14 09:30:46 intel kernel: [    0.022959] smpboot: Max logical 
packages: 2
Sep 14 09:30:46 intel kernel: [    0.022965] smpboot: APIC(0) Converting 
physical 0 to logical package 0
Sep 14 09:30:46 intel kernel: [    0.023372] ..TIMER: vector=0x30 
apic1=0 pin1=2 apic2=-1 pin2=-1
Sep 14 09:30:46 intel kernel: [    0.063061] TSC deadline timer enabled
Sep 14 09:30:46 intel kernel: [    0.063064] smpboot: CPU0: Intel(R) 
Core(TM) i3-2120 CPU @ 3.30GHz (family: 0x6, model: 0x2a, stepping: 0x7)
Sep 14 09:30:46 intel kernel: [    0.063071] Performance Events: PEBS 
fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU 
driver.
Sep 14 09:30:46 intel kernel: [    0.063095] ... version:                3
Sep 14 09:30:46 intel kernel: [    0.063098] ... bit width:              48
Sep 14 09:30:46 intel kernel: [    0.063100] ... generic registers:      4
Sep 14 09:30:46 intel kernel: [    0.063102] ... value mask:             
0000ffffffffffff
Sep 14 09:30:46 intel kernel: [    0.063105] ... max period:             
0000ffffffffffff
Sep 14 09:30:46 intel kernel: [    0.063108] ... fixed-purpose events:   3
Sep 14 09:30:46 intel kernel: [    0.063110] ... event mask:             
000000070000000f
Sep 14 09:30:46 intel kernel: [    0.063662] NMI watchdog: enabled on 
all CPUs, permanently consumes one hw-PMU counter.
Sep 14 09:30:46 intel kernel: [    0.063732] x86: Booting SMP configuration:
Sep 14 09:30:46 intel kernel: [    0.063735] .... node  #0, CPUs:      
#1 #2 #3
Sep 14 09:30:46 intel kernel: [    0.305172] x86: Booted up 1 node, 4 CPUs
Sep 14 09:30:46 intel kernel: [    0.305181] smpboot: Total of 4 
processors activated (26404.45 BogoMIPS)
Sep 14 09:30:46 intel kernel: [    0.307884] devtmpfs: initialized
Sep 14 09:30:46 intel kernel: [    0.307938] x86/mm: Memory block size: 
128MB
Sep 14 09:30:46 intel kernel: [    0.309842] evm: security.selinux
Sep 14 09:30:46 intel kernel: [    0.309844] evm: security.SMACK64
Sep 14 09:30:46 intel kernel: [    0.309847] evm: security.SMACK64EXEC
Sep 14 09:30:46 intel kernel: [    0.309849] evm: security.SMACK64TRANSMUTE
Sep 14 09:30:46 intel kernel: [    0.309851] evm: security.SMACK64MMAP
Sep 14 09:30:46 intel kernel: [    0.309854] evm: security.ima
Sep 14 09:30:46 intel kernel: [    0.309856] evm: security.capability
Sep 14 09:30:46 intel kernel: [    0.309892] PM: Registering ACPI NVS 
region [mem 0xda2a7000-0xda3b9fff] (1126400 bytes)
Sep 14 09:30:46 intel kernel: [    0.309906] PM: Registering ACPI NVS 
region [mem 0xda698000-0xda6dafff] (274432 bytes)
Sep 14 09:30:46 intel kernel: [    0.309953] clocksource: jiffies: mask: 
0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
Sep 14 09:30:46 intel kernel: [    0.309982] pinctrl core: initialized 
pinctrl subsystem
Sep 14 09:30:46 intel kernel: [    0.310068] RTC time:  7:30:28, date: 
09/14/16
Sep 14 09:30:46 intel kernel: [    0.310144] NET: Registered protocol 
family 16
Sep 14 09:30:46 intel kernel: [    0.319599] cpuidle: using governor ladder
Sep 14 09:30:46 intel kernel: [    0.325149] cpuidle: using governor menu
Sep 14 09:30:46 intel kernel: [    0.325156] PCCT header not found.
Sep 14 09:30:46 intel kernel: [    0.325218] ACPI FADT declares the 
system doesn't support PCIe ASPM, so disable it
Sep 14 09:30:46 intel kernel: [    0.325223] ACPI: bus type PCI registered
Sep 14 09:30:46 intel kernel: [    0.325226] acpiphp: ACPI Hot Plug PCI 
Controller Driver version: 0.5
Sep 14 09:30:46 intel kernel: [    0.325280] PCI: MMCONFIG for domain 
0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Sep 14 09:30:46 intel kernel: [    0.325285] PCI: MMCONFIG at [mem 
0xf8000000-0xfbffffff] reserved in E820
Sep 14 09:30:46 intel kernel: [    0.325295] PCI: Using configuration 
type 1 for base access
Sep 14 09:30:46 intel kernel: [    0.325315] core: PMU erratum BJ122, 
BV98, HSD29 worked around, HT is on
Sep 14 09:30:46 intel kernel: [    0.333263] HugeTLB registered 2 MB 
page size, pre-allocated 0 pages
Sep 14 09:30:46 intel kernel: [    0.333414] ACPI: Added _OSI(Module Device)
Sep 14 09:30:46 intel kernel: [    0.333417] ACPI: Added _OSI(Processor 
Device)
Sep 14 09:30:46 intel kernel: [    0.333420] ACPI: Added _OSI(3.0 _SCP 
Extensions)
Sep 14 09:30:46 intel kernel: [    0.333422] ACPI: Added _OSI(Processor 
Aggregator Device)
Sep 14 09:30:46 intel kernel: [    0.333566] ACPI: Executed 1 blocks of 
module-level executable AML code
Sep 14 09:30:46 intel kernel: [    0.336322] ACPI: Dynamic OEM Table Load:
Sep 14 09:30:46 intel kernel: [    0.336330] ACPI: SSDT 
0xFFFF880215569000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
Sep 14 09:30:46 intel kernel: [    0.336708] ACPI: Dynamic OEM Table Load:
Sep 14 09:30:46 intel kernel: [    0.336714] ACPI: SSDT 
0xFFFF8802154CF800 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
Sep 14 09:30:46 intel kernel: [    0.337037] ACPI: Dynamic OEM Table Load:
Sep 14 09:30:46 intel kernel: [    0.337042] ACPI: SSDT 
0xFFFF88021553EA00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
Sep 14 09:30:46 intel kernel: [    0.337845] ACPI: Interpreter enabled
Sep 14 09:30:46 intel kernel: [    0.337861] ACPI: (supports S0 S3 S4 S5)
Sep 14 09:30:46 intel kernel: [    0.337864] ACPI: Using IOAPIC for 
interrupt routing
Sep 14 09:30:46 intel kernel: [    0.337885] PCI: Using host bridge 
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Sep 14 09:30:46 intel kernel: [    0.342773] ACPI: Power Resource [FN00] 
(off)
Sep 14 09:30:46 intel kernel: [    0.342838] ACPI: Power Resource [FN01] 
(off)
Sep 14 09:30:46 intel kernel: [    0.342902] ACPI: Power Resource [FN02] 
(off)
Sep 14 09:30:46 intel kernel: [    0.342964] ACPI: Power Resource [FN03] 
(off)
Sep 14 09:30:46 intel kernel: [    0.343027] ACPI: Power Resource [FN04] 
(off)
Sep 14 09:30:46 intel kernel: [    0.343430] ACPI: PCI Root Bridge 
[PCI0] (domain 0000 [bus 00-3e])
Sep 14 09:30:46 intel kernel: [    0.343437] acpi PNP0A08:00: _OSC: OS 
supports [ExtendedConfig ASPM ClockPM Segments MSI]
Sep 14 09:30:46 intel kernel: [    0.343597] acpi PNP0A08:00: _OSC: 
platform does not support [PCIeHotplug PME]
Sep 14 09:30:46 intel kernel: [    0.343697] acpi PNP0A08:00: _OSC: OS 
now controls [AER PCIeCapability]
Sep 14 09:30:46 intel kernel: [    0.343701] acpi PNP0A08:00: FADT 
indicates ASPM is unsupported, using BIOS configuration
Sep 14 09:30:46 intel kernel: [    0.344044] PCI host bridge to bus 0000:00
Sep 14 09:30:46 intel kernel: [    0.344048] pci_bus 0000:00: root bus 
resource [io  0x0000-0x0cf7 window]
Sep 14 09:30:46 intel kernel: [    0.344052] pci_bus 0000:00: root bus 
resource [io  0x0d00-0xffff window]
Sep 14 09:30:46 intel kernel: [    0.344055] pci_bus 0000:00: root bus 
resource [mem 0x000a0000-0x000bffff window]
Sep 14 09:30:46 intel kernel: [    0.344059] pci_bus 0000:00: root bus 
resource [mem 0x000d8000-0x000dbfff window]
Sep 14 09:30:46 intel kernel: [    0.344064] pci_bus 0000:00: root bus 
resource [mem 0x000dc000-0x000dffff window]
Sep 14 09:30:46 intel kernel: [    0.344068] pci_bus 0000:00: root bus 
resource [mem 0x000e0000-0x000e3fff window]
Sep 14 09:30:46 intel kernel: [    0.344072] pci_bus 0000:00: root bus 
resource [mem 0x000e4000-0x000e7fff window]
Sep 14 09:30:46 intel kernel: [    0.344077] pci_bus 0000:00: root bus 
resource [mem 0xdfa00000-0xfeafffff window]
Sep 14 09:30:46 intel kernel: [    0.344081] pci_bus 0000:00: root bus 
resource [bus 00-3e]
Sep 14 09:30:46 intel kernel: [    0.344089] pci 0000:00:00.0: 
[8086:0100] type 00 class 0x060000
Sep 14 09:30:46 intel kernel: [    0.344163] pci 0000:00:01.0: 
[8086:0101] type 01 class 0x060400
Sep 14 09:30:46 intel kernel: [    0.344187] pci 0000:00:01.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.344221] pci 0000:00:01.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.344255] pci 0000:00:02.0: 
[8086:0102] type 00 class 0x030000
Sep 14 09:30:46 intel kernel: [    0.344262] pci 0000:00:02.0: reg 0x10: 
[mem 0xf7400000-0xf77fffff 64bit]
Sep 14 09:30:46 intel kernel: [    0.344266] pci 0000:00:02.0: reg 0x18: 
[mem 0xe0000000-0xefffffff 64bit pref]
Sep 14 09:30:46 intel kernel: [    0.344269] pci 0000:00:02.0: reg 0x20: 
[io  0xf000-0xf03f]
Sep 14 09:30:46 intel kernel: [    0.344364] pci 0000:00:14.0: 
[8086:1e31] type 00 class 0x0c0330
Sep 14 09:30:46 intel kernel: [    0.344384] pci 0000:00:14.0: reg 0x10: 
[mem 0xf7c20000-0xf7c2ffff 64bit]
Sep 14 09:30:46 intel kernel: [    0.344449] pci 0000:00:14.0: PME# 
supported from D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.344485] pci 0000:00:14.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.344519] pci 0000:00:16.0: 
[8086:1e3a] type 00 class 0x078000
Sep 14 09:30:46 intel kernel: [    0.344538] pci 0000:00:16.0: reg 0x10: 
[mem 0xf7c3b000-0xf7c3b00f 64bit]
Sep 14 09:30:46 intel kernel: [    0.344608] pci 0000:00:16.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.344676] pci 0000:00:19.0: 
[8086:1503] type 00 class 0x020000
Sep 14 09:30:46 intel kernel: [    0.344691] pci 0000:00:19.0: reg 0x10: 
[mem 0xf7c00000-0xf7c1ffff]
Sep 14 09:30:46 intel kernel: [    0.344699] pci 0000:00:19.0: reg 0x14: 
[mem 0xf7c39000-0xf7c39fff]
Sep 14 09:30:46 intel kernel: [    0.344707] pci 0000:00:19.0: reg 0x18: 
[io  0xf080-0xf09f]
Sep 14 09:30:46 intel kernel: [    0.344761] pci 0000:00:19.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.344797] pci 0000:00:19.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.344831] pci 0000:00:1a.0: 
[8086:1e2d] type 00 class 0x0c0320
Sep 14 09:30:46 intel kernel: [    0.344847] pci 0000:00:1a.0: reg 0x10: 
[mem 0xf7c38000-0xf7c383ff]
Sep 14 09:30:46 intel kernel: [    0.344925] pci 0000:00:1a.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.344971] pci 0000:00:1a.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.345005] pci 0000:00:1b.0: 
[8086:1e20] type 00 class 0x040300
Sep 14 09:30:46 intel kernel: [    0.345021] pci 0000:00:1b.0: reg 0x10: 
[mem 0xf7c30000-0xf7c33fff 64bit]
Sep 14 09:30:46 intel kernel: [    0.345087] pci 0000:00:1b.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.345126] pci 0000:00:1b.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.345164] pci 0000:00:1c.0: 
[8086:1e10] type 01 class 0x060400
Sep 14 09:30:46 intel kernel: [    0.345291] pci 0000:00:1c.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.345340] pci 0000:00:1c.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.345381] pci 0000:00:1c.4: 
[8086:1e18] type 01 class 0x060400
Sep 14 09:30:46 intel kernel: [    0.345506] pci 0000:00:1c.4: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.345554] pci 0000:00:1c.4: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.345590] pci 0000:00:1d.0: 
[8086:1e26] type 00 class 0x0c0320
Sep 14 09:30:46 intel kernel: [    0.345605] pci 0000:00:1d.0: reg 0x10: 
[mem 0xf7c37000-0xf7c373ff]
Sep 14 09:30:46 intel kernel: [    0.345683] pci 0000:00:1d.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.345729] pci 0000:00:1d.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.345763] pci 0000:00:1f.0: 
[8086:1e4a] type 00 class 0x060100
Sep 14 09:30:46 intel kernel: [    0.345916] pci 0000:00:1f.2: 
[8086:1e02] type 00 class 0x010601
Sep 14 09:30:46 intel kernel: [    0.345929] pci 0000:00:1f.2: reg 0x10: 
[io  0xf0d0-0xf0d7]
Sep 14 09:30:46 intel kernel: [    0.345936] pci 0000:00:1f.2: reg 0x14: 
[io  0xf0c0-0xf0c3]
Sep 14 09:30:46 intel kernel: [    0.345944] pci 0000:00:1f.2: reg 0x18: 
[io  0xf0b0-0xf0b7]
Sep 14 09:30:46 intel kernel: [    0.345951] pci 0000:00:1f.2: reg 0x1c: 
[io  0xf0a0-0xf0a3]
Sep 14 09:30:46 intel kernel: [    0.345958] pci 0000:00:1f.2: reg 0x20: 
[io  0xf060-0xf07f]
Sep 14 09:30:46 intel kernel: [    0.345965] pci 0000:00:1f.2: reg 0x24: 
[mem 0xf7c36000-0xf7c367ff]
Sep 14 09:30:46 intel kernel: [    0.346002] pci 0000:00:1f.2: PME# 
supported from D3hot
Sep 14 09:30:46 intel kernel: [    0.346062] pci 0000:00:1f.3: 
[8086:1e22] type 00 class 0x0c0500
Sep 14 09:30:46 intel kernel: [    0.346076] pci 0000:00:1f.3: reg 0x10: 
[mem 0xf7c35000-0xf7c350ff 64bit]
Sep 14 09:30:46 intel kernel: [    0.346095] pci 0000:00:1f.3: reg 0x20: 
[io  0xf040-0xf05f]
Sep 14 09:30:46 intel kernel: [    0.346197] pci 0000:01:00.0: 
[8086:0370] type 01 class 0x060400
Sep 14 09:30:46 intel kernel: [    0.346247] pci 0000:01:00.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.346287] pci 0000:01:00.2: 
[8086:0372] type 01 class 0x060400
Sep 14 09:30:46 intel kernel: [    0.346335] pci 0000:01:00.2: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.351629] pci 0000:00:01.0: PCI 
bridge to [bus 01-03]
Sep 14 09:30:46 intel kernel: [    0.351639] pci 0000:00:01.0: bridge 
window [mem 0xf7800000-0xf7afffff]
Sep 14 09:30:46 intel kernel: [    0.351700] pci 0000:02:0e.0: 
[9005:0285] type 00 class 0x010400
Sep 14 09:30:46 intel kernel: [    0.351720] pci 0000:02:0e.0: reg 0x10: 
[mem 0xf7800000-0xf79fffff 64bit]
Sep 14 09:30:46 intel kernel: [    0.351755] pci 0000:02:0e.0: reg 0x30: 
[mem 0xf7a00000-0xf7a3ffff pref]
Sep 14 09:30:46 intel kernel: [    0.351762] pci 0000:02:0e.0: Enabling 
fixed DMA alias to 01.0
Sep 14 09:30:46 intel kernel: [    0.351795] pci 0000:02:0e.0: supports D1
Sep 14 09:30:46 intel kernel: [    0.351832] pci 0000:01:00.0: PCI 
bridge to [bus 02]
Sep 14 09:30:46 intel kernel: [    0.351838] pci 0000:01:00.0: bridge 
window [mem 0xf7800000-0xf7afffff]
Sep 14 09:30:46 intel kernel: [    0.351892] pci 0000:01:00.2: PCI 
bridge to [bus 03]
Sep 14 09:30:46 intel kernel: [    0.351967] pci 0000:00:1c.0: PCI 
bridge to [bus 04]
Sep 14 09:30:46 intel kernel: [    0.352130] pci 0000:05:00.0: 
[1912:0014] type 00 class 0x0c0330
Sep 14 09:30:46 intel kernel: [    0.352184] pci 0000:05:00.0: reg 0x10: 
[mem 0xf7b00000-0xf7b01fff 64bit]
Sep 14 09:30:46 intel kernel: [    0.352500] pci 0000:05:00.0: PME# 
supported from D0 D3hot D3cold
Sep 14 09:30:46 intel kernel: [    0.352560] pci 0000:05:00.0: System 
wakeup disabled by ACPI
Sep 14 09:30:46 intel kernel: [    0.359703] pci 0000:00:1c.4: PCI 
bridge to [bus 05]
Sep 14 09:30:46 intel kernel: [    0.359710] pci 0000:00:1c.4: bridge 
window [mem 0xf7b00000-0xf7bfffff]
Sep 14 09:30:46 intel kernel: [    0.360209] ACPI: PCI Interrupt Link 
[LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep 14 09:30:46 intel kernel: [    0.360251] ACPI: PCI Interrupt Link 
[LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Sep 14 09:30:46 intel kernel: [    0.360293] ACPI: PCI Interrupt Link 
[LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep 14 09:30:46 intel kernel: [    0.360334] ACPI: PCI Interrupt Link 
[LNKD] (IRQs *3 4 5 6 10 11 12 14 15)
Sep 14 09:30:46 intel kernel: [    0.360374] ACPI: PCI Interrupt Link 
[LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep 14 09:30:46 intel kernel: [    0.360414] ACPI: PCI Interrupt Link 
[LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Sep 14 09:30:46 intel kernel: [    0.360457] ACPI: PCI Interrupt Link 
[LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep 14 09:30:46 intel kernel: [    0.360496] ACPI: PCI Interrupt Link 
[LNKH] (IRQs *3 4 5 6 10 11 12 14 15)
Sep 14 09:30:46 intel kernel: [    0.360672] ACPI: Enabled 4 GPEs in 
block 00 to 3F
Sep 14 09:30:46 intel kernel: [    0.360758] vgaarb: setting as boot 
device: PCI:0000:00:02.0
Sep 14 09:30:46 intel kernel: [    0.360761] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Sep 14 09:30:46 intel kernel: [    0.360767] vgaarb: loaded
Sep 14 09:30:46 intel kernel: [    0.360769] vgaarb: bridge control 
possible 0000:00:02.0
Sep 14 09:30:46 intel kernel: [    0.360895] SCSI subsystem initialized
Sep 14 09:30:46 intel kernel: [    0.360933] libata version 3.00 loaded.
Sep 14 09:30:46 intel kernel: [    0.360947] ACPI: bus type USB registered
Sep 14 09:30:46 intel kernel: [    0.360961] usbcore: registered new 
interface driver usbfs
Sep 14 09:30:46 intel kernel: [    0.360969] usbcore: registered new 
interface driver hub
Sep 14 09:30:46 intel kernel: [    0.360982] usbcore: registered new 
device driver usb
Sep 14 09:30:46 intel kernel: [    0.361066] PCI: Using ACPI for IRQ routing
Sep 14 09:30:46 intel kernel: [    0.362446] PCI: pci_cache_line_size 
set to 64 bytes
Sep 14 09:30:46 intel kernel: [    0.362539] e820: reserve RAM buffer 
[mem 0x0009a400-0x0009ffff]
Sep 14 09:30:46 intel kernel: [    0.362540] e820: reserve RAM buffer 
[mem 0xd9a20000-0xdbffffff]
Sep 14 09:30:46 intel kernel: [    0.362541] e820: reserve RAM buffer 
[mem 0xda698000-0xdbffffff]
Sep 14 09:30:46 intel kernel: [    0.362542] e820: reserve RAM buffer 
[mem 0xdb000000-0xdbffffff]
Sep 14 09:30:46 intel kernel: [    0.362543] e820: reserve RAM buffer 
[mem 0x21f600000-0x21fffffff]
Sep 14 09:30:46 intel kernel: [    0.362617] NetLabel: Initializing
Sep 14 09:30:46 intel kernel: [    0.362620] NetLabel:  domain hash size 
= 128
Sep 14 09:30:46 intel kernel: [    0.362622] NetLabel:  protocols = 
UNLABELED CIPSOv4
Sep 14 09:30:46 intel kernel: [    0.362634] NetLabel:  unlabeled 
traffic allowed by default
Sep 14 09:30:46 intel kernel: [    0.362697] hpet0: at MMIO 0xfed00000, 
IRQs 2, 8, 0, 0, 0, 0, 0, 0
Sep 14 09:30:46 intel kernel: [    0.362704] hpet0: 8 comparators, 
64-bit 14.318180 MHz counter
Sep 14 09:30:46 intel kernel: [    0.364715] amd_nb: Cannot enumerate 
AMD northbridges
Sep 14 09:30:46 intel kernel: [    0.364726] clocksource: Switched to 
clocksource hpet
Sep 14 09:30:46 intel kernel: [    0.369324] VFS: Disk quotas dquot_6.6.0
Sep 14 09:30:46 intel kernel: [    0.369344] VFS: Dquot-cache hash table 
entries: 512 (order 0, 4096 bytes)
Sep 14 09:30:46 intel kernel: [    0.369397] AppArmor: AppArmor 
Filesystem Enabled
Sep 14 09:30:46 intel kernel: [    0.369442] pnp: PnP ACPI init
Sep 14 09:30:46 intel kernel: [    0.369541] system 00:00: [mem 
0xfed40000-0xfed44fff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369546] system 00:00: Plug and Play 
ACPI device, IDs PNP0c01 (active)
Sep 14 09:30:46 intel kernel: [    0.369606] system 00:01: [io 
0x0680-0x069f] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369610] system 00:01: [io 
0x1000-0x100f] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369613] system 00:01: [io 0xffff] 
has been reserved
Sep 14 09:30:46 intel kernel: [    0.369616] system 00:01: [io 0xffff] 
has been reserved
Sep 14 09:30:46 intel kernel: [    0.369619] system 00:01: [io 
0x0400-0x0453] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369622] system 00:01: [io 
0x0458-0x047f] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369626] system 00:01: [io 
0x0500-0x057f] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369629] system 00:01: [io 
0x164e-0x164f] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369633] system 00:01: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Sep 14 09:30:46 intel kernel: [    0.369655] pnp 00:02: Plug and Play 
ACPI device, IDs PNP0b00 (active)
Sep 14 09:30:46 intel kernel: [    0.369691] system 00:03: [io 
0x0454-0x0457] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369695] system 00:03: Plug and Play 
ACPI device, IDs INT3f0d PNP0c02 (active)
Sep 14 09:30:46 intel kernel: [    0.369753] system 00:04: [io 
0x0a00-0x0a0f] has been reserved
Sep 14 09:30:46 intel kernel: [    0.369757] system 00:04: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Sep 14 09:30:46 intel kernel: [    0.369964] pnp 00:05: [dma 0 disabled]
Sep 14 09:30:46 intel kernel: [    0.370043] pnp 00:05: Plug and Play 
ACPI device, IDs PNP0400 (active)
Sep 14 09:30:46 intel kernel: [    0.370189] pnp 00:06: [dma 0 disabled]
Sep 14 09:30:46 intel kernel: [    0.370225] pnp 00:06: Plug and Play 
ACPI device, IDs PNP0501 (active)
Sep 14 09:30:46 intel kernel: [    0.370262] system 00:07: [io 
0x04d0-0x04d1] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370266] system 00:07: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Sep 14 09:30:46 intel kernel: [    0.370466] system 00:08: [mem 
0xfed1c000-0xfed1ffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370470] system 00:08: [mem 
0xfed10000-0xfed17fff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370473] system 00:08: [mem 
0xfed18000-0xfed18fff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370476] system 00:08: [mem 
0xfed19000-0xfed19fff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370479] system 00:08: [mem 
0xf8000000-0xfbffffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370482] system 00:08: [mem 
0xfed20000-0xfed3ffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370486] system 00:08: [mem 
0xfed90000-0xfed93fff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370489] system 00:08: [mem 
0xfed45000-0xfed8ffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370492] system 00:08: [mem 
0xff000000-0xffffffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370495] system 00:08: [mem 
0xfee00000-0xfeefffff] could not be reserved
Sep 14 09:30:46 intel kernel: [    0.370499] system 00:08: [mem 
0xdfa00000-0xdfa00fff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370502] system 00:08: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Sep 14 09:30:46 intel kernel: [    0.370613] system 00:09: [mem 
0x20000000-0x201fffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370616] system 00:09: [mem 
0x40000000-0x401fffff] has been reserved
Sep 14 09:30:46 intel kernel: [    0.370620] system 00:09: Plug and Play 
ACPI device, IDs PNP0c01 (active)
Sep 14 09:30:46 intel kernel: [    0.370634] pnp: PnP ACPI: found 10 devices
Sep 14 09:30:46 intel kernel: [    0.376571] clocksource: acpi_pm: mask: 
0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
Sep 14 09:30:46 intel kernel: [    0.376617] pci 0000:01:00.0: PCI 
bridge to [bus 02]
Sep 14 09:30:46 intel kernel: [    0.376623] pci 0000:01:00.0: bridge 
window [mem 0xf7800000-0xf7afffff]
Sep 14 09:30:46 intel kernel: [    0.376630] pci 0000:01:00.2: PCI 
bridge to [bus 03]
Sep 14 09:30:46 intel kernel: [    0.376639] pci 0000:00:01.0: PCI 
bridge to [bus 01-03]
Sep 14 09:30:46 intel kernel: [    0.376642] pci 0000:00:01.0: bridge 
window [mem 0xf7800000-0xf7afffff]
Sep 14 09:30:46 intel kernel: [    0.376648] pci 0000:00:1c.0: PCI 
bridge to [bus 04]
Sep 14 09:30:46 intel kernel: [    0.376667] pci 0000:00:1c.4: PCI 
bridge to [bus 05]
Sep 14 09:30:46 intel kernel: [    0.376675] pci 0000:00:1c.4: bridge 
window [mem 0xf7b00000-0xf7bfffff]
Sep 14 09:30:46 intel kernel: [    0.376689] pci_bus 0000:00: resource 4 
[io  0x0000-0x0cf7 window]
Sep 14 09:30:46 intel kernel: [    0.376690] pci_bus 0000:00: resource 5 
[io  0x0d00-0xffff window]
Sep 14 09:30:46 intel kernel: [    0.376692] pci_bus 0000:00: resource 6 
[mem 0x000a0000-0x000bffff window]
Sep 14 09:30:46 intel kernel: [    0.376693] pci_bus 0000:00: resource 7 
[mem 0x000d8000-0x000dbfff window]
Sep 14 09:30:46 intel kernel: [    0.376694] pci_bus 0000:00: resource 8 
[mem 0x000dc000-0x000dffff window]
Sep 14 09:30:46 intel kernel: [    0.376695] pci_bus 0000:00: resource 9 
[mem 0x000e0000-0x000e3fff window]
Sep 14 09:30:46 intel kernel: [    0.376696] pci_bus 0000:00: resource 
10 [mem 0x000e4000-0x000e7fff window]
Sep 14 09:30:46 intel kernel: [    0.376698] pci_bus 0000:00: resource 
11 [mem 0xdfa00000-0xfeafffff window]
Sep 14 09:30:46 intel kernel: [    0.376699] pci_bus 0000:01: resource 1 
[mem 0xf7800000-0xf7afffff]
Sep 14 09:30:46 intel kernel: [    0.376700] pci_bus 0000:02: resource 1 
[mem 0xf7800000-0xf7afffff]
Sep 14 09:30:46 intel kernel: [    0.376702] pci_bus 0000:05: resource 1 
[mem 0xf7b00000-0xf7bfffff]
Sep 14 09:30:46 intel kernel: [    0.376721] NET: Registered protocol 
family 2
Sep 14 09:30:46 intel kernel: [    0.376851] TCP established hash table 
entries: 65536 (order: 7, 524288 bytes)
Sep 14 09:30:46 intel kernel: [    0.376956] TCP bind hash table 
entries: 65536 (order: 8, 1048576 bytes)
Sep 14 09:30:46 intel kernel: [    0.377074] TCP: Hash tables configured 
(established 65536 bind 65536)
Sep 14 09:30:46 intel kernel: [    0.377100] UDP hash table entries: 
4096 (order: 5, 131072 bytes)
Sep 14 09:30:46 intel kernel: [    0.377123] UDP-Lite hash table 
entries: 4096 (order: 5, 131072 bytes)
Sep 14 09:30:46 intel kernel: [    0.377172] NET: Registered protocol 
family 1
Sep 14 09:30:46 intel kernel: [    0.377193] pci 0000:00:02.0: BIOS left 
Intel GPU interrupts enabled; disabling
Sep 14 09:30:46 intel kernel: [    0.377201] pci 0000:00:02.0: Video 
device with shadowed ROM at [mem 0x000c0000-0x000dffff]
Sep 14 09:30:46 intel kernel: [    0.416820] pci 0000:01:00.0: rerouting 
interrupts for [8086:0370]
Sep 14 09:30:46 intel kernel: [    0.416825] pci 0000:01:00.2: rerouting 
interrupts for [8086:0372]
Sep 14 09:30:46 intel kernel: [    0.417019] PCI: CLS mismatch (64 != 
32), using 64 bytes
Sep 14 09:30:46 intel kernel: [    0.417062] Trying to unpack rootfs 
image as initramfs...
Sep 14 09:30:46 intel kernel: [    4.066276] Freeing initrd memory: 
306276K (ffff88000d4e6000 - ffff88001ffff000)
Sep 14 09:30:46 intel kernel: [    4.066286] PCI-DMA: Using software 
bounce buffering for IO (SWIOTLB)
Sep 14 09:30:46 intel kernel: [    4.066290] software IO TLB [mem 
0xd5a20000-0xd9a20000] (64MB) mapped at [ffff8800d5a20000-ffff8800d9a1ffff]
Sep 14 09:30:46 intel kernel: [    4.066342] RAPL PMU: API unit is 2^-32 
Joules, 3 fixed counters, 163840 ms ovfl timer
Sep 14 09:30:46 intel kernel: [    4.066347] RAPL PMU: hw unit of domain 
pp0-core 2^-16 Joules
Sep 14 09:30:46 intel kernel: [    4.066349] RAPL PMU: hw unit of domain 
package 2^-16 Joules
Sep 14 09:30:46 intel kernel: [    4.066352] RAPL PMU: hw unit of domain 
pp1-gpu 2^-16 Joules
Sep 14 09:30:46 intel kernel: [    4.066462] Scanning for low memory 
corruption every 60 seconds
Sep 14 09:30:46 intel kernel: [    4.066706] futex hash table entries: 
1024 (order: 4, 65536 bytes)
Sep 14 09:30:46 intel kernel: [    4.066727] audit: initializing netlink 
subsys (disabled)
Sep 14 09:30:46 intel kernel: [    4.066740] audit: type=2000 
audit(1473838232.060:1): initialized
Sep 14 09:30:46 intel kernel: [    4.067072] Initialise system trusted 
keyrings
Sep 14 09:30:46 intel kernel: [    4.067131] workingset: 
timestamp_bits=37 max_order=21 bucket_order=0
Sep 14 09:30:46 intel kernel: [    4.068318] zbud: loaded
Sep 14 09:30:46 intel kernel: [    4.068590] squashfs: version 4.0 
(2009/01/31) Phillip Lougher
Sep 14 09:30:46 intel kernel: [    4.068750] fuse init (API version 7.25)
Sep 14 09:30:46 intel kernel: [    4.068851] Key type big_key registered
Sep 14 09:30:46 intel kernel: [    4.069149] Key type asymmetric registered
Sep 14 09:30:46 intel kernel: [    4.069152] Asymmetric key parser 
'x509' registered
Sep 14 09:30:46 intel kernel: [    4.069178] Block layer SCSI generic 
(bsg) driver version 0.4 loaded (major 248)
Sep 14 09:30:46 intel kernel: [    4.069207] io scheduler noop registered
Sep 14 09:30:46 intel kernel: [    4.069211] io scheduler deadline 
registered (default)
Sep 14 09:30:46 intel kernel: [    4.069234] io scheduler cfq registered
Sep 14 09:30:46 intel kernel: [    4.069611] pci_hotplug: PCI Hot Plug 
PCI Core version: 0.5
Sep 14 09:30:46 intel kernel: [    4.069618] pciehp: PCI Express Hot 
Plug Controller Driver version: 0.4
Sep 14 09:30:46 intel kernel: [    4.069636] vesafb: mode is 
1920x1080x32, linelength=7680, pages=0
Sep 14 09:30:46 intel kernel: [    4.069639] vesafb: scrolling: redraw
Sep 14 09:30:46 intel kernel: [    4.069642] vesafb: Truecolor: 
size=8:8:8:8, shift=24:16:8:0
Sep 14 09:30:46 intel kernel: [    4.069652] vesafb: framebuffer at 
0xe0000000, mapped to 0xffffc90001000000, using 8128k, total 8128k
Sep 14 09:30:46 intel kernel: [    4.176512] Console: switching to 
colour frame buffer device 240x67
Sep 14 09:30:46 intel kernel: [    4.283368] fb0: VESA VGA frame buffer 
device
Sep 14 09:30:46 intel kernel: [    4.283710] intel_idle: MWAIT 
substates: 0x1120
Sep 14 09:30:46 intel kernel: [    4.283711] intel_idle: v0.4.1 model 0x2A
Sep 14 09:30:46 intel kernel: [    4.283804] intel_idle: 
lapic_timer_reliable_states 0xffffffff
Sep 14 09:30:46 intel kernel: [    4.283862] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Sep 14 09:30:46 intel kernel: [    4.284502] ACPI: Power Button [PWRB]
Sep 14 09:30:46 intel kernel: [    4.284822] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Sep 14 09:30:46 intel kernel: [    4.285387] ACPI: Power Button [PWRF]
Sep 14 09:30:46 intel kernel: [    4.286219] thermal LNXTHERM:00: 
registered as thermal_zone0
Sep 14 09:30:46 intel kernel: [    4.286653] ACPI: Thermal Zone [TZ00] 
(28 C)
Sep 14 09:30:46 intel kernel: [    4.287136] thermal LNXTHERM:01: 
registered as thermal_zone1
Sep 14 09:30:46 intel kernel: [    4.287569] ACPI: Thermal Zone [TZ01] 
(30 C)
Sep 14 09:30:46 intel kernel: [    4.287917] GHES: HEST is not enabled!
Sep 14 09:30:46 intel kernel: [    4.288259] Serial: 8250/16550 driver, 
32 ports, IRQ sharing enabled
Sep 14 09:30:46 intel kernel: [    4.309193] 00:06: ttyS0 at I/O 0x3f8 
(irq = 4, base_baud = 115200) is a 16550A
Sep 14 09:30:46 intel kernel: [    4.310866] Linux agpgart interface v0.103
Sep 14 09:30:46 intel kernel: [    4.313310] brd: module loaded
Sep 14 09:30:46 intel kernel: [    4.314361] loop: module loaded
Sep 14 09:30:46 intel kernel: [    4.314745] libphy: Fixed MDIO Bus: probed
Sep 14 09:30:46 intel kernel: [    4.315057] tun: Universal TUN/TAP 
device driver, 1.6
Sep 14 09:30:46 intel kernel: [    4.315440] tun: (C) 1999-2004 Max 
Krasnyansky <maxk@qualcomm.com>
Sep 14 09:30:46 intel kernel: [    4.315936] PPP generic driver version 
2.4.2
Sep 14 09:30:46 intel kernel: [    4.316295] ehci_hcd: USB 2.0 
'Enhanced' Host Controller (EHCI) Driver
Sep 14 09:30:46 intel kernel: [    4.316801] ehci-pci: EHCI PCI platform 
driver
Sep 14 09:30:46 intel kernel: [    4.317247] ehci-pci 0000:00:1a.0: EHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.317649] ehci-pci 0000:00:1a.0: new 
USB bus registered, assigned bus number 1
Sep 14 09:30:46 intel kernel: [    4.318221] ehci-pci 0000:00:1a.0: 
debug port 2
Sep 14 09:30:46 intel kernel: [    4.322475] ehci-pci 0000:00:1a.0: 
cache line size of 64 is not supported
Sep 14 09:30:46 intel kernel: [    4.322485] ehci-pci 0000:00:1a.0: irq 
16, io mem 0xf7c38000
Sep 14 09:30:46 intel kernel: [    4.332619] ehci-pci 0000:00:1a.0: USB 
2.0 started, EHCI 1.00
Sep 14 09:30:46 intel kernel: [    4.333082] usb usb1: New USB device 
found, idVendor=1d6b, idProduct=0002
Sep 14 09:30:46 intel kernel: [    4.333597] usb usb1: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    4.334144] usb usb1: Product: EHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.334515] usb usb1: Manufacturer: 
Linux 4.7.3 ehci_hcd
Sep 14 09:30:46 intel kernel: [    4.334917] usb usb1: SerialNumber: 
0000:00:1a.0
Sep 14 09:30:46 intel kernel: [    4.335416] hub 1-0:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    4.335708] hub 1-0:1.0: 2 ports detected
Sep 14 09:30:46 intel kernel: [    4.336184] ehci-pci 0000:00:1d.0: EHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.336585] ehci-pci 0000:00:1d.0: new 
USB bus registered, assigned bus number 2
Sep 14 09:30:46 intel kernel: [    4.337162] ehci-pci 0000:00:1d.0: 
debug port 2
Sep 14 09:30:46 intel kernel: [    4.341395] ehci-pci 0000:00:1d.0: 
cache line size of 64 is not supported
Sep 14 09:30:46 intel kernel: [    4.341402] ehci-pci 0000:00:1d.0: irq 
23, io mem 0xf7c37000
Sep 14 09:30:46 intel kernel: [    4.352635] ehci-pci 0000:00:1d.0: USB 
2.0 started, EHCI 1.00
Sep 14 09:30:46 intel kernel: [    4.353110] usb usb2: New USB device 
found, idVendor=1d6b, idProduct=0002
Sep 14 09:30:46 intel kernel: [    4.353626] usb usb2: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    4.354174] usb usb2: Product: EHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.354545] usb usb2: Manufacturer: 
Linux 4.7.3 ehci_hcd
Sep 14 09:30:46 intel kernel: [    4.376583] usb usb2: SerialNumber: 
0000:00:1d.0
Sep 14 09:30:46 intel kernel: [    4.398581] hub 2-0:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    4.420262] hub 2-0:1.0: 2 ports detected
Sep 14 09:30:46 intel kernel: [    4.441880] ehci-platform: EHCI generic 
platform driver
Sep 14 09:30:46 intel kernel: [    4.463431] ohci_hcd: USB 1.1 'Open' 
Host Controller (OHCI) Driver
Sep 14 09:30:46 intel kernel: [    4.485014] ohci-pci: OHCI PCI platform 
driver
Sep 14 09:30:46 intel kernel: [    4.506412] ohci-platform: OHCI generic 
platform driver
Sep 14 09:30:46 intel kernel: [    4.527805] uhci_hcd: USB Universal 
Host Controller Interface driver
Sep 14 09:30:46 intel kernel: [    4.549411] xhci_hcd 0000:00:14.0: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.570993] xhci_hcd 0000:00:14.0: new 
USB bus registered, assigned bus number 3
Sep 14 09:30:46 intel kernel: [    4.593947] xhci_hcd 0000:00:14.0: hcc 
params 0x20007181 hci version 0x100 quirks 0x0000b930
Sep 14 09:30:46 intel kernel: [    4.616033] xhci_hcd 0000:00:14.0: 
cache line size of 64 is not supported
Sep 14 09:30:46 intel kernel: [    4.616106] usb usb3: New USB device 
found, idVendor=1d6b, idProduct=0002
Sep 14 09:30:46 intel kernel: [    4.638191] usb usb3: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    4.660163] usb usb3: Product: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.660604] usb 1-1: new high-speed USB 
device number 2 using ehci-pci
Sep 14 09:30:46 intel kernel: [    4.704306] usb usb3: Manufacturer: 
Linux 4.7.3 xhci-hcd
Sep 14 09:30:46 intel kernel: [    4.726597] usb usb3: SerialNumber: 
0000:00:14.0
Sep 14 09:30:46 intel kernel: [    4.748915] hub 3-0:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    4.770923] hub 3-0:1.0: 4 ports detected
Sep 14 09:30:46 intel kernel: [    4.772599] usb 2-1: new high-speed USB 
device number 2 using ehci-pci
Sep 14 09:30:46 intel kernel: [    4.792968] usb 1-1: New USB device 
found, idVendor=8087, idProduct=0024
Sep 14 09:30:46 intel kernel: [    4.792969] usb 1-1: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Sep 14 09:30:46 intel kernel: [    4.793077] hub 1-1:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    4.793211] hub 1-1:1.0: 6 ports detected
Sep 14 09:30:46 intel kernel: [    4.902058] xhci_hcd 0000:00:14.0: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    4.904960] usb 2-1: New USB device 
found, idVendor=8087, idProduct=0024
Sep 14 09:30:46 intel kernel: [    4.904962] usb 2-1: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Sep 14 09:30:46 intel kernel: [    4.905110] hub 2-1:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    4.905209] hub 2-1:1.0: 8 ports detected
Sep 14 09:30:46 intel kernel: [    5.007223] xhci_hcd 0000:00:14.0: new 
USB bus registered, assigned bus number 4
Sep 14 09:30:46 intel kernel: [    5.028073] usb usb4: New USB device 
found, idVendor=1d6b, idProduct=0003
Sep 14 09:30:46 intel kernel: [    5.048979] usb usb4: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    5.069871] usb usb4: Product: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    5.084590] usb 1-1.4: new high-speed 
USB device number 3 using ehci-pci
Sep 14 09:30:46 intel kernel: [    5.111730] usb usb4: Manufacturer: 
Linux 4.7.3 xhci-hcd
Sep 14 09:30:46 intel kernel: [    5.132743] usb usb4: SerialNumber: 
0000:00:14.0
Sep 14 09:30:46 intel kernel: [    5.153472] tsc: Refined TSC 
clocksource calibration: 3300.026 MHz
Sep 14 09:30:46 intel kernel: [    5.153632] hub 4-0:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    5.153643] hub 4-0:1.0: 4 ports detected
Sep 14 09:30:46 intel kernel: [    5.154175] xhci_hcd 0000:05:00.0: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    5.154180] xhci_hcd 0000:05:00.0: new 
USB bus registered, assigned bus number 5
Sep 14 09:30:46 intel kernel: [    5.159620] xhci_hcd 0000:05:00.0: hcc 
params 0x014051cf hci version 0x100 quirks 0x00000010
Sep 14 09:30:46 intel kernel: [    5.159828] usb usb5: New USB device 
found, idVendor=1d6b, idProduct=0002
Sep 14 09:30:46 intel kernel: [    5.159829] usb usb5: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    5.159830] usb usb5: Product: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    5.159830] usb usb5: Manufacturer: 
Linux 4.7.3 xhci-hcd
Sep 14 09:30:46 intel kernel: [    5.159831] usb usb5: SerialNumber: 
0000:05:00.0
Sep 14 09:30:46 intel kernel: [    5.159960] hub 5-0:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    5.160023] hub 5-0:1.0: 4 ports detected
Sep 14 09:30:46 intel kernel: [    5.160170] xhci_hcd 0000:05:00.0: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    5.160172] xhci_hcd 0000:05:00.0: new 
USB bus registered, assigned bus number 6
Sep 14 09:30:46 intel kernel: [    5.163200] usb usb6: We don't know the 
algorithms for LPM for this host, disabling LPM.
Sep 14 09:30:46 intel kernel: [    5.163224] usb usb6: New USB device 
found, idVendor=1d6b, idProduct=0003
Sep 14 09:30:46 intel kernel: [    5.163225] usb usb6: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    5.163226] usb usb6: Product: xHCI 
Host Controller
Sep 14 09:30:46 intel kernel: [    5.163226] usb usb6: Manufacturer: 
Linux 4.7.3 xhci-hcd
Sep 14 09:30:46 intel kernel: [    5.163227] usb usb6: SerialNumber: 
0000:05:00.0
Sep 14 09:30:46 intel kernel: [    5.163356] hub 6-0:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    5.163419] hub 6-0:1.0: 4 ports detected
Sep 14 09:30:46 intel kernel: [    5.163632] i8042: PNP: No PS/2 
controller found. Probing ports directly.
Sep 14 09:30:46 intel kernel: [    5.200584] usb 2-1.5: new full-speed 
USB device number 3 using ehci-pci
Sep 14 09:30:46 intel kernel: [    5.201540] usb 1-1.4: New USB device 
found, idVendor=04e8, idProduct=329f
Sep 14 09:30:46 intel kernel: [    5.201541] usb 1-1.4: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Sep 14 09:30:46 intel kernel: [    5.201541] usb 1-1.4: Product: CLP-320 
Series
Sep 14 09:30:46 intel kernel: [    5.201542] usb 1-1.4: Manufacturer: 
Samsung Electronics Co., Ltd.
Sep 14 09:30:46 intel kernel: [    5.201543] usb 1-1.4: SerialNumber: 
Z51WBALB400982P
Sep 14 09:30:46 intel kernel: [    5.329314] usb 2-1.5: New USB device 
found, idVendor=0557, idProduct=8021
Sep 14 09:30:46 intel kernel: [    5.329315] usb 2-1.5: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Sep 14 09:30:46 intel kernel: [    5.329588] hub 2-1.5:1.0: USB hub found
Sep 14 09:30:46 intel kernel: [    5.329688] hub 2-1.5:1.0: 4 ports detected
Sep 14 09:30:46 intel kernel: [    5.628571] usb 2-1.5.1: new full-speed 
USB device number 4 using ehci-pci
Sep 14 09:30:46 intel kernel: [    5.775422] usb 2-1.5.1: New USB device 
found, idVendor=046a, idProduct=0023
Sep 14 09:30:46 intel kernel: [    5.775423] usb 2-1.5.1: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Sep 14 09:30:46 intel kernel: [    5.872622] usb 2-1.5.2: new low-speed 
USB device number 5 using ehci-pci
Sep 14 09:30:46 intel kernel: [    5.979775] clocksource: tsc: mask: 
0xffffffffffffffff max_cycles: 0x2f9164a0129, max_idle_ns: 440795228455 ns
Sep 14 09:30:46 intel kernel: [    6.009411] usb 2-1.5.2: New USB device 
found, idVendor=1bcf, idProduct=0005
Sep 14 09:30:46 intel kernel: [    6.031856] usb 2-1.5.2: New USB device 
strings: Mfr=0, Product=2, SerialNumber=0
Sep 14 09:30:46 intel kernel: [    6.054243] usb 2-1.5.2: Product: USB 
Optical Mouse
Sep 14 09:30:46 intel kernel: [    6.077205] usb 6-3: new SuperSpeed USB 
device number 2 using xhci_hcd
Sep 14 09:30:46 intel kernel: [    6.118822] usb 6-3: New USB device 
found, idVendor=1058, idProduct=1078
Sep 14 09:30:46 intel kernel: [    6.140996] usb 6-3: New USB device 
strings: Mfr=2, Product=3, SerialNumber=1
Sep 14 09:30:46 intel kernel: [    6.163149] usb 6-3: Product: Elements 1078
Sep 14 09:30:46 intel kernel: [    6.185087] usb 6-3: Manufacturer: 
Western Digital
Sep 14 09:30:46 intel kernel: [    6.202164] i8042: No controller found
Sep 14 09:30:46 intel kernel: [    6.204684] mousedev: PS/2 mouse device 
common for all mice
Sep 14 09:30:46 intel kernel: [    6.204891] rtc_cmos 00:02: RTC can 
wake from S4
Sep 14 09:30:46 intel kernel: [    6.205051] rtc_cmos 00:02: rtc core: 
registered rtc_cmos as rtc0
Sep 14 09:30:46 intel kernel: [    6.205078] rtc_cmos 00:02: alarms up 
to one month, y3k, 242 bytes nvram, hpet irqs
Sep 14 09:30:46 intel kernel: [    6.205085] i2c /dev entries driver
Sep 14 09:30:46 intel kernel: [    6.205146] device-mapper: uevent: 
version 1.0.3
Sep 14 09:30:46 intel kernel: [    6.205238] device-mapper: ioctl: 
4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
Sep 14 09:30:46 intel kernel: [    6.205246] intel_pstate: Intel P-state 
driver initializing
Sep 14 09:30:46 intel kernel: [    6.207173] ledtrig-cpu: registered to 
indicate activity on CPUs
Sep 14 09:30:46 intel kernel: [    6.207794] NET: Registered protocol 
family 10
Sep 14 09:30:46 intel kernel: [    6.208087] NET: Registered protocol 
family 17
Sep 14 09:30:46 intel kernel: [    6.208105] Key type dns_resolver 
registered
Sep 14 09:30:46 intel kernel: [    6.235535] microcode: CPU0 
sig=0x206a7, pf=0x2, revision=0x28
Sep 14 09:30:46 intel kernel: [    6.235566] microcode: CPU1 
sig=0x206a7, pf=0x2, revision=0x28
Sep 14 09:30:46 intel kernel: [    6.235569] microcode: CPU2 
sig=0x206a7, pf=0x2, revision=0x28
Sep 14 09:30:46 intel kernel: [    6.235576] microcode: CPU3 
sig=0x206a7, pf=0x2, revision=0x28
Sep 14 09:30:46 intel kernel: [    6.235634] microcode: Microcode Update 
Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Sep 14 09:30:46 intel kernel: [    6.235762] registered taskstats version 1
Sep 14 09:30:46 intel kernel: [    6.235766] Loading compiled-in X.509 
certificates
Sep 14 09:30:46 intel kernel: [    6.237952] Loaded X.509 cert 'Build 
time autogenerated kernel key: 415eab8b5446836f77edf89db6bad84af6bc4c64'
Sep 14 09:30:46 intel kernel: [    6.237971] zswap: loaded using pool 
lzo/zbud
Sep 14 09:30:46 intel kernel: [    6.240108] Key type trusted registered
Sep 14 09:30:46 intel kernel: [    6.242241] Key type encrypted registered
Sep 14 09:30:46 intel kernel: [    6.242243] AppArmor: AppArmor sha1 
policy hashing enabled
Sep 14 09:30:46 intel kernel: [    6.242244] ima: No TPM chip found, 
activating TPM-bypass!
Sep 14 09:30:46 intel kernel: [    6.242261] evm: HMAC attrs: 0x1
Sep 14 09:30:46 intel kernel: [    6.242624]   Magic number: 0:289:521
Sep 14 09:30:46 intel kernel: [    6.242636] usb usb3-port4: hash matches
Sep 14 09:30:46 intel kernel: [    6.257932] rtc_cmos 00:02: setting 
system clock to 2016-09-14 07:30:34 UTC (1473838234)
Sep 14 09:30:46 intel kernel: [    6.258011] BIOS EDD facility v0.16 
2004-Jun-25, 0 devices found
Sep 14 09:30:46 intel kernel: [    6.258012] EDD information not available.
Sep 14 09:30:46 intel kernel: [    6.258081] PM: Hibernation image not 
present or could not be loaded.
Sep 14 09:30:46 intel kernel: [    6.920025] usb 6-3: SerialNumber: 
57584D314143353241485431
Sep 14 09:30:46 intel kernel: [    6.943483] Freeing unused kernel 
memory: 1520K (ffffffff81f44000 - ffffffff820c0000)
Sep 14 09:30:46 intel kernel: [    6.966260] Write protecting the kernel 
read-only data: 14336k
Sep 14 09:30:46 intel kernel: [    6.989251] Freeing unused kernel 
memory: 1700K (ffff880001857000 - ffff880001a00000)
Sep 14 09:30:46 intel kernel: [    7.012127] clocksource: Switched to 
clocksource tsc
Sep 14 09:30:46 intel kernel: [    7.035509] Freeing unused kernel 
memory: 348K (ffff880001da9000 - ffff880001e00000)
Sep 14 09:30:46 intel kernel: [    7.113671] random: systemd-udevd: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114111] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114147] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114330] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114375] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114412] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114448] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114488] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114526] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.114561] random: udevadm: 
uninitialized urandom read (16 bytes read, 5 bits of entropy available)
Sep 14 09:30:46 intel kernel: [    7.362755] wmi: Mapper loaded
Sep 14 09:30:46 intel kernel: [    7.386711] FUJITSU Extended Socket 
Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
Sep 14 09:30:46 intel kernel: [    7.439186] pps_core: LinuxPPS API ver. 
1 registered
Sep 14 09:30:46 intel kernel: [    7.461738] pps_core: Software ver. 
5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
Sep 14 09:30:46 intel kernel: [    7.484865] ahci 0000:00:1f.2: version 3.0
Sep 14 09:30:46 intel kernel: [    7.485051] ahci 0000:00:1f.2: SSS flag 
set, parallel bus scan disabled
Sep 14 09:30:46 intel kernel: [    7.514011] PTP clock support registered
Sep 14 09:30:46 intel kernel: [    7.519081] ahci 0000:00:1f.2: AHCI 
0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
Sep 14 09:30:46 intel kernel: [    7.519084] ahci 0000:00:1f.2: flags: 
64bit ncq stag pm led clo pio slum part ems sxs apst
Sep 14 09:30:46 intel kernel: [    7.585566] [drm] Initialized drm 1.1.0 
20060810
Sep 14 09:30:46 intel kernel: [    7.614071] hidraw: raw HID events 
driver (C) Jiri Kosina
Sep 14 09:30:46 intel kernel: [    7.614148] Adaptec aacraid driver 
1.2-1[41066]-ms
Sep 14 09:30:46 intel kernel: [    7.625174] aacraid 0000:02:0e.0: 
Changed firmware to INTX mode
Sep 14 09:30:46 intel kernel: [    7.680931] scsi host1: ahci
Sep 14 09:30:46 intel kernel: [    7.681533] scsi host2: ahci
Sep 14 09:30:46 intel kernel: [    7.681631] scsi host3: ahci
Sep 14 09:30:46 intel kernel: [    7.681712] scsi host4: ahci
Sep 14 09:30:46 intel kernel: [    7.681791] scsi host5: ahci
Sep 14 09:30:46 intel kernel: [    7.681867] scsi host6: ahci
Sep 14 09:30:46 intel kernel: [    7.681917] ata1: SATA max UDMA/133 
abar m2048@0xf7c36000 port 0xf7c36100 irq 31
Sep 14 09:30:46 intel kernel: [    7.681920] ata2: SATA max UDMA/133 
abar m2048@0xf7c36000 port 0xf7c36180 irq 31
Sep 14 09:30:46 intel kernel: [    7.681922] ata3: SATA max UDMA/133 
abar m2048@0xf7c36000 port 0xf7c36200 irq 31
Sep 14 09:30:46 intel kernel: [    7.681924] ata4: SATA max UDMA/133 
abar m2048@0xf7c36000 port 0xf7c36280 irq 31
Sep 14 09:30:46 intel kernel: [    7.681927] ata5: SATA max UDMA/133 
abar m2048@0xf7c36000 port 0xf7c36300 irq 31
Sep 14 09:30:46 intel kernel: [    7.681929] ata6: SATA max UDMA/133 
abar m2048@0xf7c36000 port 0xf7c36380 irq 31
Sep 14 09:30:46 intel kernel: [    7.683064] e1000e: Intel(R) PRO/1000 
Network Driver - 3.2.6-k
Sep 14 09:30:46 intel kernel: [    7.683064] e1000e: Copyright(c) 1999 - 
2015 Intel Corporation.
Sep 14 09:30:46 intel kernel: [    7.683237] e1000e 0000:00:19.0: 
Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Sep 14 09:30:46 intel kernel: [    7.794212] usb-storage 6-3:1.0: USB 
Mass Storage device detected
Sep 14 09:30:46 intel kernel: [    7.797152] scsi host7: usb-storage 6-3:1.0
Sep 14 09:30:46 intel kernel: [    7.798269] usbcore: registered new 
interface driver usb-storage
Sep 14 09:30:46 intel kernel: [    7.830356] e1000e 0000:00:19.0 
0000:00:19.0 (uninitialized): registered PHC clock
Sep 14 09:30:46 intel kernel: [    7.899267] AAC0: kernel 5.2-0[15753] 
Sep  6 2008
Sep 14 09:30:46 intel kernel: [    7.899268] AAC0: monitor 5.2-0[15753]
Sep 14 09:30:46 intel kernel: [    7.899269] AAC0: bios 5.2-0[15753]
Sep 14 09:30:46 intel kernel: [    7.899271] AAC0: serial 9C501143429
Sep 14 09:30:46 intel kernel: [    7.899271] AAC0: Non-DASD support enabled.
Sep 14 09:30:46 intel kernel: [    7.899272] AAC0: 64bit support enabled.
Sep 14 09:30:46 intel kernel: [    7.899273] AAC0: 64 Bit DAC enabled
Sep 14 09:30:46 intel kernel: [    7.960872] usbcore: registered new 
interface driver uas
Sep 14 09:30:46 intel kernel: [    7.961921] scsi host0: aacraid
Sep 14 09:30:46 intel kernel: [    7.964472] e1000e 0000:00:19.0 eth0: 
(PCI Express:2.5GT/s:Width x1) 00:22:4d:aa:92:32
Sep 14 09:30:46 intel kernel: [    7.964474] e1000e 0000:00:19.0 eth0: 
Intel(R) PRO/1000 Network Connection
Sep 14 09:30:46 intel kernel: [    7.964509] e1000e 0000:00:19.0 eth0: 
MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
Sep 14 09:30:46 intel kernel: [    7.999899] ata1: SATA link down 
(SStatus 0 SControl 300)
Sep 14 09:30:46 intel kernel: [    7.999922] scsi 0:0:0:0: 
Direct-Access     Adaptec  Array 1          V1.0 PQ: 0 ANSI: 2
Sep 14 09:30:46 intel kernel: [    8.326651] ata2: SATA link down 
(SStatus 0 SControl 300)
Sep 14 09:30:46 intel kernel: [    8.401612] [drm] Memory usable by 
graphics device = 2048M
Sep 14 09:30:46 intel kernel: [    8.422861] checking generic (e0000000 
7f0000) vs hw (e0000000 10000000)
Sep 14 09:30:46 intel kernel: [    8.422865] fb: switching to inteldrmfb 
from VESA VGA
Sep 14 09:30:46 intel kernel: [    8.430718] usbcore: registered new 
interface driver usbhid
Sep 14 09:30:46 intel kernel: [    8.430719] usbhid: USB HID core driver
Sep 14 09:30:46 intel kernel: [    8.484695] Console: switching to 
colour dummy device 80x25
Sep 14 09:30:46 intel kernel: [    8.484794] [drm] Replacing VGA console 
driver
Sep 14 09:30:46 intel kernel: [    8.490530] [drm] Supports vblank 
timestamp caching Rev 2 (21.10.2013).
Sep 14 09:30:46 intel kernel: [    8.490538] [drm] Driver supports 
precise vblank timestamp query.
Sep 14 09:30:46 intel kernel: [    8.491236] e1000e 0000:00:19.0 eno1: 
renamed from eth0
Sep 14 09:30:46 intel kernel: [    8.496434] vgaarb: device changed 
decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Sep 14 09:30:46 intel kernel: [    8.498310] input: USB Optical Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5.2/2-1.5.2:1.0/0003:1BCF:0005.0004/input/input2
Sep 14 09:30:46 intel kernel: [    8.498910] hid-generic 
0003:1BCF:0005.0004: input,hidraw0: USB HID v1.10 Mouse [USB Optical 
Mouse] on usb-0000:00:1d.0-1.5.2/input0
Sep 14 09:30:46 intel kernel: [    8.499774] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5.1/2-1.5.1:1.0/0003:046A:0023.0001/input/input3
Sep 14 09:30:46 intel kernel: [    8.516209] scsi 0:1:0:0: 
Direct-Access     WDC      WD5003ABYX-01WER 1S01 PQ: 0 ANSI: 5
Sep 14 09:30:46 intel kernel: [    8.552576] cherry 0003:046A:0023.0001: 
input,hidraw1: USB HID v1.11 Keyboard [HID 046a:0023] on 
usb-0000:00:1d.0-1.5.1/input0
Sep 14 09:30:46 intel kernel: [    8.553683] scsi 0:1:1:0: 
Direct-Access     WDC      WD5002ABYS-02B1B 3B03 PQ: 0 ANSI: 5
Sep 14 09:30:46 intel kernel: [    8.559656] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5.1/2-1.5.1:1.1/0003:046A:0023.0002/input/input4
Sep 14 09:30:46 intel kernel: [    8.577631] scsi 0:1:2:0: 
Direct-Access     WDC      WD5002ABYS-02B1B 3B03 PQ: 0 ANSI: 5
Sep 14 09:30:46 intel kernel: [    8.601640] scsi 0:1:3:0: 
Direct-Access     WDC      WD5002ABYS-02B1B 3B03 PQ: 0 ANSI: 5
Sep 14 09:30:46 intel kernel: [    8.634657] ata3: SATA link down 
(SStatus 0 SControl 300)
Sep 14 09:30:46 intel kernel: [    8.664562] cherry 0003:046A:0023.0002: 
input,hidraw2: USB HID v1.11 Device [HID 046a:0023] on 
usb-0000:00:1d.0-1.5.1/input1
Sep 14 09:30:46 intel kernel: [    8.664670] input: HID 046a:0023 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5.1/2-1.5.1:1.2/0003:046A:0023.0003/input/input5
Sep 14 09:30:46 intel kernel: [    8.664739] cherry 0003:046A:0023.0003: 
input,hidraw3: USB HID v1.10 Mouse [HID 046a:0023] on 
usb-0000:00:1d.0-1.5.1/input2
Sep 14 09:30:46 intel kernel: [    8.690484] sd 0:0:0:0: [sda] 
1949728768 512-byte logical blocks: (998 GB/930 GiB)
Sep 14 09:30:46 intel kernel: [    8.690517] sd 0:0:0:0: Attached scsi 
generic sg0 type 0
Sep 14 09:30:46 intel kernel: [    8.690518] sd 0:0:0:0: [sda] Write 
Protect is off
Sep 14 09:30:46 intel kernel: [    8.690521] sd 0:0:0:0: [sda] Mode 
Sense: 12 00 10 08
Sep 14 09:30:46 intel kernel: [    8.690539] sd 0:0:0:0: [sda] Write 
cache: disabled, read cache: enabled, supports DPO and FUA
Sep 14 09:30:46 intel kernel: [    8.691319] scsi 0:1:0:0: Attached scsi 
generic sg1 type 0
Sep 14 09:30:46 intel kernel: [    8.691441] scsi 0:1:1:0: Attached scsi 
generic sg2 type 0
Sep 14 09:30:46 intel kernel: [    8.691532] scsi 0:1:2:0: Attached scsi 
generic sg3 type 0
Sep 14 09:30:46 intel kernel: [    8.691622] scsi 0:1:3:0: Attached scsi 
generic sg4 type 0
Sep 14 09:30:46 intel kernel: [    8.719266]  sda: sda1 sda2 < sda5 >
Sep 14 09:30:46 intel kernel: [    8.719568] sd 0:0:0:0: [sda] Attached 
SCSI removable disk
Sep 14 09:30:46 intel kernel: [    8.797586] scsi 7:0:0:0: 
Direct-Access     WD       Elements 1078    1065 PQ: 0 ANSI: 6
Sep 14 09:30:46 intel kernel: [    8.797796] sd 7:0:0:0: Attached scsi 
generic sg5 type 0
Sep 14 09:30:46 intel kernel: [    8.798917] sd 7:0:0:0: [sdb] 
2930210816 512-byte logical blocks: (1.50 TB/1.36 TiB)
Sep 14 09:30:46 intel kernel: [    8.800167] sd 7:0:0:0: [sdb] Write 
Protect is off
Sep 14 09:30:46 intel kernel: [    8.800174] sd 7:0:0:0: [sdb] Mode 
Sense: 53 00 10 08
Sep 14 09:30:46 intel kernel: [    8.801423] sd 7:0:0:0: [sdb] No 
Caching mode page found
Sep 14 09:30:46 intel kernel: [    8.801431] sd 7:0:0:0: [sdb] Assuming 
drive cache: write through
Sep 14 09:30:46 intel kernel: [    8.840488] AAC: Host adapter dead -1
Sep 14 09:30:46 intel kernel: [    8.898228] fbcon: inteldrmfb (fb0) is 
primary device
Sep 14 09:30:46 intel kernel: [    8.942767] ata4: SATA link up 1.5 Gbps 
(SStatus 113 SControl 300)
Sep 14 09:30:46 intel kernel: [    8.946831] ata4.00: ACPI cmd 
ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Sep 14 09:30:46 intel kernel: [    8.946833] ata4.00: ACPI cmd 
f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Sep 14 09:30:46 intel kernel: [    8.946835] ata4.00: ACPI cmd 
b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Sep 14 09:30:46 intel kernel: [    8.949531] ata4.00: ATAPI: HL-DT-ST 
DVDRAM GH22NS40, NL01, max UDMA/100
Sep 14 09:30:46 intel kernel: [    8.954423] ata4.00: ACPI cmd 
ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Sep 14 09:30:46 intel kernel: [    8.954425] ata4.00: ACPI cmd 
f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Sep 14 09:30:46 intel kernel: [    8.954427] ata4.00: ACPI cmd 
b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Sep 14 09:30:46 intel kernel: [    8.957133] ata4.00: configured for 
UDMA/100
Sep 14 09:30:46 intel kernel: [    8.965763] scsi 4:0:0:0: 
CD-ROM            HL-DT-ST DVDRAM GH22NS40  NL01 PQ: 0 ANSI: 5
Sep 14 09:30:46 intel kernel: [    8.988153] sr 4:0:0:0: [sr0] scsi3-mmc 
drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Sep 14 09:30:46 intel kernel: [    8.988154] cdrom: Uniform CD-ROM 
driver Revision: 3.20
Sep 14 09:30:46 intel kernel: [    8.988284] sr 4:0:0:0: Attached scsi 
CD-ROM sr0
Sep 14 09:30:46 intel kernel: [    8.988349] sr 4:0:0:0: Attached scsi 
generic sg6 type 5
Sep 14 09:30:46 intel kernel: [    9.270405] ACPI: Video Device [GFX0] 
(multi-head: yes  rom: no  post: no)
Sep 14 09:30:46 intel kernel: [    9.298904] ata5: SATA link down 
(SStatus 0 SControl 300)
Sep 14 09:30:46 intel kernel: [    9.426917] Console: switching to 
colour frame buffer device 240x67
Sep 14 09:30:46 intel kernel: [    9.446739]  sdb: sdb1
Sep 14 09:30:46 intel kernel: [    9.449966] sd 7:0:0:0: [sdb] Attached 
SCSI disk
Sep 14 09:30:46 intel kernel: [    9.606720] ata6: SATA link down 
(SStatus 0 SControl 300)
Sep 14 09:30:46 intel kernel: [    9.744477] AAC: Host adapter dead -1
Sep 14 09:30:46 intel kernel: [   10.197470] acpi device:49: registered 
as cooling_device9
Sep 14 09:30:46 intel kernel: [   10.197563] input: Video Bus as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
Sep 14 09:30:46 intel kernel: [   10.197644] [drm] Initialized i915 
1.6.0 20160425 for 0000:00:02.0 on minor 0
Sep 14 09:30:46 intel kernel: [   10.197919] i915 0000:00:02.0: fb0: 
inteldrmfb frame buffer device
Sep 14 09:30:46 intel kernel: [   10.626395] EXT4-fs (sda1): mounted 
filesystem with ordered data mode. Opts: (null)
Sep 14 09:30:46 intel kernel: [   10.728817] random: nonblocking pool is 
initialized
Sep 14 09:30:46 intel kernel: [   13.161696] ip_tables: (C) 2000-2006 
Netfilter Core Team
Sep 14 09:30:46 intel kernel: [   13.177723] lp: driver loaded but no 
devices found
Sep 14 09:30:46 intel kernel: [   13.214570] ppdev: user-space parallel 
port driver
Sep 14 09:30:46 intel kernel: [   13.294482] parport_pc 00:05: reported 
by Plug and Play ACPI
Sep 14 09:30:46 intel kernel: [   13.295589] parport0: PC-style at 
0x378, irq 5 [PCSPP]
Sep 14 09:30:46 intel kernel: [   13.392400] lp0: using parport0 
(interrupt-driven).
Sep 14 09:30:46 intel kernel: [   13.556039] nf_conntrack version 0.5.0 
(65536 buckets, 262144 max)
Sep 14 09:30:46 intel kernel: [   14.084276] ip6_tables: (C) 2000-2006 
Netfilter Core Team
Sep 14 09:30:46 intel kernel: [   14.338800] EXT4-fs (sda1): re-mounted. 
Opts: errors=remount-ro
Sep 14 09:30:46 intel kernel: [   15.037059] ACPI Warning: SystemIO 
range 0x0000000000000428-0x000000000000042F conflicts with OpRegion 
0x0000000000000400-0x000000000000047F (\PMIO) (20160422/utaddress-255)
Sep 14 09:30:46 intel kernel: [   15.037067] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Sep 14 09:30:46 intel kernel: [   15.037071] ACPI Warning: SystemIO 
range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20160422/utaddress-255)
Sep 14 09:30:46 intel kernel: [   15.037075] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Sep 14 09:30:46 intel kernel: [   15.037077] ACPI Warning: SystemIO 
range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20160422/utaddress-255)
Sep 14 09:30:46 intel kernel: [   15.037081] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Sep 14 09:30:46 intel kernel: [   15.037082] ACPI Warning: SystemIO 
range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20160422/utaddress-255)
Sep 14 09:30:46 intel kernel: [   15.037087] ACPI Warning: SystemIO 
range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 
0x000000000000050F-0x000000000000050F (\_SB.PCI0.RLED.DBG0) 
(20160422/utaddress-255)
Sep 14 09:30:46 intel kernel: [   15.037091] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Sep 14 09:30:46 intel kernel: [   15.037092] lpc_ich: Resource 
conflict(s) found affecting gpio_ich
Sep 14 09:30:46 intel kernel: [   15.175120] shpchp: Standard Hot Plug 
PCI Controller Driver version: 0.4
Sep 14 09:30:46 intel kernel: [   16.050292] Adding 8275964k swap on 
/dev/sda5.  Priority:-1 extents:1 across:8275964k FS
Sep 14 09:30:46 intel kernel: [   16.072675] usblp 1-1.4:1.0: usblp0: 
USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04E8 pid 0x329F
Sep 14 09:30:46 intel kernel: [   16.072701] usbcore: registered new 
interface driver usblp
Sep 14 09:30:46 intel kernel: [   16.587844] audit: type=1400 
audit(1473838244.841:2): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/snapd/snap-confine" pid=3545 comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.631569] audit: type=1400 
audit(1473838244.885:3): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/lightdm/lightdm-guest-session" pid=3541 
comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.631575] audit: type=1400 
audit(1473838244.885:4): apparmor="STATUS" operation="profile_load" 
name="chromium" pid=3541 comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.638293] audit: type=1400 
audit(1473838244.893:5): apparmor="STATUS" operation="profile_load" 
name="/sbin/dhclient" pid=3542 comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.638298] audit: type=1400 
audit(1473838244.893:6): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3542 
comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.638301] audit: type=1400 
audit(1473838244.893:7): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=3542 
comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.638303] audit: type=1400 
audit(1473838244.893:8): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/connman/scripts/dhclient-script" pid=3542 
comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.639287] audit: type=1400 
audit(1473838244.893:9): apparmor="STATUS" operation="profile_load" 
name="/usr/sbin/ippusbxd" pid=3566 comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.664391] audit: type=1400 
audit(1473838244.921:10): apparmor="STATUS" operation="profile_load" 
name="/usr/sbin/cups-browsed" pid=3561 comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.682320] audit: type=1400 
audit(1473838244.937:11): apparmor="STATUS" operation="profile_load" 
name="/usr/lib/cups/backend/cups-pdf" pid=3565 comm="apparmor_parser"
Sep 14 09:30:46 intel kernel: [   16.727068] intel_rapl: Found RAPL 
domain package
Sep 14 09:30:46 intel kernel: [   16.727072] intel_rapl: Found RAPL 
domain core
Sep 14 09:30:46 intel kernel: [   16.727074] intel_rapl: Found RAPL 
domain uncore
Sep 14 09:30:46 intel kernel: [   17.334254] snd_hda_codec_realtek 
hdaudioC0D2: autoconfig for ALC892: line_outs=3 (0x14/0x15/0x16/0x0/0x0) 
type:line
Sep 14 09:30:46 intel kernel: [   17.334257] snd_hda_codec_realtek 
hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
Sep 14 09:30:46 intel kernel: [   17.334259] snd_hda_codec_realtek 
hdaudioC0D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
Sep 14 09:30:46 intel kernel: [   17.334260] snd_hda_codec_realtek 
hdaudioC0D2:    mono: mono_out=0x0
Sep 14 09:30:46 intel kernel: [   17.334261] snd_hda_codec_realtek 
hdaudioC0D2:    dig-out=0x11/0x1e
Sep 14 09:30:46 intel kernel: [   17.334262] snd_hda_codec_realtek 
hdaudioC0D2:    inputs:
Sep 14 09:30:46 intel kernel: [   17.334264] snd_hda_codec_realtek 
hdaudioC0D2:      Front Mic=0x19
Sep 14 09:30:46 intel kernel: [   17.334265] snd_hda_codec_realtek 
hdaudioC0D2:      Rear Mic=0x18
Sep 14 09:30:46 intel kernel: [   17.334266] snd_hda_codec_realtek 
hdaudioC0D2:      Line=0x1a
Sep 14 09:30:46 intel kernel: [   17.410093] snd_hda_intel 0000:00:1b.0: 
bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
Sep 14 09:30:46 intel kernel: [   17.847789] input: HDA Intel PCH Rear 
Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
Sep 14 09:30:46 intel kernel: [   17.847848] input: HDA Intel PCH Line 
as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Sep 14 09:30:46 intel kernel: [   17.847896] input: HDA Intel PCH Line 
Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Sep 14 09:30:46 intel kernel: [   17.848009] input: HDA Intel PCH Line 
Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
Sep 14 09:30:46 intel kernel: [   17.848056] input: HDA Intel PCH Line 
Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
Sep 14 09:30:46 intel kernel: [   17.848101] input: HDA Intel PCH 
HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Sep 14 09:30:46 intel kernel: [   17.848142] input: HDA Intel PCH 
HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
Sep 14 09:30:48 intel kernel: [   19.744134] AAC: Host adapter dead -1
Sep 14 09:30:49 intel kernel: [   21.254241] IPv6: ADDRCONF(NETDEV_UP): 
eno1: link is not ready
Sep 14 09:30:49 intel kernel: [   21.508219] IPv6: ADDRCONF(NETDEV_UP): 
eno1: link is not ready
Sep 14 09:30:52 intel kernel: [   24.373156] usblp0: removed
Sep 14 09:30:52 intel kernel: [   24.375630] usblp 1-1.4:1.0: usblp0: 
USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04E8 pid 0x329F
Sep 14 09:30:52 intel kernel: [   24.509892] e1000e: eno1 NIC Link is Up 
1000 Mbps Full Duplex, Flow Control: Rx/Tx
Sep 14 09:30:52 intel kernel: [   24.509929] IPv6: 
ADDRCONF(NETDEV_CHANGE): eno1: link becomes ready
Sep 14 09:30:58 intel kernel: [   29.743826] AAC: Host adapter dead -1
Sep 14 09:31:08 intel kernel: [   39.743526] AAC: Host adapter dead -1
Sep 14 09:31:09 intel kernel: [   39.899510] AAC: Host adapter dead -1
Sep 14 09:31:19 intel kernel: [   49.899695] AAC: Host adapter dead -1
Sep 14 09:31:29 intel kernel: [   59.900550] AAC: Host adapter dead -1
Sep 14 09:31:39 intel kernel: [   69.900882] AAC: Host adapter dead -1
Sep 14 09:31:49 intel kernel: [   79.900854] AAC: Host adapter dead -1
Sep 14 09:31:59 intel kernel: [   89.900708] AAC: Host adapter dead -1
Sep 14 09:32:09 intel kernel: [   99.900481] AAC: Host adapter dead -1
Sep 14 09:32:19 intel kernel: [  109.900214] AAC: Host adapter dead -1
Sep 14 09:32:29 intel kernel: [  119.902029] AAC: Host adapter dead -1
Sep 14 09:32:39 intel kernel: [  129.903539] AAC: Host adapter dead -1
Sep 14 09:32:49 intel kernel: [  139.904633] AAC: Host adapter dead -1
Sep 14 09:32:59 intel kernel: [  149.905424] AAC: Host adapter dead -1

Best regards,
Matthias
