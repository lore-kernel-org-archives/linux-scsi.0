From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Driver request: ITE8212
Date: Wed, 04 Aug 2004 09:47:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091605659.2792.10.camel@laptop.fenrus.com>
References: <1091605611.3299.16.camel@h194n2fls33o1121.telia.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mj3mdtvA/EmNQknxRTOK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28620 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261300AbUHDHro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 03:47:44 -0400
In-Reply-To: <1091605611.3299.16.camel@h194n2fls33o1121.telia.com>
List-Id: linux-scsi@vger.kernel.org
To: Peter Backlund <peter.backlund@home.se>
Cc: linux-scsi@vger.kernel.org


--=-Mj3mdtvA/EmNQknxRTOK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-08-04 at 09:46, Peter Backlund wrote:
> Hello.
>=20
> I'd like to propose to the inclusion of the ITE 8212 Raid controller
> card. The manufacturer already provides a GPL driver (one for 2.4.x and
> one for 2.6.x) and a lot of hardware specs.


why?
Alan posted a cleaned up *IDE* driver for this hardware on lkml last
week. It's IDE hardware, there's no point in glueing it to the scsi
layer.....

--=-Mj3mdtvA/EmNQknxRTOK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBEJSbxULwo51rQBIRAkRGAJ9kyB225rkeQ8+toU5OYK3bBprFEgCggw7o
z25H3PbFkMk7dMkCYV7wYrw=
=wjD2
-----END PGP SIGNATURE-----

--=-Mj3mdtvA/EmNQknxRTOK--

