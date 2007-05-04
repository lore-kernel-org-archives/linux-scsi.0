From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: mptscsih: ioc1: attempting task abort! (sc=d6e8a980)
Date: Fri, 4 May 2007 13:52:46 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705041315570.7190@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-1451149149-1178311966=:7190"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1767054AbXEDUw5@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Scsi maillist <linux-scsi@vger.kernel.org>
Cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-1451149149-1178311966=:7190
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

 =09Hello  All ,  Here We go again ...


 =09From the Console at the time of the failure .

# ( time bonnie++-1.03a/bonnie++ -u0:0 -d /home -s 524288 ) 2>&1 | tee -a 5=
12GB-bonnie++-run-ext3.log-200705022100
Using uid:0, gid:0.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...
mptscsih: ioc1: attempting task abort! (sc=3Dd6e8a980)
sd 3:0:5:0:     PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
         command: Read(10): 28 00 02 52 38 c1 00 00 80 0000032ad5_raid5
mptscsih: ioc1: WARNING - TM Handler for type=3D1: IOC Not operational=20
(0xffffffff)!301 root      18   0  2804 1180  900 D    0  0.0 505:38.63 bon=
nie++
  Issuing HardReset!! 0  2212 1136  852 R    0  0.0   1:05.37 top
mptbase: Initiating ioc1 recovery
mptbase: ioc1: WARNING - Unexpected doorbell active!
eth2: tx_timeout: tx_done_idx=3D113 free_idx=3D115 cmdsts=3D8000032a
eth2: after: tx_done_idx=3D113 free_idx=3D115 cmdsts=3D8000032a
CPU 2: Machine Check Exception: 0000000000000004
CPU 3: Machine Check Exception: 0000000000000004
Kernel panic - not syncing: Unable to continue


 =09Console log of a boot .

Linux version 2.6.21-rc7 (root@filesrv1b) (gcc version 3.4.6) #1 SMP Sun Ap=
r 22 03:44:51 UTC 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009bc00 end: 0000000=
00009bc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009bc00 size: 0000000000004400 end: 0000000=
0000a0000 type: 2
copy_e820_map() start: 00000000000e4000 size: 000000000001c000 end: 0000000=
000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 00000000cfe60000 end: 0000000=
0cff60000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000cff60000 size: 0000000000009000 end: 0000000=
0cff69000 type: 3
copy_e820_map() start: 00000000cff69000 size: 0000000000017000 end: 0000000=
0cff80000 type: 4
copy_e820_map() start: 00000000cff80000 size: 0000000000080000 end: 0000000=
0d0000000 type: 2
copy_e820_map() start: 00000000e0000000 size: 0000000010000000 end: 0000000=
0f0000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 0000000=
0fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 0000000=
0fee01000 type: 2
copy_e820_map() start: 00000000ff000000 size: 0000000001000000 end: 0000000=
100000000 type: 2
copy_e820_map() start: 0000000100000000 size: 0000000030000000 end: 0000000=
130000000 type: 1
copy_e820_map() type is E820_RAM
  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
  BIOS-e820: 00000000cff60000 - 00000000cff69000 (ACPI data)
  BIOS-e820: 00000000cff69000 - 00000000cff80000 (ACPI NVS)
  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
3968MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f5ec0
NX (Execute Disable) protection: active
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->  1245184
early_node_map[1] active PFN ranges
     0:        0 ->  1245184
