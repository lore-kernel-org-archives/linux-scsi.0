From: =?iso-8859-1?q?Karl=20Ranseier?= <karlran1234@yahoo.com>
Subject: aic7xxx says: PCI error Interrupt at seqaddr = 0x8
Date: Mon, 15 Apr 2002 18:28:16 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020415162816.99313.qmail@web14804.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: karlran1234@yahoo.com

Hello,
I've a big problem with my SCSI/PCI setup:

When doing a:
>/sbin/modprobe aic7xxx

Apr 14 09:13:04 test  kernel: SCSI subsystem driver Revision: 1.00
Apr 14 09:13:04 test  kernel: PCI: Found IRQ 11 for device 00:0b.0
Apr 14 09:13:04 test  kernel: PCI: Sharing IRQ 11 with 00:07.2
Apr 14 09:13:04 test  kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI
SCSI HBA DRIVER, Rev 6.2.4
Apr 14 09:13:04 test  kernel:         <Adaptec 29160 Ultra160 SCSI
adapter>
Apr 14 09:13:04 test  kernel:         aic7892: Ultra160 Wide Channel
A, SCSI Id=3D7, 32/253 SCBs
Apr 14 09:13:04 test  kernel:
Apr 14 09:13:04 test  kernel: scsi0: PCI error Interrupt at seqaddr =3D
0x8
Apr 14 09:13:04 test  kernel: scsi0: Data Parity Error Detected
during address or write data phase
Apr 14 09:13:04 test  kernel: scsi0: PCI error Interrupt at seqaddr =3D
0x8
Apr 14 09:13:04 test  kernel: scsi0: Data Parity Error Detected
during address or write data phase
Apr 14 09:13:04 test  kernel: scsi0: PCI error Interrupt at seqaddr =3D
0x9
Apr 14 09:13:04 test  kernel: scsi0: Data Parity Error Detected
during address or write data phase
Apr 14 09:13:05 test  kernel: scsi0: PCI error Interrupt at seqaddr =3D
0x9
Apr 14 09:13:05 test  kernel: scsi0: Data Parity Error Detected
during address or write data phase
Apr 14 09:13:05 test  kernel: scsi0: PCI error Interrupt at seqaddr =3D
0x8

Has anyone seen this before?

The problem ONLY appears when I run my PC with a Davicom 100MBPS NIC.
The Davicom runs fine without the 29160!

>scanpci  -v

pci bus 0x0 cardnum 0x00 function 0x0000: vendor 0x8086 device 0x7190
 Intel 82443BX Host
  STATUS    0xa210  COMMAND 0x0006
  CLASS     0x06 0x00 0x00  REVISION 0x03
  HEADER    0x00  LATENCY 0x40

pci bus 0x0 cardnum 0x01 function 0x0000: vendor 0x8086 device 0x7191
 Intel 82443BX AGP
  STATUS    0x0220  COMMAND 0x0107
  CLASS     0x06 0x04 0x00  REVISION 0x03
  HEADER    0x01  LATENCY 0x40
  PRIBUS    0x00  SECBUS 0x01  SUBBUS 0x01  SECLT 0x40
  IOBASE    0xc000  IOLIM 0xcfff  SECSTATUS 0x02a0
  NOPREFETCH_MEMBASE 0xfff00000  MEMLIM 0x000fffff
  PREFETCH_MEMBASE   0xfff00000  MEMLIM 0x000fffff
  FAST_B2B NO_SEC_BUS_RST NO_M_ABRT NO_VGA_EN NO_ISA_EN NO_PERR_EN

pci bus 0x0 cardnum 0x07 function 0x0000: vendor 0x8086 device 0x7110
 Intel 82371AB PIIX4 ISA
  STATUS    0x0280  COMMAND 0x000f
  CLASS     0x06 0x01 0x00  REVISION 0x02
  HEADER    0x80  LATENCY 0x00

pci bus 0x0 cardnum 0x07 function 0x0001: vendor 0x8086 device 0x7111
 Intel 82371AB PIIX4 IDE
  STATUS    0x0280  COMMAND 0x0005
  CLASS     0x01 0x01 0x80  REVISION 0x01
  BIST      0x00  HEADER 0x00  LATENCY 0x40  CACHE 0x00
  BASE4     0x0000f001  addr 0x0000f000  I/O
  BYTE_0    0x8000a307  BYTE_1  0x00  BYTE_2  0x806cc48  BYTE_3=20
