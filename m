From: Matthias Jaenichen <mj2@percomp.de>
Subject: Re: SCSI IO Errors
Date: Sat, 06 Sep 2003 20:59:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
References: <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <20030906160652.GI14376@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.percomp.de ([192.88.4.5]:43706 "HELO gateway.percomp.de")
	by vger.kernel.org with SMTP id S261539AbTIFTEn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2003 15:04:43 -0400
In-Reply-To: <20030906160652.GI14376@lug-owl.de>
References: <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
List-Id: linux-scsi@vger.kernel.org
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

Hi!

At 18:06 06.09.03 +0200, Jan-Benedict Glaw wrote:
>On Sat, 2003-09-06 17:16:22 +0200, Matthias Jaenichen <mj2@percomp.de>
>wrote in message <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>:
> > I am experiencing IO-errors with my System. This is now for weeks a=
nd I am
> > stuck with debugging.
>
>What SCSI host adaptor do you use? 'lspci' AND 'lspci -n' will help.
>
>What SCSI driver do you use with them ('dmesg' will show)
>
>What HDDs do you use? Eg. 'dmesg' will show the exact name.
>
> > Please advise me where/how to continue with debugging.
>
>Unfortunately, you don't provide any useable infos about your problem.

That's just because i sent a similar request about four weeks ago, whic=
h=20
was left unattended.

>Possibly, simply your HDDs are gone bad and need to be exchanged.

I filtered the warn-file and it contains some SCSI-Dumps (but it is 44K=
B so=20
I send it directly if requested (Alan and Jan-Benedict will receive it =
in=20
next mail))

!!!
Lastest try: reduce cablespeed to 20MB (default was 80MB, please note t=
he=20
80MB in the warn-snip)
!!!

EVERY component was changed to  an exact duplicate system. Actually I a=
lso=20
copied all files to a different system and HDD (same Hardware) with no=20
better result.

Termination and everything was checked and I beleive there is no hardwa=
re=20
problem. BIOSes updated. Same problem wit=B4jh 2.4.10, 2.4.18, 2.4.21

But here we go with the current details:

Motherboard: ASUS P2B-S, with onboard SCSI
CPU: PIII-700
MEM: 512 MB

SCSI HDD on U2W

CDROM: on UW
TAPE: on UW

2.HDD: IDE-Drive (never shows any error)


Requested data from dmesg and lspci

Linux version 2.4.22-rc3 (root@gateway) (gcc version 2.95.3 20010315=20
(SuSE)) #3 Mon Aug 25 17:21:20 MEST 2003
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000001fffd000 (usable)
  BIOS-e820: 000000001fffd000 - 000000001ffff000 (ACPI data)
  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
