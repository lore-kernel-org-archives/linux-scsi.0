From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 18:35:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123183541.H12788@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301231919.40422.oliver@neukum.name> <3E30538F.4080507@mvista.com> <200301240107.36977.oliver@neukum.name> <3E308EE1.9080208@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="Rn7IEEq3VEzCw+ji"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E308EE1.9080208@mvista.com>; from sdake@mvista.com on Thu, Jan 23, 2003 at 05:54:57PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--Rn7IEEq3VEzCw+ji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2003 at 05:54:57PM -0700, Steven Dake wrote:
> >I want:
> >LLDD to SCSI: device is gone
> >SCSI to LLDD: Ok. I'll handle from here on.
> >LLDD: OK. I am gone. And won't have any contact until the next device is
> >plugged in.
> > =20
> >
> The downside of this approach is that the LLDD must now be able to=20
> detect insertions and removals when it may not be able to do so.  If it=
=20
> is able to do so, then fine, it can tell upper layers about it, but the=
=20
> actual control of removal of a device should occur higher up to fix=20
> several problems with the approach of having the LLDD manage the hotswap=
=20
> state of the device.

Huh?

Aren't we talking about a hotplug scenario?  How can you talk about the
'LLDD must now be able to detect... when it may not be able to do so.'?

Oh... I see.  We keep talking about devices.  I'm trying to hotswap an
entire host, which is mapped to a single USB device.

But the theory is the same, really.

In the end, you can only hotswap something that is hotswapable.  That means
that the driver has to support the hotswap system, whatever it is.

If you can't support hotswap detection, then this entire scenario is
reduced to 'what happens if I blow a FET on my HD', because it's the exact
same thing.  Recovering from fatal error is a separate discussion.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--Rn7IEEq3VEzCw+ji
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+MKZ9IjReC7bSPZARArNgAJ9myf/C7uS2p7Lo4NNnkfvXIxfWOACgs5Cb
aWoSu7DDwGHuxbiBjSBlmng=
=Uwd0
-----END PGP SIGNATURE-----

--Rn7IEEq3VEzCw+ji--
