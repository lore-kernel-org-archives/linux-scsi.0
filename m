From: Ryan Anderson <ryan@autoweb.net>
Subject: Re: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Fri, 08 Jul 2005 13:41:47 -0400
Message-ID: <1120844507.19828.70.camel@ryan2.internal.autoweb.net>
References: <1120844190.19677.46.camel@markh1.pdx.osdl.net>
Reply-To: ryan@autoweb.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IEmrXG+hKDi8NOHaT2ol"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.autoweb.net ([198.172.237.26]:54459 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S262732AbVGHRlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2005 13:41:53 -0400
In-Reply-To: <1120844190.19677.46.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Martin Drab <drab@kepler.fjfi.cvut.cz>


--=-IEmrXG+hKDi8NOHaT2ol
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-07-08 at 10:36 -0700, Mark Haverkamp wrote:
> Martin Drab found that he could get aacraid timeouts with high load on
> his controller / disk drive combinations.  After some experimentation
> Mark Salyzyn has come up with a patch to reduce the default max_sectors
> to something that will keep the controller from being overloaded and
> will eliminate the timeout issues.

Would hitting this timeout issue cause the container to go offline?

If so, I think this may fix the issues I was having 6 months ago.  (We
ended up taking the aacraid controller out of our production
environment, in frustration.)

I'll try to get some testing time in on this next week, though, the
problems I've run into were very hard to reproduce on demand.

--=20
Ryan Anderson
AutoWeb Communications, Inc.
email: ryan@autoweb.net


--=-IEmrXG+hKDi8NOHaT2ol
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBCzrrbvV/uNaz8d+gRAvsqAJ0R022wv4UZ99FBoCS/1MmqoKTq5gCfYAzw
VGCaXV/TO26VFt4a3cpR/YU=
=Cad7
-----END PGP SIGNATURE-----

--=-IEmrXG+hKDi8NOHaT2ol--
