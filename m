From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: 29 Dec 2002 13:54:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1041166487.1338.1.camel@laptop.fenrus.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
	 <176730000.1040430221@aslan.btc.adaptec.com>
	 <3E03BB0D.5070605@rackable.com>
	 <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva>
	 <20021228091608.GA13814@louise.pinerecords.com>
	 <Pine.LNX.4.50L.0212281131580.26879-100000@imladris.surriel.com>
	 <705128112.1041102818@aslan.scsiguy.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qukJ2ZxCM/NjArLdSpMN"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <705128112.1041102818@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>


--=-qukJ2ZxCM/NjArLdSpMN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2002-12-28 at 20:13, Justin T. Gibbs wrote:

>=20
> The main reason why the new driver "breaks" where the old one
> doesn't is that the new driver does not perform an extra register
> read to work-around chipsets that screw up memory mapped I/O.  There
> are four solutions to this problem:

just to be sure...you're not talking about PCI posting right?
can you explain in a bit more detail the exact behavior that is the
problem ? (I'm sure a lot of other drivers will suffer the same so I
consider it of general interest)

Greetings,
   Arjan van de Ven

--=-qukJ2ZxCM/NjArLdSpMN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+DvCVxULwo51rQBIRAtlnAJ9HpRtiQC9dSnN1v6cB8tb1do4c9ACgqqBJ
A7HS7vklxxOVbrysAFHFZEg=
=oEKr
-----END PGP SIGNATURE-----

--=-qukJ2ZxCM/NjArLdSpMN--
