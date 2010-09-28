From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Tue, 28 Sep 2010 10:51:22 -0700
Message-ID: <20100928175122.GE25677@one-eyed-alien.net>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com> <1285668896-6356-2-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f61P+fpdnY2FZS1u"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:57653
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310Ab0I1Rv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 13:51:29 -0400
Content-Disposition: inline
In-Reply-To: <1285668896-6356-2-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com, Matthew Wilcox <matthew.r.wilcox@intel.com>


--f61P+fpdnY2FZS1u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2010 at 06:14:56AM -0400, Matthew Wilcox wrote:
> From: Matthew Wilcox <matthew.r.wilcox@intel.com>
>=20
> USB Attached SCSI is a new protocol specified jointly by the SCSI T10
> committee and the USB Implementors Forum.
>=20
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  MAINTAINERS                  |    8 +
>  drivers/usb/storage/Kconfig  |   13 +
>  drivers/usb/storage/Makefile |    1 +
>  drivers/usb/storage/uas.c    |  751 ++++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 773 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/storage/uas.c

Given that this is distinctly not usb-storage, and it is entirely contained
within a single file, does it really belong in the drivers/usb/storage
directory?

That just seems like a plan for confusion.  The fact that there is a big
"this is not usb-storage" message in the comments of uas.c would seem to
support this position.

Given that it is a single file, I would put it in drivers/usb directly.  If
you wanted your own directory for possible future refactoring into multiple
files or addid other files (like usb-storage did to support oddball
devices), then maybe create a drivers/usb/uas directory.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--f61P+fpdnY2FZS1u
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFMoisa3gL8qCooyc4RAgmJAJ9UoBUmg8r6BHHweJXBWjzdxUleVwCbBZZE
7fZzvaY54Yu645v10jRzhC0=
=/Pi8
-----END PGP SIGNATURE-----

--f61P+fpdnY2FZS1u--
