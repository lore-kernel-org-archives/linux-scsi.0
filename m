From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Tue, 28 Sep 2010 11:52:36 -0700
Message-ID: <20100928185236.GF25677@one-eyed-alien.net>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com> <1285668896-6356-2-git-send-email-willy@linux.intel.com> <20100928175122.GE25677@one-eyed-alien.net> <20100928181134.GA17657@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/i8j2F0k9BYX4qLc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:38563
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756820Ab0I1Swl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 14:52:41 -0400
Content-Disposition: inline
In-Reply-To: <20100928181134.GA17657@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com, Matthew Wilcox <matthew.r.wilcox@intel.com>


--/i8j2F0k9BYX4qLc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2010 at 11:11:34AM -0700, Greg KH wrote:
> On Tue, Sep 28, 2010 at 10:51:22AM -0700, Matthew Dharm wrote:
> > On Tue, Sep 28, 2010 at 06:14:56AM -0400, Matthew Wilcox wrote:
> > > From: Matthew Wilcox <matthew.r.wilcox@intel.com>
> > >=20
> > > USB Attached SCSI is a new protocol specified jointly by the SCSI T10
> > > committee and the USB Implementors Forum.
> > >=20
> > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > > ---
> > >  MAINTAINERS                  |    8 +
> > >  drivers/usb/storage/Kconfig  |   13 +
> > >  drivers/usb/storage/Makefile |    1 +
> > >  drivers/usb/storage/uas.c    |  751 ++++++++++++++++++++++++++++++++=
++++++++++
> > >  4 files changed, 773 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/usb/storage/uas.c
> >=20
> > Given that this is distinctly not usb-storage, and it is entirely conta=
ined
> > within a single file, does it really belong in the drivers/usb/storage
> > directory?
> >=20
> > That just seems like a plan for confusion.  The fact that there is a big
> > "this is not usb-storage" message in the comments of uas.c would seem to
> > support this position.
> >=20
> > Given that it is a single file, I would put it in drivers/usb directly.=
  If
> > you wanted your own directory for possible future refactoring into mult=
iple
> > files or addid other files (like usb-storage did to support oddball
> > devices), then maybe create a drivers/usb/uas directory.
>=20
> What about drivers/usb/class/ where a number of other USB class drivers
> live.  That would make more sense, right?

No argument from me.  Heck, maybe someone wants to move usb-storage into
that directory also?

My main point is that it doesn't belong in the same directory as
usb-storage.  There are lots of good alternatives.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--/i8j2F0k9BYX4qLc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFMojl03gL8qCooyc4RAht7AJ9JZhI9kP+PlKGSZXDgqETZ9bIWoACcDLd4
HrGg+AHtd8Ur+dE55FHyKBc=
=gCJQ
-----END PGP SIGNATURE-----

--/i8j2F0k9BYX4qLc--
