From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: [usb-storage] Re: External USB3 disk fails with "Invalid field
 in cdb"
Date: Fri, 27 Jun 2014 21:52:35 +0200
Message-ID: <20140627215235.4be63476@wiggum>
References: <20140627205153.6a8ac916@wiggum>
	<Pine.LNX.4.44L0.1406271521350.875-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/q3wS..JVRY_YblxYTuTs._k"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49721 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaF0Tyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 15:54:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.1406271521350.875-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Bryn M. Reeves" <bmr@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

--Sig_/q3wS..JVRY_YblxYTuTs._k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jun 2014 15:23:42 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > MaxPower=3D2mA is a nice guess for a hard disk. ;)
>=20
> That refers to the amount of power the device draws from the USB bus. =20
> Since the disk drive is self-powered, it doesn't use much bus power.

Unless the device uses free energy or some other perpetual motion power sou=
rce,
it seems that it actually is bus-powered.
So the self-powered from the descriptor is a lie, too.

> Does the patch below do what you and James want?

Yes, this does work. Thanks!

You can add my
Tested-by: Michael B=C3=BCsch <m@bues.ch>

--=20
Michael

--Sig_/q3wS..JVRY_YblxYTuTs._k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrcuGAAoJEPUyvh2QjYsOSB8QAN4lw2mJtlsM7KhVkBj/xV8j
YIAw5hOy69w1OUz+5UWoph1YDkgI+LpjwkmsmQhp96wi9yEMExuVd7CGJeIPBpVG
0RktwCfv7zHbmew//6tPazw9YJGRU2Z4B0VjWUT/EOBGfYyw0g05W7xrpxX5XuaQ
u9dFsCcZTcN0+XiF32cLka6IuTYeObPN4/Lgk1IgYAnJCbQDacf9nPDZxWIMWR6Z
zKDV5OoR8KDJLM4lXdcTskZJ0X1YpluEn48faVk8FjoLqOkcU44FiNw3pvG+Uc/B
yPQySxJCbQdT1uRXDrP/VgFsPTs8CfkTI5yfGHE0cuWIeRDEnOjTkN0ppNJMY0jH
3FjM1UXmSIVbAv3gAPtToc9gvAgH97JdlQEMbhYslMrPJUd2NG14w+tB8o1viuRi
yBpGRG6tBJcFWzwaSa0Gxo0H3lqlG7A3b4ywq+MEjyZKo4bJCV56l3jjQ96+Eyfr
Kq7QohPBICr+fJEvwBTlHvgTethyPQmsFaZeUedpUxqTkXuOesEaPZjd8/t7amBx
dUhn2bZDIUjQDJ2pCGxQqApQge9dzhYbsx6tavXqXaVvfRexRxO6vnuy8a2GuxRY
/jn224shS+uxAm9+RhliFxcjDhEN6uruPxc+LQmzZxngUPZeF1lJD2GlnfL/Kop9
l/PNG3oKgHrIopMF7Zco
=uuCf
-----END PGP SIGNATURE-----

--Sig_/q3wS..JVRY_YblxYTuTs._k--
