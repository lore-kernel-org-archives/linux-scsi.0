From: Joshua Rubin <joshua@rubixlinux.org>
Subject: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Thu, 17 Aug 2006 18:12:24 -0600
Message-ID: <200608171812.28727.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5213783.hOqEPJCuk3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 70-89-161-115-Joshua-Rubin-co.hfc.comcastbusiness.net ([70.89.161.115]:60651
	"EHLO smokescreen.cybertron.cc") by vger.kernel.org with ESMTP
	id S932245AbWHRANL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 20:13:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 380272@bugs.debian.org
Cc: maximilian attems <maks@sternwelten.at>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

--nextPart5213783.hOqEPJCuk3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Max,

I just realized that I never tried your last suggestions. I will try them=20
first thing when I get in to work tomorrow.

I have received some more info about this bug. It appears to be a timing=20
issue. Here is the link to the bug at kernel.org with an interesting=20
suggestion (that I have not tried):=20
http://bugzilla.kernel.org/show_bug.cgi?id=3D6921.

My company has inherited 5 racks of these compaq servers and it is very=20
important that debian etch work well on them :)

Thanks for all the help,
Joshua Rubin

--nextPart5213783.hOqEPJCuk3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBE5QXskKWMTL7MAq4RAjBIAKCOsmg7GctSCfA9vmCCtXpcmd0BPQCgoYJM
CY3fJ2GleRVv/wmSFgW+yec=
=LWFg
-----END PGP SIGNATURE-----

--nextPart5213783.hOqEPJCuk3--
