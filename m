From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [stable] [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
Date: Wed, 24 Jul 2013 14:16:21 +0100
Message-ID: <87vc4014ka.fsf@canonical.com>
References: <1374637362.18653.13.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXNQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 09:16:39 -0400
In-Reply-To: <1374637362.18653.13.camel@deadeye.wl.decadent.org.uk> (Ben
	Hutchings's message of "Wed, 24 Jul 2013 04:42:42 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, James Bottomley <JBottomley@Parallels.com>, stable@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ben Hutchings <ben@decadent.org.uk> writes:

> This looks like a candidate for stable:
>
> commit 16da05b1158d1bcb31656e636a8736a663b1cf1f
> Author: Andi Kleen <andi@firstfloor.org>
> Date:   Mon Sep 3 20:50:30 2012 +0200
>
>     [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
>
> Typically this sort of bug can result in leaking kernel memory to
> userland, which is a security issue, but I don't know whether that's
> true in this case.
>
> Ben.
Thanks, I'm queuing it for the 3.5 kernel.

Cheers,
=2D-=20
Luis

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR79OmAAoJENt0rrj9ziT8cpYQAJeHn/r4K/WkdT9KQJ+Sn7pe
Ph43eBY/toj1p4o52hLbpRm5iW562dNmcsSopWvwVGuAMPWXOyKJj4dn7MrYUHET
wkb6+zExyffq0Z4gYbmLpcy6jM3SV4ZJP9xXqX/gIMVqxICJfMD8dMuutxsX+fr+
QnH9oR2irYS2yHmvlAraleV+ThORmbnNEUdXPAaVu39PNLKBi8mAJX3tWjqx6HfC
Nmz+VZKGZy2A1u2Swr86t+Cnq/qIJERzTJFQQVhaUdUtZtKt1zLLk22XWDj4YcLU
xw/Vz0ljGUJSc8GquNBBQBi34xu6F5enG1XrYMkRs6fKeQmbsByfOjq21WB8hPuv
oyG85ddUYgYcdpQx/xAsGYRH7DKykE2Zkf+mEEswr4DPJLGywf3KBL2HGOO9DnDp
E2wASv4R9/2KkK/bY668VXw69T+8UO3mnut8xlw5erwnbOc6pa3MN9ACHLSr9m3G
zvVFRiJqUu+2NUCwLpNajbOhJXvVV3WDXOpYln24heBaoxP6uyV9+mxHBf4nGdqU
vPTawhupzhcan9rTyVfwz22+mTUiEFjSwyoEhUkDFCHz9ZuD+iIGt42TWy17mBC6
HfTZCBATR5PTvQjdF7mapcREdaea7eVoRScM1vQSKIbpCb0zLHtYfrnEBVzab2Hn
duQ9cpJ4b5K4vaYKuWfM
=n5Gj
-----END PGP SIGNATURE-----
--=-=-=--
