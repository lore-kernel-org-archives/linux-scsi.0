From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] 1/6: scsi_largelun and scsi_sparselun
Date: Mon, 19 Apr 2004 00:10:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418221038.GL4868@tpkurt.garloff.de>
References: <20040418185820.GD4868@tpkurt.garloff.de> <20040418201852.A3393@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmhhrsDozM2n+uz5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:26279 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264188AbUDRWKn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 18:10:43 -0400
Content-Disposition: inline
In-Reply-To: <20040418201852.A3393@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--gmhhrsDozM2n+uz5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 18, 2004 at 08:18:52PM +0100, Christoph Hellwig wrote:
> On Sun, Apr 18, 2004 at 08:58:20PM +0200, Kurt Garloff wrote:
> > +static int scsi_sparselun;
> > +module_param_named(scsi_sparselun, scsi_sparselun, int, S_IRUGO|S_IWUS=
R);
                        ^^^^^
> > +MODULE_PARM_DESC(scsi_sparselun,
                      ^^^^^
> > +		 "Assume sparse LUNs for all SCSI devices");
> > +
> > +static int scsi_largelun;
> > +module_param_named(scsi_largelun, scsi_largelun, int, S_IRUGO|S_IWUSR);
                        ^^^^^
> > +MODULE_PARM_DESC(scsi_largelun,
                      ^^^^^
> > +		 "Assume all SCSI-2 devs support more than 8 LUNs");
>=20
> The names are badly chosen.  On the bootline commandline they already
> have a scsi_mod. prefix, so the additional scsi_ is superflous.

Good point, so I'll remove all scsi_ prefixes.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--gmhhrsDozM2n+uz5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgvzexmLh6hyYd04RAq4JAJ9wdbAy5KREpgykZcncKNbJelCBUQCff3wd
ynu51BHT+w2MQCFxj2/0+6Y=
=12kV
-----END PGP SIGNATURE-----

--gmhhrsDozM2n+uz5--
