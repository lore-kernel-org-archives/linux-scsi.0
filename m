From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Fri, 25 Apr 2008 08:35:52 -0700
Message-ID: <20080425153552.GA20918@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com> <20080424233048.GQ16272@one-eyed-alien.net> <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI> <20080425070439.GA18915@one-eyed-alien.net> <Pine.LNX.4.64.0804251116000.758@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762188AbYDYPgc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804251116000.758@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2008 at 11:19:02AM +0300, Pekka J Enberg wrote:
> Hi Matthew,
>=20
> On Thu, 24 Apr 2008, Matthew Dharm wrote:
> > > > This also has all sorts of races between do_mounts 'waiting' and th=
e actual
> > > > USB device enumeration.  It's entirely possible that the kernel loa=
ds via
> > > > BIOS, the USB drivers are loaded, that forces devices to disconnect=
/reset,
> > > > and they take a while to re-enumerate.  During that delay, the kern=
el gets
> > > > to do_mount; now, no devices show in this "waiting for scan" count.
>=20
> On Fri, Apr 25, 2008 at 09:30:52AM +0300, Pekka J Enberg wrote:
> > > So how does that happen? ->storage_probe fails and driver core calls =
it=20
> > > later at some point?
>=20
> On Fri, 25 Apr 2008, Matthew Dharm wrote:
> > There's no guarantee that storage_probe is going to get called in a tim=
ely
> > manner.
>=20
> How can we add such a guarantee? Don't we have this problem with any othe=
r=20
> storage devices?

I doubt it.  It all depends on exactly when the USB controller initializes,
all relevant hubs get initialized, and the device finally discovered.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I don't have a left mouse button.  I only have one mouse and it's on my rig=
ht.
					-- Customer
User Friendly, 2/13/1999

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEfpYHL9iwnUZqnkRAtbxAJ97o1foUv6LdPPcqOW8uHG6LTTAcQCfWDhu
k5eZkJVM2mP0Vr/JCYTFpQI=
=9eLJ
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
