From: Paul Wagland <paul@wagland.net>
Subject: Megaraid and Linux 2.6 questions
Date: Mon, 05 Apr 2004 23:24:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081200277.1682.32.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OZUe2nsCnW1NMA4q0bf6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out4.xs4all.nl ([194.109.24.5]:43277 "EHLO
	smtp-out4.xs4all.nl") by vger.kernel.org with ESMTP id S263346AbUDEVYt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 17:24:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: Atul Mukker <atulm@lsil.com>


--=-OZUe2nsCnW1NMA4q0bf6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

One question, one problem:

question: What is the current status of the unified driver for 2.6?

problem: When using dellmgr v 5.31 to delete a logical drive on my
SATA-150-6 board under linux 2.6.4, the controller seems to hang. I can
continue to do stuff, so long as I don't want to touch that controller.
As this is my only IO controller that is a little tricky :-) Has thyis
problem been seen before? Is there a known workaround?

Cheers,
Paul

--=-OZUe2nsCnW1NMA4q0bf6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAcc6Vtch0EvEFvxURAnnTAJ9YcqRnDB8Yk8fMCZbbmVbXy3im+wCfX8EZ
NKChbFoitKma+MdRO1tDrsY=
=xwCb
-----END PGP SIGNATURE-----

--=-OZUe2nsCnW1NMA4q0bf6--

