From: Stefan Berder <sbe@oleane.net>
Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Wed, 5 Jan 2005 19:08:36 +0100
Message-ID: <20050105190836.56872c22@gibson>
References: <0E3FA95632D6D047BA649F95DAB60E57058C00B5@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__5_Jan_2005_19_08_36_+0100_BsOks1lSgC2E4u1+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postcard.dih.oleane.net ([213.56.0.19]:45325 "EHLO
	postcard.dih.oleane.net") by vger.kernel.org with ESMTP
	id S262533AbVAESIg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 13:08:36 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57058C00B5@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Wed__5_Jan_2005_19_08_36_+0100_BsOks1lSgC2E4u1+
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Jan 2005 12:07:06 -0500=20
"Mukker, Atul" <Atulm@lsil.com> wrote:

> Please attach the dmesg output from the megaraid_mm and megaraid_mbox
> drivers as well. Also, all files from /proc/megaraid2 directory from
> 2.4 kernel driver

Attachment follows
Under 2.6.10, the 2 megaraid drivers hang in a kernel panic. I'll get a
dump tomorrow.

Stefan
--=20
 #=3D- Stefan Berder                  tel : 6 14 80        -=3D#
 #=3D- Ing=E9nieur syst=E8me et r=E9seau          01 53 95 14 80 -=3D#
 #=3D- TRANSPAC / DO-DAE-ADMG        mail : sbe@oleane.net -=3D#
 #=3D- /(bb|[^b]{2})/      stefan.berder@francetelecom.com -=3D#

--Multipart=_Wed__5_Jan_2005_19_08_36_+0100_BsOks1lSgC2E4u1+
Content-Type: text/plain;
 name="lspci.txt"
Content-Disposition: attachment;
 filename="lspci.txt"
Content-Transfer-Encoding: 7bit

brucelee:~/src# lspci -vx
0000:00:00.0 Host bridge: ServerWorks CNB20HE Host Bridge (rev 21)
	Flags: fast devsel
00: 66 11 08 00 00 00 00 00 21 00 00 06 08 20 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:00.1 Host bridge: ServerWorks CNB20HE Host Bridge (rev 01)
	Flags: bus master, medium devsel, latency 32
00: 66 11 08 00 47 01 00 22 01 00 00 06 08 20 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00

0000:00:00.2 Host bridge: ServerWorks CNB20HE Host Bridge
	Flags: medium devsel
00: 66 11 06 00 42 01 00 22 00 00 00 06 08 20 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:00.3 Host bridge: ServerWorks CNB20HE Host Bridge
	Flags: medium devsel
00: 66 11 06 00 42 01 00 22 00 00 00 06 08 20 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:04.0 VGA compatible controller: ATI Technologies Inc 3D Rage IIC (rev 7a) (prog-if 00 [VGA])
	Subsystem: Dell: Unknown device 00a2
	Flags: bus master, VGA palette snoop, stepping, medium devsel, latency 32
	Memory at fc000000 (32-bit, prefetchable) [size=16M]
	I/O ports at ec00 [size=256]
	Memory at fbeff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled] [size=128K]
	Capabilities: [5c] Power Management version 1
00: 02 10 59 47 a7 00 90 02 7a 00 00 03 08 20 00 00
10: 08 00 00 fc 01 ec 00 00 00 f0 ef fb 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 a2 00
30: 00 00 00 00 5c 00 00 00 00 00 00 00 ff 00 08 00

0000:00:05.0 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
	Subsystem: Dell: Unknown device 00a2
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
	BIST result: 00
	I/O ports at e800 [disabled] [size=256]
	Memory at fbefe000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at fbf00000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
00: 05 90 cf 00 16 01 b0 02 01 00 00 01 08 20 80 80
10: 01 e8 00 00 04 e0 ef fb 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 a2 00
30: 00 00 f0 fb dc 00 00 00 00 00 00 00 0b 01 28 19

0000:00:05.1 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
	Subsystem: Dell: Unknown device 00a2
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	BIST result: 00
	I/O ports at e400 [disabled] [size=256]
	Memory at fbefd000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at fbf00000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
