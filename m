From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Fri, 8 Jan 2010 12:30:13 +0100
Message-ID: <201001081230.14419.eike-kernel@sf-tec.de>
References: <4B3BDB66.6000008@googlemail.com> <4B46453E.1060206@googlemail.com> <4B4646B2.6050103@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1800099.K2pXvrlG51";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752966Ab0AHLbA@vger.kernel.org>
In-Reply-To: <4B4646B2.6050103@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--nextPart1800099.K2pXvrlG51
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Ren=E9 Bolldorf wrote:
> On 01/07/10 21:34, Ren=E9 Bolldorf wrote:
> > On 01/07/10 20:15, Jeff Garzik wrote:
> >> I need a little bit more detail than an unqualified statement... Did
> >> you audit all paths leading to this code point?
> >
> > Yes, and my two systems running fine with the patch, no oops or panic's.
>=20
> Sry forgot that:
> 	/* initialize sense_buf with the error register,
> 	 * for the case where they are -not- overwritten
> 	 */
> 	sense_buf[0] =3D 0x70;
> 	sense_buf[2] =3D dfl_sense_key;
>=20
> So i think memset() is not needed and works very well without it.

What happens to sense_buf[1]?

--nextPart1800099.K2pXvrlG51
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktHF0YACgkQXKSJPmm5/E6rFwCfVCg5PogrUdwVJOuEeXK5w+LN
hVsAn05KNRlTAQyUdHgCdSoFJ+ou3gFf
=/Ctq
-----END PGP SIGNATURE-----

--nextPart1800099.K2pXvrlG51--
