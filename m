From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: Possible performance regression?
Date: Tue, 03 Jan 2006 19:37:49 +0100
Message-ID: <43BAC47D.4030702@ilsb.tuwien.ac.at>
References: <43B94DB9.5040505@hp.com> <43BA5384.5070504@ilsb.tuwien.ac.at> <43BA8C19.6010706@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA8D95B88198C6D09AAD8CD62"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:59271 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S932455AbWACSiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 13:38:07 -0500
In-Reply-To: <43BA8C19.6010706@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA8D95B88198C6D09AAD8CD62
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Alan D. Brunelle schrieb:

> I do not know how to grab that specific patch, but I am just trying a
> 2.6.15-rc6 kernel, and things seem much better. I'm hoping that
> 2.6.15-rc6 contains the patch you mention?
>=20

I do not know -rc6, but if mptbase.c contains the functions
mpt_alt_ioc_wait and mpt_bringup_adapter the patch
has been applied. Worked for me :-)

                                        GS

--=20
Gerhard Schneider
Institute of Lightweight Design and         e-Mail: gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/



--------------enigA8D95B88198C6D09AAD8CD62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFDusSAE6e53f4wQG4RAgG9AKCwGKUCyEvi9D2jUQOw3a7xRT+0qACfWC4J
YawsJH6hzBBr/lVKBm5zhd0=
=J/CY
-----END PGP SIGNATURE-----

--------------enigA8D95B88198C6D09AAD8CD62--
