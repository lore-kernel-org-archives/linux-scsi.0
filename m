From: Kurt Garloff <garloff@suse.de>
Subject: Re: Linux version 2.6.6 // libata 1.02 // sata_promise version 0.92 // problem with Promise FastTrack S150 SX4
Date: Wed, 19 May 2004 20:53:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519185302.GE5547@tpkurt.garloff.de>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAA6/QqhRnc20Gp8M2IBiikcMKAAAAQAAAAoC6hppJpiEatjNFHGy82SgEAAAAA@nawan.hostinguk.com> <40A8FF29.7090701@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNMatiwYGLtwo1cJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:23688 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264623AbUESWZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 18:25:24 -0400
Content-Disposition: inline
In-Reply-To: <40A8FF29.7090701@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--eNMatiwYGLtwo1cJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 17, 2004 at 02:06:33PM -0400, Jeff Garzik wrote:
> This is normal.
>=20
> Promise proprietary RAID is not supported under Linux, by the kernel=20
> drivers.

They should publish the metadata format of their fakeRAID stuff.
Somebody could parse this and setup linux SW raid accordingly
=66rom userspace.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--eNMatiwYGLtwo1cJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAq60OxmLh6hyYd04RArzgAJ4vtGbWwF1tCm8rJBiivUgaPYCFkQCfd3gp
ZG7VP1jJbn/GtWo67kepMWo=
=pSs/
-----END PGP SIGNATURE-----

--eNMatiwYGLtwo1cJ--
