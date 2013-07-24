From: Ben Hutchings <ben@decadent.org.uk>
Subject: [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
Date: Wed, 24 Jul 2013 04:42:42 +0100
Message-ID: <1374637362.18653.13.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RWRc7j8fb+T15ITQIyD8"
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, James Bottomley <JBottomley@Parallels.com>
Cc: stable@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-RWRc7j8fb+T15ITQIyD8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This looks like a candidate for stable:

commit 16da05b1158d1bcb31656e636a8736a663b1cf1f
Author: Andi Kleen <andi@firstfloor.org>
Date:   Mon Sep 3 20:50:30 2012 +0200

    [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp

Typically this sort of bug can result in leaking kernel memory to
userland, which is a security issue, but I don't know whether that's
true in this case.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-RWRc7j8fb+T15ITQIyD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUe9NMue/yOyVhhEJAQpLgg//T09y7Gqru/LQ0EDBUQH1aM1uhT6BFjhV
tnw+AazGvDRR9M6qitMZHwKLdbOXN4xQyVMoCaICw8DlCZWw2WNxBaewtbQ7WDtv
w1GzgGJQqP7WvzxcIGZ549Nc+ALUA+nDZT9FT7gSdiN8Ax4DiZqMzNH3k5U2R6XR
nBJksmHXBS4OmTeWj1WvSBA3D5arV9qIpNMhxd9b5TtdVJ6+G5oOxijq/0JNjAKx
gHCUAYgj+ORlQvZDDKRn9T0aQ4E06IiiAlzfTPqAdAhOWwAq5jWCemoLLCj3eE/f
c9YCWLtesX+MWTHyXHRf/SDnRtpi3NVqLo24hJODwen5cde7Cto92zUdqETeBms8
G1+/zI985LQ8fuGURIAj4fs8aBed0l9gnHYGXY4Xw1fFIuXvWGXwKzc0VY4SZCVv
ob0y9cnUS+WyzbCX8TowR7nb47gCd/dSNX7MrKYrdrNuIFzNaA4iH9Fd6GFHv6Fs
SNdeO7QHyFJEDLZnKH/uu+MXrdFR8uoU3xjGwXDoJrVutoY1pXm1UvjDTKy6kUtB
SKS0R61pebQaicx0FotBGlIXw5p7875ut3gaH5UwkFwvhsHFuc6Bh/9KOmQhf2tg
0IwtC+XnmkK6GhXQZ5Db9J8h8kXsAadnQFpKQ8LJEqTMPzxhWwA6IMosgglxhizD
WXzP+aFk98E=
=xToc
-----END PGP SIGNATURE-----

--=-RWRc7j8fb+T15ITQIyD8--
