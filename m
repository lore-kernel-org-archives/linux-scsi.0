From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Configuring the device_list in scsi_scan.c
Date: Thu, 30 May 2002 14:47:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530144750.G32763@one-eyed-alien.net>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C5EA4@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="zGQnqpIoxlsbsOfg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <08628CA53C6CBA4ABAFB9E808A5214CB0C5EA4@mercury.infiniconsys.com>; from mheinz@infiniconsys.com on Thu, May 30, 2002 at 05:18:29PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org


--zGQnqpIoxlsbsOfg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Umm... doesn't this already exist?

echo 'scsi add-single-device <bus> <channel> <target> <lun>' > /proc/scsi/s=
csi

Matt

On Thu, May 30, 2002 at 05:18:29PM -0400, Heinz, Michael wrote:
> We just ran into an issue where the RAID array we purchased didn't quite
> work with Linux, because only the first LUN was visible (Red Hat
> 2.4.7-10).
>=20
> I patched the kernel by adding the array to the device_list in
> scsi_scan.c, but that seems obnoxious. It occurs to me that it would be
> straight forward to modify scsi.c and scsi_scan.c so that you could
> write to /proc/scsi/scsi and add new entries to the device_list; and a
> module parameter that would let you add a single new entry to the
> device_list right at load time.
>=20
> Before I start fighting with my boss over whether I have time to write
> patches for the linux kernel - does this fix make sense?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--zGQnqpIoxlsbsOfg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE89p4GIjReC7bSPZARAliKAKCgJPj8sQexcPmv8RzI7ZnUxV+CAACcDi3G
o23P7y32Qhv31neNjOcEjfk=
=C1O9
-----END PGP SIGNATURE-----

--zGQnqpIoxlsbsOfg--
