From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Sat, 5 Jul 2003 09:25:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030705092544.A27540@one-eyed-alien.net>
References: <20030704125444.B17588@one-eyed-alien.net> <Pine.LNX.4.44L0.0307050959020.16984-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:15116 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S266387AbTGEQLR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jul 2003 12:11:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307050959020.16984-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Sat, Jul 05, 2003 at 10:11:18AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 05, 2003 at 10:11:18AM -0400, Alan Stern wrote:
> On Fri, 4 Jul 2003, Matthew Dharm wrote:
>=20
> > On Fri, Jul 04, 2003 at 03:36:55PM -0400, Alan Stern wrote:
> > > Finally a segmentation violation occurs when __scsi_get_command() tri=
es to
> > > access dev->host->cmd_pool->gfp_mask.  Not surprising since the host
> > > structure is gone.
> >=20
> > This could still be our (usb-storage) problem.
> >=20
> > We're not supposed to release the host structures until after ->release=
 is
> > called.  I think we're violating that right now.
>=20
> Although that used to be true, it's not true any longer.  The SCSI=20
> midlayer interface changed very recently, and ->release is no longer=20
> called for hot-pluggable hosts.  See=20
> Documentation/scsi/scsi_mid_low_api.txt in 2.5.74.

Oh.  Well, that's convenient then.  One less thing for me to worry about
for this weekend. :)

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/BvwIIjReC7bSPZARApfSAKC8ElKNGyC6yjz3d93zU3mg66xPUgCfSOXK
SXK9jwUdC2FbIJQQhfNSex4=
=uDeM
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
