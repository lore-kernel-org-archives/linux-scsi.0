From: Andre Noll <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Wed, 27 Feb 2008 11:11:43 +0100
Message-ID: <20080227101143.GC30767@skl-net.de>
References: <20080226174314.GA30767@skl-net.de> <47C45B80.6090907@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757571AbYB0KOc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47C45B80.6090907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Snook <csnook@redhat.com>
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>, Johannes =?iso-8859-1?Q?W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:33, Chris Snook wrote:

> >During the daily cron job that uses rsync to sync a 500G file system
> >from another machine to the raid on the 3ware controller the load
> >jumps up, and the machine becomes sluggish as hell. For example, an
> >ssh login to that machine takes minutes to complete and ldap becomes
> >unreliable while the rsync job is running. Even Nagios complains
> >about the machine being down while rsync is running.
>=20
> You're putting your box under astronomical load.  This is generally=20
> regarded as a bad idea, regardless of how well your storage controller=20
> is performing.

The machine becomes sluggish also when I write directly to the raid
array. A simple

	dd if=3D/dev/zero of=3Dtmpfile

shouldn't push the load up to 4, right?

> Can you measure the single-threaded throughput (say,=20
> coping one huge file, and then syncing) to give us a baseline=20
> performance figure?

Single threaded throughput seems to be ok (140M/s). The problem is
that the machine becomes unresponsive.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHxTdfWto1QDEAkw8RAtjPAJwNpRwisdtLb7LJyjBYwNlFvvw2pwCeNSeS
B3NfZXztnkBMpTmefYuZa0M=
=4v2q
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
