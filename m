From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: usb-storage: move to SCSI hotplugging
Date: Sun, 19 Jan 2003 17:11:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030119171144.B31114@one-eyed-alien.net>
References: <20030119143058.A31114@one-eyed-alien.net> <200301192356.01601.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301192356.01601.oliver@neukum.name>; from oliver@neukum.name on Sun, Jan 19, 2003 at 11:56:01PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2003 at 11:56:01PM +0100, Oliver Neukum wrote:
> Am Sonntag, 19. Januar 2003 23:30 schrieb Matthew Dharm:
> > The attached patch is my first implementation of SCSI hotplugging.
> >
> > It's only been tested that it compiles, as I can't get the current
> > linux-2.5 tree from linuxusb to boot.  It dies _very_ early.  Greg, I'm=
 not
>=20
> Just a black screen?
> I suffered from the same problem until today. The key was to compile
> without VGA mode selection.

Nope.  It loads, uncompresses, and stops a few lines after reading the
memory map.

> As for the patch itself, it's quite hard to grasp something of this size.
> Is the information previously used to make GUID available to other parts
> of the kernel? Otherwise I think you should not cut it out, but only remo=
ve
> the reattachment part.

GUID is a combination of VID, PID, and serial number.  Anyone can make one.
The only reason to have it was for re-attachment.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We've made a business out of making money from annoying and stupid people.
I think you fall under that category.
					-- Chief
User Friendly, 7/11/1998

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+K0zQIjReC7bSPZARAg0xAJ9bRLpnWz5HeS74NGgdnBWTNZ2v2gCcCi9y
KmtmxMotSOHdvDI01Nmpnp8=
=fTUq
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
