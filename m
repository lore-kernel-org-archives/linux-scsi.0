From: Greg Stitt <gstitt@gmail.com>
Subject: Re: old and new megaraid drivers for linux
Date: Fri, 17 Dec 2004 11:11:30 -0500
Message-ID: <f8d4a352041217081124063c9a@mail.gmail.com>
References: <0E3FA95632D6D047BA649F95DAB60E57058BFB6D@exa-atlanta>
Reply-To: Greg Stitt <gstitt@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1438_15643715.1103299890561"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.203]:30874 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261584AbULQQLb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2004 11:11:31 -0500
Received: by wproxy.gmail.com with SMTP id 36so67555wra
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2004 08:11:30 -0800 (PST)
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57058BFB6D@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

------=_Part_1438_15643715.1103299890561
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Atul,

Attached is the info.  If you need anything else, let me know.

Thanks!
Greg


On Fri, 17 Dec 2004 09:00:09 -0500, Mukker, Atul <Atulm@lsil.com> wrote:
> Can you send as an attachment the 2.00.3 driver information using files from
> /proc/megaraid directory and the dmesg output for the PERC controller. Also
> the output from "lspci -vx" command. Let us see if this controller can be
> safely added in the 2.20 driver.
> 
> Thanks
> 
> ---
> Atul Mukker
> Architect, Drivers and BIOS
> LSI Logic Corporation
> 
> > -----Original Message-----
> > From: Greg Stitt [mailto:gstitt@gmail.com]
> > Sent: Thursday, December 16, 2004 9:59 PM
> > To: linux-scsi@vger.kernel.org
> > Subject: old and new megaraid drivers for linux
> >
> > Hello,
> >
> > I currently have a system with both a PERC2/SC, and a
> > recently added MegaRAID SATA 150-6.
> >
> > The PERC2/SC ran fine with the 'old style' megaraid driver (2.00.3).
> > However, the SATA card has issues with this driver, as I can't even
> > format the drives without problems.   Under Windows 2003, both cards
> > operate fine, so I don't believe this is a hardware issue.
> >
> > I tried the new megaraid driver (2.20.4.0), but it doesn't
> > recognize the PERC at all.  Not sure how stable it is with
> > the SATA though, as the PERC contains all the OS. :-)
> >
> > This was tried using the 2.6.9 linux kernel.
> >
> > I've seen mention of this issue before on this list, but has
> > anything been done since then to resolve this?
> >
> > Thanks
> > Greg Stitt
> > -
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-scsi" in the body of a message to
> > majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> >
>

------=_Part_1438_15643715.1103299890561
Content-Type: text/plain; name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="dmesg.txt"

