From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 30 May 2005 21:07:16 +0200
Message-ID: <20050530190716.GA9239@gmail.com>
References: <20050524153930.GA10911@gmail.com> <1117113563.4967.17.camel@mulgrave> <20050526143516.GA9593@gmail.com> <1117118766.4967.22.camel@mulgrave> <20050526173518.GA9132@gmail.com> <1117463938.4913.3.camel@mulgrave> <20050530150950.GA14351@gmail.com> <1117467248.4913.9.camel@mulgrave> <20050530160147.GD14351@gmail.com> <1117477040.4913.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.204]:17524 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261699AbVE3TH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 15:07:28 -0400
Received: by wproxy.gmail.com with SMTP id 68so1818861wri
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2005 12:07:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1117477040.4913.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, May 30, 2005 at 01:17:20PM -0500, James Bottomley wrote:

> Well that's good ... it proves the theory that if the DV were correct=
ly
> limited initially, everything would work.

OK :-)

> However ... lets see if we can get it to work properly even with the
> initial mismatch.  Reverse the previous patch, apply this one and try
> rebooting ...

Unfortunately it don't work :

Bootdata ok (command line is root=3D/dev/sdc2 parport=3Dauto video=3Dve=
safb:mtrr,ywrap,1024x800-16@75 vga=3D0xF07 console=3DttyS0)

Linux version 2.6.12-rc5 (root@gregoire) (gcc version 3.4.3 20041125 (G=
entoo Linux 3.4.3-r1, ssp-3.4.3-0, pie-8.7.7)) #3 Mon May 30 20:38:57 C=
EST 2005

BIOS-provided physical RAM map:

 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)

 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)

 BIOS-e820: 000000003fff0000 - 000000003fff8000 (ACPI data)

 BIOS-e820: 000000003fff8000 - 0000000040000000 (ACPI NVS)

 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)

 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)

 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)

ACPI: PM-Timer IO Port: 0x808

ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)

Processor #0 15:12 APIC version 16

ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])

IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23

ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)

ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)

Setting APIC routing to flat

Using ACPI (MADT) for SMP configuration information

Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)

Built 1 zonelists

Kernel command line: root=3D/dev/sdc2 parport=3Dauto video=3Dvesafb:mtr=
r,ywrap,1024x800-16@75 vga=3D0xF07 console=3DttyS0

Initializing CPU#0

PID hash table entries: 4096 (order: 12, 131072 bytes)

time.c: Using 3.579545 MHz PM timer.

time.c: Detected 2000.148 MHz processor.

time.c: Using PIT/TSC based timekeeping.

Console: colour VGA+ 80x60

Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)

Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)

Memory: 1025304k/1048512k available (3138k kernel code, 22512k reserved=
, 1306k data, 160k init)

Mount-cache hash table entries: 256

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)

CPU: L2 Cache: 512K (64 bytes/line)

CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00

Using local APIC timer interrupts.

Detected 12.500 MHz APIC timer.

testing NMI watchdog ... OK.

NET: Registered protocol family 16

PCI: Using configuration type 1

mtrr: v2.0 (20020519)

ACPI: Subsystem revision 20050309

ACPI: Interpreter enabled

ACPI: Using IOAPIC for interrupt routing

ACPI: PCI Root Bridge [PCI0] (0000:00)

PCI: Probing PCI hardware (bus 00)

PCI: Via IRQ fixup

ACPI: Power Resource [URP1] (off)

ACPI: Power Resource [URP2] (off)

ACPI: Power Resource [FDDP] (off)

ACPI: Power Resource [LPTP] (off)

ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)

ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)

ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)

ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)

ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, dis=
abled.

ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, dis=
abled.

ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, dis=
abled.

ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, dis=
abled.

SCSI subsystem initialized

usbcore: registered new driver usbfs

usbcore: registered new driver hub

PCI: Using ACPI for IRQ routing

PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report

IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $

NTFS driver 2.1.22 [Flags: R/O].

EFS: 1.0a - http://aeschi.ch.eu.org/efs/

SGI XFS with large block/inode numbers, no debug enabled

Initializing Cryptographic API

ACPI: Power Button (FF) [PWRF]

ACPI: Sleep Button (CM) [SLPB]

Real Time Clock Driver v1.12

Non-volatile memory driver v1.2

serio: i8042 AUX port at 0x60,0x64 irq 12

serio: i8042 KBD port at 0x60,0x64 irq 1

Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabl=
ed

ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A

parport0: PC-style at 0x378 [PCSPP(,...)]

io scheduler noop registered

io scheduler anticipatory registered

io scheduler deadline registered

io scheduler cfq registered

=46loppy drive(s): fd0 is 1.44M

=46DC 0 is a post-1991 82077

r8169 Gigabit Ethernet driver 2.2LK loaded

ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 16 (level, low) -> IRQ 16

r8169: NAPI enabled

eth0: RTL8169 at 0xffffc20000002b00, 00:0c:76:bd:22:23, IRQ 16

Linux video capture interface: v1.00

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2

ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx

VP_IDE: IDE controller at PCI slot 0000:00:0f.1

ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20

VP_IDE: chipset revision 6

VP_IDE: not 100% native mode: will probe irqs later

VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1

    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio

    ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:pio

hda: IC35L120AVVA07-0, ATA DISK drive

ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

hdc: SONY DVD RW DRU-500A, ATAPI CD/DVD-ROM drive

hdd: IOMEGA ZIP 250 ATAPI Floppy, ATAPI FLOPPY drive

hdd: set_drive_speed_status: status=3D0x51 { DriveReady SeekComplete Er=
ror }

hdd: set_drive_speed_status: error=3D0x04 { AbortedCommand }

ide1 at 0x170-0x177,0x376 on irq 15

hda: max request size: 128KiB

hda: 241254720 sectors (123522 MB) w/1863KiB Cache, CHS=3D65535/16/63, =
UDMA(100)

hda: cache flushes supported

 hda: hda1 hda2 hda3 hda4

hdc: ATAPI 16X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache, UDMA(33)

Uniform CD-ROM driver Revision: 3.20

ide-floppy driver 0.99.newide

hdd: No disk in drive

hdd: 244736kB, 239/64/32 CHS, 4096 kBps, 512 sector size, 2941 rpm

ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16

ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level, low) -> IRQ 17

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36

        <Adaptec 29160B Ultra160 SCSI adapter>

        aic7892: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs



  Vendor: IBM       Model: DDRS-39130D       Rev: DC1B

  Type:   Direct-Access                      ANSI SCSI revision: 02

scsi0:A:0:0: Tagged Queuing enabled.  Depth 253

 target0:0:0: Beginning Domain Validation

WIDTH IS 1

(scsi0:A:0): 6.600MB/s transfers (16bit)

 target0:0:0: Domain Validation skipping write tests

(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 15, 16bit)

 target0:0:0: Ending Domain Validation

  Vendor: SEAGATE   Model: ST336706LW        Rev: 0108

  Type:   Direct-Access                      ANSI SCSI revision: 03

scsi0:A:15:0: Tagged Queuing enabled.  Depth 253

 target0:0:15: Beginning Domain Validation

WIDTH IS 1

(scsi0:A:15): 6.600MB/s transfers (16bit)

(scsi0:A:15): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)

 target0:0:15: Ending Domain Validation

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36

        <Adaptec 2940 Ultra SCSI adapter>

        aic7880: Ultra Single Channel A, SCSI Id=3D7, 16/253 SCBs



scsi1:0:0:0: Attempting to queue an ABORT message

CDB: 0x12 0x0 0x0 0x0 0x24 0x0

scsi1: At time of recovery, card was not paused

>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<

scsi1: Dumping Card State while idle, at SEQADDR 0x18

Card was paused

ACCUM =3D 0x3, SINDEX =3D 0x20, DINDEX =3D 0xc0, ARG_2 =3D 0x0

HCNT =3D 0x0 SCBPTR =3D 0x0

SCSISIGI[0x44] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]=20

SCSISEQ[0x1a] SBLKCTL[0x0] SCSIRATE[0x0] SEQCTL[0x10]=20

SEQ_FLAGS[0xc0] SSTAT0[0x5] SSTAT1[0x0] SSTAT2[0x0]=20

SSTAT3[0x0] SIMODE0[0x0] SIMODE1[0xa4] SXFRCTL0[0x80]=20

DFCNTRL[0x4] DFSTATUS[0x6d]=20

STACK: 0x0 0x0 0x192 0x17

SCB count =3D 4

Kernel NEXTQSCB =3D 2

Card NEXTQSCB =3D 2

QINFIFO entries:=20

Waiting Queue entries: 0:3=20

Disconnected Queue entries:=20

QOUTFIFO entries:=20

Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15=20

Sequencer SCB Info:=20

  0 SCB_CONTROL[0x50] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0x3]=20

  1 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

Pending list:=20

  3 SCB_CONTROL[0x50] SCB_SCSIID[0x7] SCB_LUN[0x0]=20

Kernel Free SCB list: 1 0=20

Untagged Q(0): 3=20



<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>

scsi1:0:0:0: Cmd aborted from QINFIFO

aic7xxx_abort returns 0x2002

scsi1:0:0:0: Attempting to queue an ABORT message

CDB: 0x0 0x0 0x0 0x0 0x0 0x0

scsi1: At time of recovery, card was not paused

>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<

scsi1: Dumping Card State while idle, at SEQADDR 0x18

Card was paused

ACCUM =3D 0x3, SINDEX =3D 0x20, DINDEX =3D 0xc0, ARG_2 =3D 0x0

HCNT =3D 0x0 SCBPTR =3D 0x0

SCSISIGI[0x44] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]=20

SCSISEQ[0x1a] SBLKCTL[0x0] SCSIRATE[0x0] SEQCTL[0x10]=20

SEQ_FLAGS[0xc0] SSTAT0[0x5] SSTAT1[0x0] SSTAT2[0x0]=20