DMI present.
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: Bridge CRB   APIC at: 0xFEE00000
Processor #0 15:6 APIC version 20
Processor #4 15:6 APIC version 20
Processor #2 15:6 APIC version 20
Processor #6 15:6 APIC version 20
Processor #1 15:6 APIC version 20
Processor #5 15:6 APIC version 20
Processor #3 15:6 APIC version 20
Processor #7 15:6 APIC version 20
I/O APIC #8 Version 32 at 0xFEC00000.
I/O APIC #9 Version 32 at 0xFEC80000.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Processors: 8
Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
Built 1 zonelists.  Total pages: 1235456
Kernel command line: BOOT_IMAGE=3Dfilesrv1 ro root=3D900 ramdisk=3D16384 se=
rial=3D0,115200n8 console=3DttyS0,115200
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3000.344 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 4142300k/4980736k available (6693k kernel code, 50224k reserved, 23=
40k data, 344k init, 3276160k highmem)
virtual kernel memory layout:
     fixmap  : 0xffeec000 - 0xfffff000   (1100 kB)
     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc09de000 - 0xc0a34000   ( 344 kB)
       .data : 0xc078956e - 0xc09d27a0   (2340 kB)
       .text : 0xc0100000 - 0xc078956e   (6693 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok=
=2E
Calibrating delay using timer specific routine.. 6005.65 BogoMIPS (lpj=3D12=
011310)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 28k freed
CPU0: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6000.49 BogoMIPS (lpj=3D12=
000990)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 2/2 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6000.81 BogoMIPS (lpj=3D12=
001626)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (24) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 3/3 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6000.70 BogoMIPS (lpj=3D12=
001404)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (24) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 4/4 eip 2000
Initializing CPU#4
Calibrating delay using timer specific routine.. 6000.61 BogoMIPS (lpj=3D12=
001230)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#4.
CPU4: Intel P4/Xeon Extended MCE MSRs (24) available
CPU4: Thermal monitoring enabled
CPU4: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 5/5 eip 2000
Initializing CPU#5
Calibrating delay using timer specific routine.. 6000.60 BogoMIPS (lpj=3D12=
001210)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#5.
CPU5: Intel P4/Xeon Extended MCE MSRs (24) available
CPU5: Thermal monitoring enabled
CPU5: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 6/6 eip 2000
Initializing CPU#6
Calibrating delay using timer specific routine.. 6026.10 BogoMIPS (lpj=3D12=
052215)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#6.
CPU6: Intel P4/Xeon Extended MCE MSRs (24) available
CPU6: Thermal monitoring enabled
CPU6: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Booting processor 7/7 eip 2000
Initializing CPU#7
Calibrating delay using timer specific routine.. 6000.56 BogoMIPS (lpj=3D12=
001138)
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#7.
CPU7: Intel P4/Xeon Extended MCE MSRs (24) available
CPU7: Thermal monitoring enabled
CPU7: Intel(R) Xeon(TM) CPU 3.00GHz stepping 04
Total of 8 processors activated (48035.56 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
migration_cost=3D9,749
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd727, last bus=3D11
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
0000:00:1f.1: trying to change BAR2 from 0000 to 0170
0000:00:1f.1: trying to change BAR3 from 0000 to 0374
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2670] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:02.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:06.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1c.0[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:1d.0[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:1d.1[B] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1d.2[C] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:1d.7[A] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:1f.1[A] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1f.3[B] -> IRQ 19
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:02:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:02:02.0[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:04:01.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:04:02.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:04:02.1[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:05:01.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:05:01.1[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:06:00.0[A] -> IRQ 18
PCI->APIC IRQ transform: 0000:06:00.1[B] -> IRQ 19
PCI->APIC IRQ transform: 0000:07:01.0[A] -> IRQ 24
PCI->APIC IRQ transform: 0000:07:01.1[B] -> IRQ 25
PCI->APIC IRQ transform: 0000:0b:01.0[A] -> IRQ 18
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI: Bridge: 0000:03:00.0
   IO window: 2000-3fff
Time: tsc clocksource has been installed.
   MEM window: d8100000-d81fffff
   PREFETCH window: d8900000-d8afffff
PCI: Bridge: 0000:03:00.2
   IO window: 4000-4fff
   MEM window: d8000000-d80fffff
   PREFETCH window: d8b00000-d8cfffff
PCI: Bridge: 0000:02:00.0
   IO window: 2000-4fff
   MEM window: d8000000-d81fffff
   PREFETCH window: d8900000-d8cfffff
PCI: Bridge: 0000:02:02.0
   IO window: 5000-5fff
   MEM window: d8200000-d82fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.0
   IO window: 2000-5fff
   MEM window: d8000000-d82fffff
   PREFETCH window: d8900000-d8cfffff
PCI: Bridge: 0000:01:00.3
   IO window: 6000-6fff
   MEM window: d8300000-d83fffff
   PREFETCH window: d8d00000-d8efffff
PCI: Bridge: 0000:00:02.0
   IO window: 2000-6fff
   MEM window: d8000000-d84fffff
   PREFETCH window: d8900000-d8efffff
PCI: Bridge: 0000:00:04.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
   IO window: 7000-7fff
   MEM window: d8700000-d87fffff
   PREFETCH window: d0000000-d7ffffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
DLM (built Apr 22 2007 03:34:30) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/W].
SGI XFS with ACLs, security attributes, large block numbers, no debug enabl=
ed
SGI XFS Quota Management subsystem
GFS2 (built Apr 22 2007 03:35:07) installed
Lock_Nolock (built Apr 22 2007 03:35:17) installed
Lock_DLM (built Apr 22 2007 03:35:15) installed
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=3D27.00 MHz (RefDiv=3D60) Memory=3D200.00 Mhz, System=
=3D200.00 MHz
radeonfb: PLL min 12000 max 35000
i2c_adapter i2c-1: unable to read EDID block.
i2c_adapter i2c-1: unable to read EDID block.
i2c_adapter i2c-1: unable to read EDID block.
i2c_adapter i2c-3: unable to read EDID block.
i2c_adapter i2c-3: unable to read EDID block.
i2c_adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type CRT found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 80x30
mtrr: type mismatch for d0000000,1000000 old: write-back new: write-combini=
ng
radeonfb (0000:0b:01.0): ATI Radeon Q^=20
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
HDLC line discipline: version $Revision: 4.8 $, maxframe=3D4096
N_HDLC line discipline registered.
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.25.0 20060524 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
=FFserial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000: 0000:06:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:30:48:3=
2:63:ae
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:06:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:30:48:3=
2:63:af
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
Intel(R) PRO/10GbE Network Driver - version 1.0.126-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Ethernet Channel Bonding Driver: v3.1.2 (January 20, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target module pa=
rameters must be specified, otherwise bonding will not detect link failures=
! see bonding.txt for details.
Attansic L1 Ethernet Network Driver - version 2.0.7
Copyright(c) 2005-2006 Attansic Corporation.
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
eth2: ns83820.c: 0x22c: f022100b, subsystem: 100b:f022
eth2: detected 64 bit PCI data bus.
eth2: enabling optical transceiver
eth2: using 64 bit addressing.
eth2: ns83820 v0.22: DP83820 v1.3: 00:40:f4:67:26:12 io=3D0xd8100000 irq=3D=
16 f=3Dh,sg
sk98lin: driver has been replaced by the skge driver and is scheduled for r=
emoval
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
myri10ge: Version 1.3.0-1.233
fore200e: FORE Systems 200E-series ATM driver - version 0.3e
idt77252_init: at c09ff730
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
ESB2: IDE controller at PCI slot 0000:00:1f.1
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0x1860-0x1867, BIOS settings: hda:pio, hdb:DMA
hdb: Slimtype COMBO SSC-2485K, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdb: ATAPI 24X DVD-ROM CD-R/RW drive, 1536kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Loading iSCSI transport class v2.0-724.
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
         <Adaptec AIC7902 Ultra320 SCSI adapter>
         aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz, 51=
2 SCBs
eth2: link now 1000F mbps, full duplex and up.
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
         <Adaptec AIC7902 Ultra320 SCSI adapter>
         aic7902: Ultra320 Wide Channel B, SCSI Id=3D7, PCI 33 or 66Mhz, 51=
2 SCBs
Adaptec aacraid driver (1.1-5[2423]-mh3)
QLogic Fibre Channel HBA Driver
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc1 Wed Feb 14 10:14:25 PST 2007
st: Version 20070203, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI Media Changer driver v0.25=20
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities=3D{Initiator,Target}
scsi2 : ioc0: LSI53C1030, FwRev=3D01032700h, Ports=3D1, MaxQ=3D255, IRQ=3D1=
6
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities=3D{Initiator,Target}
scsi 2:0:0:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:0: Beginning Domain Validation
scsi3 : ioc1: LSI53C1030, FwRev=3D01032700h, Ports=3D1, MaxQ=3D255, IRQ=3D1=
7
  target2:0:0: Ending Domain Validation
  target2:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:1: Beginning Domain Validation
  target2:0:1: Ending Domain Validation
  target2:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:2: Beginning Domain Validation
  target2:0:2: Ending Domain Validation
  target2:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:3: Beginning Domain Validation
  target2:0:3: Ending Domain Validation
  target2:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:4:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:4: Beginning Domain Validation
  target2:0:4: Ending Domain Validation
  target2:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:5:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:5: Beginning Domain Validation
  target2:0:5: Ending Domain Validation
  target2:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:6:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target2:0:6: Beginning Domain Validation
  target2:0:6: Ending Domain Validation
  target2:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 2:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 ANSI: =
2
  target2:0:8: Beginning Domain Validation
  target2:0:8: Ending Domain Validation
  target2:0:8: asynchronous
mptbase: Initiating ioc2 bringup
scsi 3:0:0:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:0: Beginning Domain Validation
  target3:0:0: Ending Domain Validation
  target3:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:1: Beginning Domain Validation
  target3:0:1: Ending Domain Validation
  target3:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:2: Beginning Domain Validation
  target3:0:2: Ending Domain Validation
  target3:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:3: Beginning Domain Validation
  target3:0:3: Ending Domain Validation
  target3:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:4:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:4: Beginning Domain Validation
  target3:0:4: Ending Domain Validation
  target3:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:5:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:5: Beginning Domain Validation
  target3:0:5: Ending Domain Validation
  target3:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:6:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target3:0:6: Beginning Domain Validation
  target3:0:6: Ending Domain Validation
  target3:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 3:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 ANSI: =
2
  target3:0:8: Beginning Domain Validation
  target3:0:8: Ending Domain Validation
  target3:0:8: asynchronous
ioc2: 53C1030: Capabilities=3D{Initiator}
scsi4 : ioc2: LSI53C1030, FwRev=3D01033010h, Ports=3D1, MaxQ=3D222, IRQ=3D2=
4
mptbase: Initiating ioc3 bringup
SCSI device sda: 287132440 512-byte hdwr sectors (147012 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sda: 287132440 512-byte hdwr sectors (147012 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sda: sda1
sd 2:0:0:0: Attached scsi disk sda
sd 2:0:0:0: Attached scsi generic sg0 type 0
SCSI device sdb: 287132440 512-byte hdwr sectors (147012 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdb: 287132440 512-byte hdwr sectors (147012 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdb: sdb1
sd 2:0:1:0: Attached scsi disk sdb
sd 2:0:1:0: Attached scsi generic sg1 type 0
SCSI device sdc: 287132440 512-byte hdwr sectors (147012 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdc: 287132440 512-byte hdwr sectors (147012 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdc: sdc1
sd 2:0:2:0: Attached scsi disk sdc
sd 2:0:2:0: Attached scsi generic sg2 type 0
SCSI device sdd: 287132440 512-byte hdwr sectors (147012 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdd: 287132440 512-byte hdwr sectors (147012 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdd: sdd1
sd 2:0:3:0: Attached scsi disk sdd
sd 2:0:3:0: Attached scsi generic sg3 type 0
SCSI device sde: 287132440 512-byte hdwr sectors (147012 MB)
sde: Write Protect is off
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sde: 287132440 512-byte hdwr sectors (147012 MB)
sde: Write Protect is off
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sde: sde1
sd 2:0:4:0: Attached scsi disk sde
sd 2:0:4:0: Attached scsi generic sg4 type 0
SCSI device sdf: 287132440 512-byte hdwr sectors (147012 MB)
sdf: Write Protect is off
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdf: 287132440 512-byte hdwr sectors (147012 MB)
sdf: Write Protect is off
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdf: sdf1
sd 2:0:5:0: Attached scsi disk sdf
sd 2:0:5:0: Attached scsi generic sg5 type 0
SCSI device sdg: 287132440 512-byte hdwr sectors (147012 MB)
sdg: Write Protect is off
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdg: 287132440 512-byte hdwr sectors (147012 MB)
sdg: Write Protect is off
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdg: sdg1
sd 2:0:6:0: Attached scsi disk sdg
sd 2:0:6:0: Attached scsi generic sg6 type 0
scsi 2:0:8:0: Attached scsi generic sg7 type 3
SCSI device sdh: 287132440 512-byte hdwr sectors (147012 MB)
sdh: Write Protect is off
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdh: 287132440 512-byte hdwr sectors (147012 MB)
sdh: Write Protect is off
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdh: sdh1
sd 3:0:0:0: Attached scsi disk sdh
sd 3:0:0:0: Attached scsi generic sg8 type 0
SCSI device sdi: 287132440 512-byte hdwr sectors (147012 MB)
sdi: Write Protect is off
SCSI device sdi: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdi: 287132440 512-byte hdwr sectors (147012 MB)
sdi: Write Protect is off
SCSI device sdi: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdi: sdi1
sd 3:0:1:0: Attached scsi disk sdi
sd 3:0:1:0: Attached scsi generic sg9 type 0
SCSI device sdj: 287132440 512-byte hdwr sectors (147012 MB)
sdj: Write Protect is off
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdj: 287132440 512-byte hdwr sectors (147012 MB)
sdj: Write Protect is off
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdj: sdj1
sd 3:0:2:0: Attached scsi disk sdj
sd 3:0:2:0: Attached scsi generic sg10 type 0
SCSI device sdk: 287132440 512-byte hdwr sectors (147012 MB)
sdk: Write Protect is off
SCSI device sdk: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdk: 287132440 512-byte hdwr sectors (147012 MB)
sdk: Write Protect is off
SCSI device sdk: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdk: sdk1
sd 3:0:3:0: Attached scsi disk sdk
sd 3:0:3:0: Attached scsi generic sg11 type 0
SCSI device sdl: 287132440 512-byte hdwr sectors (147012 MB)
sdl: Write Protect is off
SCSI device sdl: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdl: 287132440 512-byte hdwr sectors (147012 MB)
sdl: Write Protect is off
SCSI device sdl: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdl: sdl1
sd 3:0:4:0: Attached scsi disk sdl
sd 3:0:4:0: Attached scsi generic sg12 type 0
SCSI device sdm: 287132440 512-byte hdwr sectors (147012 MB)
sdm: Write Protect is off
SCSI device sdm: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdm: 287132440 512-byte hdwr sectors (147012 MB)
sdm: Write Protect is off
SCSI device sdm: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdm: sdm1
sd 3:0:5:0: Attached scsi disk sdm
sd 3:0:5:0: Attached scsi generic sg13 type 0
SCSI device sdn: 287132440 512-byte hdwr sectors (147012 MB)
sdn: Write Protect is off
SCSI device sdn: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdn: 287132440 512-byte hdwr sectors (147012 MB)
sdn: Write Protect is off
SCSI device sdn: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdn: sdn1
sd 3:0:6:0: Attached scsi disk sdn
sd 3:0:6:0: Attached scsi generic sg14 type 0
scsi 3:0:8:0: Attached scsi generic sg15 type 3
ioc3: 53C1030: Capabilities=3D{Initiator}
scsi 4:0:0:0: Direct-Access     COMPAQ   BB01811C9C       3B07 PQ: 0 ANSI: =
2
  target4:0:0: Beginning Domain Validation
scsi5 : ioc3: LSI53C1030, FwRev=3D01033010h, Ports=3D1, MaxQ=3D222, IRQ=3D2=
5
  target4:0:0: Domain Validation skipping write tests
  target4:0:0: Ending Domain Validation
  target4:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
scsi 4:0:1:0: Direct-Access     COMPAQ   BB01811C9C       3B07 PQ: 0 ANSI: =
2
  target4:0:1: Beginning Domain Validation
  target4:0:1: Domain Validation skipping write tests
  target4:0:1: Ending Domain Validation
  target4:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
scsi 4:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target4:0:2: Beginning Domain Validation
  target4:0:2: Ending Domain Validation
  target4:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
Fusion MPT FC Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
Fusion MPT misc device (ioctl) driver 3.04.04
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=3D10,220)
Fusion MPT LAN driver 3.04.04
mptlan: ioc0: PortNum=3D0, ProtocolFlags=3D0Ch (ITlb)
mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter por=
t!
mptlan: ioc1: PortNum=3D0, ProtocolFlags=3D0Ch (ITlb)
mptlan: ioc1: Hmmm... LAN protocol seems to be disabled on this adapter por=
t!
mptlan: ioc2: PortNum=3D0, ProtocolFlags=3D08h (Itlb)
mptlan: ioc2: Hmmm... LAN protocol seems to be disabled on this adapter por=
t!
mptlan: ioc3: PortNum=3D0, ProtocolFlags=3D08h (Itlb)
mptlan: ioc3: Hmmm... LAN protocol seems to be disabled on this adapter por=
t!
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 17, io mem 0xd8800000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver cdc_acm
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for US=
B modems and ISDN adapters
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
scsi 5:0:0:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
scsi 4:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target4:0:3: Beginning Domain Validation
  target5:0:0: Beginning Domain Validation
  target4:0:3: Ending Domain Validation
  target4:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
  target5:0:0: Ending Domain Validation
  target5:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 5:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target5:0:1: Beginning Domain Validation
  target5:0:1: Ending Domain Validation
  target5:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 5:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target5:0:2: Beginning Domain Validation
  target5:0:2: Ending Domain Validation
  target5:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
scsi 5:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: =
3
  target5:0:3: Beginning Domain Validation
  target5:0:3: Ending Domain Validation
  target5:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, =
offset 127)
input: PS/2 Generic Mouse as /class/input/input2
scsi 4:0:6:0: Processor         SUPER    GEM318           0    PQ: 0 ANSI: =
2
  target4:0:6: Beginning Domain Validation
  target4:0:6: Ending Domain Validation
  target4:0:6: asynchronous
scsi 5:0:6:0: Processor         SUPER    GEM318           0    PQ: 0 ANSI: =
2
  target5:0:6: Beginning Domain Validation
  target5:0:6: Ending Domain Validation
  target5:0:6: asynchronous
isl1208 2-006f: chip found, driver version 0.2
isl1208 2-006f: rtc core: registered isl1208 as rtc0
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1    642 MB/s
raid6: int32x2    824 MB/s
raid6: int32x4    693 MB/s
raid6: int32x8    566 MB/s
raid6: mmxx1     1842 MB/s
raid6: mmxx2     2158 MB/s
raid6: sse1x1    1092 MB/s
raid6: sse1x2    1221 MB/s
raid6: sse2x1    2127 MB/s
raid6: sse2x2    2243 MB/s
raid6: using algorithm sse2x2 (2243 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  4626.000 MB/sec
raid5: using function: pIII_sse (4626.000 MB/sec)
md: multipath personality registered for level -4
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
lec.c: Apr 22 2007 03:42:52 initialized
mpc.c: Apr 22 2007 03:42:50 initialized
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.=
com>
Starting balanced_irq
Using IPI Shortcut mode
scsi: waiting for bus probes to complete ...
SCSI device sdo: 35565080 512-byte hdwr sectors (18209 MB)
sdo: Write Protect is off
SCSI device sdo: write cache: disabled, read cache: enabled, supports DPO a=
nd FUA
SCSI device sdo: 35565080 512-byte hdwr sectors (18209 MB)
sdo: Write Protect is off
SCSI device sdo: write cache: disabled, read cache: enabled, supports DPO a=
nd FUA
  sdo: sdo1 sdo2 sdo3
sd 4:0:0:0: Attached scsi disk sdo
sd 4:0:0:0: Attached scsi generic sg16 type 0
SCSI device sdp: 35565080 512-byte hdwr sectors (18209 MB)
sdp: Write Protect is off
SCSI device sdp: write cache: disabled, read cache: enabled, supports DPO a=
nd FUA
SCSI device sdp: 35565080 512-byte hdwr sectors (18209 MB)
sdp: Write Protect is off
SCSI device sdp: write cache: disabled, read cache: enabled, supports DPO a=
nd FUA
  sdp: sdp1 sdp2 sdp3
sd 4:0:1:0: Attached scsi disk sdp
sd 4:0:1:0: Attached scsi generic sg17 type 0
SCSI device sdq: 287132440 512-byte hdwr sectors (147012 MB)
sdq: Write Protect is off
SCSI device sdq: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdq: 287132440 512-byte hdwr sectors (147012 MB)
sdq: Write Protect is off
SCSI device sdq: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdq: sdq1
sd 4:0:2:0: Attached scsi disk sdq
sd 4:0:2:0: Attached scsi generic sg18 type 0
SCSI device sdr: 287132440 512-byte hdwr sectors (147012 MB)
sdr: Write Protect is off
SCSI device sdr: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdr: 287132440 512-byte hdwr sectors (147012 MB)
sdr: Write Protect is off
SCSI device sdr: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdr: sdr1
sd 4:0:3:0: Attached scsi disk sdr
sd 4:0:3:0: Attached scsi generic sg19 type 0
scsi 4:0:6:0: Attached scsi generic sg20 type 3
SCSI device sds: 287132440 512-byte hdwr sectors (147012 MB)
sds: Write Protect is off
SCSI device sds: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sds: 287132440 512-byte hdwr sectors (147012 MB)
sds: Write Protect is off
SCSI device sds: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sds: sds1
sd 5:0:0:0: Attached scsi disk sds
sd 5:0:0:0: Attached scsi generic sg21 type 0
SCSI device sdt: 287132440 512-byte hdwr sectors (147012 MB)
sdt: Write Protect is off
SCSI device sdt: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdt: 287132440 512-byte hdwr sectors (147012 MB)
sdt: Write Protect is off
SCSI device sdt: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdt: sdt1
sd 5:0:1:0: Attached scsi disk sdt
sd 5:0:1:0: Attached scsi generic sg22 type 0
SCSI device sdu: 287132440 512-byte hdwr sectors (147012 MB)
sdu: Write Protect is off
SCSI device sdu: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdu: 287132440 512-byte hdwr sectors (147012 MB)
sdu: Write Protect is off
SCSI device sdu: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdu: sdu1
sd 5:0:2:0: Attached scsi disk sdu
sd 5:0:2:0: Attached scsi generic sg23 type 0
SCSI device sdv: 287132440 512-byte hdwr sectors (147012 MB)
sdv: Write Protect is off
SCSI device sdv: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
SCSI device sdv: 287132440 512-byte hdwr sectors (147012 MB)
sdv: Write Protect is off
SCSI device sdv: write cache: enabled, read cache: enabled, doesn't support=
 DPO or FUA
  sdv: sdv1
sd 5:0:3:0: Attached scsi disk sdv
sd 5:0:3:0: Attached scsi generic sg24 type 0
scsi 5:0:6:0: Attached scsi generic sg25 type 3
isl1208 2-006f: hctosys: invalid date/time
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdv1 ...
md:  adding sdv1 ...
md:  adding sdu1 ...
md:  adding sdt1 ...
md:  adding sds1 ...
md:  adding sdr1 ...
md:  adding sdq1 ...
md: sdp3 has different UUID to sdv1
md: sdp2 has different UUID to sdv1
md: sdp1 has different UUID to sdv1
md: sdo3 has different UUID to sdv1
md: sdo2 has different UUID to sdv1
md: sdo1 has different UUID to sdv1
md: sdn1 has different UUID to sdv1
md: sdm1 has different UUID to sdv1
md: sdl1 has different UUID to sdv1
md: sdk1 has different UUID to sdv1
md: sdj1 has different UUID to sdv1
md: sdi1 has different UUID to sdv1
md: sdh1 has different UUID to sdv1
md: sdg1 has different UUID to sdv1
md: sdf1 has different UUID to sdv1
md: sde1 has different UUID to sdv1
md: sdd1 has different UUID to sdv1
md: sdc1 has different UUID to sdv1
md: sdb1 has different UUID to sdv1
md: sda1 has different UUID to sdv1
md: created md3
md: bind<sdq1>
md: bind<sdr1>
md: bind<sds1>
md: bind<sdt1>
md: bind<sdu1>
md: bind<sdv1>
md: running: <sdv1><sdu1><sdt1><sds1><sdr1><sdq1>
raid5: device sdv1 operational as raid disk 5
raid5: device sdu1 operational as raid disk 4
raid5: device sdt1 operational as raid disk 3
raid5: device sds1 operational as raid disk 2
raid5: device sdr1 operational as raid disk 1
raid5: device sdq1 operational as raid disk 0
raid5: allocated 6286kB for md3
raid5: raid level 6 set md3 active with 6 out of 6 devices, algorithm 2
RAID5 conf printout:
  --- rd:6 wd:6
  disk 0, o:1, dev:sdq1
  disk 1, o:1, dev:sdr1
  disk 2, o:1, dev:sds1
  disk 3, o:1, dev:sdt1
  disk 4, o:1, dev:sdu1
  disk 5, o:1, dev:sdv1
md3: bitmap initialized from disk: read 9/9 pages, set 1 bits, status: 0
created bitmap (137 pages) for device md3
md: considering sdp3 ...
md:  adding sdp3 ...
md: sdp2 has different UUID to sdp3
md: sdp1 has different UUID to sdp3
md:  adding sdo3 ...
md: sdo2 has different UUID to sdp3
md: sdo1 has different UUID to sdp3
md: sdn1 has different UUID to sdp3
md: sdm1 has different UUID to sdp3
md: sdl1 has different UUID to sdp3
md: sdk1 has different UUID to sdp3
md: sdj1 has different UUID to sdp3
md: sdi1 has different UUID to sdp3
md: sdh1 has different UUID to sdp3
md: sdg1 has different UUID to sdp3
md: sdf1 has different UUID to sdp3
md: sde1 has different UUID to sdp3
md: sdd1 has different UUID to sdp3
md: sdc1 has different UUID to sdp3
md: sdb1 has different UUID to sdp3
md: sda1 has different UUID to sdp3
md: created md2
md: bind<sdo3>
md: bind<sdp3>
md: running: <sdp3><sdo3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering sdp2 ...
md:  adding sdp2 ...
md: sdp1 has different UUID to sdp2
md:  adding sdo2 ...
md: sdo1 has different UUID to sdp2
md: sdn1 has different UUID to sdp2
md: sdm1 has different UUID to sdp2
md: sdl1 has different UUID to sdp2
md: sdk1 has different UUID to sdp2
md: sdj1 has different UUID to sdp2
md: sdi1 has different UUID to sdp2
md: sdh1 has different UUID to sdp2
md: sdg1 has different UUID to sdp2
md: sdf1 has different UUID to sdp2
md: sde1 has different UUID to sdp2
md: sdd1 has different UUID to sdp2
md: sdc1 has different UUID to sdp2
md: sdb1 has different UUID to sdp2
md: sda1 has different UUID to sdp2
md: created md1
md: bind<sdo2>
md: bind<sdp2>
md: running: <sdp2><sdo2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdp1 ...
md:  adding sdp1 ...
md:  adding sdo1 ...
md: sdn1 has different UUID to sdp1
md: sdm1 has different UUID to sdp1
md: sdl1 has different UUID to sdp1
md: sdk1 has different UUID to sdp1
md: sdj1 has different UUID to sdp1
md: sdi1 has different UUID to sdp1
md: sdh1 has different UUID to sdp1
md: sdg1 has different UUID to sdp1
md: sdf1 has different UUID to sdp1
md: sde1 has different UUID to sdp1
md: sdd1 has different UUID to sdp1
md: sdc1 has different UUID to sdp1
md: sdb1 has different UUID to sdp1
md: sda1 has different UUID to sdp1
md: created md0
md: bind<sdo1>
md: bind<sdp1>
md: running: <sdp1><sdo1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: considering sdn1 ...
md:  adding sdn1 ...
md:  adding sdm1 ...
md:  adding sdl1 ...
md:  adding sdk1 ...
md:  adding sdj1 ...
md:  adding sdi1 ...
md: sdh1 has different UUID to sdn1
md:  adding sdg1 ...
md: sdf1 has different UUID to sdn1
md: sde1 has different UUID to sdn1
md: sdd1 has different UUID to sdn1
md: sdc1 has different UUID to sdn1
md: sdb1 has different UUID to sdn1
md: sda1 has different UUID to sdn1
md: created md4
md: bind<sdg1>
md: bind<sdi1>
md: bind<sdj1>
md: bind<sdk1>
md: bind<sdl1>
md: bind<sdm1>
md: bind<sdn1>
md: running: <sdn1><sdm1><sdl1><sdk1><sdj1><sdi1><sdg1>
raid5: device sdn1 operational as raid disk 1
raid5: device sdm1 operational as raid disk 0
raid5: device sdl1 operational as raid disk 3
raid5: device sdk1 operational as raid disk 2
raid5: device sdj1 operational as raid disk 5
raid5: device sdi1 operational as raid disk 4
raid5: device sdg1 operational as raid disk 6
raid5: allocated 7327kB for md4
raid5: raid level 6 set md4 active with 7 out of 7 devices, algorithm 2
RAID5 conf printout:
  --- rd:7 wd:7
  disk 0, o:1, dev:sdm1
  disk 1, o:1, dev:sdn1
  disk 2, o:1, dev:sdk1
  disk 3, o:1, dev:sdl1
  disk 4, o:1, dev:sdi1
  disk 5, o:1, dev:sdj1
  disk 6, o:1, dev:sdg1
md4: bitmap initialized from disk: read 9/9 pages, set 0 bits, status: 0
created bitmap (137 pages) for device md4
md: considering sdh1 ...
md:  adding sdh1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md5
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdh1>
md: running: <sdh1><sdf1><sde1><sdd1><sdc1><sdb1><sda1>
raid5: device sdh1 operational as raid disk 0
raid5: device sdf1 operational as raid disk 2
raid5: device sde1 operational as raid disk 1
raid5: device sdd1 operational as raid disk 4
raid5: device sdc1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 6
raid5: device sda1 operational as raid disk 5
raid5: allocated 7327kB for md5
raid5: raid level 6 set md5 active with 7 out of 7 devices, algorithm 2
RAID5 conf printout:
  --- rd:7 wd:7
  disk 0, o:1, dev:sdh1
  disk 1, o:1, dev:sde1
  disk 2, o:1, dev:sdf1
  disk 3, o:1, dev:sdc1
  disk 4, o:1, dev:sdd1
  disk 5, o:1, dev:sda1
  disk 6, o:1, dev:sdb1
md5: bitmap initialized from disk: read 9/9 pages, set 0 bits, status: 0
created bitmap (137 pages) for device md5
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 344k freed
INIT: version 2.84 booting
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
Adding 1003960k swap on /dev/md2.  Priority:-1 extents:1 across:1003960k
Testing root filesystem status:  read-only filesystem
Checking root filesystem:
fsck 1.38 (30-Jun-2005)
/dev/md0: clean, 317966/4128768 files, 1476899/4128688 blocks (check in 4 m=
ounts)
Remounting root device with read-write enabled.
EXT3 FS on md0, internal journal
/dev/md0 on / type ext3 (rw)
Starting udevd:  /sbin/udevd --daemon
udevd-event[2818]: udev_node_symlink: symlink(md/3, /dev/md3) failed: File =
exists
udevd-event[2820]: udev_node_symlink: symlink(md/0, /dev/md0) failed: File =
exists
udevd-event[2816]: udev_node_symlink: symlink(md/2, /dev/md2) failed: File =
exists
udevd-event[2812]: udev_node_symlink: symlink(md/1, /dev/md1) failed: File =
exists
udevd-event[2797]: udev_node_symlink: symlink(floppy/0, /dev/fd0) failed: F=
ile exists
md: md6 stopped.
udevd-event[3090]: udev_node_symlink: symlink(md/6, /dev/md6) failed: File =
exists
md: bind<md4>
md: bind<md5>
md: bind<md3>
md6: setting max_sectors to 128, segment boundary to 32767
raid0: looking at md3
raid0:   comparing md3(573905600) with md3(573905600)
raid0:   END
raid0:   =3D=3D> UNIQUE
raid0: 1 zones
raid0: looking at md5
raid0:   comparing md5(717382016) with md3(573905600)
raid0:   NOT EQUAL
raid0:   comparing md5(717382016) with md5(717382016)
raid0:   END
raid0:   =3D=3D> UNIQUE
raid0: 2 zones
raid0: looking at md4
raid0:   comparing md4(717382016) with md3(573905600)
raid0:   NOT EQUAL
raid0:   comparing md4(717382016) with md5(717382016)
raid0:   EQUAL
raid0: FINAL 2 zones
raid0: zone 1
raid0: checking md3 ... nope.
raid0: checking md4 ... contained as device 0
   (717382016) is smallest!.
raid0: checking md5 ... contained as device 1
raid0: zone->nb_dev: 2, size: 286952832
raid0: current zone offset: 717382016
raid0: done.
raid0 : md_size is 2008669632 blocks.
raid0 : conf->hash_spacing is 1721716800 blocks.
raid0 : nb_zone is 2.
raid0 : Allocating 8 bytes for hash.
mdadm: /dev/md6 has been started with 3 drives.
udevd-event[3092]: udev_node_symlink: symlink(md/6, /dev/md6) failed: File =
exists
Setting system time from the hardware clock (UTC).
Running /etc/rc.d/rc.modules -> rc.modules-2.4.33.3:
Module dependencies up to date (no new kernel modules found).
FATAL: Module agpgart not found.
FATAL: Module ide_scsi not found.
Checking non-root filesystems:
fsck 1.38 (30-Jun-2005)
/dev/md1: clean, 39/64256 files, 32163/256896 blocks
HOME: clean, 523/251084800 files, 142261474/502167408 blocks
Mounting non-root local filesystems:
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/md1 on /boot type ext3 (rw)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/md6 on /home type ext3 (rw)
Using /etc/random-seed to initialize /dev/urandom.
INIT: Entering runlevel: 3
Going multiuser...
cannot (un)set powersave mode
=1B[9;15]=1B[14;60]Starting sysklogd daemons:  /usr/sbin/syslogd /usr/sbin/=
klogd -c 3 -x
Scanning all LUNs for additional hardware:  /sbin/rescan-scsi-bus -l
Host adapter 0 (aic79xx) found.
Host adapter 1 (aic79xx) found.
Host adapter 2 (mptspi) found.
Host adapter 3 (mptspi) found.
Host adapter 4 (mptspi) found.
Host adapter 5 (mptspi) found.
Scanning hosts  0 1 2 3 4 5 channels 0 for
  SCSI target IDs  0 1 2 3 4 5 6 7 , LUNs  0 1 2 3 4 5 6 7
Scanning for device 0 0 0 0 ...
OLD: NEW: =1B[AScanning for device 0 0 1 0 ...
OLD: NEW: =1B[AScanning for device 0 0 2 0 ...
OLD: NEW: =1B[AScanning for device 0 0 3 0 ...
OLD: NEW: =1B[AScanning for device 0 0 4 0 ...
OLD: NEW: =1B[AScanning for device 0 0 5 0 ...
OLD: NEW: =1B[AScanning for device 0 0 6 0 ...
OLD: NEW: =1B[AScanning for device 0 0 7 0 ...
OLD: NEW: =1B[AScanning for device 1 0 0 0 ...
OLD: NEW: =1B[AScanning for device 1 0 1 0 ...
OLD: NEW: =1B[AScanning for device 1 0 2 0 ...
OLD: NEW: =1B[AScanning for device 1 0 3 0 ...
OLD: NEW: =1B[AScanning for device 1 0 4 0 ...
OLD: NEW: =1B[AScanning for device 1 0 5 0 ...
OLD: NEW: =1B[AScanning for device 1 0 6 0 ...
OLD: NEW: =1B[AScanning for device 1 0 7 0 ...
OLD: NEW: =1B[AScanning for device 2 0 0 0 ...
OLD: Host: scsi2 Channel: 00 Id: 00 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 0 1 ...
OLD: NEW: =1B[AScanning for device 2 0 0 2 ...
OLD: NEW: =1B[AScanning for device 2 0 0 3 ...
OLD: NEW: =1B[AScanning for device 2 0 0 4 ...
OLD: NEW: =1B[AScanning for device 2 0 0 5 ...
OLD: NEW: =1B[AScanning for device 2 0 0 6 ...
OLD: NEW: =1B[AScanning for device 2 0 0 7 ...
OLD: NEW: =1B[AScanning for device 2 0 1 0 ...
OLD: Host: scsi2 Channel: 00 Id: 01 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 1 1 ...
OLD: NEW: =1B[AScanning for device 2 0 1 2 ...
OLD: NEW: =1B[AScanning for device 2 0 1 3 ...
OLD: NEW: =1B[AScanning for device 2 0 1 4 ...
OLD: NEW: =1B[AScanning for device 2 0 1 5 ...
OLD: NEW: =1B[AScanning for device 2 0 1 6 ...
OLD: NEW: =1B[AScanning for device 2 0 1 7 ...
OLD: NEW: =1B[AScanning for device 2 0 2 0 ...
OLD: Host: scsi2 Channel: 00 Id: 02 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 2 1 ...
OLD: NEW: =1B[AScanning for device 2 0 2 2 ...
OLD: NEW: =1B[AScanning for device 2 0 2 3 ...
OLD: NEW: =1B[AScanning for device 2 0 2 4 ...
OLD: NEW: =1B[AScanning for device 2 0 2 5 ...
OLD: NEW: =1B[AScanning for device 2 0 2 6 ...
OLD: NEW: =1B[AScanning for device 2 0 2 7 ...
OLD: NEW: =1B[AScanning for device 2 0 3 0 ...
OLD: Host: scsi2 Channel: 00 Id: 03 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 3 1 ...
OLD: NEW: =1B[AScanning for device 2 0 3 2 ...
OLD: NEW: =1B[AScanning for device 2 0 3 3 ...
OLD: NEW: =1B[AScanning for device 2 0 3 4 ...
OLD: NEW: =1B[AScanning for device 2 0 3 5 ...
OLD: NEW: =1B[AScanning for device 2 0 3 6 ...
OLD: NEW: =1B[AScanning for device 2 0 3 7 ...
OLD: NEW: =1B[AScanning for device 2 0 4 0 ...
OLD: Host: scsi2 Channel: 00 Id: 04 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 4 1 ...
OLD: NEW: =1B[AScanning for device 2 0 4 2 ...
OLD: NEW: =1B[AScanning for device 2 0 4 3 ...
OLD: NEW: =1B[AScanning for device 2 0 4 4 ...
OLD: NEW: =1B[AScanning for device 2 0 4 5 ...
OLD: NEW: =1B[AScanning for device 2 0 4 6 ...
OLD: NEW: =1B[AScanning for device 2 0 4 7 ...
OLD: NEW: =1B[AScanning for device 2 0 5 0 ...
OLD: Host: scsi2 Channel: 00 Id: 05 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 5 1 ...
OLD: NEW: =1B[AScanning for device 2 0 5 2 ...
OLD: NEW: =1B[AScanning for device 2 0 5 3 ...
OLD: NEW: =1B[AScanning for device 2 0 5 4 ...
OLD: NEW: =1B[AScanning for device 2 0 5 5 ...
OLD: NEW: =1B[AScanning for device 2 0 5 6 ...
OLD: NEW: =1B[AScanning for device 2 0 5 7 ...
OLD: NEW: =1B[AScanning for device 2 0 6 0 ...
OLD: Host: scsi2 Channel: 00 Id: 06 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 6 1 ...
OLD: NEW: =1B[AScanning for device 2 0 6 2 ...
OLD: NEW: =1B[AScanning for device 2 0 6 3 ...
OLD: NEW: =1B[AScanning for device 2 0 6 4 ...
OLD: NEW: =1B[AScanning for device 2 0 6 5 ...
OLD: NEW: =1B[AScanning for device 2 0 6 6 ...
OLD: NEW: =1B[AScanning for device 2 0 6 7 ...
OLD: NEW: =1B[AScanning for device 2 0 7 0 ...
OLD: NEW: =1B[AScanning for device 3 0 0 0 ...
OLD: Host: scsi3 Channel: 00 Id: 00 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 0 1 ...
OLD: NEW: =1B[AScanning for device 3 0 0 2 ...
OLD: NEW: =1B[AScanning for device 3 0 0 3 ...
OLD: NEW: =1B[AScanning for device 3 0 0 4 ...
OLD: NEW: =1B[AScanning for device 3 0 0 5 ...
OLD: NEW: =1B[AScanning for device 3 0 0 6 ...
OLD: NEW: =1B[AScanning for device 3 0 0 7 ...
OLD: NEW: =1B[AScanning for device 3 0 1 0 ...
OLD: Host: scsi3 Channel: 00 Id: 01 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 1 1 ...
OLD: NEW: =1B[AScanning for device 3 0 1 2 ...
OLD: NEW: =1B[AScanning for device 3 0 1 3 ...
OLD: NEW: =1B[AScanning for device 3 0 1 4 ...
OLD: NEW: =1B[AScanning for device 3 0 1 5 ...
OLD: NEW: =1B[AScanning for device 3 0 1 6 ...
OLD: NEW: =1B[AScanning for device 3 0 1 7 ...
OLD: NEW: =1B[AScanning for device 3 0 2 0 ...
OLD: Host: scsi3 Channel: 00 Id: 02 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 2 1 ...
OLD: NEW: =1B[AScanning for device 3 0 2 2 ...
OLD: NEW: =1B[AScanning for device 3 0 2 3 ...
OLD: NEW: =1B[AScanning for device 3 0 2 4 ...
OLD: NEW: =1B[AScanning for device 3 0 2 5 ...
OLD: NEW: =1B[AScanning for device 3 0 2 6 ...
OLD: NEW: =1B[AScanning for device 3 0 2 7 ...
OLD: NEW: =1B[AScanning for device 3 0 3 0 ...
OLD: Host: scsi3 Channel: 00 Id: 03 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 3 1 ...
OLD: NEW: =1B[AScanning for device 3 0 3 2 ...
OLD: NEW: =1B[AScanning for device 3 0 3 3 ...
OLD: NEW: =1B[AScanning for device 3 0 3 4 ...
OLD: NEW: =1B[AScanning for device 3 0 3 5 ...
OLD: NEW: =1B[AScanning for device 3 0 3 6 ...
OLD: NEW: =1B[AScanning for device 3 0 3 7 ...
OLD: NEW: =1B[AScanning for device 3 0 4 0 ...
OLD: Host: scsi3 Channel: 00 Id: 04 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 4 1 ...
OLD: NEW: =1B[AScanning for device 3 0 4 2 ...
OLD: NEW: =1B[AScanning for device 3 0 4 3 ...
OLD: NEW: =1B[AScanning for device 3 0 4 4 ...
OLD: NEW: =1B[AScanning for device 3 0 4 5 ...
OLD: NEW: =1B[AScanning for device 3 0 4 6 ...
OLD: NEW: =1B[AScanning for device 3 0 4 7 ...
OLD: NEW: =1B[AScanning for device 3 0 5 0 ...
OLD: Host: scsi3 Channel: 00 Id: 05 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 5 1 ...
OLD: NEW: =1B[AScanning for device 3 0 5 2 ...
OLD: NEW: =1B[AScanning for device 3 0 5 3 ...
OLD: NEW: =1B[AScanning for device 3 0 5 4 ...
OLD: NEW: =1B[AScanning for device 3 0 5 5 ...
OLD: NEW: =1B[AScanning for device 3 0 5 6 ...
OLD: NEW: =1B[AScanning for device 3 0 5 7 ...
OLD: NEW: =1B[AScanning for device 3 0 6 0 ...
OLD: Host: scsi3 Channel: 00 Id: 06 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 3 0 6 1 ...
OLD: NEW: =1B[AScanning for device 3 0 6 2 ...
OLD: NEW: =1B[AScanning for device 3 0 6 3 ...
OLD: NEW: =1B[AScanning for device 3 0 6 4 ...
OLD: NEW: =1B[AScanning for device 3 0 6 5 ...
OLD: NEW: =1B[AScanning for device 3 0 6 6 ...
OLD: NEW: =1B[AScanning for device 3 0 6 7 ...
OLD: NEW: =1B[AScanning for device 3 0 7 0 ...
OLD: NEW: =1B[AScanning for device 4 0 0 0 ...
OLD: Host: scsi4 Channel: 00 Id: 00 Lun: 00
       Vendor: COMPAQ   Model: BB01811C9C       Rev: 3B07
       Type:   Direct-Access                    ANSI SCSI revision: 02
Scanning for device 4 0 0 1 ...
OLD: NEW: =1B[AScanning for device 4 0 0 2 ...
OLD: NEW: =1B[AScanning for device 4 0 0 3 ...
OLD: NEW: =1B[AScanning for device 4 0 0 4 ...
OLD: NEW: =1B[AScanning for device 4 0 0 5 ...
OLD: NEW: =1B[AScanning for device 4 0 0 6 ...
OLD: NEW: =1B[AScanning for device 4 0 0 7 ...
OLD: NEW: =1B[AScanning for device 4 0 1 0 ...
OLD: Host: scsi4 Channel: 00 Id: 01 Lun: 00
       Vendor: COMPAQ   Model: BB01811C9C       Rev: 3B07
       Type:   Direct-Access                    ANSI SCSI revision: 02
Scanning for device 4 0 1 1 ...
OLD: NEW: =1B[AScanning for device 4 0 1 2 ...
OLD: NEW: =1B[AScanning for device 4 0 1 3 ...
OLD: NEW: =1B[AScanning for device 4 0 1 4 ...
OLD: NEW: =1B[AScanning for device 4 0 1 5 ...
OLD: NEW: =1B[AScanning for device 4 0 1 6 ...
OLD: NEW: =1B[AScanning for device 4 0 1 7 ...
OLD: NEW: =1B[AScanning for device 4 0 2 0 ...
OLD: Host: scsi4 Channel: 00 Id: 02 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 4 0 2 1 ...
OLD: NEW: =1B[AScanning for device 4 0 2 2 ...
OLD: NEW: =1B[AScanning for device 4 0 2 3 ...
OLD: NEW: =1B[AScanning for device 4 0 2 4 ...
OLD: NEW: =1B[AScanning for device 4 0 2 5 ...
OLD: NEW: =1B[AScanning for device 4 0 2 6 ...
OLD: NEW: =1B[AScanning for device 4 0 2 7 ...
OLD: NEW: =1B[AScanning for device 4 0 3 0 ...
OLD: Host: scsi4 Channel: 00 Id: 03 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 4 0 3 1 ...
OLD: NEW: =1B[AScanning for device 4 0 3 2 ...
OLD: NEW: =1B[AScanning for device 4 0 3 3 ...
OLD: NEW: =1B[AScanning for device 4 0 3 4 ...
OLD: NEW: =1B[AScanning for device 4 0 3 5 ...
OLD: NEW: =1B[AScanning for device 4 0 3 6 ...
OLD: NEW: =1B[AScanning for device 4 0 3 7 ...
OLD: NEW: =1B[AScanning for device 4 0 4 0 ...
OLD: NEW: =1B[AScanning for device 4 0 5 0 ...
OLD: NEW: =1B[AScanning for device 4 0 6 0 ...
OLD: Host: scsi4 Channel: 00 Id: 06 Lun: 00
       Vendor: SUPER    Model: GEM318           Rev: 0
       Type:   Processor                        ANSI SCSI revision: 02
Scanning for device 4 0 6 1 ...
OLD: NEW: =1B[AScanning for device 4 0 6 2 ...
OLD: NEW: =1B[AScanning for device 4 0 6 3 ...
OLD: NEW: =1B[AScanning for device 4 0 6 4 ...
OLD: NEW: =1B[AScanning for device 4 0 6 5 ...
OLD: NEW: =1B[AScanning for device 4 0 6 6 ...
OLD: NEW: =1B[AScanning for device 4 0 6 7 ...
OLD: NEW: =1B[AScanning for device 4 0 7 0 ...
OLD: NEW: =1B[AScanning for device 5 0 0 0 ...
OLD: Host: scsi5 Channel: 00 Id: 00 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 5 0 0 1 ...
OLD: NEW: =1B[AScanning for device 5 0 0 2 ...
OLD: NEW: =1B[AScanning for device 5 0 0 3 ...
OLD: NEW: =1B[AScanning for device 5 0 0 4 ...
OLD: NEW: =1B[AScanning for device 5 0 0 5 ...
OLD: NEW: =1B[AScanning for device 5 0 0 6 ...
OLD: NEW: =1B[AScanning for device 5 0 0 7 ...
OLD: NEW: =1B[AScanning for device 5 0 1 0 ...
OLD: Host: scsi5 Channel: 00 Id: 01 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 5 0 1 1 ...
OLD: NEW: =1B[AScanning for device 5 0 1 2 ...
OLD: NEW: =1B[AScanning for device 5 0 1 3 ...
OLD: NEW: =1B[AScanning for device 5 0 1 4 ...
OLD: NEW: =1B[AScanning for device 5 0 1 5 ...
OLD: NEW: =1B[AScanning for device 5 0 1 6 ...
OLD: NEW: =1B[AScanning for device 5 0 1 7 ...
OLD: NEW: =1B[AScanning for device 5 0 2 0 ...
OLD: Host: scsi5 Channel: 00 Id: 02 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 5 0 2 1 ...
OLD: NEW: =1B[AScanning for device 5 0 2 2 ...
OLD: NEW: =1B[AScanning for device 5 0 2 3 ...
OLD: NEW: =1B[AScanning for device 5 0 2 4 ...
OLD: NEW: =1B[AScanning for device 5 0 2 5 ...
OLD: NEW: =1B[AScanning for device 5 0 2 6 ...
OLD: NEW: =1B[AScanning for device 5 0 2 7 ...
OLD: NEW: =1B[AScanning for device 5 0 3 0 ...
OLD: Host: scsi5 Channel: 00 Id: 03 Lun: 00
       Vendor: FUJITSU  Model: MAP3147NC        Rev: 0108
       Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 5 0 3 1 ...
OLD: NEW: =1B[AScanning for device 5 0 3 2 ...
OLD: NEW: =1B[AScanning for device 5 0 3 3 ...
OLD: NEW: =1B[AScanning for device 5 0 3 4 ...
OLD: NEW: =1B[AScanning for device 5 0 3 5 ...
OLD: NEW: =1B[AScanning for device 5 0 3 6 ...
OLD: NEW: =1B[AScanning for device 5 0 3 7 ...
OLD: NEW: =1B[AScanning for device 5 0 4 0 ...
OLD: NEW: =1B[AScanning for device 5 0 5 0 ...
OLD: NEW: =1B[AScanning for device 5 0 6 0 ...
OLD: Host: scsi5 Channel: 00 Id: 06 Lun: 00
       Vendor: SUPER    Model: GEM318           Rev: 0
       Type:   Processor                        ANSI SCSI revision: 02
Scanning for device 5 0 6 1 ...
OLD: NEW: =1B[AScanning for device 5 0 6 2 ...
OLD: NEW: =1B[AScanning for device 5 0 6 3 ...
OLD: NEW: =1B[AScanning for device 5 0 6 4 ...
OLD: NEW: =1B[AScanning for device 5 0 6 5 ...
OLD: NEW: =1B[AScanning for device 5 0 6 6 ...
OLD: NEW: =1B[AScanning for device 5 0 6 7 ...
OLD: NEW: =1B[AScanning for device 5 0 7 0 ...
OLD: NEW: =1B[A0 new device(s) found.=20
0 device(s) removed.=20
Starting Internet super-server daemon:  /usr/sbin/inetd
Starting OpenSSH SSH daemon:  /usr/sbin/sshd
Starting BIND:  /usr/sbin/named
Updating shared library links:  /sbin/ldconfig
Updating X font indexes:  /usr/X11R6/bin/fc-cache
Starting sendmail MTA daemon:  /usr/sbin/sendmail -L sm-mta -bd -q25m
Starting sendmail MSP queue runner:  /usr/sbin/sendmail -L sm-msp-queue -Ac=
 -q25m
Starting gpm:  /usr/sbin/gpm -m /dev/mouse -t ps2


Welcome to Linux 2.6.21-rc7 (ttyS0)

filesrv1b login:


# free
              total       used       free     shared    buffers     cached
Mem:       4143412     310752    3832660          0     143916      11252
-/+ buffers/cache:     155584    3987828
Swap:      1003960          0    1003960


# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0              15997560   5387940   9783884  36% /
/dev/md1                248783     24050    211889  11% /boot
/dev/md6             1977152236    131252 1956934288   1% /home

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [=
multipath]=20
md6 : active raid0 md3[0] md5[2] md4[1]
       2008669632 blocks 64k chunks

md5 : active raid6 sdh1[0] sdf1[2] sde1[1] sdd1[4] sdc1[3] sdb1[6] sda1[5]
       717382080 blocks level 6, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
       bitmap: 0/137 pages [0KB], 512KB chunk

md4 : active raid6 sdn1[1] sdm1[0] sdl1[3] sdk1[2] sdj1[5] sdi1[4] sdg1[6]
       717382080 blocks level 6, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
       bitmap: 0/137 pages [0KB], 512KB chunk

md1 : active raid1 sdp2[1] sdo2[0]
       256896 blocks [2/2] [UU]

md2 : active raid1 sdp3[1] sdo3[0]
       1003968 blocks [2/2] [UU]

md3 : active raid6 sdv1[5] sdu1[4] sdt1[3] sds1[2] sdr1[1] sdq1[0]
       573905664 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       bitmap: 0/137 pages [0KB], 512KB chunk

md0 : active raid1 sdp1[1] sdo1[0]
       16514752 blocks [2/2] [UU]

unused devices: <none>


  1282  exit
  1283  df
  1284  cat /proc/mdstat
  1285  hfind bonn
  1286* sleep 35 ; ( time bonnie++-1.03a/bonnie++ -u0:0 -d /home -s 524288 =
) 2>&1 | tee -a 512GB-bonnie++-run-ext3.log-200705022100
  1287  kill -HUP %1
  1288  dir /home/
  1289  rm /home/Binn*
  1290  rm /home/Bonn*
  1291  /etc/rc.d/rc.inet1 start
  1292  /etc/rc.d/rc.sshd start
  1293  uname -a
  1294   512GB-bonnie++-run-ext3.log-2007
  1295*  512GB-bonnie++-run-ext3.log-200705022100
  1296  uname -a > 512GB-bonnie++-run-ext3.log-200705022100
  1297  dmesg >> 512GB-bonnie++-run-ext3.log-200705022100
  1298  free >> 512GB-bonnie++-run-ext3.log-200705022100
  1299  df >> 512GB-bonnie++-run-ext3.log-200705022100
  1300  cat /proc/mdstat >> 512GB-bonnie++-run-ext3.log-200705022100
  1301  history 20 >> 512GB-bonnie++-run-ext3.log-200705022100


 =09Tia ,  JimL

--=20
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
--566704117-1451149149-1178311966=:7190--