SCSI subsystem initialized
megaraid: found 0x1000:0x1960:bus 0:slot 10:func 0
scsi0:Found MegaRAID controller at 0xf8a16000, IRQ:21
megaraid: [713G:G117] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
scsi0 : LSI Logic MegaRAID 713G 254 commands 16 targs 4 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD 0 RAID5  715G  Rev: 713G
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 1465159680 512-byte hdwr sectors (750162 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
megaraid: found 0x8086:0x1960:bus 2:slot 10:func 1
scsi1:Found MegaRAID controller at 0xf8a18000, IRQ:18
megaraid: [3.13:1.43] detected 2 logical drives.
megaraid: channel[0] is raid.
scsi1 : LSI Logic MegaRAID 3.13 254 commands 16 targs 4 chans 7 luns
scsi1: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID5 25704R  Rev: 3.13
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdb: 52641792 512-byte hdwr sectors (26953 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 >
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
  Vendor: MegaRAID  Model: LD1 RAID5 69356R  Rev: 3.13
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdc: 142041088 512-byte hdwr sectors (72725 MB)
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 sdc: sdc1
Attached scsi disk sdc at scsi1, channel 0, id 1, lun 0
scsi1: scanning scsi channel 4 [P0] for physical devices.
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: DELL      Model: 1x6 U2W SCSI BP   Rev: 5.35
  Type:   Processor                          ANSI SCSI revision: 02

------=_Part_1438_15643715.1103299890561
Content-Type: text/plain; name="lspci.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="lspci.txt"

romulus:/proc/megaraid # lspci -vx
0000:00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host brid=
ge (rev 02)
        Subsystem: Dell Computer Corporation: Unknown device 0081
        Flags: bus master, medium devsel, latency 32
        Memory at ec000000 (32-bit, prefetchable)
        Capabilities: [a0] AGP version 1.0
00: 86 80 90 71 06 01 10 22 02 00 00 06 00 20 00 00
10: 08 00 00 ec 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 81 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00

0000:00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge=
 (rev 02) (prog-if 00 [Normal decode])
        Flags: bus master, 66Mhz, medium devsel, latency 32
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
32
        I/O behind bridge: 0000f000-0000ffff
        Memory behind bridge: fb000000-fdffffff
        Prefetchable memory behind bridge: f3000000-f3ffffff
        Expansion ROM at 0000f000 [disabled] [size=3D4K]
00: 86 80 91 71 1f 01 20 02 02 00 04 06 00 20 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 20 f0 f0 a0 22
20: 00 fb f0 fd 00 f3 f0 f3 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 00

0000:00:02.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 0=
3) (prog-if 00 [Normal decode])
        Flags: bus master, medium devsel, latency 32
        Bus: primary=3D00, secondary=3D02, subordinate=3D03, sec-latency=3D=
32
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: f9000000-faffffff
        Prefetchable memory behind bridge: 00000000f1000000-00000000f2f0000=
0
        Expansion ROM at 0000e000 [disabled] [size=3D4K]
        Capabilities: [dc] Power Management version 1
00: 11 10 24 00 07 01 90 02 03 00 04 06 08 20 01 00
10: 00 00 00 00 00 00 00 00 00 02 03 20 e1 e1 80 22
20: 00 f9 f0 fa 01 f1 f1 f2 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 00 00 06 03

0000:00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
        Flags: bus master, medium devsel, latency 0
00: 86 80 10 71 0f 00 80 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01) (p=
rog-if 80 [Master])
        Flags: medium devsel
        I/O ports at 1000 [size=3D16]
00: 86 80 11 71 01 00 80 02 01 80 01 01 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01) (=
prog-if 00 [UHCI])
        Flags: bus master, medium devsel, latency 64, IRQ 19
        I/O ports at 1020 [size=3D32]
00: 86 80 12 71 05 00 80 02 01 00 03 0c 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00

0000:00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 02)
        Flags: medium devsel, IRQ 9
00: 86 80 13 71 01 00 80 02 02 00 80 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:08.0 Ethernet controller: 3Com Corporation 3c905 100BaseTX [Boomera=
ng]
        Flags: bus master, medium devsel, latency 32, IRQ 20
        I/O ports at dcc0 [size=3Df8000000]
        Expansion ROM at 00010000 [disabled]
00: b7 10 50 90 07 01 00 02 00 00 00 02 00 20 00 00
10: c1 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 f8 00 00 00 00 00 00 00 00 0e 01 03 08

0000:00:0a.0 RAID bus controller: LSI Logic / Symbios Logic PowerEdge Expan=
dable RAID Controller 4 (rev 01)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 0523
        Flags: bus master, 66Mhz, slow devsel, latency 32, IRQ 21
        Memory at f4000000 (32-bit, prefetchable) [size=3Df8000000]
        Expansion ROM at 00010000 [disabled]
        Capabilities: [80] Power Management version 2
00: 00 10 60 19 16 01 b0 24 01 00 04 01 08 20 00 00
10: 08 00 00 f4 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 10 23 05
30: 00 00 00 f8 80 00 00 00 00 00 00 00 0b 01 00 00

0000:00:0e.0 Multimedia audio controller: Aureal Semiconductor Vortex 1 (re=
v 02)
        Subsystem: Voyetra Technologies Montego
        Flags: bus master, medium devsel, latency 32, IRQ 17
        Memory at fe000000 (32-bit, non-prefetchable)
        I/O ports at dcb8 [size=3D8]
        I/O ports at dca8 [size=3D8]
        Capabilities: [dc] Power Management version 1
