From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sat, 29 Mar 2003 12:53:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030329125302.A10565@one-eyed-alien.net>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave> <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave> <20030328173253.A32352@one-eyed-alien.net> <1048948992.21525.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048948992.21525.1.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Mar 29, 2003 at 08:43:08AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

My understanding was that I couldn't call set_device_offline with the host
lock held, which is a problem because I need the host lock to traverse the
device list.

Matt

On Sat, Mar 29, 2003 at 08:43:08AM -0600, James Bottomley wrote:
> On Fri, 2003-03-28 at 19:32, Matthew Dharm wrote:
> > Well, Linus wants this to work for usb-storage more short-term than
> > long-term....
>=20
> Well, I think Mike's given us everything you need.  We can use the
> set_device_offline to alter the remove-single-device path to offline the
> device, wait for the returning I/Os to complete or error and then remove
> the device.
>=20
> You can then trigger this from your hotplug scripts.
>=20
> James
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hgeuIjReC7bSPZARAhsYAJ9SXWsyoqeQUsr3MdjzjyA0jJnSbQCgzxPK
lNrFT3fbb5kwuqcTJBuuVoY=
=LNKA
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
