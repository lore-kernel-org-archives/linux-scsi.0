From: Joshua Rubin <joshua@rubixlinux.org>
Subject: Re: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Fri, 18 Aug 2006 11:14:52 -0600
Message-ID: <200608181114.52739.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1373750.v8hE4zFsNE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 70-89-161-115-Joshua-Rubin-co.hfc.comcastbusiness.net ([70.89.161.115]:16347
	"EHLO smokescreen.cybertron.cc") by vger.kernel.org with ESMTP
	id S1030310AbWHRRPj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 13:15:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 380272@bugs.debian.org
Cc: maximilian attems <maks@sternwelten.at>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>

--nextPart1373750.v8hE4zFsNE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Maks,

I tried linux-image-2.6.17-2-686_2.6.17-6_i386.deb from unstable and the=20
problem still exists there.

I have attached the outputs of "lspci -vv" and "lspci -n".

Thanks,
Joshua Rubin

# lspci -vv
00:00.0 Host bridge: Broadcom CNB20LE Host Bridge (rev 05)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
=20
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes

00:00.1 Host bridge: Broadcom CNB20LE Host Bridge (rev 05)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
=20
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes

00:01.0 RAID bus controller: LSI Logic / Symbios Logic 53C1510 (rev 02)
        Subsystem: Compaq Computer Corporation Integrated Array Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+=
=20
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 192 (7500ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 177
        Region 0: I/O ports at 2000 [size=3D256]
        Region 1: Memory at c5000000 (32-bit, non-prefetchable) [size=3D16M]
        Region 2: Memory at c4000000 (32-bit, non-prefetchable) [size=3D16M]
        [virtual] Expansion ROM at 20000000 [disabled] [size=3D512K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:03.0 VGA compatible controller: ATI Technologies Inc 3D Rage IIC 215IIC=
=20
[Mach64 GT IIC] (rev 7a) (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc Rage IIC
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
=20
Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min), Cache Line Size: 32 bytes
        Region 0: Memory at c2000000 (32-bit, prefetchable) [size=3D16M]
        Region 1: I/O ports at 2400 [size=3D256]
        Region 2: Memory at c3fff000 (32-bit, non-prefetchable) [size=3D4K]
        [virtual] Expansion ROM at 20080000 [disabled] [size=3D128K]
        Capabilities: [5c] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:04.0 System peripheral: Compaq Computer Corporation Advanced System=20
Management Controller
        Subsystem: Compaq Computer Corporation Unknown device b0f3
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+=
=20
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 255
        Region 0: I/O ports at 1800 [size=3D256]
        Region 1: Memory at c3ffef00 (32-bit, non-prefetchable) [size=3D256]

00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 4f)
        Subsystem: Broadcom OSB4 South Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
=20
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:0f.1 IDE interface: Broadcom OSB4 IDE Controller (prog-if 8a [Master Sec=
P=20
PriP])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+=
=20
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 4: I/O ports at 2800 [size=3D16]

03:04.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100]=
=20
(rev 08)
        Subsystem: Compaq Computer Corporation NC3163 Fast Ethernet NIC=20
(embedded, WOL)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+=
=20
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 185
        Region 0: Memory at c6fff000 (32-bit, non-prefetchable) [size=3D4K]
        Region 1: I/O ports at 3000 [size=3D64]
        Region 2: Memory at c6e00000 (32-bit, non-prefetchable) [size=3D1M]
        [virtual] Expansion ROM at 20100000 [disabled] [size=3D1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA=20
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

03:05.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100]=
=20
(rev 08)
        Subsystem: Compaq Computer Corporation NC3163 Fast Ethernet NIC=20
(embedded, WOL)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+=
=20
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
=20
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 193
        Region 0: Memory at c6dff000 (32-bit, non-prefetchable) [size=3D4K]
        Region 1: I/O ports at 3040 [size=3D64]
        Region 2: Memory at c6c00000 (32-bit, non-prefetchable) [size=3D1M]
        [virtual] Expansion ROM at 20200000 [disabled] [size=3D1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA=20
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-


# lspci -n
00:00.0 0600: 1166:0009 (rev 05)
00:00.1 0600: 1166:0009 (rev 05)
00:01.0 0104: 1000:0010 (rev 02)
00:03.0 0300: 1002:4756 (rev 7a)
00:04.0 0880: 0e11:a0f0
00:0f.0 0601: 1166:0200 (rev 4f)
00:0f.1 0101: 1166:0211
03:04.0 0200: 8086:1229 (rev 08)
03:05.0 0200: 8086:1229 (rev 08)

--nextPart1373750.v8hE4zFsNE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBE5fWMkKWMTL7MAq4RAn5/AJ9aR9U3dPll4ATkSjOSxF6uFrRF8ACeOTqk
E/2SsYalq8xCUK5E4oJFQkE=
=E836
-----END PGP SIGNATURE-----

--nextPart1373750.v8hE4zFsNE--
