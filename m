From: Thomas Schwinge <thomas@codesourcery.com>
Subject: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Sat, 16 Jun 2012 12:14:14 +0200
Message-ID: <87obojef7t.fsf@schwinge.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58024 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2FPKOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jun 2012 06:14:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!

After many others that played with no problems, I just tried playing
Guano Apes' audio CD =C2=BBProud Like a God=C2=AB (1997) in Rhythmbox, on m=
y mostly
up-to-date Debian GNU/Linux testing system.

    $ uname -a
    Linux boole 3.2.0-2-amd64 #1 SMP Mon May 21 17:45:41 UTC 2012 x86_64 GN=
U/Linux

... which specifically is =C2=BBlinux-image-3.2.0-2-amd64 3.2.18-1=C2=AB.

While "loading" the CD in Rhythmbox, after a few seconds the kernel
crashed.  I rebooted, tried again, and it crashed again.  At
<http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd.jpeg> you
can find the panic message (low resolution, sorry), pointing to the
SCSI/ATA code.

Are there any such known issues?  Does the panic message give any clue
already, or would you want me to reproduce that with debugging symbols,
etc.?


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJP3Fx2AAoJENuKOtuXzphJoCQH/RhfqvncKRtjyUuVnV2W1x28
hBrsJ8DiDw6VswQlgo1XpkH49A2MqwVvumBC00xshTw6Gbs/SXhC4BKsNx/aiI2M
yiTIaeR5Z0TSsrmGHTGUuc09XFlxH13sKp85Q0QBSw+A/2dfYLuqWSb4icdXT0Y0
inD9gg20BA3ziO2CxkYXu6kFVJkEKYocf/1OESn0E6Xr1M1VuXvWKqeRk4lhkw8E
ClIvxN+uamGQrMGHF0OWEd934s37dosP27swteL4QdRusDvnFSJmZhVYqhsNzRA8
ZzXIiWN6BQEMd0bs1c+5+3kpydnAbTU5vYzjduBJKuTPxSbocbSTUwXM2XZ/Bjs=
=zc66
-----END PGP SIGNATURE-----
--=-=-=--