511MB LOWMEM available.
On node 0 totalpages: 131069
zone(0): 4096 pages.
zone(1): 126973 pages.
zone(2): 0 pages.
Kernel command line: ether=3D0,0,eth1 root=3D/dev/sda2 auto BOOT_IMAGE=3D=
Linux=20
2.4.22-rc3
Initializing CPU#0
Detected 701.599 MHz processor.
Console: colour VGA+ 80x25
Calibrating delay loop... 1399.19 BogoMIPS
Memory: 515608k/524276k available (1594k kernel code, 8280k reserved, 6=
90k=20
data, 100k init, 0k highmem)
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount cache hash table entries: 512 (order: 0, 4096 bytes)
Buffer cache hash table entries: 32768 (order: 5, 131072 bytes)
Page-cache hash table entries: 131072 (order: 7, 524288 bytes)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU serial number disabled.
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383f9ff 00000000 00000000 00000000
CPU:             Common caps: 0383f9ff 00000000 00000000 00000000
CPU: Intel Pentium III (Coppermine) stepping 03
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
PCI: PCI BIOS revision 2.10 entry at 0xf0720, last bus=3D1
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router PIIX [8086/7110] at 00:04.0
PCI: Found IRQ 5 for device 00:04.2
PCI: Sharing IRQ 5 with 00:06.0
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
Starting kswapd
Journalled Block Device driver loaded
aty128fb: Rage128 BIOS located at segment C00C0000
aty128fb: Rage128 RF (AGP) [chip rev 0x2] 16M 64-bit SDR SGRAM (2:1)
Console: switching to colour frame buffer device 80x30
fb0: ATY Rage128 frame buffer device on PCI
aty128fb: Rage128 MTRR set to ON
Detected PS/2 Mouse Port.
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ=20
SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq =3D 4) is a 16550A
ttyS01 at 0x02f8 (irq =3D 3) is a 16550A
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
Linux agpgart interface v0.99 (c) Jeff Hartmann
agpgart: Maximum main memory to use for agp memory: 439M
agpgart: Detected Intel 440BX chipset
agpgart: AGP aperture is 64M @ 0xe4000000
[drm] Initialized tdfx 1.0.0 20010216 on minor 0
[drm] AGP 0.99 on Intel 440BX @ 0xe4000000 64MB
[drm] Initialized r128 2.2.0 20010917 on minor 1
[drm] AGP 0.99 on Intel 440BX @ 0xe4000000 64MB
[drm] Initialized radeon 1.1.1 20010405 on minor 2
[drm] AGP 0.99 on Intel 440BX @ 0xe4000000 64MB
[drm] Initialized i810 1.2.0 20010920 on minor 3
Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
PIIX4: IDE controller at PCI slot 00:04.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xb800-0xb807, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xb808-0xb80f, BIOS settings: hdc:pio, hdd:pio
hda: WDC WD800JB-00CRA1, ATA DISK drive
blk: queue c037e160, I/O limit 4095Mb (mask 0xffffffff)
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: attached ide-disk driver.
hda: host protected area =3D> 1
hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=3D9729/255/63, U=
DMA(33)
Partition check:
  hda: hda1
SCSI subsystem driver Revision: 1.00
PCI: Found IRQ 5 for device 00:06.0
PCI: Sharing IRQ 5 with 00:04.2
PCI: Setting latency timer of device 00:06.0 to 64
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
         <Adaptec aic7890/91 Ultra2 SCSI adapter>
         aic7890/91: Ultra2 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
(scsi0:A:0): 20.000MB/s transfers (10.000MHz, offset 31, 16bit)
   Vendor: SEAGATE   Model: ST318436LW        Rev: 0010
   Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:2): 20.000MB/s transfers (20.000MHz, offset 16)
   Vendor: NEC       Model: CD-ROM DRIVE:466  Rev: 1.26
   Type:   CD-ROM                             ANSI SCSI revision: 02
(scsi0:A:4): 10.000MB/s transfers (10.000MHz, offset 32)
   Vendor: HP        Model: C1533A            Rev: A708
   Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
