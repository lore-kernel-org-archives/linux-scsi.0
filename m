From: Kurt Garloff <garloff@suse.de>
Subject: WWID / SerialNo in sysfs?
Date: Mon, 9 Feb 2004 17:08:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209160856.GS3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XDqeUMnLaDfDQgU1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:61619 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265201AbUBIQI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 11:08:58 -0500
Received: from hermes.suse.de (Hermes.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id 3FDA418AEE2
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2004 17:08:57 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--XDqeUMnLaDfDQgU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I would like to add a few lines to the SCSI scanning code to retrieve
WWID and/or serial number from pages INQUIRY pages 0x83 and 0x80.

I'm aware that this can be done from userspace. I've done it before
(scsidev). However, you need some code to relate device nodes=20
(sg, sd) to device IDs (C:B:T:U), thus it's non-trivial to do.

Thus, IMHO, it would be good to retrieve WWID and/or serial no
and export it via sysfs to make persistent device naming in userspace
easier. The USB subsystem already does it.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--XDqeUMnLaDfDQgU1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ7CXxmLh6hyYd04RAntfAJsENzqrwHfkOAIk3/u37BohQN2DBgCeLnIn
yDERdm0uL5GGSnKQKaN1qvI=
=VBc6
-----END PGP SIGNATURE-----

--XDqeUMnLaDfDQgU1--
