From: Thomas Schwinge <thomas@codesourcery.com>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Mon, 18 Jun 2012 07:29:43 +0200
Message-ID: <87bokhdw6w.fsf@schwinge.name>
References: <87obojef7t.fsf@schwinge.name> <1339854034.4942.176.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1339854034.4942.176.camel@deadeye.wl.decadent.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!

On Sat, 16 Jun 2012 14:40:34 +0100, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> On Sat, 2012-06-16 at 12:14 +0200, Thomas Schwinge wrote:
> > After many others that played with no problems, I just tried playing
> > Guano Apes' audio CD =C2=BBProud Like a God=C2=AB (1997) in Rhythmbox, =
on my mostly
> > up-to-date Debian GNU/Linux testing system.
> >=20
> >     $ uname -a
> >     Linux boole 3.2.0-2-amd64 #1 SMP Mon May 21 17:45:41 UTC 2012 x86_6=
4 GNU/Linux
> >=20
> > ... which specifically is =C2=BBlinux-image-3.2.0-2-amd64 3.2.18-1=C2=
=AB.
> >=20
> > While "loading" the CD in Rhythmbox, after a few seconds the kernel
> > crashed.  I rebooted, tried again, and it crashed again.  At
> > <http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd.jpeg> you
> > can find the panic message (low resolution, sorry), pointing to the
> > SCSI/ATA code.
> >=20
> > Are there any such known issues?  Does the panic message give any clue
> > already, or would you want me to reproduce that with debugging symbols,
> > etc.?
>=20
> Your computer is broken; Machine Check Exception indicates a hardware
> fault.

Hmm, I see, thanks.  Nothing the kernel could do to catch that, I
suppose?  (Scary that simply putting a regular audio CD into the drive
can crash the kernel.)

> The other text at the top of the screen may help to identify
> which component is at fault.


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJP3rzHAAoJENuKOtuXzphJXJwH/Azofxu5sQr1+1aS/C/JueP3
UjGlBE21jA1AfnObL3u7o5W8FtZvbTuHG9Gdn1TjKuP/qrakR9h0atB+71ilk9St
cgQPPcu10KmwGdZAcgxyG7Wf/NCFXuG+8UtFV23RjFccEYgbntQxTY5q9L5z9kLt
m53tL7uejtleiydwGWBoy6BGs/OYNBVRga/0aI0pg84CrTN+4bEuYvTDiKyHUdVR
7S1knw50fMURC5MQW4IxaFVRWTmS5NidDVRrUv+8wexu4yUMKAznb10B4XZfFslF
VjCnRMM37Uq7y61laHzkl8tXA0DckfLDRwnC7IWcubUI58iHLXuaBdl0ibWQkYY=
=W1jX
-----END PGP SIGNATURE-----
--=-=-=--
