From: Srihari Vijayaraghavan <harisri@bigpond.com>
Subject: Re: 2.5.65 and cciss
Date: Mon, 24 Mar 2003 22:38:10 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303242238.11095.harisri@bigpond.com>
References: <20030321024743.GA2267@zuul.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030321024743.GA2267@zuul.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: steve.cameron@hp.com
Cc: linux-scsi@vger.kernel.org

Hello Steve,

On Friday 21 March 2003 13:47, Stephen Cameron wrote:
> ...
> Ok, .config would help to duplicate the problem.
> Also, console output (dmesg output) if it's not
> too inconvenient.  (you might have to hook up a
> serial console to capture it.)

The dmesg output using the serial console:
---------------------------------------------------------------
Linux version 2.5.65 (root@dl380) (gcc version 3.2 20020903 (Red Hat Linux 8.0 
3.2-7)) #3 SMP Mon Mar 24 15:30:37 EST 2003
Video mode to be used for restore is ffff
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffa000 (usable)
 BIOS-e820: 000000003fffa000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f4fd0
hm, page 000f4000 reserved twice.
hm, page 000f5000 reserved twice.
hm, page 000f2000 reserved twice.
hm, page 000f3000 reserved twice.
On node 0 totalpages: 262138
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 32762 pages, LIFO batch:7
ACPI: RSDP (v000 COMPAQ                     ) @ 0x000f4f70
ACPI: RSDT (v001 COMPAQ P29      00000.00002) @ 0x3fffa000
ACPI: FADT (v001 COMPAQ P29      00000.00002) @ 0x3fffa040
ACPI: MADT (v001 COMPAQ 00000083 00000.00002) @ 0x3fffa100
ACPI: SPCR (v001 COMPAQ SPCRRBSU 00000.00001) @ 0x3fffa1c0
ACPI: DSDT (v001 COMPAQ     DSDT 00000.00001) @ 0x00000000
ACPI: BIOS passes blacklist
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0xff] polarity[0x0] trigger[0x0] lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] global_irq_base[0x0])
IOAPIC[0]: Assigned apic_id 2
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, IRQ 0-15
ACPI: IOAPIC (id[0x03] address[0xfec01000] global_irq_base[0x10])
IOAPIC[1]: Assigned apic_id 3
IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, IRQ 16-31
ACPI: IOAPIC (id[0x04] address[0xfec02000] global_irq_base[0x20])
IOAPIC[2]: Assigned apic_id 4
IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, IRQ 32-47
ACPI: IOAPIC (id[0x05] address[0xfec03000] global_irq_base[0x30])
IOAPIC[3]: Assigned apic_id 5
IOAPIC[3]: apic_id 5, version 17, address 0xfec03000, IRQ 48-63
ACPI: INT_SRC_OVR (bus[0] irq[0x0] global_irq[0x2] polarity[0x1] trigger[0x1])
Enabling APIC mode:  Flat.  Using 4 I/O APICs
Using ACPI (MADT) for SMP configuration information
Building zonelist for node : 0
Kernel command line: ro root=/dev/cciss/c0d0p5 console=ttyS03
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 2787.238 MHz processor.
Console: colour VGA+ 80x25
Calibrating delay loop... 5505.02 BogoMIPS
Memory: 1033920k/1048552k available (1668k kernel code, 13708k reserved, 725k 
data, 328k init, 131048k highmem)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
-> /dev
-> /dev/console
-> /root
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU#0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#0: Thermal monitoring enabled
Machine check exception polling timer started.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 07
per-CPU timeslice cutoff: 1462.49 usecs.
task migration cache decay timeout: 2 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Booting processor 1/1 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 5554.17 BogoMIPS
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU#1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.80GHz stepping 07
Booting processor 2/6 eip 2000
Initializing CPU#2
masked ExtINT on CPU#2
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 5554.17 BogoMIPS
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU#2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.80GHz stepping 07
Booting processor 3/7 eip 2000
Initializing CPU#3
masked ExtINT on CPU#3
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 5554.17 BogoMIPS
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU#3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.80GHz stepping 07
Total of 4 processors activated (22167.55 BogoMIPS).
cpu_sibling_map[0] = 1
cpu_sibling_map[1] = 0
cpu_sibling_map[2] = 3
cpu_sibling_map[3] = 2
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=0
testing the IO APIC.......................




