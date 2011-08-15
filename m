From: Alexander Kurtz <kurtz.alex@googlemail.com>
Subject: Re: [PATCH] [SCSI] mvsas: Add support for Marvell's 88SE9480 chip.
Date: Mon, 15 Aug 2011 22:45:31 +0200
Message-ID: <1313441131.12266.11.camel@localhost>
References: <1313231597.6786.0.camel@alexander>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DEFIiquQmBka5krvm7PG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39023 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1HOUpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2011 16:45:35 -0400
Received: by fxh19 with SMTP id 19so3811234fxh.19
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2011 13:45:34 -0700 (PDT)
In-Reply-To: <1313231597.6786.0.camel@alexander>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, 637591-done@bugs.debian.org


--=-DEFIiquQmBka5krvm7PG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

although the patch made my system recognize the HBA, there were several
severe issues when actually using it: I experienced random reboots
during POST and several freezes during heavy I/O. Additionally the
system always failed to wake up from S3 when the HBA was plugged in.

I'm therefore going to return the card in a few days. You may still
consider merging the patch since it made my system at least recognize
the HBA after all.

Best regards

Alexander Kurtz

--=-DEFIiquQmBka5krvm7PG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJOSYVqAAoJECmUnEL6df6RGVIP/3aL6RA/g+tMOFOGvUht1Lsa
S14dBheuEf/nX0cvTl5qOKh3AY5n/yjNl+dxOXrsFUbkT8WWJHBBZGYFXL3DsQwc
3wfowk2YisIIWFtk8SYB2kMPxHYUXfPvoTx7l9CiN7xV2fO7FOTKp7WozbXnw/iD
oOExPLbv3GwF3+DzoDrk5MHWqT2jnJ/VyoYZ2LOTQHab6bhYm7Ek4aegg+5H5hlr
FSMJG+uj6orUDnHh1UuE5QWup0S0N4vex6b2pnVUBN7jkRUgnK7JmqARL1m8Buy/
+p2/Gslxk5BPhy6Tn5nJKKHmKvkJWAc1LHpZFrUqkBlB7/MeKRr/nAzr+uSL1qIh
vub9IgpgQK+DhsArVFrAFtClXnA9Sg9PNPtFeRXZso8u/L8nVhXDJHEs3UKtsiZC
cGq8E1kIERAACb0ca1vy2wTDmmEHxJaPf2GYyPcvvT2XQb9TLOE/rrFx1EiutW8n
IlzQYCabQkKDD73A5Ye5UJUNXSG3tInJv86y0pxnNnkJ5n0DvkiLxAOlrgX2aXak
gDE7YAyynGo9RyASmjwWxvFb2kL2wKalSX+vBt4nG+TdtDKMjTvqMobXs2S5o4/v
HhXHZHvIel/jLY3FdMI74JjRHErWyjzIKmL19zq6iAZEry8jna+EGfxpx2oQy5FM
DsoN5oSMPhOX8AV6D7GN
=nuDj
-----END PGP SIGNATURE-----

--=-DEFIiquQmBka5krvm7PG--

