From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 22:34:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210213438.GV4010@tpkurt.garloff.de>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210155203.A5238@infradead.org> <20040210160803.GL4010@tpkurt.garloff.de> <20040210211002.A1534@pclin040.win.tue.nl> <20040210205833.GT4010@tpkurt.garloff.de> <20040210212113.GG21151@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pDtNmxPr5KTxcQ6Z"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:17582 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262078AbUBJVem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:34:42 -0500
Content-Disposition: inline
In-Reply-To: <20040210212113.GG21151@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: Andries Brouwer <aebr@win.tue.nl>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>


--pDtNmxPr5KTxcQ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 10, 2004 at 09:21:13PM +0000, viro@parcelfarce.linux.theplanet.=
co.uk wrote:
> On Tue, Feb 10, 2004 at 09:58:33PM +0100, Kurt Garloff wrote:
> > We maintain backwards compatibility.
> > We need some bit shuffling and the rest is straightforward.
>=20
> Bit shuffling where?  Since partitioning does *not* reach the driver (nor
> should it), I really wonder where exactly do you expect that turd to land.

We always needed to tell the gendisk code what part of the minor refers
to disks and which one to partitions. The knowledge is there, like it or
not.

> > I don't see what's crappy with the suggestion. Tell us!
>=20
> Putting partitioning crap back into driver.

Oh well, are you happier if we declare the two bits reserved instead
of having the hope of using them to extend the number of partitions per=20
disk to 64 per disk some day?

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--pDtNmxPr5KTxcQ6Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKU5txmLh6hyYd04RApR2AKCMHR5Fi6Qf0DcAxDaaVJN5RsLj9QCeP0hv
zQTimLjkccK+3qvCQiFmCs0=
=M5VD
-----END PGP SIGNATURE-----

--pDtNmxPr5KTxcQ6Z--
