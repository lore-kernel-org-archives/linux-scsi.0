From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Fri, 28 Mar 2003 17:32:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030328173253.A32352@one-eyed-alien.net>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave> <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048779761.1789.21.camel@mulgrave>; from James.Bottomley@steeleye.com on Thu, Mar 27, 2003 at 09:42:39AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, Linus wants this to work for usb-storage more short-term than
long-term....

Suggestions?

Matt

On Thu, Mar 27, 2003 at 09:42:39AM -0600, James Bottomley wrote:
> On Tue, 2003-03-25 at 17:29, Mike Anderson wrote:
> > I thought we where looking at a solution for all traversals of the list?
> > There are currently ~52 refs to my_devices, while some traversals can be
> > evalutated and possibly removed there maybe valid ones that happen
> > without user context.
>=20
> Sorry, I was thinking both short and long term.
>=20
> Short term, it's probably easiest for the firewire stuff to access the
> offline and removal functions from user land hotplug scripts (so they
> don't actually need the in-kernel hook).
>=20
> Long term we do need to see if we can go to a nice refcounted model for
> all 50 odd list traversals.  At least auditing them to see if we can use
> a semaphore everywhere.
>=20
> James
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hPfFIjReC7bSPZARAk4rAKCTANs2GCb/D8oxnNS3c+LYxjQXpgCgkUhm
g3kDu6cd98ATGhiQhwUOgKc=
=iX1T
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
