From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 21:58:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210205833.GT4010@tpkurt.garloff.de>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210155203.A5238@infradead.org> <20040210160803.GL4010@tpkurt.garloff.de> <20040210211002.A1534@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="js+/jT5SQQin5+Fm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:25751 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266181AbUBJU7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 15:59:50 -0500
Content-Disposition: inline
In-Reply-To: <20040210211002.A1534@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>


--js+/jT5SQQin5+Fm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andries,

On Tue, Feb 10, 2004 at 09:10:02PM +0100, Andries Brouwer wrote:
> + *       major     p2    disc2   disc  p1
> + *   |............|..|..........|....|....| <- dev_t
> + *    31        20    17       8 7  4 3  0
[...]
>=20
> It is true that the first step needed is some agreement on
> how to assign device numbers to disks and their partitions.
>=20
> The above suggestion is really ugly, however.

Nice! Ask two people and you'll get three opinions.

> I can hardly imagine that we would like to start such crap
> while still in the design phase.

We maintain backwards compatibility.
We need some bit shuffling and the rest is straightforward.
As we are pretty sure to not need beyong 256k disks, we reserve two
extra bits for the partition (though we can't currently use it).

The only alternative that I see is leaving the old majors alone
and starting a new scheme with new majors. Not really nice either;
if you think about supporting > 16 partitions, it's even very
inconsistent.

I don't see what's crappy with the suggestion. Tell us!

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--js+/jT5SQQin5+Fm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKUX5xmLh6hyYd04RAmxtAKCP7tszrbQlc8Kpc9hI+Ax7Z/BTogCgnAVd
pg6QWUb5rjmoWUZ/fDq2ngE=
=V2In
-----END PGP SIGNATURE-----

--js+/jT5SQQin5+Fm--
