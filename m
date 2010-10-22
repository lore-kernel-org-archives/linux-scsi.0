From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH] [USB] Allow retrieval of the Caching mode page
Date: Thu, 21 Oct 2010 17:04:05 -0700
Message-ID: <20101022000405.GC25431@one-eyed-alien.net>
References: <662065.4331.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:41507
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab0JVAEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2010 20:04:10 -0400
Content-Disposition: inline
In-Reply-To: <662065.4331.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2010 at 03:52:12PM -0700, Luben Tuikov wrote:
> The statement of the comment removed by this
> patch, "A number of devices have problems with
> MODE SENSE for page x08, so we will skip it" is
> certainly too general to apply for *all*
> devices. This patch removes the unconditional
> retrieval constraint of the Caching mode page.

If you remove this, there are several devices which will stop working.
They will simply go out-to-lunch when the sd_mod driver sends a request for
Mode Page 8.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I want my GPFs!!!
					-- Stef
User Friendly, 11/9/1998

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFMwNT13gL8qCooyc4RAquZAJ49cBukZbQWvwbG2vs+GTf18UmP+QCeMVcT
5O2s2e7nsqCB89Mt7hv/uCA=
=uij1
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
