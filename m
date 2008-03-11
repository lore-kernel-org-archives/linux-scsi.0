From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer dereference
Date: Tue, 11 Mar 2008 10:39:45 -0700
Message-ID: <20080311173945.GJ2820@one-eyed-alien.net>
References: <867igc3w8r.fsf@deprecated.bitebene.org> <47D551B8.9080807@panasas.com> <1205183577.2941.38.camel@localhost.localdomain> <47D6B050.7070803@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EdRE1UL8d3mMOE6m"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:46598
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061AbYCKRmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2008 13:42:01 -0400
Content-Disposition: inline
In-Reply-To: <47D6B050.7070803@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>


--EdRE1UL8d3mMOE6m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2008 at 06:16:16PM +0200, Boaz Harrosh wrote:
> I would like to fix this better by calling scsi_get/put_command but there=
 is=20
> something fundamental that bothers me with isd200 driver. I can see that=
=20
> an isd200_info struct is allocated and put on a struct us_data->extra. Bu=
t=20
> as I understand the code, the struct us_data is associated with a scsi_ho=
st=20
> not a scsi_device. Are we guarantied that we have only one scsi_device=20
> per host at all times?

Yes.  We allocate a scsi_host for each USB device that we see.  The only
time you can have more than one scsi_device is in the case of multi-target
devices, of which the ISD-200 is NOT one.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hey, has anyone seen the Microsoft sales guy? It's his feeding time...
					-- Mike
User Friendly, 4/17/1998

--EdRE1UL8d3mMOE6m
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH1sPhHL9iwnUZqnkRAmhMAJkB5UlBfVPWuhk8V4qNDTqxVfmmUQCeKKSN
xgvwLgPFw79jRClCVf+I29E=
=FzME
-----END PGP SIGNATURE-----

--EdRE1UL8d3mMOE6m--
