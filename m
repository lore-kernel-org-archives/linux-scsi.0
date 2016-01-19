From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Wed, 20 Jan 2016 00:20:27 +0100
Message-ID: <1453245627.1947.3.camel@giantmonkey.de>
References: <Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-EuNzQCAJ8+bC7EHGw1Hn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33792 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASXUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 18:20:41 -0500
Received: by mail-wm0-f51.google.com with SMTP id u188so163558605wmu.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2016 15:20:40 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Alexandre Rossi <alexandre.rossi@gmail.com>


--=-EuNzQCAJ8+bC7EHGw1Hn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Alan,


Am Dienstag, den 19.01.2016, 16:08 -0500 schrieb Alan Stern:
> On Tue, 19 Jan 2016, Paul Menzel wrote:
>
> > Could you please attach the debugging patch. Hopefully Alexandre, Erich=
,
> > or I will have some spare time to build an image from it.
>=20
> Actually, this patch is an attempt at a fix.  After looking more=20
> carefully at your log pictures, I realized what the problem must be. =20

that indeed fixed it for me. I applied your patch on
linux-image-4.4.0-rc8-686 [1] and was able to get to the LUKS passphrase
dialog. Awesome! Thank you very, very much!

[=E2=80=A6]


Thanks,

Paul


[1] https://packages.debian.org/experimental/linux-image-4.4.0-rc8-686
--=20
GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-EuNzQCAJ8+bC7EHGw1Hn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWnsTEAAoJEE3Xv3UzYj6bqvEP/jJuwEBe6aaXQgox1+uOcXXH
qd1V9h0k7G10L13oBlhwV3bQgxZPXSQRy/S7zOArZmFsDpBYTiDNNyJyEe3LfEo/
ZMBaq7bvdo2+bzcJa5Q6smDbY1A76sIaH5qS/s0hd+w+MvBEe5Mcf45xV2OJpuKc
9wA1uab+yYu8FtH+W7CucZxUEybnHDIk5LmK7C4x8cbldMaal9+KjO2VuIR6F8Vz
Cb78kPI9KULgUhjnf/FkXT562b6Kntg6eDtDnzOGdoRDmMpcwqlBbI4URbaERi3M
Z2OW/KSZjSqHZs34MG5CnjjUJt70ntDkOuRet1lqbCcA9ySYaPApNq3wO9wHvA65
Xt/Cyc2utng3Gy4KFZvp3OiUxyX3jRBB/CjXngmwHFu5+yyf7EWWrkCckzeW88Nh
9few8XlnKZ/e/ju79k/asycI4+aLilVL43dLKsf/eciXCS2OBLmxGZwt8p90WoR0
Ghhp6LWZ3fTHeAbnKwz3jqA5oC4dvA39aiXWHnN/bcTuxWTZ8Sr/BIrqHyxGmdM7
Dzxe5Tn+Frt3OPBGPbBVaiG/Hi3nZ9q/DxrKFRmG68wosjoXiqAskKSlqkdvKKCz
9bMBZY7FMnfp59vigt00lPlXE2vgG3zVhI77XtgF6JE5dS+1CzBUNyYNg0MtLuhS
3CTcF4dQVH3wCJKNCEzg
=PN3V
-----END PGP SIGNATURE-----

--=-EuNzQCAJ8+bC7EHGw1Hn--

