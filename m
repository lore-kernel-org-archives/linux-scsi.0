From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If I try to
 attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Mon, 11 Aug 2008 07:45:53 +0200
Message-ID: <20080811074553.11b06602@mjolnir.drzeus.cx>
References: <bug-11302-10286@http.bugzilla.kernel.org/>
	<20080810135344.6f900129.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-17549-1218433558-0001-2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server.drzeus.cx ([85.8.24.28]:44538 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750786AbYHKFqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2008 01:46:04 -0400
In-Reply-To: <20080810135344.6f900129.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, pinc_o@yahoo.it

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-17549-1218433558-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Aug 2008 13:53:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

>=20
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>=20
> On Sun, 10 Aug 2008 13:45:49 -0700 (PDT) bugme-daemon@bugzilla.kernel.org=
 wrote:
>=20
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D11302
> >=20
> >            Summary: I get a kernel OOPS! If I try to attach an usb card
> >                     reader, SD, MMC, ecc.. to my Slamd64
> >            Product: IO/Storage
> >            Version: 2.5
> >      KernelVersion: 2.6.26.2
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: blocking
> >           Priority: P1
> >          Component: SCSI
> >         AssignedTo: linux-scsi@vger.kernel.org
> >         ReportedBy: pinc_o@yahoo.it
>=20
> Is this a scsi regresion, or an mmc regression?
>=20

There are no USB based "real" MMC controllers, so I'd say SCSI.

> > If attach my usb card reader, without load mmc_block an mmc_core module=
s, then
> > the follow OOPS appear(If first load them, simply doesn't mount the SD.=
 Please
> > note: I always use "automatic loading kernel modules" compiled in "my" =
kernelS.
> > But from many time, the recent kernelS not load the mmc_block module):

I don't know what kind of weird ass scripts loaded them for USB mass
storage to begin with. As for the claimed lack of crashes when loaded;
no idea as there is no interaction between the SCSI and MMC layer.

> > Modules linked in: nvidia(P) [last unloaded: nvidia]

This is always a good start..

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-17549-1218433558-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkif0hQACgkQ7b8eESbyJLj4gACfQSqfgeB9f3t682xwZiTCNQFf
rrwAoIo/EO+EYl0X8ON+r4IfwFfzFBvg
=4LF9
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-17549-1218433558-0001-2--
