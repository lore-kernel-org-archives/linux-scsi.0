From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: How to map between /dev/sdX and dev/sgX devices?
Date: Thu, 19 Aug 2004 21:12:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092942751.2820.5.camel@laptop.fenrus.com>
References: <C8CF60CFC4D8A74E9945E32CF096548A022148EC@silver.nane.netapp.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AxPnX/hB0ywaK5I/p0JX"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35001 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S267258AbUHSTMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 15:12:37 -0400
In-Reply-To: <C8CF60CFC4D8A74E9945E32CF096548A022148EC@silver.nane.netapp.com>
List-Id: linux-scsi@vger.kernel.org
To: "Reilley, Peter" <Peter.Reilley@netapp.com>
Cc: linux-scsi@vger.kernel.org


--=-AxPnX/hB0ywaK5I/p0JX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-08-19 at 20:35, Reilley, Peter wrote:
> What is the correct way to find the corresponding scsi generic
> device given the scsi disk node name?   I have a situation
> where I must issue SCSI pass thru commands to a specific
> /dev/sdX node. =20

don't..... use SG_IO on the device directly

--=-AxPnX/hB0ywaK5I/p0JX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBJPufxULwo51rQBIRAr3LAJ9+N4v6SHLwo52pYy98PHEBQnve1QCbB8z9
+a3dfeA6B4VHaq0xCEmHSic=
=CxCB
-----END PGP SIGNATURE-----

--=-AxPnX/hB0ywaK5I/p0JX--