00: eb 12 01 00 07 01 90 02 02 00 01 04 08 20 00 00
10: 00 00 00 fe b9 dc 00 00 a9 dc 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 53 50 55 33
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0a 01 02 0c

0000:01:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro AG=
P 1X (rev 5c) (prog-if 00 [VGA])
        Subsystem: Dell Computer Corporation: Unknown device 0081
        Flags: bus master, VGA palette snoop, stepping, medium devsel, late=
ncy 32
        Memory at fc000000 (32-bit, non-prefetchable)
        I/O ports at fc00 [size=3D256]
        Memory at fbfff000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [50] AGP version 1.0
00: 02 10 44 47 a7 00 90 02 5c 00 00 03 08 20 00 00
10: 00 00 00 fc 01 fc 00 00 00 f0 ff fb 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 81 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 08 00

0000:02:04.0 SCSI storage controller: Adaptec AHA-2940U2/U2W / 7890/7891
        Subsystem: Dell Computer Corporation: Unknown device 0081
        Flags: bus master, medium devsel, latency 32, IRQ 16
        BIST result: 00
        I/O ports at ec00 [disabled] [size=3Dfa000000]
        Memory at f9fff000 (64-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at 00020000 [disabled]
        Capabilities: [dc] Power Management version 1
00: 05 90 1f 00 16 01 90 02 00 00 00 01 08 20 00 80
10: 01 ec 00 00 04 f0 ff f9 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 81 00
30: 00 00 00 fa dc 00 00 00 00 00 00 00 05 01 27 19

0000:02:06.0 SCSI storage controller: Adaptec AIC-7860 (rev 03)
        Subsystem: Adaptec: Unknown device 7860
        Flags: bus master, medium devsel, latency 32, IRQ 16
        I/O ports at e800 [disabled]
        Memory at f9ffe000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [dc] Power Management version 1
00: 04 90 78 60 16 01 90 02 03 00 00 01 08 20 00 00
10: 01 e8 00 00 00 e0 ff f9 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 04 90 60 78
30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 04 04

0000:02:0a.0 PCI bridge: Intel Corp. 80960RP [i960 RP Microprocessor/Bridge=
] (rev 03) (prog-if 00 [Normal decode])
        Flags: bus master, medium devsel, latency 32
        Bus: primary=3D02, secondary=3D03, subordinate=3D03, sec-latency=3D=
32
00: 86 80 60 09 07 01 80 02 03 00 04 06 08 20 81 00
10: 00 00 00 00 00 00 00 00 02 03 03 20 f0 00 80 22
20: f0 ff 00 00 f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 00

0000:02:0a.1 SCSI storage controller: Intel Corp. 80960RP [i960RP Microproc=
essor] (rev 03)
        Subsystem: Dell Computer Corporation PowerEdge Expandable RAID Cont=
roller 2/SC
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at f2ff0000 (32-bit, prefetchable) [size=3Dfa000000]
        Expansion ROM at 00008000 [disabled]
00: 86 80 60 19 16 01 80 02 03 00 00 01 08 20 80 00
10: 08 00 ff f2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 11 11
30: 00 00 00 fa 00 00 00 00 00 00 00 00 0a 01 00 00

romulus:/proc/megaraid #
------=_Part_1438_15643715.1103299890561
Content-Type: text/plain; name="proc-megaraid.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="proc-megaraid.txt"

romulus:/proc/megaraid/hba1 # ls -al
total 0
dr-xr-xr-x  2 root root 0 Dec 17 10:50 .
dr-xr-xr-x  4 root root 0 Dec 17 10:44 ..
-r--------  1 root root 0 Dec 17 10:50 battery-status
-r--------  1 root root 0 Dec 17 10:50 config
-r--------  1 root root 0 Dec 17 10:50 diskdrives-ch0
-r--------  1 root root 0 Dec 17 10:50 diskdrives-ch1
-r--------  1 root root 0 Dec 17 10:50 diskdrives-ch2
-r--------  1 root root 0 Dec 17 10:50 diskdrives-ch3
-r--------  1 root root 0 Dec 17 10:50 mailbox
-r--------  1 root root 0 Dec 17 10:50 raiddrives-0-9
-r--------  1 root root 0 Dec 17 10:50 raiddrives-10-19
-r--------  1 root root 0 Dec 17 10:50 raiddrives-20-29
-r--------  1 root root 0 Dec 17 10:50 raiddrives-30-39
-r--------  1 root root 0 Dec 17 10:50 rebuild-rate
-r--------  1 root root 0 Dec 17 10:50 stat
romulus:/proc/megaraid/hba1 # more *
::::::::::::::
battery-status
::::::::::::::
Battery Status:[9] Module Missing Pack Missing
::::::::::::::
config
::::::::::::::
v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)
Controller Type: 438/466/467/471/493/518/520/531/532
Controller is not using 64-bit memory addressing
Base =3D f8a18000, Irq =3D 18, Logical Drives =3D 2, Channels =3D 1
Version =3D3.13:1.43, DRAM =3D 16Mb
Controller Queue Depth =3D 254, Driver Queue Depth =3D 126
support_ext_cdb    =3D 0
support_random_del =3D 0
boot_ldrv_enabled  =3D 1
boot_ldrv          =3D 0
boot_pdrv_enabled  =3D 0
boot_pdrv_ch       =3D 0
boot_pdrv_tgt      =3D 0
quiescent          =3D 0
has_cluster        =3D 0