00: 05 90 cf 00 16 01 b0 02 01 00 00 01 08 20 80 80
10: 01 e4 00 00 04 d0 ef fb 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 a2 00
30: 00 00 f0 fb dc 00 00 00 00 00 00 00 0a 02 28 19

0000:00:07.0 System peripheral: American Megatrends Inc. MegaRAC (rev 04)
	Subsystem: American Megatrends Inc. Dell Remote Assistant Card 2
	Flags: bus master, medium devsel, latency 32, IRQ 21
	BIST result: 00
	I/O ports at e080 [size=128]
	Memory at fbefc000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at fbf00000 [disabled] [size=16K]
00: 1e 10 63 90 17 01 00 02 04 00 80 08 08 20 00 80
10: 81 e0 00 00 00 c0 ef fb 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 1e 10 67 07
30: 00 00 f0 fb 00 00 00 00 00 00 00 00 05 01 00 00

0000:00:08.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 08)
	Subsystem: Dell PowerEdge 2550
	Flags: bus master, medium devsel, latency 32, IRQ 26
	Memory at fbefb000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at e040 [size=64]
	Memory at fbd00000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [dc] Power Management version 2
00: 86 80 29 12 17 01 90 02 08 00 00 02 08 20 00 00
10: 00 b0 ef fb 41 e0 00 00 00 00 d0 fb 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 9b 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 08 38

0000:00:0f.0 ISA bridge: ServerWorks OSB4 South Bridge (rev 50)
	Subsystem: ServerWorks OSB4 South Bridge
	Flags: bus master, medium devsel, latency 0
00: 66 11 00 02 07 00 00 02 50 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 00 02
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:0f.1 IDE interface: ServerWorks OSB4 IDE Controller (prog-if 8a [Master SecP PriP])
	Flags: bus master, medium devsel, latency 64
	I/O ports at 08b0 [size=16]
00: 66 11 11 02 05 00 00 02 00 8a 01 01 00 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: b1 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:0f.2 USB Controller: ServerWorks OSB4/CSB5 OHCI USB Controller (rev 04) (prog-if 10 [OHCI])
	Subsystem: ServerWorks OSB4/CSB5 OHCI USB Controller
	Flags: bus master, medium devsel, latency 32, IRQ 31
	Memory at fbefa000 (32-bit, non-prefetchable) [size=4K]
00: 66 11 20 02 17 01 80 02 04 10 03 0c 08 20 80 00
10: 00 a0 ef fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 66 11 20 02
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 50

0000:03:09.0 PCI bridge: Digital Equipment Corporation DECchip 21154 (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 32
	Bus: primary=03, secondary=04, subordinate=05, sec-latency=32
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: faa00000-facfffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f7f00000
	Capabilities: [dc] Power Management version 1
00: 11 10 26 00 07 01 b0 02 05 00 04 06 00 20 01 00
10: 00 00 00 00 00 00 00 00 03 04 05 20 c1 c1 80 22
20: a0 fa c0 fa 01 f0 f1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 00 00 06 00

0000:03:0a.0 PCI bridge: Intel Corp. 21154 PCI-to-PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 32
	Bus: primary=03, secondary=06, subordinate=07, sec-latency=32
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fa700000-fa9fffff
	Prefetchable memory behind bridge: 00000000e8000000-00000000eff00000
	Capabilities: [dc] Power Management version 1
00: 86 80 54 b1 07 01 b0 02 00 00 04 06 00 20 01 00
10: 00 00 00 00 00 00 00 00 03 06 07 20 b1 b1 80 22
20: 70 fa 90 fa 01 e8 f1 ef 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 00 00 06 00

0000:03:0b.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 08)
	Subsystem: Intel Corp. EtherExpress PRO/100+ Server Adapter (PILA8470B)
	Flags: bus master, medium devsel, latency 32, IRQ 25
	Memory at fa5ff000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at acc0 [size=64]
	Memory at fa400000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [dc] Power Management version 2
00: 86 80 29 12 17 01 90 02 08 00 00 02 08 20 00 00
10: 00 f0 5f fa c1 ac 00 00 00 00 40 fa 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 0c 10
30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 08 38

