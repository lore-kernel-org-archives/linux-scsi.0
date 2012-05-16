From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: pull request: linux-firmware: Update qla2xxx firmware files.
Date: Wed, 16 May 2012 23:45:52 +0100
Message-ID: <1337208352.4107.58.camel@deadeye>
References: <alpine.WNT.2.00.1204271521300.1704@N5102REMCQXM4BS.qlogic.org>
	 <1335836916.8274.50.camel@deadeye>
	 <20120501020525.GE67085@plapa.qlogic.org>
	 <20120503041600.GJ1440@plapa.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-n4AWgJI5TNspK7o7zb91"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57212 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206Ab2EPWqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 18:46:03 -0400
In-Reply-To: <20120503041600.GJ1440@plapa.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-n4AWgJI5TNspK7o7zb91
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-02 at 21:16 -0700, Andrew Vasquez wrote:
> On Mon, 30 Apr 2012, Andrew Vasquez wrote:
>=20
> > On Mon, 30 Apr 2012, Ben Hutchings wrote:
> >=20
> > > On Fri, 2012-04-27 at 15:41 -0400, Chad Dupuis wrote:
> > > > Hi Ben, David,
> > > >=20
> > > > Can you please pull the following patches from the "for_upstream" b=
ranch
> > > > of the repo below to update the ql2300_fw.bin, ql2322_fw.bin,
> > > > ql2400_fw.bin and ql2500_fw.bin files?
> > > >=20
> > > > git://avgit01.qlogic.org/linux-firmware for_upstream
> > >=20
> > > That hostname isn't resolvable here and now.
> >=20
> > Ben,
> >=20
> > Actually, the forward-facing URL is actually:
> >=20
> > 	git://git.qlogic.com/linux-firmware
> >=20
> > But...there seems to be a problem, as there's no A record for that
> > server.
> >=20
> > We will let you know when we get that issue resolved.
>=20
>=20
> Ben,
>=20
> Thanks for your patience here, you should now be able to pull from the
> URL above:
[...]

Pulled, thanks.

Ben.

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-n4AWgJI5TNspK7o7zb91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7QuIOe/yOyVhhEJAQpkJA/9FwhJqMb5L+m6JMzyriZOtSzpEkyHSrrk
/Qq6QJ+E7IskbueFOTXfgG9adLKJFcXi+E9KMbu1yUO+9HJfOd2kGiu7VI3mGltV
rKZ/EpF+MWUvkHuvNq+w9towu1MTXNo9iosKBfZsuFQqkQ90DoRq180rpXaxbGx1
WCliXkPXU5MPtS5x4wxi2Mu9QfHNR3Mwg/s94AuIDIjnLafislChG5R4FoIIOZiX
Z8QCJUOi54kE0oU0vuoNgdAe4JLI85ZC0oifN/PpdC7zjr8X7PuoD+tH6arplJrn
BoCO+c2ZHnMY8KYfMtKg12S9+6DJOL3HzPHT3VL6D3hAsW15eu2+f6Az9ITt1RN9
HWeWRKG5A+AbQCzaX/bIztB8m+iyqGh/WhkCdueFtzrgQ35CvRYQugmXdMIfOC0k
cFxblS6qIZdvRxaE7k68KVHswxDlmlQX02h5pmpo7L8r9efsaizRvUn1gP7K6n2r
8bflGXVy9VLPGxaGQ2x9gpbfamxDWh3kwRMh/vTfonISBgS2Qj+qkdUav1Qd6spA
6wQKAjEKprmgj/6wdGBkuVPuagfPWNozy9pjjRjBNBjG7oqtv4yais5MtdIZVCAJ
2pX8DIREyL4YHH8opomjNkyDpFVdOlYYomY0E4WEdLFloEOTo69+2RchCT+W2sGS
D51UMzSRqmI=
=IDzF
-----END PGP SIGNATURE-----

--=-n4AWgJI5TNspK7o7zb91--
