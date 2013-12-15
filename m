From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 1/1 linux-scs-ml] qla2xxx: Update ql2{4,5}00_fw.bin to
 version 7.01.00
Date: Sun, 15 Dec 2013 18:02:11 +0000
Message-ID: <1387130531.12172.94.camel@deadeye.wl.decadent.org.uk>
References: <5290A6DE.8080008@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KdSlKQ1WxcyGapn2uDCn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679Ab3LOSCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Dec 2013 13:02:33 -0500
In-Reply-To: <5290A6DE.8080008@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, David Woodhouse <dwmw2@infradead.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>


--=-KdSlKQ1WxcyGapn2uDCn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-11-23 at 14:00 +0100, Xose Vazquez Perez wrote:
> resent to linux-scsi-ml, without the binary blob(316K).
>=20
> fw and licence were taken from http://ldriver.qlogic.com/firmware/
>=20
> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: linux-driver@qlogic.com
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  LICENCE.qla2xxx |  60 ++++++++++++++++++++++++--------------------------=
------
>  WHENCE          |   4 ++--
>  ql2400_fw.bin   | Bin 257108 -> 259332 bytes
>  ql2500_fw.bin   | Bin 260064 -> 265420 bytes
>  4 files changed, 28 insertions(+), 36 deletions(-)
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-KdSlKQ1WxcyGapn2uDCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUq3uo+e/yOyVhhEJAQo5/xAAl36gQu5WceO9kBYM1GhRiPYUyE0pws4B
JM5uBo6PoCf90HLm7oEFtgDFLBYIgVx6KvjKb/4PAer+cJ1iOHF5LGc4OjkgmwpH
PKyRItoSXylEfC0WHTtZxRraTiGL9SE+4H9myiRhjImgrBg2jgLx+uuna1b+/mGW
aXbRY+C7zVnhhmqi/0plSYwq7cRZ/Hrk7mcHXzKY52058YhjIHAKalGv/BJlRQIb
5MkWmBNb+p+APQisXUBsm29+HuARUXadme8e6eqFBN/fDOQMCtyxe/pbMlWKFIAd
efdrjPMD5U2AKiVWImGBHcrHqbUo3QSR35BLH74KGUXWieh5M6mjWWyL4poKnR1E
Jw37/V1jl5RZ+FIYzBACueOgWraghn5eUn5T8XeqmKJdBBehkjt4zmN4DSZ0LRqB
b5gPFFbTuBmois4nU3IS3PoO+Gv0sJOcmcSVNPVlGnquEj9c2lY9m8Ojdg1U5AUM
/racFz3H/zof3MvSiCyvHDLJu9VlGYKN2msasUhGdQfKWZpWYOD+aXbvz8R3nbqM
gXJGd0Ks1Pj6vi0GLAt0Oa4dpBw7df/keMU0L5X9vTpS5nCCTD7amBpyTIvntn10
8FvTUGUxvOAAaNmg238s1TkVAUwir1/R0jtrsRZJdV557Gvh6ap2BQXxV4v7Os3V
BPMk4LvjOS8=
=TQ3H
-----END PGP SIGNATURE-----

--=-KdSlKQ1WxcyGapn2uDCn--