0000:04:00.0 PCI bridge: Digital Equipment Corporation DECchip 21154 (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, medium devsel, latency 32
	Bus: primary=04, secondary=05, subordinate=05, sec-latency=32
	Memory behind bridge: fac00000-facfffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f7f00000
	Capabilities: [dc] Power Management version 1
00: 11 10 26 00 07 01 90 02 05 00 04 06 00 20 01 00
10: 00 00 00 00 00 00 00 00 04 05 05 20 f1 01 80 22
20: c0 fa c0 fa 01 f0 f1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 00 00 06 00

0000:04:01.0 SCSI storage controller: QLogic Corp. ISP12160 Dual Channel Ultra3 SCSI Processor (rev 06)
	Subsystem: American Megatrends Inc. QLA12160 on AMI MegaRAID
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 27
	I/O ports at cc00 [size=256]
	Memory at faaff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at fab00000 [disabled] [size=128K]
	Capabilities: [44] Power Management version 1
00: 77 10 16 12 17 01 b0 02 06 00 00 01 08 20 00 00
10: 01 cc 00 00 00 f0 af fa 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 1e 10 93 84
30: 00 00 b0 fa 44 00 00 00 00 00 00 00 0b 01 40 00

0000:05:00.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 20)
	Subsystem: Dell PowerEdge RAID Controller 3/DC
	Flags: bus master, medium devsel, latency 32, IRQ 23
	Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Expansion ROM at fac00000 [disabled] [size=32K]
	Capabilities: [80] Power Management version 2
00: 1e 10 60 19 16 01 90 02 20 00 04 01 08 20 00 00
10: 08 00 00 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 93 04
30: 00 00 c0 fa 80 00 00 00 00 00 00 00 0a 01 00 00

0000:06:00.0 PCI bridge: Intel Corp. 21154 PCI-to-PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, medium devsel, latency 32
	Bus: primary=06, secondary=07, subordinate=07, sec-latency=32
	Memory behind bridge: fa900000-fa9fffff
	Prefetchable memory behind bridge: 00000000e8000000-00000000eff00000
	Capabilities: [dc] Power Management version 1
00: 86 80 54 b1 07 01 90 02 00 00 04 06 00 20 01 00
10: 00 00 00 00 00 00 00 00 06 07 07 20 f1 01 80 22
20: 90 fa 90 fa 01 e8 f1 ef 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 00 00 06 00

0000:06:01.0 SCSI storage controller: QLogic Corp. ISP12160 Dual Channel Ultra3 SCSI Processor (rev 06)
	Subsystem: American Megatrends Inc. QLA12160 on AMI MegaRAID
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 28
	I/O ports at bc00 [size=256]
	Memory at fa7ff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at fa800000 [disabled] [size=128K]
	Capabilities: [44] Power Management version 1
00: 77 10 16 12 17 01 b0 02 06 00 00 01 08 20 00 00
10: 01 bc 00 00 00 f0 7f fa 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 1e 10 93 84
30: 00 00 80 fa 44 00 00 00 00 00 00 00 05 01 40 00

0000:07:00.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 20)
	Subsystem: Dell PowerEdge RAID Controller 3/DC
	Flags: bus master, medium devsel, latency 32, IRQ 24
	Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Expansion ROM at fa900000 [disabled] [size=32K]
	Capabilities: [80] Power Management version 2
00: 1e 10 60 19 16 01 90 02 20 00 04 01 08 20 00 00
10: 08 00 00 e8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 93 04
30: 00 00 90 fa 80 00 00 00 00 00 00 00 0b 01 00 00


--Multipart=_Wed__5_Jan_2005_19_08_36_+0100_BsOks1lSgC2E4u1+
Content-Type: text/plain;
 name="dmesg-2.4.28.txt"
Content-Disposition: attachment;
 filename="dmesg-2.4.28.txt"
Content-Transfer-Encoding: 7bit

brucelee:~/src# dmesg
Linux version 2.4.28-bruce2.4 (root@brucelee) (gcc version 3.3.4 (Debian 1:3.3.4-13)) #1 SMP Wed Jan 5 13:39:01 CET 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 000000003fffe000 (usable)
 BIOS-e820: 000000003fffe000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
