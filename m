From: Zan Lynx <zlynx@acm.org>
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load
Date: Tue, 26 Feb 2008 14:04:12 -0700
Message-ID: <1204059852.665822.13.camel@localhost>
References: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz>
	 <20080224161034.f494fc7f.akpm@linux-foundation.org>
	 <alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz>
	 <20080226094308.35db8f3f.akpm@linux-foundation.org>
	 <alpine.LRH.0.9999.0802262018230.14724@linuxbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EoiYypk6TXvLZqh5JTYk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from threatwall.zlynx.org ([199.45.143.218]:33293 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756234AbYB0Ahm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 19:37:42 -0500
In-Reply-To: <alpine.LRH.0.9999.0802262018230.14724@linuxbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Nick Cheng <nick.cheng@areca.com.tw>, Erich Chen <erich@areca.com.tw>, kopi@linuxbox.cz


--=-EoiYypk6TXvLZqh5JTYk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-02-26 at 20:29 +0100, Nikola Ciprich wrote:
> Hi Andrew,
> no, right now I have the machine in the weird state, swap is empty (3GB),=
=20
> and so is bigger part of RAM (~100MB free), and the gcc crashes even when=
=20
> trying to compile c program with empty main function. so it doesn't seem=20
> to be problem with memory exhaustion.

Maybe memory fragmentation?  Perhaps the driver tries to allocate a
large block of memory and cannot find a continuous block of the right
size.

Maybe the driver developers used different kernel .config options than
you are using. =20

Try increasing the value in /proc/sys/vm/min_free_kbytes.

Try switching some things like SLAB or SLUB, try booting with
kernelcore=3D512M to enable the Movable memory zone, or try 64-bit vs
32-bit kernels.=20
--=20
Zan Lynx <zlynx@acm.org>

--=-EoiYypk6TXvLZqh5JTYk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHxH7MG8fHaOLTWwgRAlMnAJ9ib1TYBP/raSIIQp2WIz1jSaIBuwCfZIGZ
An3ApUucleETaoCZSBzarWM=
=G2fr
-----END PGP SIGNATURE-----

--=-EoiYypk6TXvLZqh5JTYk--

