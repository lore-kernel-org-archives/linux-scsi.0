From: Thayne Harbaugh <tharbaugh@lnxi.com>
Subject: buffer-list destroyed message
Date: 25 Apr 2003 11:31:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051291883.1172.358.camel@tubarao>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BCoeEi1K+D81iCd/JWD3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ash.lnxi.com ([207.88.130.242]:40270 "HELO ash.lnxi.com")
	by vger.kernel.org with SMTP id S263381AbTDYRTO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 13:19:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-BCoeEi1K+D81iCd/JWD3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I have a system that spits out the following error message:

scsi_end_request: buffer-list destroyed

It appears to come from drivers/scsi/scsi_lib.c: __scsi_end_request()

I can see that the code detects a mis-match in the number of sectors.=20
I'm wondering if anyone can enlighten me on how serious this problem is
(the machine appears to work fine), what might be causing the problem,
and how I might fix things.

I searched the archives and only found one mail that seemed relevant:

http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D93303946423398&w=3D2

The comment for the MegaRAID refers to SMP and that the system appears
to continue to function with no problems - two symptoms of the machine I
have.  Yep, not a lot of information.

Additional information is that the SCSI disk has been swapped twice -
all three disks had the same errors.  The cable has been swapped and the
SCSI controller (aic7899 Ultra 160 - Tyan 2462 built-in) has been
swapped (motherboard was swapped).


--=20
Thayne Harbaugh
Linux Networx

--=-BCoeEi1K+D81iCd/JWD3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA+qXDrfsBPTKE6HMkRAsgjAJ9M3iSbuNHzkYOVxWoevc52jownwwCfcwH3
sDrvKhk+b/bdmqaMU8p3O8M=
=iUly
-----END PGP SIGNATURE-----

--=-BCoeEi1K+D81iCd/JWD3--

