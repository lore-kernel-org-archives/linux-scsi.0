From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Tue, 17 Feb 2004 16:27:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217152714.GG3810@tpkurt.garloff.de>
References: <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave> <20040217144959.GA4282@pclin040.win.tue.nl> <1077031099.1757.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:50147 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266243AbUBQP3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 10:29:40 -0500
Content-Disposition: inline
In-Reply-To: <1077031099.1757.24.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org


--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 10:18:07AM -0500, James Bottomley wrote:
> The correct way to solve this is an all or nothing migration gated by a
> boot time flag.

Agreed. Having it the new scheme optional now (defaulting to off),=20
deprecating the old numbers in 2.7 (defaulting new scheme to on)
and drop from 2.8 looks like a reasonable plan to me.

Now we ionly need to get some device space allocated.

PS: I believe 64 partitions is enough.=20

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAMjLSxmLh6hyYd04RAomwAJ0T/q+Miwpz/sdezUU647Jh8peOVgCdGOJJ
BueW3eDsAc7cpIQMS9jTrNk=
=Ltj0
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
