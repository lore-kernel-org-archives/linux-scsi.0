From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 2/5: scsi-scan-blist_replun
Date: Wed, 21 Apr 2004 18:03:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421160335.GJ29699@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141234.GT28633@tpkurt.garloff.de> <20040421161412.B6793@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEkEgRdBLZYkpbX2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:56731 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263291AbUDUQDk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:03:40 -0400
Content-Disposition: inline
In-Reply-To: <20040421161412.B6793@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--PEkEgRdBLZYkpbX2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2004 at 04:14:12PM +0100, Christoph Hellwig wrote:
> > Remove CONFIG_SCSI_REPORT_LUNS config option.
> > Instead provide BLIST_NOREPORTLUN that can be passed as default_dev_fla=
gs
> > (but also per device if needed).
> > Provide BLIST_REPORTLUN2
>=20
> Can we make this simply BLIST_REPORTLUN?  I always have to think why the
> 2 is there until I guess this could mean only for scsi <=3D 2..

The 2 is indicating for SCSI-2, indeed, as normally REPORT_LUNS is only=20
for SCSI-3. I like it this way.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--PEkEgRdBLZYkpbX2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhptXxmLh6hyYd04RApHRAKCveaq6gs+pxP/gNhKogbvIqw4GzgCePRNY
y88dJ5Z9Z8weosX1vQ7lous=
=sKIt
-----END PGP SIGNATURE-----

--PEkEgRdBLZYkpbX2--