.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 2787.0176 MHz.
..... host bus clock speed is 99.0541 MHz.
checking TSC synchronization across 4 CPUs: passed.
Starting migration thread for cpu 0
Bringing up 1
CPU 1 IS NOW UP!
Starting migration thread for cpu 1
Bringing up 2
CPU 2 IS NOW UP!
Starting migration thread for cpu 2
Bringing up 3
CPU 3 IS NOW UP!
Starting migration thread for cpu 3
CPUS done 32
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
mtrr: v2.0 (20020519)
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
PCI: PCI BIOS revision 2.10 entry at 0xf0094, last bus=9
PCI: Using configuration type 1
BIO: pool of 256 setup, 14Kb (56 bytes/bio)
biovec pool[0]:   1 bvecs: 256 entries (12 bytes)
biovec pool[1]:   4 bvecs: 256 entries (48 bytes)
biovec pool[2]:  16 bvecs: 256 entries (192 bytes)
biovec pool[3]:  64 bvecs: 256 entries (768 bytes)
biovec pool[4]: 128 bvecs: 256 entries (1536 bytes)
biovec pool[5]: 256 bvecs: 256 entries (3072 bytes)
ACPI: Subsystem revision 20030228
 tbxface-0117 [03] acpi_load_tables      : ACPI Tables successfully acquired
Parsing all Control 
Methods:..................................................................................................................
Table [DSDT] - 632 Objects with 41 Devices 114 Methods 11 Regions
ACPI Namespace successfully loaded at root c03df15c
evxfevnt-0092 [04] acpi_enable           : Transition to ACPI mode successful
   evgpe-0416 [06] ev_create_gpe_block   : GPE Block: 4 registers at 
0000000000000930
   evgpe-0421 [06] ev_create_gpe_block   : GPE Block defined as GPE0 to GPE31
Executing all Device _STA and_INI 
methods:.........................................
41 Devices found containing: 41 _STA, 0 _INI methods
Completing Region/Field/Buffer/Package 
initialization:.............................................................................................................................................................................................................................................................................
Initialized 8/11 Regions 197/197 Fields 59/59 Buffers 5/5 Packages (632 nodes)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 00:0f.1
ACPI: PCI Root Bridge [PCI1] (00:01)
PCI: Probing PCI hardware (bus 01)
ACPI: PCI Root Bridge [PCI2] (00:02)
PCI: Probing PCI hardware (bus 02)
ACPI: PCI Root Bridge [PCI3] (00:03)
PCI: Probing PCI hardware (bus 03)
ACPI: PCI Root Bridge [PCI4] (00:06)
PCI: Probing PCI hardware (bus 06)
ACPI: PCI Interrupt Link [IUSB] (IRQs 4 5 *7 10 11 15)
ACPI: PCI Interrupt Link [IN16] (IRQs 4 5 7 10 11 15, enabled at IRQ 3)
ACPI: PCI Interrupt Link [IN17] (IRQs 4 *5 7 10 11 15)
ACPI: PCI Interrupt Link [IN18] (IRQs 4 5 7 10 11 15, enabled at IRQ 3)
ACPI: PCI Interrupt Link [IN19] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN20] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN21] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN22] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN23] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN24] (IRQs 4 5 7 10 11 *15)
ACPI: PCI Interrupt Link [IN25] (IRQs 4 5 7 10 *11 15)
ACPI: PCI Interrupt Link [IN26] (IRQs 4 5 *7 10 11 15)
ACPI: PCI Interrupt Link [IN27] (IRQs 4 *5 7 10 11 15)
ACPI: PCI Interrupt Link [IN28] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN29] (IRQs 4 5 7 10 *11 15)
ACPI: PCI Interrupt Link [IN30] (IRQs 4 5 7 *10 11 15)
ACPI: PCI Interrupt Link [IN31] (IRQs 4 5 7 10 11 *15)
ACPI: PCI Interrupt Link [IN32] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN33] (IRQs 4 5 7 10 11 15, disabled)
ACPI: PCI Interrupt Link [IN34] (IRQs 4 5 7 10 11 15, disabled)
block request queues:
 128 requests per read queue
 128 requests per write queue
 8 requests per batch
 enter congestion at 15
 exit congestion at 17
SCSI subsystem initialized
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN19] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN20] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN21] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN22] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN23] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN28] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN32] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN33] enabled at IRQ 0
pci_link-0349 [34] acpi_pci_link_set     : Link disabled
ACPI: PCI Interrupt Link [IN34] enabled at IRQ 0
PCI: Using ACPI for IRQ routing
PCI: if you experience problems, try using option 'pci=noacpi' or even 
'acpi=off'
PCI: Device 00:00 not found by BIOS
PCI: Device 00:01 not found by BIOS
PCI: Device 00:02 not found by BIOS
PCI: Device 00:78 not found by BIOS
PCI: Device 00:7b not found by BIOS
PCI: Device 00:80 not found by BIOS
PCI: Device 00:82 not found by BIOS
PCI: Device 00:88 not found by BIOS
PCI: Device 00:8a not found by BIOS
Starting balanced_irq
Enabling SEP on CPU 1
Enabling SEP on CPU 2
Enabling SEP on CPU 3
Enabling SEP on CPU 0
highmem bounce pool size: 64 pages
Journalled Block Device driver loaded
ACPI: Power Button (FF) [PWRF]
ACPI: Processor [CPU0] (supports C1)
ACPI: Processor [CPU1] (supports C1)
ACPI: Processor [CPU2] (supports C1)
ACPI: Processor [CPU3] (supports C1)
[ACPI Debug] String: _TMP Method
[ACPI Debug] String: _CRT Method
[ACPI Debug] String: _PSV Method
[ACPI Debug] String: _TMP Method
ACPI: Thermal Zone [THM0] (8 C)
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.11
Serial: 8250/16550 driver $Revision: 1.90 $ IRQ sharing disabled
ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
Compaq CISS Driver (v 2.5.0)
cciss: using DAC cycles
      blocks= 142245120 block_size= 512
      heads= 255, sectors= 32, cylinders= 17432

 cciss/c0d0: p1 p2 p3 p4 < p5 p6 p7 >
