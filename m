From: maple@maple.org.ua
Subject: test9, aic79xx raise errors
Date: Sun, 16 Nov 2003 16:11:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031116141128.GA6557@valinor.localnet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ua-online.net ([213.179.225.6]:63751 "EHLO center.hqhost.net")
	by vger.kernel.org with ESMTP id S262794AbTKPOMe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2003 09:12:34 -0500
Received: from valinor.localnet (valinor.localnet [10.10.1.2])
	by center.hqhost.net (8.12.10/8.12.10/Debian-4) with ESMTP id hAGECMbY005512
	for <linux-scsi@vger.kernel.org>; Sun, 16 Nov 2003 16:12:23 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: maple@center.hqhost.net


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

after upgrading kernel on machine to 2.6.0-test9 aic79xx driver 
stops working.

problem raises just after 
cat /dev/sd{a,b} >/dev/null

in 2.4.22 all is fine
disabling TCQ and acpi=off didnt help. also tried other drivers (aic7xxx,
aic7xxx_old), they dont see the card

# lspci | grep SCSI
02:06.0 SCSI storage controller: Adaptec ASC-29320LP U320 (rev 03)

machine is dual xeon 2.4 with 4G RAM and two IBM 40G disks
kernel dmesg and /proc/scsi/aic79xx/0 attached
If you need more info, let me know (please CC as I'm not subscribed to
the list)

        SY, Vladimir

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=aic_dmesg

Linux version 2.6.0-test9 (root@localhost) (gcc version 2.95.4 20011002 (Debian prerelease)) #8 SMP Sun Nov 16 06:21:44 EST 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000eff70000 (usable)
 BIOS-e820: 00000000eff70000 - 00000000eff7f000 (ACPI data)
 BIOS-e820: 00000000eff7f000 - 00000000eff80000 (ACPI NVS)
 BIOS-e820: 00000000eff80000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000110000000 (usable)
