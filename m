From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 5 Nov 2004 10:06:11 -0800
Message-ID: <20041105180611.GA23104@one-eyed-alien.net>
References: <41765CD1.8060108@adaptec.com> <Pine.LNX.4.44L0.0411051059540.834-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:26533 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261418AbUKESGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 13:06:15 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0411051059540.834-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 05, 2004 at 11:18:34AM -0500, Alan Stern wrote:
> On the other hand, the adjustment of the READ CAPACITY value should still=
=20
> be moved to sd.c from usb-storage.  This can be implemented easily enough=
=20
> by adding a bitflag to the scsi_device structure; the flag could be set=
=20
> either by a SCSI blist entry or by usb-storage in its slave_configure=20
> routine.  The flag would tell sd_read_capacity to decrement the number of=
=20
> sectors it receives from the device.

If I read this right, you're saying we should flag the device, but not
actually tweak the READ_CAPACITY data?  In other words we get rid of the
code which tries to munge the data in-flight?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBi8ETIjReC7bSPZARAoxgAKCjTuriy/awGYPVkELetgtoYiURUACdH1zB
g9THOQ5/U5IpRcOQe5ytfDw=
=JOWN
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
