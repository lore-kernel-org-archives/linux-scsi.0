From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: 2.6.24.2: MPT Fusion LTO-3 tape troubles
Date: Tue, 12 Feb 2008 15:13:01 +0100
Message-ID: <47B1A96D.3080303@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6AF2FDE280919FD57B3917E6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw2.ilsb.tuwien.ac.at ([128.130.23.15]:57188 "EHLO
	gh-gw2.ilsb.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759214AbYBLOVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 09:21:52 -0500
Received: from [128.130.71.82] (gs.ilsb.tuwien.ac.at [128.130.71.82])
	by gh-gw2.ilsb.tuwien.ac.at (8.13.8/8.13.8/Debian-3) with ESMTP id m1CED5UF010630
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2008 15:13:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6AF2FDE280919FD57B3917E6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


After using 2.6.11.12 for long time (with success) I tried to update to
2.6.24.2

Hardware:   LSI53C1030 B2
            Overland NEO Changer
            HP Ultrium 3-SCSI tape drive

Kernel messages when booting:

Feb 12 14:28:03 ilfb03 kernel: Fusion MPT base driver 3.04.06
Feb 12 14:28:03 ilfb03 kernel: Copyright (c) 1999-2007 LSI Corporation
Feb 12 14:28:03 ilfb03 kernel: Fusion MPT SPI Host driver 3.04.06
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: Initiating bringup
Feb 12 14:28:03 ilfb03 kernel: ioc0: LSI53C1030 B2: Capabilities=3D{Initi=
ator}
Feb 12 14:28:03 ilfb03 kernel: scsi10 : ioc0: LSI53C1030 B2,
FwRev=3D01000000h, Ports=3D1, MaxQ=3D255, IRQ=3D10
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:3:0: Medium Changer    OVERLAND
NEO Series       0513 PQ: 0 ANSI: 2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:3: Beginning Domain Validation=

Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: attempting task abort!
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:3:0: CDB: Inquiry: 12 00 00 00
3a 00
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: task abort: FAILED
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: attempting target reset!
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:3:0: CDB: Inquiry: 12 00 00 00
3a 00
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: Initiating recovery
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:3:0: mptscsih: ioc0: completing
cmds: fw_channel 0, fw_id 3, sc=3Df7fb7dc0, mf =3D f7fc3400, idx=3D20
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: target reset: FAILED
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: attempting bus reset!
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:3:0: CDB: Inquiry: 12 00 00 00
3a 00
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: bus reset: SUCCESS
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel:  target10:0:3: Wide Transfers Fail
Feb 12 14:28:03 ilfb03 kernel:  target10:0:3: Domain Validation skipping
write tests
Feb 12 14:28:03 ilfb03 kernel:  target10:0:3: Ending Domain Validation
Feb 12 14:28:03 ilfb03 kernel:  target10:0:3: FAST-10 SCSI 10.0 MB/s ST
(100 ns, offset 15)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Sequential-Access HP
 Ultrium 3-SCSI   G24H PQ: 0 ANSI: 3
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Beginning Domain Validation=

Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation Disabing
Information Units
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 800000=
2
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: attempting task abort!
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: CDB: Write Buffer: 3b 0a
00 00 00 00 00 10 00 00
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: WARNING - TM Handler for
type=3D1: IOC Not operational (0x4000000e)!
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: WARNING -  Issuing
HardReset!!
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: Initiating recovery
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: WARNING - IOC is in FAULT
state!!!
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: WARNING -            FAULT
code =3D 000eh
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: ERROR - Doorbell ACK
timeout (count=3D4999), IntStatus=3D80000001!
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: mptscsih: ioc0: completing
cmds: fw_channel 0, fw_id 4, sc=3Df7fb7dc0, mf =3D f7fc5680, idx=3D7c
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: Recovered from IOC FAULT
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: task abort: FAILED
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: attempting target reset!
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: CDB: Write Buffer: 3b 0a
00 00 00 00 00 10 00 00
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc0: Initiating recovery
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: target reset: FAILED
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: attempting bus reset!
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: CDB: Write Buffer: 3b 0a
00 00 00 00 00 10 00 00
Feb 12 14:28:03 ilfb03 kernel: mptscsih: ioc0: bus reset: SUCCESS
(sc=3Df7fb7dc0)
Feb 12 14:28:03 ilfb03 kernel: scsi 10:0:4:0: Write Buffer failure 80000
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Domain Validation detected
failure, dropping back
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: Ending Domain Validation
Feb 12 14:28:03 ilfb03 kernel:  target10:0:4: asynchronous
Feb 12 14:28:03 ilfb03 kernel: mptbase: ioc1: Initiating bringup
Feb 12 14:28:03 ilfb03 kernel: ioc1: LSI53C1030 B2: Capabilities=3D{Initi=
ator}
Feb 12 14:28:03 ilfb03 kernel: scsi11 : ioc1: LSI53C1030 B2,
FwRev=3D01000000h, Ports=3D1, MaxQ=3D255, IRQ=3D11

The LTO-3 tape drive is running with 1MB/s (compared to more than 40MB/s
on 2.6.11.12

Any ideas?

Thank you in advance!

Gerhard Schneider

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29         http://www.ilsb.tuwien.ac.at/


--------------enig6AF2FDE280919FD57B3917E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHsalxE6e53f4wQG4RAl9aAJ97vGlXCSCmoeF434lhkpxRxcwMfgCdHSyu
zEtnRmECLE3dj2aHjBxHd4U=
=NiLL
-----END PGP SIGNATURE-----

--------------enig6AF2FDE280919FD57B3917E6--
