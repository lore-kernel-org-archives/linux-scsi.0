From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Mon, 4 Aug 2008 10:45:24 -0700
Message-ID: <20080804174524.GL4322@one-eyed-alien.net>
References: <489656EC.5000602@torque.net> <Pine.LNX.4.44L0.0808041147580.3818-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:54343
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbYHDRph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 13:45:37 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0808041147580.3818-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2008 at 11:51:57AM -0400, Alan Stern wrote:
> I tend to agree with Matt that it would be best to have the higher
> layers tell usb-storage exactly how much sense data they want to get.
> The problem is that these higher layers would not know about the=20
> 18-byte restriction on many earlier USB devices, so usb-storage would=20
> probably end up needing to make its own dynamic decisions anyway.

Why not handle this like other fields in the struct scsi_device?  Let the
core initialize it with a value, then override it in the slave_configure()
routine via unusual_devs.h flag OR via userspace command to the SCSI core?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIl0A0HL9iwnUZqnkRAvHsAJ9r7ceBvllgdEeZ1eNNMOfBHiSsAQCgl+Hz
zW/TgxNNaj6Tgqc7RXUE9nU=
=joWU
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