Intel(R) PRO/1000 Network Driver - version 4.4.19-k3
Copyright (c) 1999-2002 Intel Corporation.
eth0: Intel(R) PRO/1000 Network Connection
eth1: Intel(R) PRO/1000 Network Connection
eth2: Intel(R) PRO/1000 Network Connection
eth3: Intel(R) PRO/1000 Network Connection
tg3.c:v1.4c (Feb 18, 2003)
eth4: Tigon3 [partno(TBD) rev 1002 PHY(5703)] (PCIX:100MHz:64-bit) 
10/100/1000BaseT Ethernet 00:0b:cd:0f:63:7d
eth5: Tigon3 [partno(TBD) rev 1002 PHY(5703)] (PCIX:100MHz:64-bit) 
10/100/1000BaseT Ethernet 00:0b:cd:0f:63:7c
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks CSB5: IDE controller at PCI slot 00:0f.1
SvrWks CSB5: chipset revision 147
SvrWks CSB5: not 100% native mode: will probe irqs later
SvrWks CSB5: simplex device: DMA forced
    ide0: BM-DMA at 0x2000-0x2007, BIOS settings: hda:pio, hdb:pio
SvrWks CSB5: simplex device: DMA forced
    ide1: BM-DMA at 0x2008-0x200f, BIOS settings: hdc:pio, hdd:pio
hda: COMPAQ CD-ROM SN-124, ATAPI CD/DVD-ROM drive
hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hda: set_drive_speed_status: error=0x04
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.12
end_request: I/O error, dev hda, sector 0
mice: PS/2 mouse device common for all mice
input: PS/2 Generic Mouse on isa0060/serio1
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
NET4: Linux TCP/IP 1.0 for NET4.0
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
VFS: Cannot open root device "cciss/c0d0p5" or unknown-block(0,0)
Please append a correct "root=" boot option
Kernel panic: VFS: Unable to mount root fs on unknown-block(0,0)

Here is the .config:
---------------------------
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_UID16=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_EXPERIMENTAL=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSCTL=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_X86_PC=y
CONFIG_MPENTIUM4=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_XADD=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_PREFETCH=y
CONFIG_X86_SSE2=y
CONFIG_SMP=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_NR_CPUS=32
CONFIG_X86_TSC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_HIGHMEM4G=y
CONFIG_HIGHMEM=y
CONFIG_HIGHPTE=y
CONFIG_MTRR=y
CONFIG_HAVE_DEC_LOCK=y
CONFIG_ACPI=y
CONFIG_ACPI_BOOT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_BUS=y
CONFIG_ACPI_INTERPRETER=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_PCI=y
CONFIG_ACPI_SYSTEM=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_NAMES=y
CONFIG_KCORE_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_IDEDMA_PCI_AUTO=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_BLK_DEV_ADMA=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_IDEDMA_AUTO=y
CONFIG_BLK_DEV_IDE_MODES=y
CONFIG_SCSI=y
CONFIG_BLK_DEV_SD=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_REPORT_LUNS=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_FILTER=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IPV6_SCTP__=y
CONFIG_NETDEVICES=y
CONFIG_NET_ETHERNET=y
CONFIG_NET_PCI=y
CONFIG_EEPRO100=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000_NAPI=y
CONFIG_TIGON3=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_SOUND_GAMEPORT=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_UNIX98_PTY_COUNT=256
CONFIG_HW_RANDOM=y
CONFIG_RTC=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=y
CONFIG_JBD=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_PROC_FS=y
CONFIG_DEVPTS_FS=y
CONFIG_TMPFS=y
CONFIG_RAMFS=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_KALLSYMS=y
CONFIG_X86_EXTRA_IRQS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y

I see the same kernel boot parameters in 2.4.21-pre5, and it works fine there 
however.

Thanks for your help (BTW it's a HP/Compaq DL380 Generation 3 computer).
-- 
Hari
harisri@bigpond.com

