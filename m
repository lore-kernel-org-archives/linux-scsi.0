From: Andre Noll <maan@systemlinux.org>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Date: Thu, 10 Jan 2008 20:07:48 +0100
Message-ID: <20080110190748.GA20152@skl-net.de>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760272AbYAJTJU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080110185944.GA1690@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
List-Id: linux-scsi@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:59, Andi Kleen wrote:

> But perhaps for such a long ioctl handler it would be better to move
> the lock/unlock_kernel()s into the individual case ...: statements;
> then it could be eliminated step by step.

Sure, I can do that if James likes the idea. Since not all case
statements need the BKL, we could add it only to those for which it
isn't clear that it is unnecessary.

And this would actually improve something.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHhm0EWto1QDEAkw8RAnHLAKCVzJIQO3qkNpYDADIwByWgXWCKBQCeIHoX
3jVTY6J2pWn+rpEc/A84rUE=
=KeEV
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