st: Version 20030406, bufsize 32768, max init. bufs 4, s/g segs 16
Attached scsi tape st0 at scsi0, channel 0, id 4, lun 0
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 35885168 512-byte hdwr sectors (18373 MB)
  sda: sda1 sda2 sda3 sda4 < sda5 >
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 2, lun 0
sr0: scsi3-mmc drive: 17x/40x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.12
Linux Kernel Card Services 3.1.22
   options:  [pci] [cardbus] [pm]
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP
IP: routing cache hash table of 4096 buckets, 32Kbytes
TCP: Hash tables configured (established 32768 bind 32768)
ip_tables: (C) 2000-2002 Netfilter core team
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
ds: no socket drivers loaded!
VFS: Mounted root (ext2 filesystem) readonly.
=46reeing unused kernel memory: 100k freed
Adding Swap: 506036k swap-space (priority -1)
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on ide0(3,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
CSLIP: code copyright 1989 Regents of the University of California
ISDN subsystem Rev: 1.1.4.1/1.1.4.1/1.1.4.1/1.1.4.1/1.1.4.1/1.1.4.1 loa=
ded
HiSax: Linux Driver for passive ISDN cards
HiSax: Version 3.5 (module)
HiSax: Layer1 Revision 1.1.4.1
HiSax: Layer2 Revision 1.1.4.1
HiSax: TeiMgr Revision 1.1.4.1
HiSax: Layer3 Revision 1.1.4.1
HiSax: LinkLayer Revision 1.1.4.1
HiSax: Approval certification failed because of
HiSax: unauthorized source code changes
HiSax: Total 1 card defined
HiSax: Card 1 Protocol EDSS1 Id=3DHiSax (0)
HiSax: AVM PCI driver Rev. 1.1.4.1
=46ritzPnP: no ISA PnP present
PCI: Found IRQ 11 for device 00:0c.0
AVM PCI: stat 0x2020a
AVM PCI: Class A Rev 2
HiSax: AVM Fritz!PCI config irq:11 base:0xA000
AVM PCI: ISAC version (0): 2086/2186 V1.1
AVM Fritz PnP/PCI: IRQ 11 count 0
AVM Fritz PnP/PCI: IRQ 11 count 5
HiSax: DSS1 Rev. 1.1.4.1
HiSax: 2 channels added
HiSax: MAX_WAITING_CALLS added
HiSax: debugging flags card 1 set to 4
isdn: Verbose-Level is 3
ippp, open, slot: 0, minor: 1, state: 0000
ippp_ccp: allocated reset data structure d8609000
ippp, open, slot: 1, minor: 2, state: 0000
ippp_ccp: allocated reset data structure d8609800
ippp, open, slot: 2, minor: 3, state: 0000
ippp_ccp: allocated reset data structure d7d8f800
via-rhine.c:v1.10-LK1.1.19  July-12-2003  Written by Donald Becker
   http://www.scyld.com/network/via-rhine.html
PCI: Found IRQ 12 for device 00:0a.0
PCI: Setting latency timer of device 00:0a.0 to 64
eth0: VIA VT6102 Rhine-II at 0xa800, 00:50:ba:70:1a:3b, IRQ 12.
eth0: MII PHY found at address 8, status 0x7829 advertising 01e1 Link 4=
0a1.
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: Printer, Kyocera FS-680
lp0: using parport0 (polling).
ip_conntrack version 2.1 (4095 buckets, 32760 max) - 292 bytes per conn=
track
pcnet32.c:v1.27a 10.02.2002 tsbogend@alpha.franken.de
PCI: Found IRQ 10 for device 00:0b.0
PCI: Setting latency timer of device 00:0b.0 to 64
pcnet32: PCnet/PCI II 79C970A at 0xa400, 00 00 b4 50 8f a8 assigned IRQ=
 10.
eth1: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
PPP generic driver version 2.4.2
**********************************************************************
00:00.0 Host bridge: Intel Corporation 440BX/ZX - 82443BX/ZX Host bridg=
e=20
(rev 03)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX - 82443BX/ZX AGP bridge =
(rev 03)
00:04.0 ISA bridge: Intel Corporation 82371AB PIIX4 ISA (rev 02)
00:04.1 IDE interface: Intel Corporation 82371AB PIIX4 IDE (rev 01)
00:04.2 USB Controller: Intel Corporation 82371AB PIIX4 USB (rev 01)
00:04.3 Bridge: Intel Corporation 82371AB PIIX4 ACPI (rev 02)
00:06.0 SCSI storage controller: Adaptec AHA-2940U2/W / 7890
00:0a.0 Ethernet controller: VIA Technologies, Inc. Ethernet Controller=
=20
(rev 42)
00:0b.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet=
=20
LANCE] (rev 16)
00:0c.0 Network controller: AVM Audiovisuelles MKTG & Computer System G=
mbH=20
A1 ISDN [Fritz] (rev 02)
**********************************************************************
01:00.0 VGA compatible controller: ATI Technologies Inc Rage 128 RF
00:00.0 Class 0600: 8086:7190 (rev 03)
00:01.0 Class 0604: 8086:7191 (rev 03)
00:04.0 Class 0601: 8086:7110 (rev 02)
00:04.1 Class 0101: 8086:7111 (rev 01)
00:04.2 Class 0c03: 8086:7112 (rev 01)
00:04.3 Class 0680: 8086:7113 (rev 02)
00:06.0 Class 0100: 9005:001f
00:0a.0 Class 0200: 1106:3065 (rev 42)
00:0b.0 Class 0200: 1022:2000 (rev 16)
00:0c.0 Class 0280: 1244:0a00 (rev 02)
01:00.0 Class 0300: 1002:5246
**********************************************************************

Thanks again

Matthias


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
