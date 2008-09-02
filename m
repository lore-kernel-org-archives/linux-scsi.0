From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: WAS: "Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If
 I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64"
Date: Tue, 2 Sep 2008 08:03:16 +0200
Message-ID: <20080902080316.0167b47f@mjolnir.drzeus.cx>
References: <20080810233352.8423614f.akpm@linux-foundation.org>
	<8635.97645.qm@web27302.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-13404-1220335402-0001-2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server.drzeus.cx ([85.8.24.28]:40818 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751818AbYIBGDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 02:03:24 -0400
In-Reply-To: <8635.97645.qm@web27302.mail.ukl.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pinc_o@yahoo.it
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-13404-1220335402-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Sep 2008 23:30:56 +0000 (GMT)
pinco pallino <pinc_o@yahoo.it> wrote:

> Hi Andrew,
>=20
> with the new kernel 2.6.26.3 the SD are now read and wrote correctly, but=
 SDHC are not read! The kernel repeat the error. Follow the error:
>=20

Have you checked that the reader does in fact support SDHC? They tend
to fail in all sorts of ways when they don't.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-13404-1220335402-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAki81ycACgkQ7b8eESbyJLi6vQCgolJCW5bQ/iqXsi2MIZ0ajn1J
UPgAn0Ut+G9A3bfSCbDsg8J/aOm88NXi
=YQ94
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-13404-1220335402-0001-2--
