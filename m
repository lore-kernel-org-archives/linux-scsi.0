From: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Subject: Re: Usb storage mounting was broken
Date: Wed, 22 Oct 2003 22:33:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066854786.3848.8.camel@m70.net81-64-235.noos.fr>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
	 <20031021175556.A8670@beaverton.ibm.com>
	 <1066808944.3699.9.camel@ulysse.olympe.o2t> <3F969E04.6060801@pacbell.net>
	 <1066837537.6960.3.camel@ulysse.olympe.o2t> <3F96AE64.5020305@pacbell.net>
	 <1066845819.2806.11.camel@m70.net81-64-235.noos.fr>
	 <3F96D00E.1080500@pacbell.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yRf4ARbbcz4WZ+uYKBy1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nan-smtp-02.noos.net ([212.198.2.71]:1558 "EHLO smtp.noos.fr")
	by vger.kernel.org with ESMTP id S261406AbTJVUhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 16:37:41 -0400
In-Reply-To: <3F96D00E.1080500@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org


--=-yRf4ARbbcz4WZ+uYKBy1
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mer 22/10/2003 =E0 20:44, David Brownell a =E9crit :
> > The only weird thing is some messages made it to /var/log/messages,
> > /var/log/kernel and show up with dmesg, but didn't end up in
> > /var/log/dmesg (which is what I used as attachement before, but the
> > other messages were extracted from /var/log/kernel and put in the bug
> > too). I suppose RedHat stops writing in /var/log/dmesg after the end of
> > the boot.
>=20
> As a rule, "dmesg output" means "output of dmesg command" ... :)

Well, the acpi people for example need /var/log/dmesg since their stuff
happens early and the log buffer will often overflow:)

> Boot messages (/var/log/dmesg) aren't a substitute.
>=20
> OK, at this point what's needed is the more customary usb debug
> information.  Contents of /proc/bus/usb/devices for starters.

In the bugzilla report

> And since this resembles an enumeration failure, it'd be good
> to have the Alt-Sysrq-t output for "khubd".

In the report too (took me some time to remember it ended up in
/var/log/messages, not only the current console)

> And does this happen if you try this with, say, OHCI not EHCI?

I haven't used OHCI for months - all my usb1 devices are plugged in an
external usb2 hub, so I don't even build OHCI as module in my own
kernels. Do you really want me to try it ? Because if it fails I won't
be able to tell you if it ever worked for me this year.

One less usb driver makes tester life easier:)

Cheers,

--=20
Nicolas Mailhot

--=-yRf4ARbbcz4WZ+uYKBy1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/lumBI2bVKDsp8g0RAhRIAJ9jwrgUgMQe9pJrVvaP4IZgqkVDbwCeMmwC
voFOw7UfVczE67CdjWYc5AQ=
=8wDe
-----END PGP SIGNATURE-----

--=-yRf4ARbbcz4WZ+uYKBy1--

