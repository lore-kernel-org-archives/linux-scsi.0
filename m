From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Mon, 1 Mar 2004 00:31:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229233104.GC13934@tpkurt.garloff.de>
References: <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave> <20040217144959.GA4282@pclin040.win.tue.nl> <1077031099.1757.24.camel@mulgrave> <20040217152714.GG3810@tpkurt.garloff.de> <1078072902.1779.41.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:63905 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262176AbUB2XbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 18:31:07 -0500
Content-Disposition: inline
In-Reply-To: <1078072902.1779.41.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 29, 2004 at 10:41:36AM -0600, James Bottomley wrote:
> OK, this all went quiet again.
>=20
> The choices are between the current patch from Kurt which is limited to
> 16 partitions, or a new patch (which no-one has yet produced) to raise
> us to 64 partitions on a new major number with a switching scheme.

And those two solutions don't even exclude each other ;-)

> Kurt, since you're pushing the patch, which do you want me to do?  Apply
> your current patch for 16 or wait for a new one for 64?

Sticking with the old majors for now has the advantage that we don't
force people with many disks to get all the userspace fixed immediately.

And for those needing we introduce ~22 bits of (4 majors) with 64
partitions and provide a switch. Or actually reserve ~24 bits for
/dev/disk and start using it with SCSI ;-)

So, I'd do both.
For now, I would to have my patch applied.
Let's see what Linus thinks about the /dev/disk thing. I know there are
long term plans in that direction.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAQnY4xmLh6hyYd04RAoUlAKCxLS0u4My14KN0g3U70x4AgXWYpACgrcRN
uYOhvrDKvoyMWnd+6+nDVBc=
=C64H
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