Warning only 4GB will be used.
Use a PAE enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6550
hm, page 000f6000 reserved twice.
hm, page 000f7000 reserved twice.
hm, page 0009f000 reserved twice.
hm, page 000a0000 reserved twice.
On node 0 totalpages: 1048576
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 819200 pages, LIFO batch:16
DMI present.
ACPI: RSDP (v000 PTLTD                                     ) @ 0x000f64b0
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0xeff7b6fd
ACPI: FADT (v001 INTEL  PLACER   0x06040000 PTL  0x00000008) @ 0xeff7eee0
ACPI: MADT (v001 PTLTD  	 APIC   0x06040000  LTP 0x00000000) @ 0xeff7ef54
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0xeff7efd8
ACPI: DSDT (v001   TYAN    S2665 0x06040000 MSFT 0x0100000d) @ 0x00000000
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] polarity[0x1] trigger[0x1] lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] polarity[0x1] trigger[0x1] lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] polarity[0x1] trigger[0x1] lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] polarity[0x1] trigger[0x1] lint[0x1])
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID:   Product ID: PLACER CRB   APIC at: 0xFEE00000
I/O APIC #2 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 4
Building zonelist for node : 0
Kernel command line: auto BOOT_IMAGE=2.6 ro root=901 log_buf_len=64k profile=2
log_buf_len: 65536
kernel profiling enabled
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 2392.326 MHz processor.
Console: colour VGA+ 80x25
Memory: 3883292k/4194304k available (2101k kernel code, 47112k reserved, 744k data, 332k init, 3014080k highmem)
Calibrating delay loop... 4718.59 BogoMIPS
Security Scaffold v1.0.0 initialized
Capability LSM initialized
Dentry cache hash table entries: 524288 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 262144 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU:     After generic identify, caps: bfebfbff 00000000 00000000 00000000
CPU:     After vendor identify, caps: bfebfbff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU:     After all inits, caps: bfebfbff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU#0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#0: Thermal monitoring enabled
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
per-CPU timeslice cutoff: 1462.89 usecs.
task migration cache decay timeout: 2 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Booting processor 1/1 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 4767.74 BogoMIPS
CPU:     After generic identify, caps: bfebfbff 00000000 00000000 00000000
CPU:     After vendor identify, caps: bfebfbff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU:     After all inits, caps: bfebfbff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU#1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Booting processor 2/6 eip 2000
Initializing CPU#2
masked ExtINT on CPU#2
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 4767.74 BogoMIPS
CPU:     After generic identify, caps: bfebfbff 00000000 00000000 00000000
CPU:     After vendor identify, caps: bfebfbff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU:     After all inits, caps: bfebfbff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU#2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Booting processor 3/7 eip 2000
Initializing CPU#3
masked ExtINT on CPU#3
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 4767.74 BogoMIPS
CPU:     After generic identify, caps: bfebfbff 00000000 00000000 00000000
CPU:     After vendor identify, caps: bfebfbff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU:     After all inits, caps: bfebfbff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU#3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU#3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Total of 4 processors activated (19021.82 BogoMIPS).
cpu_sibling_map[0] = 1
cpu_sibling_map[1] = 0
cpu_sibling_map[2] = 3
cpu_sibling_map[3] = 2
ENABLING IO-APIC IRQs
Setting 2 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 2 ... ok.
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-5, 2-11, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 pin1=2 pin2=0
number of MP IRQ sources: 18.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................
IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00178020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0020
.... register #02: 00000000
.......     : arbitration: 00
.... register #03: 00000001
.......     : Boot DT    : 1
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 001 01  0    0    0   0   0    1    1    39
 02 001 01  0    0    0   0   0    1    1    31
 03 001 01  0    0    0   0   0    1    1    41
 04 001 01  0    0    0   0   0    1    1    49
 05 000 00  1    0    0   0   0    0    0    00
 06 001 01  0    0    0   0   0    1    1    51
 07 001 01  0    0    0   0   0    1    1    59
 08 001 01  0    0    0   0   0    1    1    61
 09 001 01  0    0    0   0   0    1    1    69
 0a 001 01  0    0    0   0   0    1    1    71
 0b 000 00  1    0    0   0   0    0    0    00
 0c 001 01  0    0    0   0   0    1    1    79
 0d 001 01  0    0    0   0   0    1    1    81
 0e 001 01  0    0    0   0   0    1    1    89
 0f 001 01  0    0    0   0   0    1    1    91
 10 001 01  1    1    0   1   0    1    1    99
 11 001 01  1    1    0   1   0    1    1    A1
 12 001 01  1    1    0   1   0    1    1    A9
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ16 -> 0:16
IRQ17 -> 0:17
IRQ18 -> 0:18
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 2391.0654 MHz.
..... host bus clock speed is 132.0869 MHz.
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
CPUS done 4
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd915, last bus=2
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX [8086/24c0] at 0000:00:1f.0
PCI->APIC IRQ transform: (B0,I31,P0) -> 17
PCI->APIC IRQ transform: (B0,I31,P1) -> 17
PCI->APIC IRQ transform: (B2,I3,P0) -> 18
PCI->APIC IRQ transform: (B2,I4,P0) -> 16
PCI->APIC IRQ transform: (B2,I6,P0) -> 17
SBF: Simple Boot Flag extension found and enabled.
SBF: Setting boot flags 0x80
Machine check exception polling timer started.
Starting balanced_irq
ikconfig 0.7 with /proc/config*
highmem bounce pool size: 64 pages
SGI XFS for Linux with no debug enabled
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.12
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
eepro100.c:v1.09j-t 9/29/99 Donald Becker http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
eth0: 0000:02:03.0, 00:E0:81:26:C0:F0, IRQ 18.
  Board assembly 567812-052, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0xd0a6c714).
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1420-0x1427, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1428-0x142f, BIOS settings: hdc:pio, hdd:pio
hda: ST340014A, ATA DISK drive
Using anticipatory io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 1024KiB
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.9
        <Adaptec 29320LP Ultra320 SCSI adapter>
        aic7901A: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs

