From: Tom Duffy <tduffy@sun.com>
Subject: RE: [PATCH 22/82] remove linux/version.h from
	drivers/message/fus	ion
Date: Tue, 12 Jul 2005 13:30:20 -0700
Message-ID: <1121200220.13708.17.camel@duffman>
References: <91888D455306F94EBD4D168954A9457C030A908F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D9D1/BBQJYs+1EOwjco8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nwkea-mail-1.sun.com ([192.18.42.13]:21659 "EHLO
	nwkea-mail-1.sun.com") by vger.kernel.org with ESMTP
	id S262389AbVGLUcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 16:32:39 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C030A908F@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


--=-D9D1/BBQJYs+1EOwjco8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2005-07-10 at 18:15 -0600, Moore, Eric Dean wrote:
> I'd rather you not kill linux_compat.h file.
> I use this file for compatibility of driver source=20
> across various kernel versions.  I provide our
> customers with driver builds containing single source=20
> which needs to compile in kernels 2.6.5( e.g. SLES9),
> 2.6.8 (e.g. RHEL4), and 2.6.11 ( e.g. SuSE 9.3 Pro).

It is the general policy that the source in the latest linux kernel only
supports that kernel.  You can certainly keep a compat header for your
customers, but what is in kernel.org should be clean for that version of
the kernel.

> If you look at our 3.02.18 driver source I submitted to SuSE
> for SLES9 SP2, you will see this file is about 3K bytes of
> compatibility. =20

Is the 3.02.18 code generally available now?  Can it be cleaned up for
submission to 2.6.13?

-tduffy

--=-D9D1/BBQJYs+1EOwjco8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC1ChcdY502zjzwbwRAjz7AJ498j2j8RknLzTTZEKRfp9g4K4xowCdGJ0x
H768BjFZFV5UKmU7uLMr9cs=
=vmnQ
-----END PGP SIGNATURE-----

--=-D9D1/BBQJYs+1EOwjco8--
