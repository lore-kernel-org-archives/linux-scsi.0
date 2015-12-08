From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v4 0/3] Badblock tracking for gendisks
Date: Wed, 09 Dec 2015 07:30:38 +1100
Message-ID: <87poygsmxd.fsf@notabene.neil.brown.name>
References: <1449602295-28781-1-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbbLHUav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 15:30:51 -0500
In-Reply-To: <1449602295-28781-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

--=-=-=
Content-Type: text/plain

On Wed, Dec 09 2015, Vishal Verma <vishal.l.verma@intel.com> wrote:

>
> Patch 3 converts md over to use the new badblocks 'library'. I have
> done some pretty simple testing on this - created a raid 1 device,
> made sure the sysfs entries show up, and can be used to add and view
> badblocks. A closer look by the md folks would be nice here.

Hi,
 this all looks reasonably sensible.  I haven't gone over it with a
 fine toothed comb (I wonder where that analogy comes from....) but
 nothing is obviously wrong.

 Acked-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZz3vAAoJEDnsnt1WYoG5S84P+wVCYzirtIkAFpLxJ7XrXc2w
lsKy2lcS/fVkcNWtaVch9D6y8rdi7RQ2Y/vGcW1wYahJLPd9eDsYVfl2L0IZqijL
Ug78ll9yFT/tRYXvr3Lx83+vMqKXtyjSaZ9OirNhzs+w3OOb8oDDeH4cdUJDYXUs
IfwK64WNc3Ng8YrR31VbPT/BbQLyLp1FZjmwR0JFeKz+wtQkz2gbRE1IZlOy8s7j
OTFvVo4DtR40glra/cZH/geCRpsueCfp+R0vw1+p5Y/aedoPXvGFxubWHMXjzyVk
V+OgI3Ie2fiF0lxRNPZa6aDtJ1V9o98bw8BOO2JJqQu42ZOJr6kKfDi0M14+fcpy
L5ngGW3O2wKSvRQ+PrLS4+oWCg3emyKhJ7mcjwmdH/b6EH5BSPocMOJHaNPezMuk
kUDYHjcQrlB6cDf0ZHufyx8Sq9eUI/mPa70nYCiSi3TeI7/Ot28aZxmT104ilcyT
ncwY+o9It+B3u2OmpxJYKkEij8pYHLoZfPhIYEUt+4GDcgfHE5zaWsXs/VtwuTPW
LdfkEcSerlAlOUBz0tSmPsgGHTuUgTGJ3dPNv7jyNx+E9JemIFX/vgpDwlCIHVyK
/zXZ6qZL4ZfVH1s0ScLrUCSjeuw7wNGwH40ETv3xsI8yMN8H/8kaQMfBrqigcHdy
4fbxCtceYP7poSy2jniL
=kkub
-----END PGP SIGNATURE-----
--=-=-=--
