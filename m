From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
Date: Sat, 27 Jul 2013 15:48:32 +0100
Message-ID: <1374936512.13555.21.camel@deadeye.wl.decadent.org.uk>
References: <1374637362.18653.13.camel@deadeye.wl.decadent.org.uk>
	 <20130724142048.GV6123@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TNwT7zBeYHP0+jbPu/Un"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130724142048.GV6123@two.firstfloor.org>
Sender: stable-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, James Bottomley <JBottomley@Parallels.com>, stable@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-TNwT7zBeYHP0+jbPu/Un
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-07-24 at 16:20 +0200, Andi Kleen wrote:
> On Wed, Jul 24, 2013 at 04:42:42AM +0100, Ben Hutchings wrote:
> > This looks like a candidate for stable:
>=20
> Don't know if it's a security issue, but should be fine for stable.

OK, I've queued it up for 3.2.

Ben.

> > commit 16da05b1158d1bcb31656e636a8736a663b1cf1f
> > Author: Andi Kleen <andi@firstfloor.org>
> > Date:   Mon Sep 3 20:50:30 2012 +0200
> >=20
> >     [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
> >=20
> > Typically this sort of bug can result in leaking kernel memory to
> > userland, which is a security issue, but I don't know whether that's
> > true in this case.
> >=20
> > Ben.
> >=20
> > --=20
> > Ben Hutchings
> > Once a job is fouled up, anything done to improve it makes it worse.
>=20
>=20
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-TNwT7zBeYHP0+jbPu/Un
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfPdwOe/yOyVhhEJAQrWsA//dN3EdmYX/3/HCtUuuyj/f+U9MU0bvxcL
Y86BrRDLizjMGkTFfx4/dDCzYYbnCFm/9i5Xuc5veqyuBvyUr5UKX/6ArsubLWhN
hX+lQ0duxIuXGMs58IpujVxd2M+CNdnE5SdM8zUOFZCD5I7bISz+oRX6XS49eN58
rmz5aho+n+cV16o+0dsk9emONes+tVYWDBMoPgoOKe68pWkco3jrnlbuYAppfSn3
P04LtgQFLaoh17uJWYQo2R+sKP72nA7SC0GOgieZEXrkvJimbxh/RzkKBNyNcC8R
3QPchFid+iJA4Hul2VZp94oGMZ9Ljnl/3Css0UPG/6j+Kc8eJWzWPnT7I4VeKebK
ki2nmz+eZF13U+VqOdc4QR/lAPutGhQ8FrD25+kKxx10eAaaB1OAkcT7pL2240f7
4WlyHR/zdN7vRRYGjrrGGB5mKga99H3DPwkeeKi3DxzputPzPeMzhuchSyE/13ri
RVGuZUDEY2NLDnxqlatIw9xsni/XLqBPRjAac8S44AiTdBzgTG2gDY9qRV0LLNf1
560OM+iaWRTspYMQ8x29vZlanq4VaV7ugzsufQvoemz2/X2oBRc7gVonLYn6FZ3s
FCXorZofC/3i3sqrwvSVsFG82ukJH7EBvj/XfH6kAEb/Zal4BOByEYiWHsy+RF74
pBizigdBpic=
=ESfy
-----END PGP SIGNATURE-----

--=-TNwT7zBeYHP0+jbPu/Un--
