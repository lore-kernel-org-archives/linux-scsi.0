From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Tue, 17 Feb 2004 08:57:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217075724.GA3805@tpkurt.garloff.de>
References: <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:51142 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264894AbUBQLVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 06:21:41 -0500
Content-Disposition: inline
In-Reply-To: <1076979373.1758.688.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, Feb 16, 2004 at 07:56:10PM -0500, James Bottomley wrote:
> Thus it makes sense to have a boot time switch for this, for 2.6 it
> would be an "opt in" to the new major, for 2.7 it would be an "opt out".

OK, if you take care to register some major number (or some space for=20
dev_t in newspeak), I'll write the patch to allow the SCSI disks to
be registered there. We need about 20 bits, IMHO.
=20
> I don't see a reason to keep the old majors hanging around after 2.7 if
> this is the chosen solution ... any user application relying on hard
> coded device numbers is by definition broken.

Agreed.

> On Mon, 2004-02-16 at 17:57, Andries Brouwer wrote:
> > It is not either or, but both.
> > Old devices must not change number.
>=20
> I don't understand this.  The user does not know devices by number but
> by device node name (which is chosen by the OS vendor who populated
> /dev/ now, or by udev in future).  I agree the node name should not
> change, but don't see any reason why the major/minor might not.

You underestimate the amount of cruft code out there that does care.
Unfortunately. Some programs (think scsiformat, ...) do want to know
what transport the underlying hardware actually uses. And determine
this by looking at the device number.
I expect it will take some time to sort this all out.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAMcljxmLh6hyYd04RAlN8AKC9Y9TNIG6Uot7wy52fzCehnUbcHgCeOQ8d
VYUwtC/Rn+f2oQRNxL65Mak=
=MgF4
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