0xffffffff

pci bus 0x0 cardnum 0x07 function 0x0002: vendor 0x8086 device 0x7112
 Intel 82371AB PIIX4 USB
  STATUS    0x0280  COMMAND 0x0005
  CLASS     0x0c 0x03 0x00  REVISION 0x01
  BIST      0x00  HEADER 0x00  LATENCY 0x40  CACHE 0x00
  BASE4     0x0000e001  addr 0x0000e000  I/O
  MAX_LAT   0x00  MIN_GNT 0x00  INT_PIN 0x04  INT_LINE 0xff

pci bus 0x0 cardnum 0x07 function 0x0003: vendor 0x8086 device 0x7113
 Intel 82371AB PIIX4 ACPI
  STATUS    0x0280  COMMAND 0x0003
  CLASS     0x06 0x80 0x00  REVISION 0x02

pci bus 0x0 cardnum 0x08 function 0x0000: vendor 0x1011 device 0x0024
 Digital DC21152
  STATUS    0x8290  COMMAND 0x0107
  CLASS     0x06 0x04 0x00  REVISION 0x03
  HEADER    0x01  LATENCY 0x40
  PRIBUS    0x00  SECBUS 0x02  SUBBUS 0x02  SECLT 0x40
  IOBASE    0xd100  IOLIM 0xdfff  SECSTATUS 0x0280
  NOPREFETCH_MEMBASE 0xe0000000  MEMLIM 0xe7ffffff
  PREFETCH_MEMBASE   0xfff10000  MEMLIM 0x000fffff
  NO_FAST_B2B NO_SEC_BUS_RST NO_M_ABRT VGA_EN ISA_EN NO_PERR_EN

pci bus 0x0 cardnum 0x09 function 0x0000: vendor 0x1282 device 0x9102
 Device unknown
 CardVendor 0x3030 card 0x5032 (Card unknown)
  STATUS    0x8210  COMMAND 0x0007
  CLASS     0x02 0x00 0x00  REVISION 0x31
  BIST      0x00  HEADER 0x00  LATENCY 0x40  CACHE 0x00
  BASE0     0x0000e401  addr 0x0000e400  I/O
  BASE1     0xee001000  addr 0xee001000  MEM
  BASEROM   0xec000000  addr 0xec000000  not-decode-enabled
  MAX_LAT   0x28  MIN_GNT 0x14  INT_PIN 0x01  INT_LINE 0x0a

pci bus 0x0 cardnum 0x0a function 0x0000: vendor 0x13f6 device 0x0111
 Device unknown
 CardVendor 0x13f6 card 0x0111 (Card unknown)
  STATUS    0x0210  COMMAND 0x0005
  CLASS     0x04 0x01 0x00  REVISION 0x10
  BIST      0x00  HEADER 0x00  LATENCY 0x40  CACHE 0x00
  BASE0     0x0000e801  addr 0x0000e800  I/O
  MAX_LAT   0x18  MIN_GNT 0x02  INT_PIN 0x01  INT_LINE 0x0b

pci bus 0x0 cardnum 0x0b function 0x0000: vendor 0x9005 device 0x0080
 Adaptec  Device unknown
 CardVendor 0x9005 card 0xe2a0 (Adaptec, Card unknown)
  STATUS    0x82b0  COMMAND 0x0007
  CLASS     0x01 0x00 0x00  REVISION 0x02  =20
  BIST      0x80  HEADER 0x00  LATENCY 0x40  CACHE 0x08
  BASE0     0x0000ec01  addr 0x0000ec00  I/O
  BASE1     0xee000004  addr 0xee000000  MEM 64BIT
  BASEROM   0xed000000  addr 0xed000000  not-decode-enabled
  MAX_LAT   0x19  MIN_GNT 0x28  INT_PIN 0x01  INT_LINE 0x0a
  BYTE_0    0x482  BYTE_1  0x00  BYTE_2  0x806e140  BYTE_3=20
0xffffffff

Kernel: 2.4.17
MoBo: GA-BXE (Intel BX)
CPU: Celeron300
Aha29160
Davicom9102

I already tried shuffeling the boards & IRQs - no luck :-((


Thanks for any tricks or hints,

Karl

PS: Please keep the Cc...


__________________________________________________________________

Gesendet von Yahoo! Mail - http://mail.yahoo.de
Sie brauchen mehr Speicher f=FCr Ihre E-Mails? - http://premiummail.yah=
oo.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
