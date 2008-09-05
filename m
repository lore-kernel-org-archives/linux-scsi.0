From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [PATCH] mmc_block: use generic helper to print capacities
Date: Fri, 5 Sep 2008 22:52:09 +0200
Message-ID: <20080905225209.29aace1b@mjolnir.drzeus.cx>
References: <48B9546B.4010004@simon.arlott.org.uk>
	<1220117091.3615.3.camel@localhost.localdomain>
	<20080830174516.GD1239@parisc-linux.org>
	<48B9B552.8060406@simon.arlott.org.uk>
	<48B9B588.7060709@simon.arlott.org.uk>
	<1220147947.3615.18.camel@localhost.localdomain>
	<20080831025412.GJ1239@parisc-linux.org>
	<1220195310.4021.4.camel@localhost.localdomain>
	<1220195634.4021.9.camel@localhost.localdomain>
	<20080831205448.5b23507d@mjolnir.drzeus.cx>
	<1220645340.3331.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-21762-1220647937-0001-2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server.drzeus.cx ([85.8.24.28]:39477 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098AbYIEUwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2008 16:52:19 -0400
In-Reply-To: <1220645340.3331.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-21762-1220647937-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Sep 2008 15:09:00 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2008-08-31 at 20:54 +0200, Pierre Ossman wrote:
> > From: Pierre Ossman <drzeus@drzeus.cx>
> >=20
> > Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>=20
> Did you want me to take this?

That was the idea since it needed your helper.

> It seems to depend on pieces of your mmc
> tree, so I'd have to carry it in my post-merge tree.
>=20

Oh? There shouldn't be any changes around those chunks. What kind of
problems are you seeing?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-21762-1220647937-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjBm/4ACgkQ7b8eESbyJLhXlQCg0ydekPFBDFYBnIMHBONuY37p
5WgAoMCLm893WV1ZKvybXBQxiK1ZVDNB
=XiW4
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-21762-1220647937-0001-2--
