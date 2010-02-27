From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] atp870u: Split long udelay()
Date: Sat, 27 Feb 2010 21:17:57 +0000
Message-ID: <1267305477.16186.99.camel@localhost>
References: <1266544619.10567.715.camel@localhost>
	 <1266593299.2822.7.camel@mulgrave.site>
	 <20100219164457.GX21665@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/MH5oPK6t/6gLJO32lqQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45756 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935475Ab0B0VSE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Feb 2010 16:18:04 -0500
In-Reply-To: <20100219164457.GX21665@decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


--=-/MH5oPK6t/6gLJO32lqQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-19 at 16:44 +0000, Ben Hutchings wrote:
> On Fri, Feb 19, 2010 at 09:28:19AM -0600, James Bottomley wrote:
> > On Fri, 2010-02-19 at 01:56 +0000, Ben Hutchings wrote:
> > > udelay() is supposed to be limited to 1 ms, and will generate a
> > > __bad_udelay() on ARM for constant arguments > 2000.  Split
> > > udelay(0x800) into mdelay(2); udelay(48).  (I suspect that msleep(3)
> > > would work but I do not know how critical the timing is here.)
> >=20
> > So no to this one.  Either ARM is right and udelay > 2000 is wrong
> > (which actually sounds correct given how long this will eat CPU for) so
> > the driver needs fixing, or ARM is wrong and the warning needs fixing.
> >=20
> > Splitting the delay to defeat the warning while retaining the behaviour
> > it was trying to warn about is the wrong thing to do.
> =20
> AIUI the restrictions on udelay() are there because the delay is likely
> to be inaccurate for large arguments.  If it was actually wrong to wait
> for over a millisecond then mdelay() would not exist.

Please could you respond to the above?

Ben.

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-/MH5oPK6t/6gLJO32lqQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS4mMBOe/yOyVhhEJAQIO+g/+LW51K42sai+I1GiPwJOMjPvIVmYcwXch
B439D4H2ZNX/H2UeZ9xX3ioN1Kqh4Gh5XakThfcY9oEJw92mlDf2y93DtbfO8zk5
ubKneXvAWSZGpFD4xBW2j9oe4zJWR5GwMTL6gZPOFT5qoitYXqvVBjpslE1YiFp9
c0hmzklvmcLzvh9XEuVbekPjZ3hem6uiO5r3/c+JyZWE4laPgf5qDhhpZ89Rcaop
Cc6T8VzKn6YLuGQ1ruQrneA00uLSsJOm0Sactg8VPik2g8637Zxiz7O7mT8TWl8x
BS7FVAt7Q2V5kVgp9UDuaK9dizBLCc59cqUlbKmuROQXLMyyKo2Ht5LjXBUkoZHr
6ftLDwovBtqw9QLIUtlZm3G7J7qDDy/9EWUF0mg+vBlvE7oeuzD6s8w1EA28pbQH
qo84uBlj3aRESeFOYYPiUs+BRvsXnLvuVgCVyO6CYuVcQ4A2dnpGRhKQIqXkeyGy
2fMeW1x8OK501jbSoSqXlVHFwQeuXEVTHFOwnkhAFzfdXNuQKNAlNWQilipFfWht
XAiGINSxSNDtkW2qpYcmGOOjQu7fBIc+gz7BSd2OfVvfRhsDezwH0bUavRQ9S/QM
ZwTC5ifi/EnfcZHMHff3iYa9F012ZI3e6ZTy2WFr5n6XZWQeEnhks+qTiSXQCIl4
C51/UeFfNjw=
=jRmg
-----END PGP SIGNATURE-----

--=-/MH5oPK6t/6gLJO32lqQ--
