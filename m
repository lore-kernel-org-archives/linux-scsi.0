From: Kurt Garloff <garloff@suse.de>
Subject: Re: WWID / SerialNo in sysfs?
Date: Mon, 9 Feb 2004 17:29:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209162906.GV3944@tpkurt.garloff.de>
References: <20040209160856.GS3944@tpkurt.garloff.de> <1076343628.1804.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NXxBKFTfdeXlAk+N"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:29378 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265242AbUBIQfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 11:35:36 -0500
Content-Disposition: inline
In-Reply-To: <1076343628.1804.19.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--NXxBKFTfdeXlAk+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 09, 2004 at 11:20:26AM -0500, James Bottomley wrote:
> The SCSI part of udev already has most of this implemented at the user
> level, so you should just be able to reuse that code.

As you know I have everything in scsidev as well already since long ;-)
Nice code duplication though ...

The nontrivial thing was always to make the relation sg/sd/... device
to C:B:T:U tuple. With sysfs it's at least possible to do that in
a reliable way.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--NXxBKFTfdeXlAk+N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ7VRxmLh6hyYd04RAsNEAJ9m8lOM4NpGuPJ/16NIVSg+g4Hs0QCgiDrK
0xhe4og72WLZbqLNOAHXX4U=
=RJ/L
-----END PGP SIGNATURE-----

--NXxBKFTfdeXlAk+N--
