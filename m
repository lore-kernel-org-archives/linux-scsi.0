From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [SCSI] hpsa: dial down lockup detection during firmware flash
Date: Sun, 14 Oct 2012 10:22:16 +0100
Message-ID: <1350206536.4832.73.camel@deadeye.wl.decadent.org.uk>
References: <1349840858.6336.31.camel@deadeye.wl.decadent.org.uk>
	 <20121010141840.GE3546@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5kA2vjHMFzGPjVVYGiLv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43867 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362Ab2JNJWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Oct 2012 05:22:40 -0400
In-Reply-To: <20121010141840.GE3546@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: stable@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-5kA2vjHMFzGPjVVYGiLv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-10 at 09:18 -0500, scameron@beardog.cce.hp.com wrote:
> Yes, I think so.  Thanks.

I've queued this up for 3.2, thanks.

Ben.

> -- steve
>=20
> On Wed, Oct 10, 2012 at 04:47:38AM +0100, Ben Hutchings wrote:
> > Should this fix for hpsa be included in stable updates?  It looks like
> > it would be needed in 3.2.y and 3.4.y, as lockup detection was
> > introduced in 3.2 and the fix went into 3.5.
> >=20
> > commit e85c59746957fd6e3595d02cf614370056b5816e
> > Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > Date:   Tue May 1 11:43:42 2012 -0500
> >=20
> >     [SCSI] hpsa: dial down lockup detection during firmware flash
> >=20
> > Ben.
> >=20
> > --=20
> > Ben Hutchings
> > Who are all these weirdos? - David Bowie, about L-Space IRC channel #af=
p
>=20
>=20
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-5kA2vjHMFzGPjVVYGiLv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHqESOe/yOyVhhEJAQpVehAA0+doXZqqCYaFnR+XEv5ue7NlHCe8ICED
b6EA/lOaBmSoczIjw6ZIMNz2ppf9Yz6Sv9tMA8yfpxWDfbVNA30yhsVsQiN6N+ub
NdDZN2ZRTDKRUd7k3Ug4Oan7hsLo+1vl+4HztuT2ChY0gdajCXsEy5IvkC8Z+j+G
E8cIH31tfpoC6N+Fhed8TVub9qdK70KOdvX/dJkqosQNR1KtY3iyL8VKZy+yihjT
9BWHW8n5RqDGlcj3ZFwadEH2jvduZiPpXr5YMpW+vTIM+KEqV/SCNauf+1ba2Iby
h+3SrVraQo0X7TWUQeGV5LIOD3cJ2tqGUACNArebkayNj+u0y4bJ2u3SB9di5S4d
LSKe6B/38nO6Ds7zb1vcNy1xDvnoj3WgzC1rZQBueCkbwkZTy8dSm1qEprqsoGEC
e/jaemy6RZQBavhzXV8o3x5oWYTUfTS9rjccRbQgbY+Y21OmpdV8IFeLIAaD9xMB
a/7VUmeuFi6vpOpRkIK1X/yxiqspIuEXt375abgrza6UNukHbeQW+MY8Ztz8kGla
rwW4OMiE3puLOAR9plyy4W38W7Pwlzvlwg540fjmwZ6hipASbjAmYHu1/BcWq8nP
QuIMTDAK4Fy899S4t6Asjbzs007dWnDy8S9DJZOwkZcO3YLspgB7XcUBYS5RPz8s
hA18P+qicjg=
=aX26
-----END PGP SIGNATURE-----

--=-5kA2vjHMFzGPjVVYGiLv--
