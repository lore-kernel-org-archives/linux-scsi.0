From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Wed, 21 Apr 2004 15:48:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421134846.GQ28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <1082477331.2191.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZMy3ZKywLyoHonN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:28818 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262514AbUDUNsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 09:48:51 -0400
Content-Disposition: inline
In-Reply-To: <1082477331.2191.44.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>


--7ZMy3ZKywLyoHonN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2004 at 11:08:49AM -0500, James Bottomley wrote:
> This looks like it needs fixing in our lun mapping support, doesn't it,
> rather than trying to work around it with a flag?

Any ideas?
We need to use full 8byte LUNs then.=20
* We can use them as opaque handles. Clean, but resulting in crazy numbers
  which sysadmins will hate us for.
* Reorder the bytes as currently done, but for all 8 of them. Less clean
  conceptually, but resulting in low LUNs and not changing the behaviour
  for already supported devices.

I'm in favour of the second solution.
Want a patch?

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--7ZMy3ZKywLyoHonN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhnu+xmLh6hyYd04RAuYMAJ9UnvVrHZd1NhprLqGjhS2vEeO62QCgvMTv
t6a+JnE9d+jyC6TmcB759tE=
=81mo
-----END PGP SIGNATURE-----

--7ZMy3ZKywLyoHonN--
