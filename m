From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 17:04:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113170416.D30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131702560.949-100000@ida.rowland.org> <1068766852.2851.155.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:21509 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261678AbTKNBEW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 20:04:22 -0500
Content-Disposition: inline
In-Reply-To: <1068766852.2851.155.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 04:40:52PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 04:40:52PM -0700, Pat LaVarre wrote:
> > > Anybody able to clue me in quickly as to why classifying a device as
> > > writable or not, rather than a disc, can ever be meaningful?
> >=20
> > The notion makes sense for tape drives as well.
>=20
> Re write-protect, personally I know only of discs that have
> write-protect tabs.
>=20
> Are we saying some SCSI drives have write-protect switches also?  Only
> tape drives or also the disk drives of sd and the disc drives of cdrom/
> sr/ ide-cd?

I've seen write-protect switches/jumpers on SCSI disks, on tapes, and even
flash-disk keychain devices.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  They kicked your ass, didn't they?
S:  They were cheating!
					-- The Chief and Stef
User Friendly, 11/19/1997

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tCoQIjReC7bSPZARAtqqAKCaZdSdvnmm3A4YF9ZzCkkpn1MULgCginDg
AaPC61pawIXbVj74MDZJQnQ=
=NMtR
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
