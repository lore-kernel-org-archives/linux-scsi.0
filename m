From: Andre Noll <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Wed, 27 Feb 2008 11:11:54 +0100
Message-ID: <20080227101154.GD30767@skl-net.de>
References: <20080226174314.GA30767@skl-net.de> <47C49B99.1060707@nets.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:55128 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbYB0KNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2008 05:13:37 -0500
Content-Disposition: inline
In-Reply-To: <47C49B99.1060707@nets.rwth-aachen.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>, Johannes =?iso-8859-1?Q?W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:07, Arnd Hannemann wrote:

> > During the daily cron job that uses rsync to sync a 500G file system
> > from another machine to the raid on the 3ware controller the load
> > jumps up, and the machine becomes sluggish as hell. For example, an
> > ssh login to that machine takes minutes to complete and ldap becomes
> > unreliable while the rsync job is running. Even Nagios complains
> > about the machine being down while rsync is running.
>=20
> Could you give some numbers, please?

What kind of numbers would you like to see?

> However there are some known issues:
>=20
> http://forums.storagereview.net/index.php?showtopic=3D25923
> http://tumbleweed.org.za/2007/02/16/horrific-performance-with-3ware-raid

Thanks, this helped a lot. However, there does not seem to be a way
to make the system more responsive, which is really the problem we
are experiencing.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHxTdqWto1QDEAkw8RAs56AJ9ySmErHiQDjJWvw974+MK0h+4PqQCgoYDs
pvMcr6YM34Pd6jkjIZzoJU0=
=Ghs2
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
