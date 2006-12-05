From: "Wesley J. Landaker" <wjl@icecavern.net>
Subject: [SOLVED] Re: Support for (new?) Silicon Image PCI SATA controller
Date: Tue, 5 Dec 2006 15:48:50 -0700
Message-ID: <200612051548.54416.wjl@icecavern.net>
References: <200611081803.52986.wjl@icecavern.net> <20061109234009.GT16952@parisc-linux.org> <200611091659.16002.wjl@icecavern.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart44836930.EB9X6IMpzB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from c-68-54-3-45.hsd1.nm.comcast.net ([68.54.3.45]:2162 "EHLO
	icecavern.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936998AbWLEWsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Dec 2006 17:48:43 -0500
In-Reply-To: <200611091659.16002.wjl@icecavern.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org, Carlos Pardo <Carlos.Pardo@siliconimage.com>

--nextPart44836930.EB9X6IMpzB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 09 November 2006 16:59, Wesley J. Landaker wrote:
> On Thursday 09 November 2006 16:40, Matthew Wilcox wrote:
> > On Fri, Nov 10, 2006 at 08:37:23AM +0900, Tejun Heo wrote:
> > > >00:10.0 Mass storage controller [0180]: Silicon Image, Inc. Unknown
> > > > device [1095:2502] (rev 01)
> > > >        Subsystem: Silicon Image, Inc. Unknown device [1095:2512]
> > >
> > > SIMG says there's no such device and it's probably bad hardware
> > > (probably a 3512) with stuck bits in PCI ID.  If you bought it, ask
> > > for replacement.
> >
> > It could also be a problem with his motherboard.  I'd try it in a
> > different slot (or in a different machine) before returning the card
> > as bad.
>
> Guys, thank you. Your suggestion about a stuck bit sounds reasonable,
> since I couldn't find any indication of any device IDs from SI that
> matched... that's why I originally assumed it was a new device (since the
> hardware is supposedly fairly recent).
>
> I will try this out in a different motherboard slot and if there's no
> luck there see if I can get this card replaced.
>
> Thank for the help, and hopefully I can get it working. =3D)

Just to follow up with this, I got another new SATA card (just in case) and=
=20
had another chance to take down the server in question and try to fix this.=
=20

I did some testing with the other card and other slots and it was definitel=
y=20
the motherboard PCI slot that had problems.=20

A different card in the same slot failed, moving to a different slot with=20
the either card worked immediately. It's now shows up as I would have=20
expected. Whew!

00:0f.0 Mass storage controller [0180]: Silicon Image, Inc. SiI 3512=20
[SATALink/SATARaid] Serial ATA Controller [1095:3512] (rev 01)
        Subsystem: Silicon Image, Inc. SiI 3512 SATALink Controller=20
[1095:3512]

Anyway, thanks everyone for your help.

=2D-=20
Wesley J. Landaker <wjl@icecavern.net> <xmpp:wjl@icecavern.net>
OpenPGP FP: 4135 2A3B 4726 ACC5 9094  0097 F0A9 8A4C 4CD6 E3D2

--nextPart44836930.EB9X6IMpzB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFdfdW8KmKTEzW49IRAuKCAKCVwNuasuhanKt2wPt3A5vS6ALkQACfb8Px
cwwNx0qDQfhPNwOD2fFOcEc=
=sem6
-----END PGP SIGNATURE-----

--nextPart44836930.EB9X6IMpzB--
