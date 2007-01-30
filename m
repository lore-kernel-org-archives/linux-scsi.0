From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.20-rc6-mm1
Date: Tue, 30 Jan 2007 21:22:31 +0100
Message-ID: <45BFA907.6060300@drzeus.cx>
References: <20070127234928.64d8e437.akpm@osdl.org>	<45BC7A26.1080303@gmail.com>	<20070129232727.96e580ac.akpm@osdl.org> <20070130113055.431ad91a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-32411-1170188557-0001-2"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751296AbXA3UWk@vger.kernel.org>
In-Reply-To: <20070130113055.431ad91a.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Miles Lane <miles.lane@gmail.com>, Anton Altaparmakov <aia21@cantab.net>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-32411-1170188557-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
>=20
> A quick scan indicates that the following files might be buggy in this
> regard:
>=20
> drivers/mmc/wbsd.c
> drivers/mmc/sdhci.c

This are probably even buggier than so. They really should be using
page_address(), it seems that kmap_atomic() gives the same result when
not using highmem (which they are carful to avoid).

I'll put on the paper bag and whip up a patch.

Rgds
Pierre


--=_hera.drzeus.cx-32411-1170188557-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFv6kM7b8eESbyJLgRAguWAKCSdQ7YKPJ6bMEwTPbqYzNtgYAliwCgpwJ+
QjoJJUrd4ycOj5KMFjR2iAQ=
=85cV
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-32411-1170188557-0001-2--
