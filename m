From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH 09/24] libata-scsi: convert to use the data buffer accessors
Date: Tue, 11 Sep 2007 18:40:46 -0700
Message-ID: <20070912014046.GB14439@one-eyed-alien.net>
References: <46E6F92D.2090409@panasas.com> <46E72B8D.1080508@panasas.com> <46E72E4F.9020508@garzik.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:39687
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764075AbXILBmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Sep 2007 21:42:03 -0400
Content-Disposition: inline
In-Reply-To: <46E72E4F.9020508@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2007 at 08:09:51PM -0400, Jeff Garzik wrote:
> I would much rather see the !use_sg cleanup in a separate patch series...

Are we really sure this can all go?  No requests, not even ones from SG_IO
will ever use the non-sg paths?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG50OeHL9iwnUZqnkRAkeoAJ9JZBs9KITGzESzCVraGH9mCaJy4ACgj+mm
8WYEgIAQbTymvImoQNbIiHw=
=WhZ/
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
