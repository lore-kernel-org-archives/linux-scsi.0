From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Wed, 2 Nov 2005 15:45:32 -0800
Message-ID: <20051102234532.GC26148@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:27572 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S1030210AbVKBXpi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Nov 2005 18:45:38 -0500
Content-Disposition: inline
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2005 at 02:18:52PM -0800, Timothy Thelin wrote:
>=20
> If you had time to spare, instead of touching usb-storage,
> it might be better spent resurecting SG_FLAG_LUN_INHIBIT to
> stop the above behavior so that SG_IO cdbs can be passed
> through untouched.
> (SG_FLAG_FUN_INHIBIT was a flag SG_IO used to support a long
> time ago, and I have no idea why it was dropped, but it was)

I didn't realize that had been removed.  Anyone that sends a
vendor-specific command to a device needs this flag to make sure it goes
through unmangled.

Perhaps someone on linux-scsi can comment on why this was removed and how
we might get it back?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDaU+cHL9iwnUZqnkRAisdAJ0Wf12qSDjyXG4HIVhLFEz3ctzrDwCfXmXP
7H9nxo1rXSTeT8CqvzjtMks=
=OBZX
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
