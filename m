From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Wed, 11 Feb 2004 15:56:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211145614.GA4010@tpkurt.garloff.de>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dvv5THrRrdqidt0E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:61656 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265289AbUBKO7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 09:59:08 -0500
Content-Disposition: inline
In-Reply-To: <20040210102603.0c835212.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com


--dvv5THrRrdqidt0E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, Feb 10, 2004 at 10:26:03AM -0800, Andrew Morton wrote:
> Kurt Garloff <garloff@suse.de> wrote:
> >
> > Since when is 4k huge?
> >  Sorry, I don't see any benefit in adding complexity to avoid a 4k arra=
y.
>=20
> Well yes, but we do have lib/idr.c which I believe does what you need.  It
> is simple to use.

It can store a pointer per ID. One that I don't need, unless I overlook
some possibility to put an already existing pointer in there.

If we really allocate thousands of disks, the overhead of this solution
will be higher than the bitmap, I'm afraid.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--dvv5THrRrdqidt0E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKkKOxmLh6hyYd04RAuVDAKCCy2DzR5P3RqiKsekQQi1LUVlp5wCg2ev1
5K1Dzf0/cU7MlyiBZt7sKk4=
=mOTH
-----END PGP SIGNATURE-----

--dvv5THrRrdqidt0E--
