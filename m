From: Kurt Garloff <kurt@garloff.de>
Subject: Re: TMSCSIM [2.6]
Date: Sat, 29 Nov 2003 19:11:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031129181131.GL3049@tpkurt.garloff.de>
References: <3FC7FC89.4060601@yk.rim.or.jp> <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HLsZ5Z1opAQvdr2J"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:134 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263855AbTK2SLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 13:11:39 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chiaki <ishikawa@yk.rim.or.jp>, Linux SCSI list <linux-scsi@vger.kernel.org>, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de


--HLsZ5Z1opAQvdr2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2003 at 10:46:24AM +0100, Guennadi Liakhovetski wrote:
> > PS: now that the driver seems to be in better shape, you might want to
> > bump the driver version number  reported in the banner,
> > "Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f
> > 2000-12-20".
>=20
> Yep. Kurt, Christian, shall I increment the version number (2.0g / 2.1a?),
> adding a Changelog entry? Also, how shall it be maintained now, until it
> is included in the stock 2.6 (hopefully)? Is there a linux-scsi tree,
> where this driver could be merged in, or just an ftp site, where the patch
> could be uploaded? I am not using BK (don't think it would make much sense
> with a 56K modem dial-up:-)).

Well, 2.1a seems a reasonable version number.
Please add a changelog entry. You should get the credits for doing all
the work for porting the driver! Thanks again!

I can put it for download on my site;=20
we should try to push it into 2.6.0/1, of course.

> No, wouldn't do that. It would unnecessarily blow the patch up...

I wouldn't do it either.
Then better have two patches, one doing only functional changes, one
only changing formatting.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux:SCSI, Security           <garloff@suse.de>    [SUSE Nuernberg, DE]

--HLsZ5Z1opAQvdr2J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/yOFTxmLh6hyYd04RAkMqAJ0dF4NDnwi5JO87jHbHZSdNgL/3CgCfavLT
vH3UNtpxMpn5ToV5S9vIFGs=
=tm56
-----END PGP SIGNATURE-----

--HLsZ5Z1opAQvdr2J--
