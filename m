From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Sat, 09 Jan 2016 16:23:52 +0100
Message-ID: <1452353032.1150.4.camel@giantmonkey.de>
References: <Pine.LNX.4.44L0.1510312200080.24212-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kzBWl48RJQRF63AkQ9ar"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36873 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbcAIPYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2016 10:24:20 -0500
Received: by mail-wm0-f41.google.com with SMTP id f206so210581372wmf.0
        for <linux-scsi@vger.kernel.org>; Sat, 09 Jan 2016 07:24:19 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1510312200080.24212-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ben Hutchings <ben@decadent.org.uk>, "James E. J. Bottomley" <JBottomley@odin.com>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Erich Schubert <erich@debian.org>, Alexandre Rossi <alexandre.rossi@gmail.com>


--=-kzBWl48RJQRF63AkQ9ar
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Version: 4.4~rc8-1~exp1

Dear Alan,


Thank you for your help!

There were some follow-ups to the bug report [1], but I think you and I
were not in CC.

Am Samstag, den 31.10.2015, 22:05 -0400 schrieb Alan Stern:
> On Sat, 31 Oct 2015, Alan Stern wrote:
>=20
> > I believe the problem shown in that photo was fixed by commit
> > 49718f0fb8c9 ("SCSI: Fix NULL pointer dereference in runtime PM"),
> > which was merged in 4.2 and has been back-ported to various stable=20
> > releases.
>=20
> On second thought, it seems more likely that this issue probably was
> _caused_ by that commit.  The fix can be found in these two emails:
>=20
> 	http://marc.info/?l=3Dlinux-scsi&m=3D144185206825609&w=3D2
> 	http://marc.info/?l=3Dlinux-scsi&m=3D144185208525611&w=3D2
>=20
> which have not been merged yet as far as I know even though they were
> submitted back in September.

I can only say, that I am still unable to boot my system with Linux
4.4-rc8 [2]. Are these patches included there?


Thanks,

Paul


[1] https://bugs.debian.org/801925
[2] https://packages.debian.org/experimental/linux-image-4.4.0-rc8-686-pae-=
dbg
--=20
GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-kzBWl48RJQRF63AkQ9ar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWkSYfAAoJEE3Xv3UzYj6b3ZwP/j0cVbDgqTlV5i14qjtLa6yU
WxG3V1rB+14UwzRgJF/T0T1t6c7GDUZ8CYGqko/ftOurlC3skJRQIePh5Ft3nQqu
UZZ/s6LNi8lIiB4UIczSvRK6xG6MJo59E3owSAm+TH3iR4D3AQQG4OYT5DsWHsW0
+Lq+2LGYgD1HkTv3dtomdRoWYtixgBZyDYHVm14tl0GnNT5f36c5OYCJBagTvCd0
GnvdO3AL9ueIn8z61TVpuIdvWlY5KQKfi55lGcb94rRWS168d2+EFQDoFKgCiPKR
dynnr4UNKijvcAUgNWOjIpgUAQprEBa6KXjR7cCSNiRBMcVO6Pt0IbKDpEBkImBQ
XRVQZBP0YQCrcLZcjH/8Fd5q8IarXWi3bv1NEIOZ5T3qBtWytshJlap2ZIyqXEad
aTg1M81lPRYGt+OUs6b0yINjTmk9n8PWRnWg6rbkaj9xDiB4e5wHQa9CDZvsQNFA
7MUh9GDoi2kCdXEeB3FfTkYqTFMh/ebGEm+ywlzR2EF5sfWAWclqJD7ue9OwI9k4
0M1FnTjgErm59oIzQvjruDktnn7hy8omFQnIpa649mW5HIEmdKV1r3tFUBbGb7Z0
XU8qJu7EXbuTkI5B3vzJopRwo0odgFHSKVzMIBOOmdrxN7wHWjYqGXQ+Z54HSvWK
x4pblMDgb6/JcjHf5Szj
=kp1N
-----END PGP SIGNATURE-----

--=-kzBWl48RJQRF63AkQ9ar--

