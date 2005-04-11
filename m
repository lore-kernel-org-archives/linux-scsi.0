From: folkert@vanheusden.com
Subject: 2.6.x (x=4|10|11) doesn't detect my scsi devices on my aic7880 scsi
	interface
Date: Mon, 11 Apr 2005 11:18:24 +0200
Message-ID: <20050411091823.GG29797@vanheusden.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TdMwOTenGjBWB1uY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from keetweej.xs4all.nl ([213.84.46.114]:45197 "EHLO
	keetweej.vanheusden.com") by vger.kernel.org with ESMTP
	id S261747AbVDKJS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 05:18:28 -0400
Received: from keetweej.intranet.vanheusden.com (keetweej.intranet.vanheusden.com [192.168.64.99])
	by keetweej.vanheusden.com (Postfix) with ESMTP id 94D681CA36D
	for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2005 11:18:25 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--TdMwOTenGjBWB1uY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have a dual pentium-II with on-board adaptec aic7880 controller.
2.4.x runs nicely, but 2.6 no longer.
The details.

lspci:
0000:00:00.0 Host bridge: Intel Corp. 440LX/EX - 82443LX/EX Host bridge (re=
v 03)
0000:00:01.0 PCI bridge: Intel Corp. 440LX/EX - 82443LX/EX AGP bridge (rev =
03)
0000:00:04.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 01)
0000:00:04.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)
0000:00:04.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)
0000:00:04.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 01)
0000:00:06.0 SCSI storage controller: Adaptec AIC-7880U
0000:00:09.0 Ethernet controller: 3Com Corporation 3c905 100BaseTX [Boomera=
ng]
0000:00:0c.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (r=
ev 07)
0000:00:0c.1 Input device controller: Creative Labs SB Live! MIDI/Game Port=
 (rev 07)
0000:01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200 AGP =
(rev 01)
scsi controller:
0000:00:06.0 0100: 9004:8078

On 2.4.26 things boot-up this way:
PCI: Setting latency timer of device 00:06.0 to 64
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7880 Ultra SCSI adapter>
        aic7880: Ultra Wide Channel A, SCSI Id=3D7, 16/253 SCBs

  Vendor: RICOH     Model: MP6200S           Rev: 2.20
  Type:   CD-ROM                             ANSI SCSI revision: 02
(scsi0:A:6): 5.813MB/s transfers (5.813MHz, offset 15)
  Vendor: IBM       Model: DCAS-34330        Rev: S65A
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0:A:6:0: Tagged Queuing enabled.  Depth 32
Attached scsi disk sda at scsi0, channel 0, id 6, lun 0
SCSI device sda: 8467200 512-byte hdwr sectors (4335 MB)
 /dev/scsi/host0/bus0/target6/lun0: p1 p2

but 2.6.x comes with this:
message buffer busy, unable to abort    <--- only for device 0 and 6

devices offlined - not ready after recover  <--- for each id it probes
(had to copy it manually as the system won't come up)

acpi is disabled because the bios is too old

that interface is on the same irq with some other devices: 19:      10858  =
    11757   IO-APIC-level  aic7xxx, usb-uhci, eth0


Folkert van Heusden

Auto te koop, zie: http://www.vanheusden.com/daihatsu.php
Op zoek naar een IT of Finance baan? Mail me voor de mogelijkheden.
--------------------------------------------------------------------
 UNIX admin? Then give MultiTail (http://vanheusden.com/multitail/)=20
 a try, it brings monitoring logfiles to a different level! See    =20
 http://vanheusden.com/multitail/features.html for a feature-list. =20
--------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE
Get your PGP/GPG key signed at www.biglumber.com!

--TdMwOTenGjBWB1uY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iIMEARECAEMFAkJaQN88Gmh0dHA6Ly93d3cudmFuaGV1c2Rlbi5jb20vZGF0YS1z
aWduaW5nLXdpdGgtcGdwLXBvbGljeS5odG1sAAoJEDAZDowfKNiuS+wAmgKr3O3a
8cHRxyqMbEDjOmrsLObaAJ9Z+9NXyBufHtLWz7lGZR91OP+p/g==
=vtFq
-----END PGP SIGNATURE-----

--TdMwOTenGjBWB1uY--