Module Parameters:
max_cmd_per_lun    =3D 63
max_sectors_per_io =3D 128
::::::::::::::
diskdrives-ch0
::::::::::::::
Channel: 0 Id: 0 State: Online.
  Vendor: SEAGATE   Model: ST39102LC         Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 02
Channel: 0 Id: 1 State: Online.
  Vendor: SEAGATE   Model: ST39102LC         Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 02
Channel: 0 Id: 2 State: Online.
  Vendor: SEAGATE   Model: ST39102LC         Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 02
Channel: 0 Id: 3 State: Online.
  Vendor: SEAGATE   Model: ST39102LC         Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 02
Channel: 0 Id: 4 State: Online.
  Vendor: SEAGATE   Model: ST336605LC        Rev: 2203
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 8 State: Online.
  Vendor: SEAGATE   Model: ST336737LW        Rev: 0102
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 9 State: Online.
  Vendor: SEAGATE   Model: ST336737LW        Rev: 0102
  Type:   Direct-Access                      ANSI SCSI revision: 03
::::::::::::::
diskdrives-ch1
::::::::::::::
::::::::::::::
diskdrives-ch2
::::::::::::::
::::::::::::::
diskdrives-ch3
::::::::::::::
::::::::::::::
mailbox
::::::::::::::
Contents of Mail Box Structure
  Fw Command   =3D 0x04
  Cmd Sequence =3D 0x7f
  No of Sectors=3D 0000
  LBA          =3D 0x00
  DTA          =3D 0x15412000
  Logical Drive=3D 0x00
  No of SG Elmt=3D 0x00
  Busy         =3D 0
  Status       =3D 0x00
::::::::::::::
raiddrives-0-9
::::::::::::::
Logical drive: 0:, state: optimal
Span depth:  1, RAID level:  5, Stripe size: 64, Row size:  4
Read Policy: Adaptive, Write Policy: Write thru, Cache Policy: Direct IO

Logical drive: 1:, state: optimal
Span depth:  1, RAID level:  5, Stripe size: 64, Row size:  3
Read Policy: Adaptive, Write Policy: Write thru, Cache Policy: Direct IO

::::::::::::::
raiddrives-10-19
::::::::::::::
::::::::::::::
raiddrives-20-29
::::::::::::::
::::::::::::::
raiddrives-30-39
::::::::::::::
::::::::::::::
rebuild-rate
::::::::::::::
Rebuild Rate: [30%]
::::::::::::::
stat
::::::::::::::
Statistical Information for this controller
pend_cmds =3D 0
IO and error counters not compiled in driver.
romulus:/proc/megaraid/hba1 #=20

-------------------------------------------------------------------

