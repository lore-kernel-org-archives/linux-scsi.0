From: Quercus <quercus@nosomos.org>
Subject: dc395 with a scanner, failing.
Date: Wed, 26 May 2004 18:49:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B4CA83.8020700@nosomos.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6046116510EB663679152864"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.26.248.6] ([217.26.248.6]:16039 "EHLO ns5.virtualpyme.net")
	by vger.kernel.org with ESMTP id S265663AbUEZQrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 12:47:20 -0400
Received: from nosomos.org (213.Red-80-33-110.pooles.rima-tde.net [80.33.110.213])
	by ns5.virtualpyme.net (8.11.6/8.10.2) with ESMTP id i4QGgrD23624
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2004 18:42:54 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6046116510EB663679152864
Content-Type: multipart/mixed;
 boundary="------------090608090308080805090601"

This is a multi-part message in MIME format.
--------------090608090308080805090601
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi there... I own a dc395 scsi card "working" on a Debian GNU/Linux 3.0, 
with kernels 2.4.22 and 2.6.5.

On the 2.4 series kernel it works flawlessly using the old driver from 
Garloff, but on the 2.6 series (using the new one, included in the 
kernel source) it seems to work, but while scanning with sane the 
scanner freezes for some time (minutes) until I cancel the scan and wait 
for a while until the scsi processes end :-(

I've tried changing the parameters for the kernel module (while loading 
the module) but no combination seem to solve the problem :-(

The scanner is an old HP ScanJet 3c.

What other tests should I do to send some feedback to the list and try 
to find a solution? Anyone had this same problem?

Thanks in advance.

-Quercus-
-- 
Yo uso Software Libre
Debian GNU/Linux 3.0 (Woody)       Kernel 2.6.5
OpenPGP id: 700F3CC6
Mi weblog :: http://quercus.nosomos.org

--------------090608090308080805090601
Content-Type: text/txt;
 name="info_firma.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="info_firma.txt"

(ES) Este mensaje está firmado/encriptado digitalmente con OpenPGP,
en formago PGP/MIME (rfc 3156). Para verificar su autenticidad utilice software compatible con PGP/MIME:

(EN) This email is signed/encrypted digitally with OpenPGP, using 
PGP/MIME (rfc 3156) format. To verify its authenticity use compatible software with OpenPGP:

Mozilla - http://www.mozilla.org
GnuPG - http://www.gnupg.org

--------------090608090308080805090601--

--------------enig6046116510EB663679152864
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFAtMqLZPYrUXAPPMYRAnzeAJ9TaYuemCwuU+GOc9VjDpucUqsluwCdGzrK
eoWnQNzOJ6ODxJ4235iJPz4=
=vZP0
-----END PGP SIGNATURE-----

--------------enig6046116510EB663679152864--
