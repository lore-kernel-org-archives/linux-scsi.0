From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 10:30:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014103059.C9725@one-eyed-alien.net>
References: <andersen@codepoet.org> <200210141557.g9EFvLw02517@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210141557.g9EFvLw02517@localhost.localdomain>; from James.Bottomley@steeleye.com on Mon, Oct 14, 2002 at 08:57:21AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: andersen@codepoet.org, linux-scsi@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2002 at 08:57:21AM -0700, James Bottomley wrote:
> andersen@codepoet.org said:
> > Anyone have any objections to such a patch?  For 2.4.x?  Comments?
>=20
> The patch looks fine per se.
>=20
> However, I thought that the whole spirit of hotplug was that this type of=
=20
> problem should be solved in user space to which SCSI currently exposes a=
=20
> perfectly adequate interface.

Yes and no, I think.

While I think much of hotplug should exist in userspace, some of it must
exist in the kernel.

sbp2 and usb-storage get devices attaching and detaching all the time.  The
SCSI core needs to be able to handle that in the kernel.

In userspace, something should get a new device notification and decide
what to do with the new device. Format?  Mount?  Ignore?  But, it needs a
/dev node to be able to handle the device, therefore the kernel must do the
work up to that point.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We've made a business out of making money from annoying and stupid people.
I think you fall under that category.
					-- Chief
User Friendly, 7/11/1998

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qv9TIjReC7bSPZARAoHiAJ9UHzWn5vRJZJrH924NLCoaQBchkACeMP8X
Tnx0tI30rEdIJxAm1nZfF7o=
=u4J/
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