romulus:/proc/megaraid/hba0 # ls -al
total 0
dr-xr-xr-x  2 root root 0 Dec 17 10:53 .
dr-xr-xr-x  4 root root 0 Dec 17 10:44 ..
-r--------  1 root root 0 Dec 17 10:53 battery-status
-r--------  1 root root 0 Dec 17 10:53 config
-r--------  1 root root 0 Dec 17 10:53 diskdrives-ch0
-r--------  1 root root 0 Dec 17 10:53 diskdrives-ch1
-r--------  1 root root 0 Dec 17 10:53 diskdrives-ch2
-r--------  1 root root 0 Dec 17 10:53 diskdrives-ch3
-r--------  1 root root 0 Dec 17 10:53 mailbox
-r--------  1 root root 0 Dec 17 10:53 raiddrives-0-9
-r--------  1 root root 0 Dec 17 10:53 raiddrives-10-19
-r--------  1 root root 0 Dec 17 10:53 raiddrives-20-29
-r--------  1 root root 0 Dec 17 10:53 raiddrives-30-39
-r--------  1 root root 0 Dec 17 10:53 rebuild-rate
-r--------  1 root root 0 Dec 17 10:53 stat
romulus:/proc/megaraid/hba0 # more *
::::::::::::::
battery-status
::::::::::::::
Battery Status:[1] Module Missing
::::::::::::::
config
::::::::::::::
v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)
MegaRAID SATA 150-6D
Controller Type: 438/466/467/471/493/518/520/531/532
Controller Supports 40 Logical Drives
Controller capable of 64-bit memory addressing
Controller is not using 64-bit memory addressing
Base =3D f8a16000, Irq =3D 21, Logical Drives =3D 1, Channels =3D 1
Version =3D713G:G117, DRAM =3D 64Mb
Controller Queue Depth =3D 254, Driver Queue Depth =3D 126
support_ext_cdb    =3D 1
support_random_del =3D 1
boot_ldrv_enabled  =3D 1
boot_ldrv          =3D 0
boot_pdrv_enabled  =3D 0
boot_pdrv_ch       =3D 0
boot_pdrv_tgt      =3D 0
quiescent          =3D 0
has_cluster        =3D 0

Module Parameters:
max_cmd_per_lun    =3D 63
max_sectors_per_io =3D 128
::::::::::::::
diskdrives-ch0
::::::::::::::
Channel: 0 Id: 0 State: Online.
  Vendor: WDC       Model: WD2500JD-98HBB0   Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 1 State: Online.
  Vendor: WDC       Model: WD2500JD-00HBB0   Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 2 State: Online.
  Vendor: WDC       Model: WD2500JD-00HBB0   Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 03
Channel: 0 Id: 3 State: Online.
  Vendor: WDC       Model: WD2500JD-00HBB0   Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 03
::::::::::::::
diskdrives-ch1
::::::::::::::
::::::::::::::
diskdrives-ch2
::::::::::::::
::::::::::::::
diskdrives-ch3
::::::::::::::
::::::::::::::
mailbox
::::::::::::::
Contents of Mail Box Structure
  Fw Command   =3D 0xa1
  Cmd Sequence =3D 0x7f
  No of Sectors=3D 0527
  LBA          =3D 0x00
  DTA          =3D 0x0f2b6000
  Logical Drive=3D 0x00
  No of SG Elmt=3D 0x00
  Busy         =3D 0
  Status       =3D 0x00
::::::::::::::
raiddrives-0-9
::::::::::::::
Logical drive: 0:, state: optimal
Span depth:  1, RAID level:  5, Stripe size: 64, Row size:  4
Read Policy: No read ahead, Write Policy: Write thru, Cache Policy: Direct =
IO

::::::::::::::
raiddrives-10-19
::::::::::::::
::::::::::::::
raiddrives-20-29
::::::::::::::
::::::::::::::
raiddrives-30-39
::::::::::::::
::::::::::::::
rebuild-rate
::::::::::::::
Rebuild Rate: [30%]
::::::::::::::
stat
::::::::::::::
Statistical Information for this controller
pend_cmds =3D 0
IO and error counters not compiled in driver.
romulus:/proc/megaraid/hba0 #=20


------=_Part_1438_15643715.1103299890561--
