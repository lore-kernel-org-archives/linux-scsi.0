From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Help - how to identify the callers in a SCSI lower-level driver
Date: Wed, 07 Apr 2004 22:01:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081368099.4680.5.camel@laptop.fenrus.com>
References: <519672568F040C41B6FAC21ADF51B18FEF9F@mailnode1.commstor.crossroads.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fQXNk7Z//wXiBs86HdLV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50908 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264062AbUDGUBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2004 16:01:46 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEF9F@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org


--=-fQXNk7Z//wXiBs86HdLV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-04-07 at 21:52, Lee Xing wrote:
> Hi,
>=20
> I'm writing a pseudo Linux lower-level SCSI driver, which interfaces with=
 the standard mid-level driver and needs to identify different calling appl=
ications in Linux user space.  For example, there are 2 applications, app1 =
and app2, in user space, and they both use /dev/hda.  We don't need the SCS=
I lower-level driver to know the applications' names "app1" or "app2", but =
just need it to tell the (SCSI passthrough ioctl) calls are from the "this"=
 application or from "that" application.


you'll find that most IO's will come from the VM subsystem and not
directly from applications. Why do you think you need this functionality
????

--=-fQXNk7Z//wXiBs86HdLV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD4DBQBAdF4jxULwo51rQBIRAnJwAJjQzOIm+ZiozONNZrq7etvZtFphAJ9w7LjF
pbd3wyiYWQTwwTqEqP7SZQ==
=TVTE
-----END PGP SIGNATURE-----

--=-fQXNk7Z//wXiBs86HdLV--

