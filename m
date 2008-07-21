From: Pierre Ossman <drzeus-p3sGCRWkH8CeZLLa646FqQ@public.gmane.org>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Mon, 21 Jul 2008 13:32:09 +0200
Message-ID: <20080721133209.62e31bc8@mjolnir.drzeus.cx>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	<200807170053.36661.rjw@sisk.pl>
	<1216249292.3358.66.camel@localhost.localdomain>
	<200807170109.30655.rjw@sisk.pl>
	<48808EE0.2060603@gmail.com>
	<20080719004736.626ef169@mjolnir.drzeus.cx>
	<48813C5F.70007@gmail.com>
	<20080719033050.552f9b49@mjolnir.drzeus.cx>
	<48814D81.8060001@gmail.com>
	<20080719140717.7b296eae@mjolnir.drzeus.cx>
	<4881F437.7000503@gmail.com>
	<20080721004033.1fc66aa3@mjolnir.drzeus.cx>
	<4883DA8C.5030306@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2472-1216639933-0001-2"
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4883DA8C.5030306-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-ide <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, tino.keitel-Mmb7MZpHnFY@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2472-1216639933-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Jul 2008 09:38:36 +0900
Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>=20
> I think it needs an ACK from Jens.  Jens?
>=20

He seems to be on vacation. I sent him a review request for my original
code a couple of weeks ago, and I haven't heard anything. marc.info
also doesn't show anything since the 3rd. Odds are he won't be back
during the merge window. :/

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2472-1216639933-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiEc7sACgkQ7b8eESbyJLiuuQCcD7NCbqFggYtniBwAHBa8rL98
gdQAoJ3NzNvWyflLOF4NoK6OkVCsSsUG
=t/bj
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2472-1216639933-0001-2--
