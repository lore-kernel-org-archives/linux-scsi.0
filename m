From: Kurt Garloff <garloff@suse.de>
Subject: Patches for SCSI scanning
Date: Sun, 18 Apr 2004 20:57:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418185751.GC4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:27813 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263611AbUDRTAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

at SUSE, the way that Linux scan SCSI devices has constantly generated
a certain support load. Not extremely but still astonishing.
As a consequence, we have created a number of patches to our 2.4 kernels
that did improve some things, such as the backport of the REPORT_LUNS
scanning from 2.6 and a number of boot/module parameters that allowed
users to influence how the scanning is done.
http://www.suse.de/~garloff/Linux/scsi-scan/scsi-scanning.html

With kernel 2.6, the REPORT_LUNS is standard for SCSI-3 devices,
but still many arrays exist that report as SCSI-2 and will require
BLIST_SPARSELUN|BLIST_LARGELUN.

An alternative to the blacklist is to offer boot/module parameters
again. This is what the following series of 6 patches do.
Most don't really depend on each other, but they'll only apply
cleanly in the order sent.

I did not yet compare our 2.4 blacklist with the 2.6 one; I'll
port our additional 2.4 entries to 2.6 soon.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgs+vxmLh6hyYd04RAuqAAKCRrYF/jVmVLMNOTf0BnuGtPxTn9gCfX2Eq
uVLV8gzjtpcOje1ZA/aaI2E=
=THHM
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
