From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [BUG] "block: make generic_make_request handle arbitrarily sized bios" breaks boot on parisc-linux
Date: Thu, 10 Mar 2016 08:04:51 +0100
Message-ID: <4070811.QJ02MzEnrO@caliban.sf-tec.de>
References: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net> <56E03E2A.5020208@bell.net> <56E093B6.4040206@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2709909.azQZ8q3AFL"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <56E093B6.4040206@gmx.de>
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: John David Anglin <dave.anglin@bell.net>, Ming Lei <tom.leiming@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-parisc List <linux-parisc@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

--nextPart2709909.azQZ8q3AFL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

> Right.
> I just succeeded in reproducing the bug with moving blk_bio_segment_split()
> into an own file (and with "extern" instead of "static" in blk-merge.c).
> When compiled with -O2 it still crashes. So, next step is to analyze what
> gcc does wrong when compiling this function. It should get easier now to
> find the reason, since we have a smaller reproducer now.

I have a ton of compilers here on my C8000 and a few even on my C3600 which 
drive nightly CMake dashboards. Could you send the testcase so I can pass it 
through the list and see what breaks?

Greetings,

Eike
--nextPart2709909.azQZ8q3AFL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlbhHJkACgkQXKSJPmm5/E7HNACfRi2PViWGjXY+EeBNwwR1fe1m
Bv4AnjzQq/DCYQipxboH8Bd5Ahr0rnTo
=LsIb
-----END PGP SIGNATURE-----

--nextPart2709909.azQZ8q3AFL--

