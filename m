From: Tilman Schmidt <tilman@imap.cc>
Subject: [2.6.25-rc2] Drivers sd, sr, st, osst need updating - please use
 bus_type methods
Date: Wed, 20 Feb 2008 22:26:51 +0100
Message-ID: <47BC9B1B.3010800@imap.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig085842E8F732FE158B66CF95"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33948 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759405AbYBTV0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 16:26:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig085842E8F732FE158B66CF95
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Finding these in my syslog when testing 2.6.25-rc2{,-mm1} with
CONFIG_ENABLE_WARN_DEPRECATED=3Dy:

<4>[    5.312173] Driver 'sd' needs updating - please use bus_type method=
s

<4>[   20.028800] Driver 'sr' needs updating - please use bus_type method=
s

<6>[   22.849626] st: Version 20080117, fixed bufsize 32768, s/g segs 256=

<4>[   22.849813] Driver 'st' needs updating - please use bus_type method=
s

<6>[   22.930275] osst :I: Tape driver with OnStream support version 0.99=
=2E4
<4>[   22.930278] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede =
Exp $
<4>[   22.930554] Driver 'osst' needs updating - please use bus_type meth=
ods

Just thought I'd let you know.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig085842E8F732FE158B66CF95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvJsbMdB4Whm86/kRAvWhAJwMjuwpsXuIugwA+Awrh1Sy5Ti1qACfew34
SHQV24EhWHpGuUzBi9Dms94=
=ahW2
-----END PGP SIGNATURE-----

--------------enig085842E8F732FE158B66CF95--
