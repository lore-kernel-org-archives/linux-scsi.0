From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Fri, 2 Aug 2002 13:37:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802133701.C31990@one-eyed-alien.net>
References: <3D49BCDB.392ACAA4@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D49BCDB.392ACAA4@torque.net>; from dougg@torque.net on Thu, Aug 01, 2002 at 06:57:31PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2002 at 06:57:31PM -0400, Douglas Gilbert wrote:
>                  SCSI Hotplug for lk 2.5

On a related note....

It would be really nice if a low-level driver could signal, somehow, to the
VFS layer that it was a hot-unpluggable device, and thus precautions should
be taken (i.e. perfer mounting with -o sync, etc.)

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  They kicked your ass, didn't they?
S:  They were cheating!
					-- The Chief and Stef
User Friendly, 11/19/1997

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9Su1tIjReC7bSPZARAg3QAJ9BtLM+f1WCEQwqT2I+cTl0J2IXkQCfdtLC
SBUd4PJP1HWG5s+K2TCFkU0=
=RnlC
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
