From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Sat, 19 Jul 2008 14:07:17 +0200
Message-ID: <20080719140717.7b296eae@mjolnir.drzeus.cx>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	<200807170053.36661.rjw@sisk.pl>
	<1216249292.3358.66.camel@localhost.localdomain>
	<200807170109.30655.rjw@sisk.pl>
	<48808EE0.2060603@gmail.com>
	<20080719004736.626ef169@mjolnir.drzeus.cx>
	<48813C5F.70007@gmail.com>
	<20080719033050.552f9b49@mjolnir.drzeus.cx>
	<48814D81.8060001@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-30400-1216469241-0001-2"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48814D81.8060001@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-30400-1216469241-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Jul 2008 11:12:17 +0900
Tejun Heo <htejun@gmail.com> wrote:

>=20
> Oh... I see.  How about adding sg_miter_consume(@miter, @bytes)?  If the
> function is never called, the whole chunk is assumed to be consumed.  If
> the function is called only @bytes are consumed.
>=20

Sounds reasonable. Care to make an independent patch so that I can
continue my PIO hacking adventures? :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-30400-1216469241-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiB2PgACgkQ7b8eESbyJLjB2QCg1KCslUIDEmrKFM9JVmIIIShK
jfIAoPg5hu1NeLw/v+DiodxZY/bqK3pd
=N4n4
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-30400-1216469241-0001-2--
