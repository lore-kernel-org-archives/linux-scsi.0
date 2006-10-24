From: Phil Dibowitz <phil@ipom.com>
Subject: Re: [linux-usb-devel] Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Tue, 24 Oct 2006 14:43:22 -0700
Message-ID: <453E88FA.3070304@ipom.com>
References: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1DA0A3947BD431849FC69D4E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipom.com ([209.40.128.125]:12007 "EHLO
	uberhacker.sage-inc.com") by vger.kernel.org with ESMTP
	id S1161247AbWJXVn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Oct 2006 17:43:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1DA0A3947BD431849FC69D4E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Alan Stern wrote:
> There's a comment about this in the source code, asking what should be
> done if the INQUIRY response is too short (as it is here).  Maybe the b=
est
> approach would be always to assume the first 36 bytes are valid, even w=
hen
> the device says they aren't.  It ought to solve your problem, and it's
> no worse than what we're doing now.
>=20
> The patch is below.  This replaces the patch I sent earlier.

Perhaps a better approach might be to set the product and vendor to some
specific string if the device says it isn't providing one? In the new mod=
el,
can't we still have the chance of showing garbage if the device really is=
n't
setting anything useful? So what if we show "Unknown" and "Unknown" or
something similar in the event that the device sets the 'invalid' bit?

Just a thought...

--=20
Phil Dibowitz                             phil@ipom.com
Freeware and Technical Pages              Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Be who you are and say what you feel, because those who mind don't matte=
r
and those who matter don't mind."
 - Dr. Seuss



--------------enig1DA0A3947BD431849FC69D4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFPoj6N5XoxaHnMrsRAv5+AKCUMoWTB7PppvDa05DjGsp2fcAlegCgnJ3e
MTFzVzeTTe3lX8Qy3A4IPzk=
=ZY/D
-----END PGP SIGNATURE-----

--------------enig1DA0A3947BD431849FC69D4E--
