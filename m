From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH RESEND] [SCSI] aic94xx: Remove broken fallback for
 missing 'Ctrl-A' user settings
Date: Mon, 07 Jul 2014 03:03:53 +0100
Message-ID: <1404698633.2902.89.camel@deadeye.wl.decadent.org.uk>
References: <1402267064.23860.42.camel@deadeye.wl.decadent.org.uk>
	 <20140625111244.GB19415@infradead.org> <yq11tuccrtm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vYUm1R6AQIuHnulje51R"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55859 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbaGGB73 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jul 2014 21:59:29 -0400
In-Reply-To: <yq11tuccrtm.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-vYUm1R6AQIuHnulje51R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-06-25 at 22:44 -0400, Martin K. Petersen wrote:
> >>>>> "Christoph" =3D=3D Christoph Hellwig <hch@infradead.org> writes:
>=20
> Christoph> On Sun, Jun 08, 2014 at 11:37:44PM +0100, Ben Hutchings wrote:
> >> asd_process_ctrl_a_user() attempts to find user settings in flash,
> >> and if they are missing it prepares a substitute structure containing
> >> default values for PHY settings.  But having done so, it will still
> >> try to read user settings - from some random address in flash, as the
> >> local variable 'offs' has not been initialised.
> >>=20
> >> Since asd_common_setup() already sets default PHY settings, there
> >> seems to be no need to repeat them here, and we can just return 0.
> >>=20
> >> Compile-tested only.
>=20
> If I read this correctly we'll get the link rates initialized but the
> sas_addr will no longer be populated for each phy_desc.
>=20
> The old code copied the board global sas_addr into dflt_ps before
> calling asd_process_ctrla_phy_settings(). Whereas asd_common_setup()
> does not populate the sas_addr.

The old code also reassigned ps before calling
asd_process_ctrla_phy_settings(), so dflt_ps was not actually used.

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-vYUm1R6AQIuHnulje51R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU7oAEue/yOyVhhEJAQqy7RAAhkVqY/AFgfc5OlzzI2ZBQyG2KliDZ01l
nskW2/5MpFlBnIy4ds3cx5uW5YjbijSks5oHfHuA071i6adZ6QKSdpI+VFkCBoOI
xq9MJKXyh4o2osN7A88mSadO+vZLw3Uo2mpxEohD+WYupDW823GmlJamo3npiq1n
xusp57O00TunYo4igH5JFojr8QCya4vOQBLb72nn4itO7DA0npEiyqqXWt09AI8k
Lzyh7kso6eU1xrymDOrX95KA3+gAJOWNUkB5AanhcITrY031MuYA8d9ZbufmmDer
UVZLFXGAsWlf+emTK6Wq0QpIbCAurrXHv9HCCM4j547o5r3Ov0O2Dj45A4X5q4gU
R44rM/X7tovmtCMeXuYsMUELUlyPQ+w2pbj7eSLlxBSAObGiq2rNSUx5fNiJeIxI
Ro2arpRRkk26l6zkLpthLjXqbzElg3t9bHl75J9uia9DOdA+T5KK1qcX4wBBaC5p
ESQS5L3FB3D4LOqsouecl237eiG7LhrfWxtajDxLazfitHZV90ldJZ7+LRtdgnF0
DZ9DrhaisaNRM0AguzwO+SjKy4amVgoLGgFZC01esCSQWpo2/d7w315PxXyTkoeI
bFNxI4uBwBucmXgohvgyWW3MVOj4j48Endz2k/QQroBd0XMiSnkYmwmgEDgvGMR0
v+BKO+4SZq4=
=Sp4s
-----END PGP SIGNATURE-----

--=-vYUm1R6AQIuHnulje51R--
