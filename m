From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Thu, 7 Aug 2003 09:38:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807073814.GB12862@marowsky-bree.de>
References: <1060042082.1985.53.camel@fuzzy> <20030805171416.A7963@beaverton.ibm.com> <1060201601.25773.30.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:43733 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S275202AbTHGHi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2003 03:38:28 -0400
Content-Disposition: inline
In-Reply-To: <1060201601.25773.30.camel@persist.az.mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>, Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2003-08-06T13:26:41,
   Steven Dake <sdake@mvista.com> said:

> There are problems with multipath in the md driver, specifically how to
> manage partitions.  Each partition requires a seperate multipath.=20

This is indeed a deficiency, but it all depends on how the DM device is
setup. You can also setup the DM for the physical device and then the
partitions on top of the DM, either using the partition code in the
kernel or, better, using user-space discovery and creating appropriate
DM devices to match the partitions.

> Changing partition sizes is quite difficult after multipaths are setup.=
=20
> One could argue that partitions should be managed by device mapper, but
> unfortunately all firmware doesn't know about device mapper devices,
> requiring the use of partitions.

Whether DM manages partitions or not is unrelated to whether firmware
knows about them; firmware depends on how the metadata is represented on
disk, not how (and where, whether 'in kernel' or DM) Linux choses to
interpret it.

> Also most people don't want to mess with device mapper.

Tough ;-)

> I like the idea of a generic queueing interface for block commands
> integrated with multipathing as it solves the partitioning problem quite
> nicely.

This would of course also be nice.

Sorry for getting into the discussion so late on the list here. I really
managed to miss it. I wonder how ever I did that...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)."
  -- Capt. Edward A. Murphy            -- Louis Pasteur

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE/MgHmudf3XQV4S2cRAtI5AJ4vtm/KCpzuDWhi85SAm8l3Q76nxgCfWKew
v/LiAJbFvuCwkd/I8BuhyyU=
=+6mO
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
