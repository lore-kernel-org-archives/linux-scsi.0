From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Determining the UUID of a USB storage device
Date: Thu, 22 Aug 2002 16:26:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020822162640.E17378@one-eyed-alien.net>
References: <20BF5713E14D5B48AA289F72BD372D6812BB32@AUSXMPC122.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20BF5713E14D5B48AA289F72BD372D6812BB32@AUSXMPC122.aus.amer.dell.com>; from Gary_Lerhaupt@Dell.com on Thu, Aug 22, 2002 at 05:19:36PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Gary_Lerhaupt@Dell.com
Cc: linux-scsi@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Unless you can come up with a command that specifically asks for the serial
number of the media, I think you're stuck.

Not all devices (or media technologies) support this.

The usb-storage driver is only passing the command along to the device, so
whatever the device chooses to report is what you get.

Matt

On Thu, Aug 22, 2002 at 05:19:36PM -0500, Gary_Lerhaupt@Dell.com wrote:
> I am attempting to glean some sort of a unique identifier from a USB stor=
age
> device.  As it should, the storage shows up as a SCSI disk in
> /proc/partitions and subsequent SCSI inquiries sent to it return a page 80
> serial number.  However, it is apparent that this serial number is actual=
ly
> the serial number of my ZIO! smartmedia reader and not of the actual card=
 in
> the reader.
>=20
> Similarly, I am attempting to do the same thing with a firewire/IDE hard
> drive reader.  This also is presented as a SCSI disk and again, the seria=
l #
> that I come up with is coming from the drive reader and not from the actu=
al
> disk.  I know if I were to install this IDE drive directly, I'd be able to
> get the serial# from /proc/ide/hd#/identify, but obviously this is not so
> easy to get to when attached the SCSI/firewire way.
>=20
> Any thoughts?  Is it possible to tunnel through the SCSI stuff to get to =
the
> real serial numbers that I'm looking for?
>=20
> Gary Lerhaupt
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9ZXMwIjReC7bSPZARAkocAJ40r1i/9EGcvRfdyx6+XVF+ObDiEwCg0OqK
1akBKXViYwpFwguNcmpCkWw=
=QQFm
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
