From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] 5/6: scsi_inq_timeout
Date: Mon, 19 Apr 2004 00:16:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418221610.GN4868@tpkurt.garloff.de>
References: <20040418185957.GH4868@tpkurt.garloff.de> <20040418202109.C3393@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxQt9wRz9wbL5Edg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:9643 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264192AbUDRWRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 18:17:04 -0400
Content-Disposition: inline
In-Reply-To: <20040418202109.C3393@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--HxQt9wRz9wbL5Edg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 18, 2004 at 08:21:09PM +0100, Christoph Hellwig wrote:
> On Sun, Apr 18, 2004 at 08:59:57PM +0200, Kurt Garloff wrote:
> > +#ifdef __powerpc64__
> > +static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+25;
> > +#else
> > +static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+3;
> > +#endif
>=20
> Huh?  per-arch ifdefs in the scsi code are completely bogus.

Well, those broken chips seem to be very common on machines from
a specific vendor that ships PPC64 hardware ...
That hunk could be dropped of course in mainline, I would not mind.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--HxQt9wRz9wbL5Edg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgv4qxmLh6hyYd04RAktmAJ40N71dYSPr/243JfNotVDOLSYtJQCdGysX
5ZL3w6qqVrkcAX0uhAyYvTM=
=0gUC
-----END PGP SIGNATURE-----

--HxQt9wRz9wbL5Edg--
