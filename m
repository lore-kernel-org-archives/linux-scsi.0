From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Tue, 4 Mar 2003 12:36:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304123605.D6452@one-eyed-alien.net>
References: <20030303221532.GB1587@beaverton.ibm.com> <200303040103.18491.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200303040103.18491.oliver@neukum.name>; from oliver@neukum.name on Tue, Mar 04, 2003 at 01:03:18AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2003 at 01:03:18AM +0100, Oliver Neukum wrote:
> Don't we need to disallow further devices being discovered on this
> host's busses before we set the existing devices offline?

Hrm... yes, I think this could be a problem.

For 99% of USB storage devices, it's not.  One device =3D=3D one host with =
one
target.  However, for the other 1% of devices (and all 'real' SCSI hosts),
this could be an issue.  I could be trying to yank the device (hot-unplug)
at the same moment someone is doing an add-single-device.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I need a computer?
					-- Customer
User Friendly, 2/19/1998

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ZQ41IjReC7bSPZARAt7DAKDOEKC9z1sWhWD/gdAFed7yKOua9wCgjTVD
zIcIO6CMutawNHZ1QiBjKTo=
=CzTS
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
