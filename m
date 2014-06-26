From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: External USB3 disk fails with "Invalid field in cdb"
Date: Thu, 26 Jun 2014 20:55:19 +0200
Message-ID: <20140626205519.314a71ae@wiggum>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/myzV12/YJzOUahJit=We1k="; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49442 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaFZTU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 15:20:26 -0400
Received: by bues.ch with esmtpsa (Exim 4.80)
	(envelope-from <m@bues.ch>)
	id 1X0Eqm-0004Ca-Oa
	for linux-scsi@vger.kernel.org; Thu, 26 Jun 2014 20:56:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Sig_/myzV12/YJzOUahJit=We1k=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I got a new USB3->SATA adapter that throws the following errors
when trying to mount the ext4 file system on the attached disk.

Jun 26 20:47:11 wiggum kernel: [156016.840175] usb 4-2: new SuperSpeed USB =
device number 8 using xhci_hcd
Jun 26 20:47:11 wiggum kernel: [156016.856962] usb 4-2: New USB device foun=
d, idVendor=3D152d, idProduct=3D0567
Jun 26 20:47:11 wiggum kernel: [156016.856969] usb 4-2: New USB device stri=
ngs: Mfr=3D1, Product=3D2, SerialNumber=3D3
Jun 26 20:47:11 wiggum kernel: [156016.856972] usb 4-2: Product: USB to ATA=
/ATAPI Bridge
Jun 26 20:47:11 wiggum kernel: [156016.856975] usb 4-2: Manufacturer: JMicr=
on
Jun 26 20:47:11 wiggum kernel: [156016.856977] usb 4-2: SerialNumber: xxx
Jun 26 20:47:11 wiggum kernel: [156016.858030] usb-storage 4-2:1.0: USB Mas=
s Storage device detected
Jun 26 20:47:11 wiggum kernel: [156016.858141] scsi22 : usb-storage 4-2:1.0
Jun 26 20:47:12 wiggum kernel: [156017.857096] scsi 22:0:0:0: Direct-Access=
     JMicron  Generic          0114 PQ: 0 ANSI: 6
Jun 26 20:47:12 wiggum kernel: [156017.857427] sd 22:0:0:0: Attached scsi g=
eneric sg1 type 0
Jun 26 20:47:12 wiggum kernel: [156017.860670] sd 22:0:0:0: [sdb] Spinning =
up disk...
Jun 26 20:47:14 wiggum kernel: [156018.865281] ..ready
Jun 26 20:47:14 wiggum kernel: [156019.870310] sd 22:0:0:0: [sdb] 976773168=
 512-byte logical blocks: (500 GB/465 GiB)
Jun 26 20:47:14 wiggum kernel: [156019.870653] sd 22:0:0:0: [sdb] Write Pro=
tect is off
Jun 26 20:47:14 wiggum kernel: [156019.870659] sd 22:0:0:0: [sdb] Mode Sens=
e: 47 00 10 08
Jun 26 20:47:14 wiggum kernel: [156019.870956] sd 22:0:0:0: [sdb] Write cac=
he: enabled, read cache: enabled, supports DPO and FUA
Jun 26 20:47:14 wiggum kernel: [156019.924517]  sdb: sdb1
Jun 26 20:47:14 wiggum kernel: [156019.928649] sd 22:0:0:0: [sdb] Attached =
SCSI disk
Jun 26 20:47:27 wiggum kernel: [156032.936896] JBD2: Clearing recovery info=
rmation on journal
Jun 26 20:47:27 wiggum kernel: [156032.938218] sd 22:0:0:0: [sdb] Invalid c=
ommand failure
Jun 26 20:47:27 wiggum kernel: [156032.938222] sd 22:0:0:0: [sdb]
Jun 26 20:47:27 wiggum kernel: [156032.938225] Result: hostbyte=3DDID_OK dr=
iverbyte=3DDRIVER_SENSE
Jun 26 20:47:27 wiggum kernel: [156032.938228] sd 22:0:0:0: [sdb]
Jun 26 20:47:27 wiggum kernel: [156032.938230] Sense Key : Illegal Request =
[current]
Jun 26 20:47:27 wiggum kernel: [156032.938234] sd 22:0:0:0: [sdb]
Jun 26 20:47:27 wiggum kernel: [156032.938237] Add. Sense: Invalid field in=
 cdb
Jun 26 20:47:27 wiggum kernel: [156032.938239] sd 22:0:0:0: [sdb] CDB:
Jun 26 20:47:27 wiggum kernel: [156032.938241] Write(10): 2a 08 1d 04 00 3f=
 00 00 08 00
Jun 26 20:47:27 wiggum kernel: [156032.938247] end_request: critical target=
 error, dev sdb, sector 486801471
Jun 26 20:47:27 wiggum kernel: [156032.938249] Buffer I/O error on device s=
db1, logical block 60850176
Jun 26 20:47:27 wiggum kernel: [156032.938251] lost page write due to I/O e=
rror on sdb1
Jun 26 20:47:27 wiggum kernel: [156032.938260] JBD2: Error -5 detected when=
 updating journal superblock for sdb1-8.

Does somebody have a hint to debug this?

--=20
Michael.


--Sig_/myzV12/YJzOUahJit=We1k=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrGyaAAoJEPUyvh2QjYsO0PkQAJO1eHSyW0bzFNZXQyLcojV7
3UR62g+jJU55L004yoMgxWhPbMHu0qlftdB1LNGWIcnDPE23vdZRWAUI4tB9r5IU
35wcc5H/p9JBs5QTXbigQStFV48P9yLnUUcgkenfEZn7jLPy1PsG2+U1fJ7u4Xph
kFNQHypOEkZYLAqOU1wKma2pVtleUwYXdnIjQkM3sS1k0ICuCWma8BwAX0LLT7QJ
RngR3VZ/daf9tdzi5SX3f+MaDnmX6PRK1fyYV260+2DvLOW+dNJeXbZiBGTvVZae
QxD3ytpe0y8an1ctjBjcZPndG+IrzUSvUdly1r6niyytISux+9oKR46hYjb6fwAL
oXjZO/V4pY7NEp29LoX7+1SelRayp0DEavrgGsQw3VuLWXAnhbCQX1NCQasfMZ6B
ocEhctzgw1OvVDu9qmkserQQ66xhxPGensyQCcGM8U+qj7TTLw7g1Gh2lsBEqaAN
o6geq974DLTaC2hGF80bDgcWuv80pDKsddwMtmixLRiOX9WPXA9i+6o6nm8Jleey
0o6gOi0kuZP4/yXgdK34lkx0bc446R9f4vVzN4TYgiYFLu4O4Z82hc5i1wuuQql3
DGaJVLv6NFX2O5+43R+8f9WgJ7iRJ512z0Pf3qT6KhNuCZV0XL7CC09Fp8KiGaNW
bMSepDckDOZcRnofAeJO
=A/+H
-----END PGP SIGNATURE-----

--Sig_/myzV12/YJzOUahJit=We1k=--
