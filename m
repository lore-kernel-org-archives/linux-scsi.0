From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Mon, 19 Apr 2004 00:14:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418221454.GM4868@tpkurt.garloff.de>
References: <20040418185950.GG4868@tpkurt.garloff.de> <20040418202022.B3393@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vTfKKTivj/mQoluA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:15529 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264190AbUDRWO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 18:14:59 -0400
Content-Disposition: inline
In-Reply-To: <20040418202022.B3393@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--vTfKKTivj/mQoluA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 18, 2004 at 08:20:22PM +0100, Christoph Hellwig wrote:
> On Sun, Apr 18, 2004 at 08:59:50PM +0200, Kurt Garloff wrote:
> > scsi_allow_ghost_devices=3DN
> > This patch introduces a boot/module parameter that allows the user to t=
ell
> > the kernel to NOT set the first N devices to offline despite they would
> > normally be. Needed for some EMC multipathing devices.
> > This parameter is even documented in EMC docs as both RH and SUSE had
> > such a parameter in their 2.4 vendor kernels :-/
>=20
> I'm very unhappy with that. =20

So am I.
But there's compromises you have to take ...

> Could you explain why EMC needs this?

Hmm, it's some time ago.
The LUN 0 is used for multipathing and becomes active if another path
fails. Something they use in PowerPath IIRC.=20

> And even if we have to work around it I'd rather use the blacklist mechan=
ism
> for this.

There's no bits left :-(
There's one difference: The parameter could be used to set more LUNs
unconditionally to online, though I believe EMC only needs LUN 0.=20

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--vTfKKTivj/mQoluA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgv3exmLh6hyYd04RArjiAJ4978ocTl/pakiYBlkbJoI0sYZdUgCeMypf
4FgF0pnUtXlEu02u0fUazl4=
=9zyy
-----END PGP SIGNATURE-----

--vTfKKTivj/mQoluA--