hm, page 000fe000 reserved twice.
hm, page 000ff000 reserved twice.
hm, page 000f0000 reserved twice.
On node 0 totalpages: 262142
zone(0): 4096 pages.
zone(1): 225280 pages.
zone(2): 32766 pages.
ACPI: RSDP (v000 DELL                                      ) @ 0x000fdcb0
ACPI: RSDT (v001 DELL   PE6450   0x00000002 MSFT 0x0100000a) @ 0x000fdcc4
ACPI: FADT (v001 DELL   PE6450   0x00000002 MSFT 0x0100000a) @ 0x000fdcf0
ACPI: MADT (v001 DELL   PE6450   0x00000002 MSFT 0x0100000a) @ 0x000fdd64
ACPI: DSDT (v001 DELL   PE6450   0x00000002 MSFT 0x0100000a) @ 0x00000000
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 Pentium(tm) Pro APIC version 17
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] enabled)
Processor #0 Pentium(tm) Pro APIC version 17
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: DELL     Product ID: POWEREDGE A2 APIC at: 0xFEE00000
I/O APIC #2 Version 17 at 0xFEC00000.
I/O APIC #3 Version 17 at 0xFEC01000.
Enabling APIC mode: Flat.	Using 2 I/O APICs
Processors: 2
Kernel command line: auto BOOT_IMAGE=Linux ro root=802
Initializing CPU#0
Detected 699.336 MHz processor.
Console: colour VGA+ 80x50
Calibrating delay loop... 1395.91 BogoMIPS
Memory: 1032112k/1048568k available (2290k kernel code, 16072k reserved, 758k data, 132k init, 131064k highmem)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount cache hash table entries: 512 (order: 0, 4096 bytes)
Buffer cache hash table entries: 65536 (order: 6, 262144 bytes)
Page-cache hash table entries: 262144 (order: 8, 1048576 bytes)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
CPU0: Intel Pentium III (Cascades) stepping 01
per-CPU timeslice cutoff: 2923.06 usecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000040
ESR value after enabling vector: 00000000
Booting processor 1/0 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 1395.91 BogoMIPS
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check reporting enabled on CPU#1.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
CPU1: Intel Pentium III (Cascades) stepping 01
Total of 2 processors activated (2791.83 BogoMIPS).
ENABLING IO-APIC IRQs
Setting 2 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 2 ... ok.
Setting 3 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 3 ... ok.
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-2, 2-5, 2-10, 2-11, 2-13 not connected.
..TIMER: vector=0x31 pin1=-1 pin2=0
...trying to set up timer (IRQ0) through the 8259A ... 
..... (found pin 0) ...works.
number of MP IRQ sources: 48.
number of IO-APIC #2 registers: 16.
number of IO-APIC #3 registers: 16.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 003 03  0    0    0   0   0    1    1    31
 01 003 03  0    0    0   0   0    1    1    39
 02 000 00  1    0    0   0   0    0    0    00
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  0    0    0   0   0    1    1    49
 05 000 00  1    0    0   0   0    0    0    00
 06 003 03  0    0    0   0   0    1    1    51
 07 003 03  0    0    0   0   0    1    1    59
 08 003 03  0    0    0   0   0    1    1    61
 09 003 03  0    0    0   0   0    1    1    69
 0a 000 00  1    0    0   0   0    0    0    00
 0b 000 00  1    0    0   0   0    0    0    00
 0c 003 03  0    0    0   0   0    1    1    71
 0d 000 00  1    0    0   0   0    0    0    00
 0e 003 03  0    0    0   0   0    1    1    79
 0f 003 03  0    0    0   0   0    1    1    81

