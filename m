From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: Wed, 10 Sep 2003 14:52:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030910145252.F13649@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org> <1063229049.6245.12.camel@patehci2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:16396 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265807AbTIJVxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 17:53:05 -0400
Content-Disposition: inline
In-Reply-To: <1063229049.6245.12.camel@patehci2>; from p.lavarre@ieee.org on Wed, Sep 10, 2003 at 03:24:09PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2003 at 03:24:09PM -0600, Pat LaVarre wrote:
>=20
> > The reason for the unsolicited REQUEST-SENSE ...
>=20
> Help, lost me.
>=20
> I'm thinking usb-storage auto sense should always and only follow
> bCSWStatus =3D x01 Failed.  I'm thinking unsolicited auto sense should
> occur only if the layers above request such an abuse - never
> automagically.
>=20
> I'm thinking not injecting unsolicited auto sense is a part of the
> unwritten specification that "everyone knows" helps hosts get along with
> devices.
>=20
> No?  Where have I gone wrong?

Experience tells us that this is a flawed algorithm.

> > Since sgp_dd asked for a 64-byte
> > READ-CAPACITY, it gets what it deserves.
>=20
> Ah, here we educate me.
>=20
> I should prepare and forward a patch to correct sgp_dd?
>=20
> We the community now broadly accept this rule?  We say apps own the job
> of keeping the bus "on the thin diagonal" i.e. asking for precisely the
> expected count of data bytes?

Yes.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Somebody call an exorcist!
					-- Dust Puppy
User Friendly, 5/16/1998

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/X500IjReC7bSPZARAmEXAJsEiJ/nTTHZ0AE2qs+ewtFgs2X22ACfeXqY
EFT0Ozb4ZGFy66Rcr3CcyIw=
=x7cM
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
