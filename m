From: Erik Mouw <mouw@nl.linux.org>
Subject: Re: In which case EWOULDBLOCK is set while a write operation
Date: Wed, 19 Dec 2007 18:13:26 +0100
Message-ID: <20071219171326.GC15327@gateway.home>
References: <200712180553.lBI5rQgD004427@arlmail.patni.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4394 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXLSR0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 12:26:43 -0500
Content-Disposition: inline
In-Reply-To: <200712180553.lBI5rQgD004427@arlmail.patni.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saquib Imam <saquib.imam@patni.com>
Cc: linux-scsi@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 18, 2007 at 11:27:49AM +0530, Saquib Imam wrote:
> In which case EWOULDBLOCK / EAGAIN is set while a write operation ?

=46rom write(2):

ERRORS
       EAGAIN Non-blocking  I/O  has  been  selected  using O_NONBLOCK and =
the
              write would block.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHaVE2/PlVHJtIto0RArPWAJ9bodofGhlrEPRUnoHj5GmJh0VhlwCcDuqa
6pyyGswXMP4k+JIB2Q4LJlI=
=mR8P
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
