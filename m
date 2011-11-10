From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Silencing 'killing requests for dead queue'
Date: Thu, 10 Nov 2011 23:13:04 +1100
Message-ID: <20111110231304.9685eb077365ed1447e37c33@canb.auug.org.au>
References: <1320824364-8510-1-git-send-email-hare@suse.de>
	<20111110131029.be09b1080f3fe22d5fa86fe4@canb.auug.org.au>
	<CAO+b5-pAuUixoNsckZheThHnh5H2LbYHh8D8Tm7PQfRxEMgRJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Nov_2011_23_13_04_+1100_oj9YtrthHtfW+UGI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from calzone.tip.net.au ([203.10.76.15]:51841 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab1KJMNP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2011 07:13:15 -0500
In-Reply-To: <CAO+b5-pAuUixoNsckZheThHnh5H2LbYHh8D8Tm7PQfRxEMgRJw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

--Signature=_Thu__10_Nov_2011_23_13_04_+1100_oj9YtrthHtfW+UGI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Thu, 10 Nov 2011 12:57:37 +0100 Bart Van Assche <bvanassche@acm.org> wro=
te:
>
> On Thu, Nov 10, 2011 at 3:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > ipr_init is now down to 2543495 usecs (down from 494857993 usecs without
> > this patch) and the machine boots as well as can be expected.
>=20
> These timing differences are puzzling me. Have you been able to find
> out what is causing them ? Are kernel messages on that system perhaps
> sent to a serial console ?

Yeah, effectively (not actually serial, but close enough).  And there
were a very large number of messages.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Nov_2011_23_13_04_+1100_oj9YtrthHtfW+UGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOu7/QAAoJEECxmPOUX5FEZUcQAIegyr4c2dSnSb6YUn3RiOhi
IbaN7L4jyvIeV+shNBv7lxW0gYRJcuwHQ+sS9MaxkczZHo7KloyNAxE+uXtWkcWI
t/ee5igEwCp3ChpWuYNgefRssMiYjRoLW/PPqmysSlAGapEp/xNqyzvXidijfHxn
G3S3wy15KH4Vg0+MHlbV+dKKaPHCO+hi5nEmnvFum1HxCD+NchuN/q0r861Rckr3
pbRCGJwPHqRVD2t0knYlojKxQ+PFWMTjcytetbYdWEUASgaxaSyhv7bQbFTVbZQh
YFI3nOrJkL2B2LTI7/EOSr4PzS4nrU/XaTzyYmRp5MEGZ7p3ZHcRdRXZ2IWUiQyl
W8wU4v6UHjsFLxQqquBMU8l4rl21pKNzgXvupSHAxqAOdoYqJ3i64je9/BvfeWT+
IPnPCjBdHUo3s3REnNE6/WnguwfYtp/b+GNSIJTjBY0VxIIfLGnRZr2DDUpxxin5
ZEkpUycbyIr0uqKSmUmF74Fn/rBmXaEuBsdU34zCTi7v/KMoYsRV6cTOYVBAUUnI
/aMVPMFKRjIh16ve2+Aa70XX+omeAgcotr+nzVqch77vBnDy9ThdXeNmXrnNv6/x
LvGa71XsO3J3VX98yqAzLhnSOGNUD0H5qv0tKoz4jbCcWg9XnHszh766XYGOg+oB
EU7CJQNRC/tZem5yAO/0
=ezVq
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Nov_2011_23_13_04_+1100_oj9YtrthHtfW+UGI--
