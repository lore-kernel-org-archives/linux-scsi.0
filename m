From: "Richard F. Rebel" <rrebel@whenu.com>
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 16:55:37 -0500
Message-ID: <1101851737.1779.1055.camel@rebel.corp.whenu.com>
References: <200412010331.VAA21676@catalyst.austin.ibm.com>
	 <1101843791.1779.1048.camel@rebel.corp.whenu.com>
	 <20041130204848.GC8863@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Un6zrbebC4mT6FJMEJPv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garibaldi.swishmail.com ([209.10.110.70]:18702 "HELO
	garibaldi.swishmail.com") by vger.kernel.org with SMTP
	id S262347AbUK3V7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 16:59:35 -0500
In-Reply-To: <20041130204848.GC8863@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: kwhite@austin.ibm.com, linux-scsi@vger.kernel.org


--=-Un6zrbebC4mT6FJMEJPv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-30 at 12:48 -0800, Mike Anderson wrote:
> Richard F. Rebel [rrebel@whenu.com] wrote:
> > Earlier someone responded to the tune that I needed to change the PCI
> > boot order, and unless the bios allows me to change that,  I have to
> > move the cards around in the chassis.  I have a cage monkey trying that
> > now.
> >=20
>=20
> Relying on pci / device probe order will always leave you open to possibl=
e
> name slippage issues in the future. You mentioned that you are running md=
k
> so you may want to look at using udev for your device naming.

Umm, what is udev?  Is this the /dev/scsi/<host>/* mapping???

BTW, I was able to resolve the problem of the fiber channel being
identified first by moving the pci-x cards around.  Now when the fiber
fabric is visible my box still boots off the local scsi disks.




>=20
>=20
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
>=20

--=-Un6zrbebC4mT6FJMEJPv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBrOxZx1ZaISfnBu0RAtMQAJ9u7rBXybJZVIgupj3kQzgUyszsqgCfXEpS
sdGKmxcNBYmG/bZICYEMt1c=
=IETe
-----END PGP SIGNATURE-----

--=-Un6zrbebC4mT6FJMEJPv--