SSTAT3[0x0] SIMODE0[0x0] SIMODE1[0xa4] SXFRCTL0[0x80]=20

DFCNTRL[0x4] DFSTATUS[0x6d]=20

STACK: 0x0 0x0 0x192 0x17

SCB count =3D 4

Kernel NEXTQSCB =3D 3

Card NEXTQSCB =3D 2

QINFIFO entries: 2=20

Waiting Queue entries:=20

Disconnected Queue entries:=20

QOUTFIFO entries:=20

Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15=20

Sequencer SCB Info:=20

  0 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]=20

  1 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

Pending list:=20

  2 SCB_CONTROL[0x50] SCB_SCSIID[0x7] SCB_LUN[0x0]=20

Kernel Free SCB list: 1 0=20

Untagged Q(0): 2=20



<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>

scsi1:0:0:0: Cmd aborted from QINFIFO

aic7xxx_abort returns 0x2002

scsi1:0:0:0: Attempting to queue a TARGET RESET message

CDB: 0x12 0x0 0x0 0x0 0x24 0x0

scsi1:0:0:0: Command not found

aic7xxx_dev_reset returns 0x2002

scsi1:0:0:0: Attempting to queue an ABORT message

CDB: 0x0 0x0 0x0 0x0 0x0 0x0

scsi1: At time of recovery, card was not paused

>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<

scsi1: Dumping Card State while idle, at SEQADDR 0x18

Card was paused

ACCUM =3D 0x3, SINDEX =3D 0x20, DINDEX =3D 0xc0, ARG_2 =3D 0x0

HCNT =3D 0x0 SCBPTR =3D 0x0

SCSISIGI[0x44] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x1]=20

SCSISEQ[0x1a] SBLKCTL[0x0] SCSIRATE[0x0] SEQCTL[0x10]=20

SEQ_FLAGS[0xc0] SSTAT0[0x5] SSTAT1[0x0] SSTAT2[0x0]=20

SSTAT3[0x0] SIMODE0[0x0] SIMODE1[0xa4] SXFRCTL0[0x80]=20

DFCNTRL[0x4] DFSTATUS[0x6d]=20

STACK: 0x0 0x0 0x192 0x17

SCB count =3D 4

Kernel NEXTQSCB =3D 2

Card NEXTQSCB =3D 3

QINFIFO entries: 3=20

Waiting Queue entries:=20

Disconnected Queue entries:=20

QOUTFIFO entries:=20

Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15=20

Sequencer SCB Info:=20

  0 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]=20

  1 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

Pending list:=20

  3 SCB_CONTROL[0x50] SCB_SCSIID[0x7] SCB_LUN[0x0]=20

Kernel Free SCB list: 1 0=20

Untagged Q(0): 3=20



<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>

scsi1:0:0:0: Cmd aborted from QINFIFO

aic7xxx_abort returns 0x2002

scsi: Device offlined - not ready after error recovery: host 1 channel =
0 id 0 lun 0

  Vendor: TOSHIBA   Model: DVD-ROM SD-M1201  Rev: 1R08

  Type:   CD-ROM                             ANSI SCSI revision: 02

 target1:0:1: Beginning Domain Validation

 target1:0:1: Domain Validation skipping write tests

(scsi1:A:1): 20.000MB/s transfers (20.000MHz, offset 15)

scsi1:0:1:0: Attempting to queue an ABORT message

CDB: 0x12 0x0 0x0 0x0 0x60 0x0

scsi1: At time of recovery, card was not paused

>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<

scsi1: Dumping Card State in Data-in phase, at SEQADDR 0x7b

Card was paused

ACCUM =3D 0x0, SINDEX =3D 0xb8, DINDEX =3D 0xa8, ARG_2 =3D 0x0

HCNT =3D 0x60 SCBPTR =3D 0x0

SCSISIGI[0x44] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0x40]=20

SCSISEQ[0x12] SBLKCTL[0x0] SCSIRATE[0xf] SEQCTL[0x10]=20

SEQ_FLAGS[0x20] SSTAT0[0x0] SSTAT1[0x2] SSTAT2[0x0]=20

SSTAT3[0x0] SIMODE0[0x0] SIMODE1[0xac] SXFRCTL0[0xa0]=20

DFCNTRL[0x38] DFSTATUS[0x40]=20

STACK: 0x0 0x162 0x192 0x6e

SCB count =3D 4

Kernel NEXTQSCB =3D 2

Card NEXTQSCB =3D 2

QINFIFO entries:=20

Waiting Queue entries:=20

Disconnected Queue entries:=20

QOUTFIFO entries:=20

Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15=20

Sequencer SCB Info:=20

  0 SCB_CONTROL[0x48] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x3]=20

  1 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff]=20

Pending list:=20

  3 SCB_CONTROL[0x48] SCB_SCSIID[0x17] SCB_LUN[0x0]=20

Kernel Free SCB list: 1 0=20

Untagged Q(1): 3=20



<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>

scsi1:0:1:0: Device is active, asserting ATN

R...

Thank,
--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
