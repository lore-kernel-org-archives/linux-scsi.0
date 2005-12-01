From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: cpqfc
Date: Thu, 1 Dec 2005 16:16:17 +0100
Message-ID: <200512011616.23078@bilbo.math.uni-mannheim.de>
References: <1133449397.28116.20.camel@think.jsc.nasa.gov>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1661301.WIScPfrc9u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:46812 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932250AbVLAPQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 10:16:27 -0500
In-Reply-To: <1133449397.28116.20.camel@think.jsc.nasa.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lance dillon <ldillon@sk-tech.com>
Cc: linux-scsi@vger.kernel.org

--nextPart1661301.WIScPfrc9u
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Lance Dillon wrote:
>I have an old compaq proliant server (dual 733) with the Compaq
>FibreChannel HBA Tachyon Chip/Board Ver??: WWN 5002CE4E44556677 (that is
>what the kernel messages say).  This is for my church, which has a very
>limited budget, so they really can't just buy a new machine with regular
>ide drives (this machine was donated to them).  It also has a fibre
>channel array attached to it.

The driver has been removed now. It was broken at many more places. I've=20
hacked a bit on this beast, you can find several of my patches on=20
http://opensource.sf-tec.de/kernel/ . After all these it was still not=20
usable.

Martin K. Petersen (mkp) is writing a replacement driver for this, but I do=
n't=20
know the state of this work. We've tried many things on this beast, but som=
e=20
changed got recursive. This is because many of the functions just return vo=
id=20
and now have to check about the return codes because of kmalloc() an such=20
stuff.

I wonder where all the users of this thing come from as it went clear that =
the=20
driver will die :))

Eike

--nextPart1661301.WIScPfrc9u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDjxPGXKSJPmm5/E4RAndnAKCL2TSmgui90LAPeeQlMXp/xlNmAACghhtt
X90Yrre19lvyqNAKUoWcZ2w=
=kRc8
-----END PGP SIGNATURE-----

--nextPart1661301.WIScPfrc9u--
