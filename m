From: Mike Bursell <mike@hingston.demon.co.uk>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 24 Apr 2003 12:45:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051184753.1373.2.camel@lemon.hingston>
References: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cfNILZyU0QLMdRsSjRoS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:21391 "EHLO
	anchor-post-35.mail.demon.net") by vger.kernel.org with ESMTP
	id S262693AbTDXLdX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 07:33:23 -0400
In-Reply-To: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, stelian@popies.net, torvalds@transmeta.com


--=-cfNILZyU0QLMdRsSjRoS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2003-04-23 at 23:39, Andries.Brouwer@cwi.nl wrote:
> Yesterday or so we discussed three people's problems with USB devices.
> Today a fourth very similar complaint was reported.
>=20
> I asked
>=20
> > Could you try this patch of drivers/scsi/sd.c?
> >
> > --- sd.c~       Sun Apr 20 12:59:32 2003
> > +++ sd.c        Wed Apr 23 21:45:10 2003
> > @@ -1079,6 +1079,9 @@
> >                   int dbd, int modepage, unsigned char *buffer, int len=
) {
> >         unsigned char cmd[8];
> >
> > +       if (len < 8)
> > +               len =3D 8;
> > +
> >         memset((void *) &cmd[0], 0, 8);
> >         cmd[0] =3D MODE_SENSE;
> >         cmd[1] =3D dbd;
>=20
> and got the reply
>=20
> #
> # Wohoo! Patch worked like a charm. Thanks Andries!
> #
>=20
> So, for the time being I assume we know what is causing
> these problems. It would be nice if the other three
> (afafc@rnl.ist.utl.pt, mike@hingston.demon.co.uk, stelian@popies.net)
> could report on their experiences with the above patch.

I can confirm that this patch worked for me under 2.5.68: everything
works absolutely fine.  However, given that I can't open terminals under
Gnome in 2.5.68, I think I'll stick with 2.5.67 (I assume that that the
patch is also OK with this version).

Well done, and thanks.

-Mike.
--=20
07050 144575 mike@hingston.demon.co.uk

--=-cfNILZyU0QLMdRsSjRoS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+p85xj6h57cc9oOkRAosLAKCFcM4eQUeGj+EbDOAJwcd3x6KPQQCgg7BS
TpwgDbvtCRnWzk7PY1bd5c8=
=Wr03
-----END PGP SIGNATURE-----

--=-cfNILZyU0QLMdRsSjRoS--