(scsi0:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
(scsi0:A:1): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S21E
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S21E
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 71687340 512-byte hdwr sectors (36704 MB)
SCSI device sda: drive cache: write back
 sda: unknown partition table
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 71687340 512-byte hdwr sectors (36704 MB)
SCSI device sdb: drive cache: write back
 sdb: unknown partition table
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
mice: PS/2 mouse device common for all mice
input: ImExPS/2 Generic Explorer Mouse on isa0060/serio1
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Translated Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :  2756.000 MB/sec
   8regs_prefetch:  2256.000 MB/sec
   32regs    :  1988.000 MB/sec
   32regs_prefetch:  1752.000 MB/sec
   pIII_sse  :  3060.000 MB/sec
   pII_mmx   :  3916.000 MB/sec
   p5_mmx    :  3828.000 MB/sec
raid5: using function: pIII_sse (3060.000 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 16384 buckets, 256Kbytes
TCP: Hash tables configured (established 262144 bind 43690)
NET: Registered protocol family 1
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda6 ...
md:  adding hda6 ...
md:  adding hda5 ...
md: hda2 has different UUID to hda6
md: hda1 has different UUID to hda6
md: created md2
md: bind<hda5>
md2: WARNING: hda6 appears to be on the same physical disk as hda5. True
     protection against single-disk failure might be compromised.
md: bind<hda6>
md: running: <hda6><hda5>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering hda2 ...
md:  adding hda2 ...
md:  adding hda1 ...
md: created md1
md: bind<hda1>
md1: WARNING: hda2 appears to be on the same physical disk as hda1. True
     protection against single-disk failure might be compromised.
md: bind<hda2>
md: running: <hda2><hda1>
raid1: raid set md1 active with 2 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 332k freed
Adding 1959920k swap on /dev/hda3.  Priority:-1 extents:1
EXT3 FS on md1, internal journal
md: autorun ...
md: considering sda ...
md:  adding sda ...
md: created md3
md: bind<sda>
md: running: <sda>
raid1: raid set md3 active with 1 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
scsi0:0:0:0: Attempting to abort cmd f7009e00: 0x28 0x0 0x0 0x9 0x2a 0x18 0x0 0x0 0xf8 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x1bf Mode 0x11
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] 
SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
SCSISIGI[0x66]:(P_DATAIN_DT|REQI|BSYI) SCSIPHASE[0x2]:(DATA_IN_PHASE) 
SCSIBUS[0x61] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x9]:(REQINIT|BUSFREE) 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO) 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] 
LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] 
LQOSTAT2[0x81]:(LQOSTOP0) 

SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0x2 CURRSCB 0x2 NEXTSCB 0x0
qinstart = 2417 qinfifonext = 2417
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x2 )
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
Total 2
Kernel Free SCB list: 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 

scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0xfa] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
scsi0: FIFO1 Active, LONGJMP == 0x257, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x8]:(HDMAEN) DFSTATUS[0x0] 
SG_CACHE_SHADOW[0x32]:(LAST_SEG) SG_STATE[0x3]:(SEGS_AVAIL|LOADING_NEEDED) 
DFFSXFRCTL[0x0] SOFFCNT[0xfa] MDFFSTAT[0x12]:(DATAINFIFO|LASTSDONE) 
SHADDR = 0x0242af200, SHCNT = 0xfffe00 HADDR = 0x0242ad000, HCNT = 0x1000 
CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x5 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0 
scsi0: LQISTATE = 0x23, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
CCSCBCTL[0x4]:(CCSCBDIR) 
scsi0: REG0 == 0x60, SINDEX = 0x111, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xffb2
CDB 28 0 0 0 43 10
STACK: 0x14 0x125 0x125 0x0 0x257 0x25e 0x94 0x257
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:0:0): 0 waiting
DevQ(0:1:0): 0 waiting
scsi0:0:0:0: Cmd aborted from QINFIFO
scsi0:0:0:0: Attempting to abort cmd f7009e00: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x0 Mode 0x22
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] 
SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
SCSISIGI[0x66]:(P_DATAIN_DT|REQI|BSYI) SCSIPHASE[0x2]:(DATA_IN_PHASE) 
SCSIBUS[0x61] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x9]:(REQINIT|BUSFREE) 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO) 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] 
LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] 
LQOSTAT2[0x81]:(LQOSTOP0) 

SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0x2 CURRSCB 0x2 NEXTSCB 0x0
qinstart = 2418 qinfifonext = 2418
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x2 )
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
Total 2
Kernel Free SCB list: 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 

scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0xfa] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
scsi0: FIFO1 Active, LONGJMP == 0x257, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x8]:(HDMAEN) DFSTATUS[0x0] 
SG_CACHE_SHADOW[0x32]:(LAST_SEG) SG_STATE[0x3]:(SEGS_AVAIL|LOADING_NEEDED) 
DFFSXFRCTL[0x0] SOFFCNT[0xfa] MDFFSTAT[0x12]:(DATAINFIFO|LASTSDONE) 
SHADDR = 0x0242af200, SHCNT = 0xfffe00 HADDR = 0x0242ad000, HCNT = 0x1000 
CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x5 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0 
scsi0: LQISTATE = 0x23, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
CCSCBCTL[0x4]:(CCSCBDIR) 
scsi0: REG0 == 0x2, SINDEX = 0x122, DINDEX = 0x102
scsi0: SCBPTR == 0xff00, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB 0 1 0 0 0 0
STACK: 0x125 0x125 0x0 0x257 0x25e 0x94 0x29 0x15
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:0:0): 0 waiting
DevQ(0:1:0): 0 waiting
scsi0:0:0:0: Cmd aborted from QINFIFO
scsi0:0:0:0: Attempting to abort cmd f7009c80: 0x28 0x0 0x0 0x9 0x2b 0x10 0x0 0x1 0x0 0x0
scsi0:0:0:0: Command not found
scsi0:0:0:0: Attempting to abort cmd f7009c80: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x1bf Mode 0x11
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] 
SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
SCSISIGI[0x64]:(P_DATAIN_DT|BSYI) SCSIPHASE[0x2]:(DATA_IN_PHASE) 
SCSIBUS[0x61] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x9]:(REQINIT|BUSFREE) 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO) 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] 
LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] 
LQOSTAT2[0x81]:(LQOSTOP0) 

SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0x2 CURRSCB 0x2 NEXTSCB 0x0
qinstart = 2419 qinfifonext = 2419
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x2 )
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
Total 2
Kernel Free SCB list: 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 

scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0xfa] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
scsi0: FIFO1 Active, LONGJMP == 0x257, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x8]:(HDMAEN) DFSTATUS[0x0] 
SG_CACHE_SHADOW[0x32]:(LAST_SEG) SG_STATE[0x3]:(SEGS_AVAIL|LOADING_NEEDED) 
DFFSXFRCTL[0x0] SOFFCNT[0xfa] MDFFSTAT[0x12]:(DATAINFIFO|LASTSDONE) 
SHADDR = 0x0242af200, SHCNT = 0xfffe00 HADDR = 0x0242ad000, HCNT = 0x1000 
CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x5 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0 
scsi0: LQISTATE = 0x23, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
CCSCBCTL[0x4]:(CCSCBDIR) 
scsi0: REG0 == 0x60, SINDEX = 0x111, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xffb2
CDB 28 0 0 0 43 10
STACK: 0x14 0x125 0x125 0x0 0x257 0x25e 0x94 0x257
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:0:0): 0 waiting
DevQ(0:1:0): 0 waiting
scsi0:0:0:0: Cmd aborted from QINFIFO
Recovery code sleeping
Recovery code awake
Timer Expired
scsi0: Device reset returning 0x2003
Recovery SCB completes
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
SCSI error : <0 0 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 600848
Buffer I/O error on device sda, logical block 150212
Buffer I/O error on device sda, logical block 150213
Buffer I/O error on device sda, logical block 150214
Buffer I/O error on device sda, logical block 150215
Buffer I/O error on device sda, logical block 150216
Buffer I/O error on device sda, logical block 150217
Buffer I/O error on device sda, logical block 150218
Buffer I/O error on device sda, logical block 150219
Buffer I/O error on device sda, logical block 150220
Buffer I/O error on device sda, logical block 150221
Buffer I/O error on device sda, logical block 150222
Buffer I/O error on device sda, logical block 150223
Buffer I/O error on device sda, logical block 150224
Buffer I/O error on device sda, logical block 150225
Buffer I/O error on device sda, logical block 150226
Buffer I/O error on device sda, logical block 150227
Buffer I/O error on device sda, logical block 150228
Buffer I/O error on device sda, logical block 150229
Buffer I/O error on device sda, logical block 150230
Buffer I/O error on device sda, logical block 150231
Buffer I/O error on device sda, logical block 150232
Buffer I/O error on device sda, logical block 150233
Buffer I/O error on device sda, logical block 150234
Buffer I/O error on device sda, logical block 150235
Buffer I/O error on device sda, logical block 150236
Buffer I/O error on device sda, logical block 150237
Buffer I/O error on device sda, logical block 150238
Buffer I/O error on device sda, logical block 150239
Buffer I/O error on device sda, logical block 150240
Buffer I/O error on device sda, logical block 150241
Buffer I/O error on device sda, logical block 150242
Buffer I/O error on device sda, logical block 150243
Buffer I/O error on device sda, logical block 150244
Buffer I/O error on device sda, logical block 150245
Buffer I/O error on device sda, logical block 150246
Buffer I/O error on device sda, logical block 150247
Buffer I/O error on device sda, logical block 150248
Buffer I/O error on device sda, logical block 150249
Buffer I/O error on device sda, logical block 150250
Buffer I/O error on device sda, logical block 150251
Buffer I/O error on device sda, logical block 150252
Buffer I/O error on device sda, logical block 150253
Buffer I/O error on device sda, logical block 150254
Buffer I/O error on device sda, logical block 150255
Buffer I/O error on device sda, logical block 150256
Buffer I/O error on device sda, logical block 150257
Buffer I/O error on device sda, logical block 150258
Buffer I/O error on device sda, logical block 150259
Buffer I/O error on device sda, logical block 150260
Buffer I/O error on device sda, logical block 150261
Buffer I/O error on device sda, logical block 150262
Buffer I/O error on device sda, logical block 150263
Buffer I/O error on device sda, logical block 150264
Buffer I/O error on device sda, logical block 150265
Buffer I/O error on device sda, logical block 150266
Buffer I/O error on device sda, logical block 150267
Buffer I/O error on device sda, logical block 150268
Buffer I/O error on device sda, logical block 150269
Buffer I/O error on device sda, logical block 150270
Buffer I/O error on device sda, logical block 150271
Buffer I/O error on device sda, logical block 150272
Buffer I/O error on device sda, logical block 150273
Buffer I/O error on device sda, logical block 150274
Buffer I/O error on device sda, logical block 150275
Buffer I/O error on device sda, logical block 150150
Buffer I/O error on device sda, logical block 150151
Buffer I/O error on device sda, logical block 150152
Buffer I/O error on device sda, logical block 150153
Buffer I/O error on device sda, logical block 150154
Buffer I/O error on device sda, logical block 150155
Buffer I/O error on device sda, logical block 150156
Buffer I/O error on device sda, logical block 150157
Buffer I/O error on device sda, logical block 150158
Buffer I/O error on device sda, logical block 150159
Buffer I/O error on device sda, logical block 150160
Buffer I/O error on device sda, logical block 150161
Buffer I/O error on device sda, logical block 150162
Buffer I/O error on device sda, logical block 150163
Buffer I/O error on device sda, logical block 150164
Buffer I/O error on device sda, logical block 150165
Buffer I/O error on device sda, logical block 150166
Buffer I/O error on device sda, logical block 150167
Buffer I/O error on device sda, logical block 150168
Buffer I/O error on device sda, logical block 150169
Buffer I/O error on device sda, logical block 150170
Buffer I/O error on device sda, logical block 150171
Buffer I/O error on device sda, logical block 150172
Buffer I/O error on device sda, logical block 150173
Buffer I/O error on device sda, logical block 150174
Buffer I/O error on device sda, logical block 150175
Buffer I/O error on device sda, logical block 150176
Buffer I/O error on device sda, logical block 150177
Buffer I/O error on device sda, logical block 150178
Buffer I/O error on device sda, logical block 150179
Buffer I/O error on device sda, logical block 150180
Buffer I/O error on device sda, logical block 150181
Buffer I/O error on device sda, logical block 150182
Buffer I/O error on device sda, logical block 150183
Buffer I/O error on device sda, logical block 150184
Buffer I/O error on device sda, logical block 150185
Buffer I/O error on device sda, logical block 150186
Buffer I/O error on device sda, logical block 150187
Buffer I/O error on device sda, logical block 150188
Buffer I/O error on device sda, logical block 150189
Buffer I/O error on device sda, logical block 150190
Buffer I/O error on device sda, logical block 150191
Buffer I/O error on device sda, logical block 150192
Buffer I/O error on device sda, logical block 150193
Buffer I/O error on device sda, logical block 150194
Buffer I/O error on device sda, logical block 150195
Buffer I/O error on device sda, logical block 150196
Buffer I/O error on device sda, logical block 150197
Buffer I/O error on device sda, logical block 150198
Buffer I/O error on device sda, logical block 150199
Buffer I/O error on device sda, logical block 150200
Buffer I/O error on device sda, logical block 150201
Buffer I/O error on device sda, logical block 150202
Buffer I/O error on device sda, logical block 150203
Buffer I/O error on device sda, logical block 150204
Buffer I/O error on device sda, logical block 150205
Buffer I/O error on device sda, logical block 150206
Buffer I/O error on device sda, logical block 150207
Buffer I/O error on device sda, logical block 150208
Buffer I/O error on device sda, logical block 150209
Buffer I/O error on device sda, logical block 150210
Buffer I/O error on device sda, logical block 150211
scsi0 (0:0): rejecting I/O to offline device
Buffer I/O error on device sda, logical block 150150
Buffer I/O error on device sda, logical block 150151

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=aic_info

Adaptec AIC79xx driver version: 1.3.9
Adaptec 29320LP Ultra320 SCSI adapter
aic7901A: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
Allocated SCBs: 4, SG List Length: 128

Serial EEPROM:
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x09f4 0x01c7 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff 
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0410 0xb458 

Target 0 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Goal: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Curr: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Transmission Errors 0
	Channel A Target 0 Lun 0 Settings
		Commands Queued 12
		Commands Active 0
		Command Openings 253
		Max Tagged Openings 253
		Device Queue Frozen Count 0
Target 1 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Goal: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Curr: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Transmission Errors 0
	Channel A Target 1 Lun 0 Settings
		Commands Queued 11
		Commands Active 0
		Command Openings 253
		Max Tagged Openings 253
		Device Queue Frozen Count 0
Target 2 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 3 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 4 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 5 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 6 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 7 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 8 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 9 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 10 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 11 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 12 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 13 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 14 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 15 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)

--y0ulUmNC+osPPQO6--