IO APIC #3......
.... register #00: 03000000
.......    : physical APIC id: 03
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 0D000000
.......     : arbitration: 0D
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 003 03  1    1    0   1   0    1    1    89
 01 003 03  1    1    0   1   0    1    1    91
 02 003 03  1    1    0   1   0    1    1    99
 03 003 03  1    1    0   1   0    1    1    A1
 04 003 03  1    1    0   1   0    1    1    A9
 05 003 03  1    1    0   1   0    1    1    B1
 06 003 03  1    1    0   1   0    1    1    B9
 07 003 03  1    1    0   1   0    1    1    C1
 08 003 03  1    1    0   1   0    1    1    C9
 09 003 03  1    1    0   1   0    1    1    D1
 0a 003 03  1    1    0   1   0    1    1    D9
 0b 003 03  1    1    0   1   0    1    1    E1
 0c 003 03  1    1    0   1   0    1    1    E9
 0d 003 03  1    1    0   1   0    1    1    32
 0e 003 03  1    1    0   1   0    1    1    3A
 0f 003 03  1    1    0   1   0    1    1    42
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ12 -> 0:12
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ16 -> 1:0
IRQ17 -> 1:1
IRQ18 -> 1:2
IRQ19 -> 1:3
IRQ20 -> 1:4
IRQ21 -> 1:5
IRQ22 -> 1:6
IRQ23 -> 1:7
IRQ24 -> 1:8
IRQ25 -> 1:9
IRQ26 -> 1:10
IRQ27 -> 1:11
IRQ28 -> 1:12
IRQ29 -> 1:13
IRQ30 -> 1:14
IRQ31 -> 1:15
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 699.2856 MHz.
..... host bus clock speed is 99.8976 MHz.
cpu: 0, clocks: 998976, slice: 332992
CPU0<T0:998976,T1:665984,D:0,S:332992,C:998976>
cpu: 1, clocks: 998976, slice: 332992
CPU1<T0:998976,T1:332992,D:0,S:332992,C:998976>
checking TSC synchronization across CPUs: passed.
Waiting on wait_init_idle (map = 0x2)
All processors have done init_idle
PCI: PCI BIOS revision 2.10 entry at 0xfc7ee, last bus=16
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Discovered primary peer bus 03 [IRQ]
PCI: Discovered primary peer bus 10 [IRQ]
PCI: Using IRQ router ServerWorks [1166/0200] at 00:0f.0
PCI->APIC IRQ transform: (B0,I5,P0) -> 17
PCI->APIC IRQ transform: (B0,I5,P1) -> 18
PCI->APIC IRQ transform: (B0,I7,P0) -> 21
PCI->APIC IRQ transform: (B0,I8,P0) -> 26
PCI->APIC IRQ transform: (B0,I15,P0) -> 31
PCI->APIC IRQ transform: (B3,I11,P0) -> 25
PCI->APIC IRQ transform: (B4,I1,P0) -> 27
PCI->APIC IRQ transform: (B5,I0,P0) -> 23
PCI->APIC IRQ transform: (B6,I1,P0) -> 28
PCI->APIC IRQ transform: (B7,I0,P0) -> 24
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
Starting kswapd
allocated 32 pages and 32 bhs reserved for the highmem bounces
Journalled Block Device driver loaded
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
HP CISS Driver (v 2.4.52)
Intel(R) PRO/100 Network Driver - version 2.3.43-k1
Copyright (c) 2004 Intel Corporation

e100: selftest OK.
e100: eth0: Intel(R) PRO/100 Network Connection
  Hardware receive checksums enabled
  cpu cycle saver enabled

e100: selftest OK.
e100: eth1: Intel(R) PRO/100 Network Connection
  Hardware receive checksums enabled
  cpu cycle saver enabled

Linux agpgart interface v0.99 (c) Jeff Hartmann
agpgart: Maximum main memory to use for agp memory: 941M
agpgart: no supported devices found.
[drm] Initialized tdfx 1.0.0 20010216 on minor 0
[drm] Initialized radeon 1.7.0 20020828 on minor 1
[drm:drm_init] *ERROR* Cannot initialize the agpgart module.
Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks OSB4: IDE controller at PCI slot 00:0f.1
SvrWks OSB4: chipset revision 0
SvrWks OSB4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x08b0-0x08b7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x08b8-0x08bf, BIOS settings: hdc:pio, hdd:pio
hda: TEAC CD-ROM CD-224E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: attached ide-cdrom driver.
hda: ATAPI 24X CD-ROM drive, 128kB Cache, (U)DMA
Uniform CD-ROM driver Revision: 3.12
SCSI subsystem driver Revision: 1.00
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

