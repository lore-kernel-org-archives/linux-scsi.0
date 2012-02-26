From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#661057: linux-2.6: hpsa driver does not support multipath
 on Smart Array 712m with latest firmware
Date: Sun, 26 Feb 2012 17:36:28 +0000
Message-ID: <1330277788.8460.90.camel@deadeye>
References: <20120223203730.32558.81859.reportbug@pirate.dialogue.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uXDCSEBTpJssOcsrz6br"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab2BZRgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2012 12:36:46 -0500
In-Reply-To: <20120223203730.32558.81859.reportbug@pirate.dialogue.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, Scott Teel <scott.teel@hp.com>, James Bottomley <JBottomley@Parallels.com>
Cc: 661057@bugs.debian.org, Steven Williamson <steven.williamson@dialogue.net>, linux-scsi <linux-scsi@vger.kernel.org>


--=-uXDCSEBTpJssOcsrz6br
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-23 at 20:37 +0000, Steven Williamson wrote:
> Package: linux-2.6
> Severity: important
> Tags: patch
>=20
>=20
> The hpsa driver fails to correctly assign devices when there are
> multiple paths on at least the Smart Array 712m with the latest
> firmware.
>
> The end result is only one device node is created in /dev and multipath
> tools then only detect one path.
>=20
> Applying the patch here:
> http://www.spinics.net/lists/linux-scsi/msg56690.html
> to the current stable version of the squeeze kernel fixes the issue.
>=20
> This was tested on a Smart Array 712m, connected via 2 SAS switches to a
> HP P2000 G3 SAS Array.

This sounds important; why has it not been sent to Linus for 3.3 (and
cc: stable)?

Ben.

--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-uXDCSEBTpJssOcsrz6br
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT0ptnOe/yOyVhhEJAQpKrQ//ZZjgWYYlHny7AU51LXKfMHZ543ksIQUg
YDOZTA38jIW2JIWGEYRofndxCbh5EY43+45ozMxyUnecQdKxQG0wFXp2hD2c0/gG
nBaunHLmhNmB3sveqfL0EwmKVTJHV6Ls4KXgiztgZhY3psne1CmImKK1El5ar1sD
SzBT6MToGx51KAzCuC2I0ybz2/Qw24GXt627tJx6P8yKbE2BgFID6a+V2tjRJjjg
W0BnWm8x/LBC/eHm+ow+kWZD3pC6vSXRH7FxLDAhAvorFo1kXKBhy7vnZDvPIcxE
liihMt4j8j02kyPxp9uZslVPZoMde5CYwE+UOUkf3NGZWzJEDoIu4DkWoylRXD6c
FsyeODSrV/kUIy5kQFjgcDZaEABTNHNhmQm9PL9FCKlidQa5kTmWOlGgTXN9jf7I
FbWb68+M+323ybf9HJN+O8HwEKqusJdZcw9OYBV3Zoc6IaQFXFTCspW8JY/bokDG
jB6XQLG9Rp8VTW4pS7snLyVZrxEKJg3vTrZqO9gLpfAQoeLmpwWaarWGUTiAX1Hv
Clofe2nDYOCH6lGbLKTfIej7gCZLaOVubIllbQkT0GthwdErSZNNaAnw4JjofICm
XIw8g6+cyuRcT7eOK5WyHH5DZXojlHNkLTR1XQeLnWZZBs4OhYMKiEhYSGGeI50H
Pqg4PC41+UY=
=dYlm
-----END PGP SIGNATURE-----

--=-uXDCSEBTpJssOcsrz6br--
