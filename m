From: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Subject: Re: Usb storage mounting was broken
	somewhere	between	2.6.0-test5-bk10 and 2.6.0-test6-bk1
Date: Wed, 22 Oct 2003 20:03:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066845819.2806.11.camel@m70.net81-64-235.noos.fr>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
	 <20031021175556.A8670@beaverton.ibm.com>
	 <1066808944.3699.9.camel@ulysse.olympe.o2t> <3F969E04.6060801@pacbell.net>
	 <1066837537.6960.3.camel@ulysse.olympe.o2t> <3F96AE64.5020305@pacbell.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XQxIE49TCraUSkTe1kX9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nan-smtp-06.noos.net ([212.198.2.75]:59007 "EHLO smtp.noos.fr")
	by vger.kernel.org with ESMTP id S263151AbTJVSDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 14:03:42 -0400
In-Reply-To: <3F96AE64.5020305@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org


--=-XQxIE49TCraUSkTe1kX9
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mer 22/10/2003 =E0 18:20, David Brownell a =E9crit :
> Nicolas Mailhot wrote:
>=20
> >>So I closed that bug report.  If you come up with any
> >>evidence to support a real bug report, file a new bug
> >>report with it.  But having this one sitting around
> >>in such a state does nobody any good.
> >=20
> >=20
> > Rhaa. There is no evidence of a failure. The reader is plugged like in
> > previous kernels, logs show it's detected as a usb-storage device, then
> > *nothing*.
>=20
> Not according to any information you included in the bug report,
> after several weeks of waiting for clarifications...
>=20
> Maybe you thought you'd included that information, but it's
> not there.  The only "logs show ..." information you included
> was for cases where everything worked (test5).

The not-working case logs were put in comment #4 not in attachements
because there were very short (ie the device name showed up and the
kernel did nothing with it). The only reason the working case was put in
attachement is there were too many activity messages to include it
inline.

I've redone the tests with 2.6.0-test8-bk2-exec-shield-G4.
The results are exactly the same device name echoed by usb-storage then
nothing.

The only weird thing is some messages made it to /var/log/messages,
/var/log/kernel and show up with dmesg, but didn't end up in
/var/log/dmesg (which is what I used as attachement before, but the
other messages were extracted from /var/log/kernel and put in the bug
too). I suppose RedHat stops writing in /var/log/dmesg after the end of
the boot.

To make clear I didn't cut some messages after the device detection I
included the date at which the files were copied.

I'm sorry about the communication failure - you asked for info already
in the report and I didn't realise you didn't see it.

--=20
Nicolas Mailhot

--=-XQxIE49TCraUSkTe1kX9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/lsZ7I2bVKDsp8g0RAljMAJ49JTst+PpJKCbqvYG0Z2RTJIE9NwCfVKHn
iNcIWJylzTW0AE3yAAGfJRg=
=r+qd
-----END PGP SIGNATURE-----

--=-XQxIE49TCraUSkTe1kX9--

