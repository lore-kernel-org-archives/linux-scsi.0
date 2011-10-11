From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: Re: [PATCH] mv_sas: OCZ RevoDrive3 & zDrive R4 support
Date: Tue, 11 Oct 2011 21:21:43 +0000
Message-ID: <robbat2-20111011T211421-450808012Z@orbis-terrarum.net>
References: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
 <1318132024-12426-1-git-send-email-robbat2@gentoo.org>
 <robbat2-20111011T204841-021218330Z@orbis-terrarum.net>
 <1318366663.2992.29.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aF3LVLvitz/VQU3c"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36722 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab1JKVVo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2011 17:21:44 -0400
Received: from grubbs.orbis-terrarum.net (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.gentoo.org (Postfix) with ESMTPS id 687A41B403D
	for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2011 21:21:44 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <1318366663.2992.29.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-ide@vger.kernel.org
Cc: "	Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2011 at 03:57:43PM -0500,  James Bottomley wrote:
> Well, when you put things like
>=20
> "NOT FOR COMMIT USE; TESTING ONLY; NO WARRANTY; DANGER!"
>=20
> and
>=20
> "I constructed this patch for my friend to test, completely blind.
> I haven't heard back from him at all yet, but I thought that the wider
> community might find it useful for testing as well. I think it _should_
> work, just need to figure out what the correct chip variant is."
>=20
> On the patch it tends to make maintainers exercise extreme caution.
> Thus comments from others (preferably successful test reports) or acks
> from Marvell or Vertex would be very helpful.
Both of those were on the first version of the patch, when I'd written
the code and not run it at all. After that, I got access to a RevoDrive3
remotely, and run about 5TiB of data through it for testing.

The second version of the patch removed those warnings, and described
some of my testing:
http://thread.gmane.org/gmane.linux.kernel/1200731/focus=3D50312

Some fio performance numbers:
http://paste.pocoo.org/show/489716/

dmesg/hdparm/smartctl:
http://www.ocztechnologyforum.com/forum/showthread.php?95151-Linux-patch-su=
pport-for-RevoDrive3-RevoDrive3-X2-zDrive-R4&p=3D686054&viewfull=3D1#post68=
6054

--=20
Robin Hugh Johnson
Gentoo Linux: Developer, Trustee & Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--aF3LVLvitz/VQU3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAk6Us2cACgkQPpIsIjIzwiyS4ACfTl9WChJbrfzIxgrbaXiNWDB+
9LEAn3QUlUISMBzeh3E91F11LbKX3yXi
=h3y7
-----END PGP SIGNATURE-----

--aF3LVLvitz/VQU3c--
