From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Fri, 25 Apr 2008 00:04:39 -0700
Message-ID: <20080425070439.GA18915@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com> <20080424233048.GQ16272@one-eyed-alien.net> <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:36916
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYDYHE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 03:04:58 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2008 at 09:30:52AM +0300, Pekka J Enberg wrote:
> On Thu, 24 Apr 2008, Matthew Dharm wrote:
> > This also has all sorts of races between do_mounts 'waiting' and the ac=
tual
> > USB device enumeration.  It's entirely possible that the kernel loads v=
ia
> > BIOS, the USB drivers are loaded, that forces devices to disconnect/res=
et,
> > and they take a while to re-enumerate.  During that delay, the kernel g=
ets
> > to do_mount; now, no devices show in this "waiting for scan" count.
>=20
> So how does that happen? ->storage_probe fails and driver core calls it=
=20
> later at some point?

There's no guarantee that storage_probe is going to get called in a timely
manner.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--DocE+STaALJfprDB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEYKHHL9iwnUZqnkRAr4lAJ99ziHd+inhTXYC2kwX0VxN4gvMpwCfWZQC
pvQdqtMklB7t0FbGBv2dtJQ=
=WNEb
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
