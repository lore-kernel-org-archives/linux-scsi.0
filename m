From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Tue, 09 Feb 2016 17:47:00 +0100
Message-ID: <1455036420.11996.5.camel@giantmonkey.de>
References: <1453222373.3588.3.camel@giantmonkey.de>
	 <Pine.LNX.4.44L0.1601191532210.1312-200000@iolanthe.rowland.org>
	 <CAM79t8GJvQPzOt1oDikxv3wPZ9xgVMez5EUgXmeVH2zKJCeaAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-GCYCE4FQiVBiYD78CAyB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36655 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbcBIQrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 11:47:20 -0500
Received: by mail-wm0-f46.google.com with SMTP id p63so166795293wmp.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Feb 2016 08:47:19 -0800 (PST)
In-Reply-To: <CAM79t8GJvQPzOt1oDikxv3wPZ9xgVMez5EUgXmeVH2zKJCeaAw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexandre Rossi <alexandre.rossi@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org


--=-GCYCE4FQiVBiYD78CAyB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Debian and Linux folks,


Am Mittwoch, den 20.01.2016, 23:07 +0100 schrieb Alexandre Rossi:

> >> Could you please attach the debugging patch. Hopefully Alexandre, Eric=
h,
> >> or I will have some spare time to build an image from it.
> >
> > Actually, this patch is an attempt at a fix.  After looking more
> > carefully at your log pictures, I realized what the problem must be.
> >
> > It's too bad nobody was able to capture a log where the error
> > occurred in sr_runtime_suspend, though -- all the logs in the bug
> > report show sd_runtime_resume.
>=20
> I just tested the patch applied on top of 4.3.3 (4.3.3-6 in Debian).
>=20
> It still crashes at boot, but the stacktrace is different : it happens
> in blk_post_runtime_resume . Maybe I'm bit by a different bug or maybe
> the I need to try with 4.4.
>=20
> I'll post the captured log when I have access to a wired network. I'd
> be happy to provide the logs of a debugging patch.

I tried Linux 4.3.5-1 [1], which entered Debian Sid/unstable yesterday,
and I get the same null pointer dereference as Alexandre.

As this is Linux 4.3 and not 4.4, I guess this is a different problem
though. Alexandre, where you able to capture the stack trace? I=E2=80=99d s=
ubmit
a new bug report with this.


Thanks,

Paul


[1] http://metadata.ftp-master.debian.org/changelogs/main/l/linux/linux_4.3=
.5-1_changelog
--=20
GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-GCYCE4FQiVBiYD78CAyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWuhgUAAoJEE3Xv3UzYj6bDdQP/iL9rLNkrRu1coCOKVWEeXX4
+UqhYBPTFvfYcBam3ixTCYY2vDYfBClPW7oWiJjadkBEcMKuZZavHFnR2qc7F73u
dqxHondhCx1ByH7A0FI0zSb+b30uOMVF/fD/LDE4uyIbV7xqyq9i5LvatuWKBGIP
/gwaI423Zh0gnc8W8Z25Up00VbClXoAbUg3kp79gPqohT3Y3I5TkXsQeCZxlOEwC
byw5PtPnubZtk8chUSAegN64QejhRXLQzVi5OwTJb/9J046yZq51GQ4AScOAuO84
VJlY5V7yGiwo/3iluYYHu6hRGDT7vQ7XGTJgCvMZDvLG5Zz1z6q4UR9lMyb1wMde
cuSGb1pZWk5QUyvqUi38HWyAKLf2XD3qrpxUx+0vzAIzuCd5EZ9HOVpIb8P6FNJY
lB3DBz4uO/Ex4E35l3uVpadbBvh7ohoRViaePFCxqb2bYzYrfvRHqfcZzNA1S9pA
QJoOoQ/vljcvJc+HQT3KdkGkGQpUDW7JugbIyovd4b0s3Px3bTHU9/3/Q0nP9ZwL
mSM+ki0y9qVW2xco/JkAzSrlumHOw6G/jr/rf7XHjmq0PdB5+RFDY+n4bxljPlFp
i+VVowI7mmqOmZvhEHi6LeoosRsUR8HqD9Q++7J4XeU+tcd7kvhf4S7tWRLGihq0
A7qKRE0m8ePlTD+Ci3TR
=uVYV
-----END PGP SIGNATURE-----

--=-GCYCE4FQiVBiYD78CAyB--

