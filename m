From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Fri, 4 Nov 2005 09:28:44 -0800
Message-ID: <20051104172844.GA12384@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com> <20051102234532.GC26148@one-eyed-alien.net> <1131077287.3117.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:9448 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S1750744AbVKDR2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 12:28:53 -0500
Content-Disposition: inline
In-Reply-To: <1131077287.3117.22.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 03, 2005 at 11:08:07PM -0500, James Bottomley wrote:
> On Wed, 2005-11-02 at 15:45 -0800, Matthew Dharm wrote:
> > On Wed, Nov 02, 2005 at 02:18:52PM -0800, Timothy Thelin wrote:
> > >=20
> > > If you had time to spare, instead of touching usb-storage,
> > > it might be better spent resurecting SG_FLAG_LUN_INHIBIT to
> > > stop the above behavior so that SG_IO cdbs can be passed
> > > through untouched.
> > > (SG_FLAG_FUN_INHIBIT was a flag SG_IO used to support a long
> > > time ago, and I have no idea why it was dropped, but it was)
> >=20
> > I didn't realize that had been removed.  Anyone that sends a
> > vendor-specific command to a device needs this flag to make sure it goes
> > through unmangled.
> >=20
> > Perhaps someone on linux-scsi can comment on why this was removed and h=
ow
> > we might get it back?
>=20
> I've no distinct recollection of someone removing this, but if I
> remember correctly what it used to do, it was a hack to stop us from
> mangling SCSI-3 CDB's.  We fixed the mid-layer not to require the hack
> by only setting the CDB[1] lun field for SCSI-1 and SCSI-2 devices (as
> the standards mandate).  What's the actual problem?  No SCSI-1 or SCSI-2
> device should have any vendor specific CDBs that uses these bits in
> CDB[1].

Unfortunately, reality appears to disagree with the last "should".  I've
personally seen devices with vendor-specific commands that want to control
CDB[1] in SCSI-2.

I didn't know it was removed; I only know what Timothy Thelin told me.  Can
we get the feature back?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDa5pMHL9iwnUZqnkRAomfAJ4qoOjE/XYsR0gpZmPnPndRAcjbxQCfalNJ
rrFKOe4O2FD6Fwp55dSEKDc=
=13td
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
