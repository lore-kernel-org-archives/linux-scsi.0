From: Phil Dibowitz <phil-LijsOF1cAEA@public.gmane.org>
Subject: Re: [linux-usb-devel] [PATCH] [2.6.23.13] udev hangs USB-storage
 (HP	r707 camera)
Date: Tue, 22 Jan 2008 21:27:09 -0800
Message-ID: <4796D02D.8000108@ipom.com>
References: <20080119174556.GE11553@colo.lackof.org>	<47929B9F.8080607@s5r6.in-berlin.de>	<20080120022829.GG11553@colo.lackof.org>	<1200797791.11214.3.camel@localhost.localdomain>	<20080120031008.GI11553@colo.lackof.org>	<1200802265.11214.8.camel@localhost.localdomain> <20080120052553.GA5452@colo.lackof.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8B6FC1C1690DAD26AB023115"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080120052553.GA5452-lGaJ6EKWmV+kGg0756fqLw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Grundler <grundler-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B6FC1C1690DAD26AB023115
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Grant Grundler wrote:
> On Sat, Jan 19, 2008 at 10:11:05PM -0600, James Bottomley wrote:
> ...
>> Add the device to drivers/usb/storage/unusual_devs.h with
>> US_FL_FIX_CAPACITY.  You'll need to know it's USB ids as well for this=

>> file.
>=20
> James,
> Thanks! Patch below (for Alan) works for me.

Patch looks fine to me. Let me get my tree in order (sorry, been really
swamped lately so I haven't updated in a while), make sure this diff's
nicely against the latest rc's, and I'll pass it on up. .24 is already
(essentially) done, so I'll get it to Greg in the next day or so and it
should make it into .25.

Sorry for the delay, and thanks Alan for pinging me on this.

As for Grant - more information on "Protocol" vs "Subclass" can be found =
on
my unusual_devs page here:

  http://www.phildev.net/linux/usb-unusualdevs-notes.html

--=20
Phil Dibowitz                             phil-LijsOF1cAEA@public.gmane.org
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enig8B6FC1C1690DAD26AB023115
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHltAtN5XoxaHnMrsRAgIOAJ0aam4W/B0rZ4baHpUP8P26+frgWACgicmB
iZ61Y72f0L6fhlmUNRW/Sk0=
=XUXj
-----END PGP SIGNATURE-----

--------------enig8B6FC1C1690DAD26AB023115--
