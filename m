From: support <support@degrp.de>
Subject: Re[2]: Megaraid problem.
Date: Thu, 13 May 2004 08:40:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <744578064.20040513084031@degrp.de>
References: <1269894521.20040510145117@degrp.de>
 <m34qqotl6s.fsf@merlin.emma.line.org>
Reply-To: support <support@degrp.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.degrp.org ([62.225.179.11]:7436 "EHLO mail.degrp.de")
	by vger.kernel.org with ESMTP id S263826AbUEMGkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 02:40:41 -0400
In-Reply-To: <m34qqotl6s.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello Matthias,

Monday, May 10, 2004, 4:23:55 PM, you wrote:

MA> support <support@degrp.de> writes:

>> the megaraid driver doesn't load when correctly when the local APIC =
or
>> SMP is enabled in the kernel. Is this problem know or is anyone
>> working on this problem?

MA> Not a problem for me.

MA> Please add system configuration details, mainboard, BIOS manufactur=
er
MA> and version, exact megaraid hardware and so on.

The System is a HP LH 3000 Server with integrated Netraid (onboard).
lspci output and serial console output is appended

00:00.0 Host bridge: Intel Corp. 440BX/ZX - 82443BX/ZX Host bridge (AGP=
 disabled) (rev 03)
00:04.0 ISA bridge: Intel Corp. 82371AB PIIX4 ISA (rev 02)
00:04.1 IDE interface: Intel Corp. 82371AB PIIX4 IDE (rev 01)
00:04.2 USB Controller: Intel Corp. 82371AB PIIX4 USB (rev 01)
00:04.3 Bridge: Intel Corp. 82371AB PIIX4 ACPI (rev 02)
00:07.0 PCI bridge: Intel Corp. 80960RP [i960 RP Microprocessor/Bridge]=
 (rev 03)
00:07.1 SCSI storage controller: Intel Corp. 80960RP [i960RP Microproce=
ssor] (rev 03)
00:08.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03=
)
00:0b.0 System peripheral: Hewlett-Packard Company NetServer Smart IRQ =
Router (rev a0)
00:0d.0 VGA compatible controller: Cirrus Logic GD 5446 (rev 45)
02:02.0 Ethernet controller: Intel Corp. 82557 [Ethernet Pro 100] (rev =
02)

Kernel boot log:

LILO 22.2 boot:
Loading Linux266.........................
Linux version 2.6.6 (root@serial) (gcc version 2.95.4 20011002 (Debian =
prerelease)) #1 SMP Wed May 12 16:23:26 CEST 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000010000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
256MB LOWMEM available.
found SMP MP-table at 000f69b0
On node 0 totalpages: 65536
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 61440 pages, LIFO batch:15
  HighMem zone: 0 pages, LIFO batch:1
DMI not present.
ACPI: Unable to locate RSDP
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: HP       Product ID: LH 3         APIC at: 0xFEE00000
Processor #1 6:7 APIC version 17
I/O APIC #0 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Built 1 zonelists
Kernel command line: BOOT_IMAGE=3DLinux266 ro root=3D801 console=3DttyS=
0,9600n8
Initializing CPU#0
PID hash table entries: 2048 (order 11: 16384 bytes)
Detected 499.282 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Memory: 256116k/262144k available (1776k kernel code, 5296k reserved, 8=
98k data, 156k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode..=
=2E Ok.
Calibrating delay loop... 985.08 BogoMIPS
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU serial number disabled.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
CPU0: Intel Pentium III (Katmai) stepping 03
per-CPU timeslice cutoff: 1461.94 usecs.
task migration cache decay timeout: 2 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Total of 1 processors activated (985.08 BogoMIPS).
ENABLING IO-APIC IRQs
Setting 0 in the phys_id_present_map
=2E..changing IO-APIC physical APIC ID to 0 ... ok.
=2E.TIMER: vector=3D0x31 pin1=3D2 pin2=3D0
=2E.MP-BIOS bug: 8254 timer not connected to IO-APIC
=2E..trying to set up timer (IRQ0) through the 8259A ...
=2E.... (found pin 0) ...works.
testing the IO APIC.......................
=2E................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
=2E.... CPU clock speed is 499.0090 MHz.
=2E.... host bus clock speed is 99.0818 MHz.
Brought up 1 CPUs
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfdaa7, last bus=3D2
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040326
ACPI: Interpreter disabled.
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:04.0
PCI->APIC IRQ transform: (B0,I7,P0) -> 25
PCI->APIC IRQ transform: (B2,I2,P0) -> 27
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
udf: registering filesystem
Limiting direct PCI/PCI transfers.
Real Time Clock Driver v1.12
Serial: 8250/16550 driver $Revision: 1.90 $ 48 ports, IRQ sharing enabl=
ed
=FFttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
ttyS3 at I/O 0x2e8 (irq =3D 0) is a 16550A
Using anticipatory io scheduler
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
e100: Intel(R) PRO/100 Network Driver, 3.0.17
e100: Copyright(c) 1999-2004 Intel Corporation
e100: eth0: e100_probe: addr 0xefffe000, irq 27, MAC addr 00:A0:C9:F4:9=
B:A8
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
PIIX4: IDE controller at PCI slot 0000:00:04.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfcd0-0xfcd7, BIOS settings: hda:pio, hdb:pio
hda: CD-532E-B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 32X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
megaraid: found 0x8086:0x1960:bus 0:slot 7:func 1
scsi0:Found MegaRAID controller at 0xd081c000, IRQ:25
megaraid: Couldn't register IRQ 25!
mice: PS/2 mouse device common for all mice
serio: i8042 AUX port at 0x60,0x64 irq 12
input: ImExPS/2 Logitech Explorer Mouse on isa0060/serio1
serio: i8042 KBD port at 0x60,0x64 irq 1
atkbd.c: Failed to enable keyboard on isa0060/serio0
input: AT Translated Set 2 keyboard on isa0060/serio0
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 16384)
NET: Registered protocol family 1
NET: Registered protocol family 17
VFS: Cannot open root device "801" or unknown-block(8,1)
Please append a correct "root=3D" boot option
Kernel panic: VFS: Unable to mount root fs on unknown-block(8,1)

--
Best regards,
 Thomas                            mailto:support@degrp.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