megaraid: v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
megaraid: found 0x101e:0x1960:bus 5:slot 0:func 0
scsi2:Found MegaRAID controller at 0xf8808000, IRQ:23
megaraid: [1.57:3.13] detected 2 logical drives.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: found 0x101e:0x1960:bus 7:slot 0:func 0
scsi3:Found MegaRAID controller at 0xf880a000, IRQ:24
megaraid: [161J:3.17] detected 0 logical drives.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: Cluster driver, initiator id:14
scsi2 : LSI Logic MegaRAID 1.57 254 commands 16 targs 5 chans 7 luns
scsi3 : LSI Logic MegaRAID 161J 254 commands 16 targs 5 chans 7 luns
scsi2: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID1 34678R  Rev: 1.57
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: MegaRAID  Model: LD1 RAID5 46780R  Rev: 1.57
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi2: scanning scsi channel 1 for logical drives.
scsi2: scanning scsi channel 2 for logical drives.
scsi2: scanning scsi channel 4 [P0] for physical devices.
  Vendor: DELL      Model: 1x4 U2W SCSI BP   Rev: 1.27
  Type:   Processor                          ANSI SCSI revision: 02
scsi2: scanning scsi channel 5 [P1] for physical devices.
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
scsi3: scanning scsi channel 0 for logical drives.
scsi3: scanning scsi channel 1 for logical drives.
scsi3: scanning scsi channel 2 for logical drives.
scsi3: scanning scsi channel 4 [P0] for physical devices.
scsi3: scanning scsi channel 5 [P1] for physical devices.
Attached scsi disk sda at scsi2, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi2, channel 0, id 1, lun 0
SCSI device sda: 71020544 512-byte hdwr sectors (36363 MB)
Partition check:
 sda: sda1 sda2
SCSI device sdb: 710205440 512-byte hdwr sectors (363625 MB)
 sdb: sdb1
es1371: version v0.32 time 13:43:04 Jan  5 2005
Linux Kernel Card Services 3.1.22
  options:  [pci] [cardbus] [pm]
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
host/usb-ohci.c: USB OHCI at membase 0xf880c000, IRQ 31
host/usb-ohci.c: usb-00:0f.2, ServerWorks OSB4/CSB5 OHCI USB Controller
usb.c: new USB bus registered, assigned bus number 1
hub.c: USB hub found
hub.c: 2 ports detected
Initializing USB Mass Storage driver...
usb.c: registered new driver usb-storage
USB Mass Storage support registered.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
ip_conntrack version 2.1 (8191 buckets, 65528 max) - 152 bytes per conntrack
ip_tables: (C) 2000-2002 Netfilter core team
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ds: no socket drivers loaded!
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 132k freed
Adding Swap: 1000424k swap-space (priority -1)
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,2), internal journal
hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04Aborted Command 
e100: eth0 NIC Link is Up 100 Mbps Full duplex

--Multipart=_Wed__5_Jan_2005_19_08_36_+0100_BsOks1lSgC2E4u1+
Content-Type: application/octet-stream;
 name="proc-megaraid-2.4.28.tar.bz2"
Content-Disposition: attachment;
 filename="proc-megaraid-2.4.28.tar.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWW/r7DUABql/mMiAAEBAAv+ioaIQAH/v32AEAAAQAAhAAh2lIgGMhkNBoNGgDQAN
DBIo00gU0DagADQAAYyGQ0Gg0aANAA0MClSRNJ4KbEQGg9NRoPUyaepzStw06sa8tmWOb6vNyaW6
004YYwmMW0r+Eh7AEAtNNduGsFI4GWyiYgpF2TeZxQlhaEskrKVwlZpWpK7pWKLKEYSspXlKyldp
nYYYYMD7PR69ubLJttttugJUpuQlSjbbbbfmZCFXTZkgQtzO63xb9CWgqTi4uLi4uKwnLk9srlKx
Qt0rENsp2uGfc6pWZ2RwlNADYBBJNtwlNjjQlB1ZN0gwIxvtxEpIQlUytBJatnmIWdx2Wqvd5poS
goOSaqhdMsSyUVQkxjaSVnE6TjNEkpAG2Z1NTSleJXfI5vCVylYZmdk3lcnN4vKVrGdnc5GQ8B/B
pa22Vk9A83qbJX3GorvkebD0bRsD9DSddVvZ5WlhKySu106Fa0rrHcw1h0lcpXwlb25gOwZSut6m
1K1N0GHcwdjJ0laQ0N7ZRf8XckU4UJBv6+w1

--Multipart=_Wed__5_Jan_2005_19_08_36_+0100_BsOks1lSgC2E4u1+--
