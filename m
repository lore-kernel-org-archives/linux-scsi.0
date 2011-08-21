From: Alexander Kurtz <kurtz.alex@googlemail.com>
Subject: RE: [PATCH] [SCSI] mvsas: Add support for Marvell's 88SE9480 chip.
Date: Sun, 21 Aug 2011 17:02:05 +0200
Message-ID: <1313938925.9034.28.camel@localhost>
References: <1313231597.6786.0.camel@alexander>
	 <F766E4F80769BD478052FB6533FA745D19FE5D21A9@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-e5quVmleCs4k18b+2Iwj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37362 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1HUPCL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2011 11:02:11 -0400
Received: by fxh19 with SMTP id 19so2819558fxh.19
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2011 08:02:10 -0700 (PDT)
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FE5D21A9@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: linux-scsi@vger.kernel.org


--=-e5quVmleCs4k18b+2Iwj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2011-08-15 at 19:44 -0700, Xiangliang Yu wrote:
> Subdevice should be is 0x9480
> 		.subdevice =3D 0x9480,

As announced earlier[1], I have returned the device meanwhile because of
some serious malfunctions, so I can't test this change. If you are still
interested, you might want to read my Debian bug report[2] which
contains some further information.

Best regards

Alexander Kurtz

[1] http://permalink.gmane.org/gmane.linux.scsi/69578
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D637591

--=-e5quVmleCs4k18b+2Iwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJOUR3tAAoJECmUnEL6df6RiDEQAKRap3WtS/gAEtnTdKAMMPCA
bNQEVKXRMuCPZkIj9HvJJOgdKSswI+ctt7X6opMV6izDz5aG6coLNYEzGLmz2ssX
iU/rcyvgHpcyQld3NKDt7b6b3WehW59+zr33Y++JwZy9HpbQeuHV7Ssu282gnvH0
gjFuCR3A/td+MU5keOLfM/dOhStGQA7QqG8LWHqwTqHCQufNFLbDvO2UBTK3uUgR
ajrZTnGlYoPGVMTb9H15aZ5odEFWZdSiRnj2aGXj9J1wViLhYSJVo8nMj6xMG3rJ
ihcjIur4co4a8NuwOh9nFzPKFk/c6WVb0+mcEY06434PHSlnEwZdJlOirZRnTB5m
RJMHSdt5No3QzgwHKUi9sGhbSOHRqTM2fzFME9gptZXHi9Ar12hr3Q3leGBTfZyO
O6Em/btWpHUhdov4jL9xe00IKkvNLVzd5erySJXCCg/jBwy/6zs6hRGG/Zavr0g+
I6WaO9iGuxLxs5BUnd92qlvucHK4+/U1XGwd/YytoFaFjegJ5APzx6x+InZlEiE5
lwOXJwoTfpshKcKsiK+KZpiBTFDjJ8cUMYSKtD3ek48CVX2dT3cB1uKJrkFihor3
/SZ+ZmpYlw7LMT4zp8kPRT166JoTCXX/CK6+vsDcLAZl8YjuXXRKuUhC5fP3XPp3
dQx/r769zImWKgljSySB
=H/Me
-----END PGP SIGNATURE-----

--=-e5quVmleCs4k18b+2Iwj--

