From: "Richard F. Rebel" <rrebel@whenu.com>
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 14:43:11 -0500
Message-ID: <1101843791.1779.1048.camel@rebel.corp.whenu.com>
References: <200412010331.VAA21676@catalyst.austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cyf7g1TKvI3tx/ko5k89"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garibaldi.swishmail.com ([209.10.110.70]:30220 "HELO
	garibaldi.swishmail.com") by vger.kernel.org with SMTP
	id S262300AbUK3TrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 14:47:09 -0500
In-Reply-To: <200412010331.VAA21676@catalyst.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kwhite@austin.ibm.com
Cc: linux-scsi@vger.kernel.org


--=-cyf7g1TKvI3tx/ko5k89
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-30 at 21:31 -0600, kwhite@austin.ibm.com wrote:
> > I am running mdk 10.0 with kernel 2.6.3-16 out of box on a dual opteron
> > 250 system.  The system has a LSI logic U320 controller with 7 internal
> > disks on two channels.
> >=20
> >=20
> > Well, the difference is that the fiber channel card seems to boot first=
,
> > and thus reorders the scsi bus.  If I attach the fiber channel cables t=
o
> > the switch (making all of our storage visible) and re-probe the scsi bu=
s
> > by hand using the /dev interface, access to the SAN is fine etc.  Upon
> > reboot with the fc connected, my system panics because now the root
> > drive is no longer where it thinks it should be (sda is now a device on
> > the fiber channel switch fabric).
> >=20
> > Is there a way to control this process or to mitigate the problem?  I
> > really need the system to boot properly off of local disk whether or no=
t
> > the fc is connected or the devices available.
>=20
> You need to force the LSI U320 scsi driver to load before the fibre-chann=
el
> driver loads.

For the MPT Fusion based devices, the fc driver is the same drive as the
scsi driver.  Eg, mpt_scsih.  There is no separate module to load for
the SCSI nor FC cards.  I guess the problem I am having is due to a
quirk of having a common chipset and driver for the two cards installed
on my machines.

Earlier someone responded to the tune that I needed to change the PCI
boot order, and unless the bios allows me to change that,  I have to
move the cards around in the chassis.  I have a cage monkey trying that
now.

I'll write to the list with the results of moving the cards.

Thanks!!

> Thanks,
> Karen White
>=20

--=-cyf7g1TKvI3tx/ko5k89
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBrM1Px1ZaISfnBu0RAk8rAJ45I9qq6f3PtANeFCDYZ95S3URYdwCfbIti
gVSowl1HMDaw86fTizTQAlw=
=YRTg
-----END PGP SIGNATURE-----

--=-cyf7g1TKvI3tx/ko5k89--

