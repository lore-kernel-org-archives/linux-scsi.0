From: Stefan =?ISO-8859-1?Q?V=F6lkel?= <stefan.voelkel@millenux.com>
Subject: Patch: s390 root on scsi disc
Date: Sat, 19 Jun 2004 16:13:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087661628.26436.30.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vXsKZlOIm+x3kUSF+ePJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pong.topalis.com ([195.243.109.5]:6291 "EHLO pong.topalis.com")
	by vger.kernel.org with ESMTP id S261162AbUFSOPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 10:15:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Heiko Carstens <Heiko.Carstens@de.ibm.com>


--=-vXsKZlOIm+x3kUSF+ePJ
Content-Type: multipart/mixed; boundary="=-NEnfpiZSbshPWfquMNe0"


--=-NEnfpiZSbshPWfquMNe0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

the attached patch adds the ability to pass an initial zfcp scsi device
to the kernel. This enables us to have / on a scsi disc.

This is no "scsi only system" patch as you still need a small minidisk
that contains the kernel. Our typical setup looks like this:

        /	/dev/sda1
        /boot	/dev/dasda1
       =20
With this patch we are able to preserve our rare DASD space by having
most of the data on a cheap scsi disc in our JBOD.

regards
	Stefan
--=20
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-NEnfpiZSbshPWfquMNe0
Content-Disposition: attachment; filename=zfcp_root.diff
Content-Type: text/x-patch; name=zfcp_root.diff; charset=ISO-8859-15
Content-Transfer-Encoding: base64

LS0tIHpmY3BfYXV4LmMub3JpZwkyMDA0LTA2LTE5IDE2OjAxOjI1LjAwMDAwMDAwMCArMDAwMA0K
KysrIHpmY3BfYXV4LmMJMjAwNC0wNi0xOSAxNjowMDowMS4wMDAwMDAwMDAgKzAwMDANCkBAIC0x
NDYsNiArMTQ2LDE3IEBADQogbW9kdWxlX3BhcmFtKGZsYWdzX2R1bXAsIHVpbnQsIDApOw0KICNl
bmRpZg0KIA0KKyNpZm5kZWYgTU9EVUxFDQorLyogcmVtZW1iZXIga2VybmVsIGJvb3QgdGltZSBw
YXJhbWV0ZXIgKi8NCitzdGF0aWMgaW50IF9faW5pdCB6ZmNwX2RldmljZShjaGFyICpzdHIpDQor
ew0KKwlkZXZpY2UgPSBzdHI7DQorCXJldHVybiAxOw0KK30NCisNCitfX3NldHVwKCJ6ZmNwZGV2
aWNlPSIsIHpmY3BfZGV2aWNlKTsNCisjZW5kaWYNCisNCiAvKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8NCiAvKioqKioqKioq
KioqKiogRnVuY3Rpb25zIHdpdGhvdXQgbG9nZ2luZyAqKioqKioqKioqKioqKioqKioqKioqKi8N
CiAvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKi8NCg==

--=-NEnfpiZSbshPWfquMNe0--

--=-vXsKZlOIm+x3kUSF+ePJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA1GY8tWF28C4HGsQRAqKfAJ9CSk9I/1k2aF0dnb98YWpRkQ5GHgCgnncI
qtfBSBHBPYZW1pVToGEvtec=
=2QAk
-----END PGP SIGNATURE-----

--=-vXsKZlOIm+x3kUSF+ePJ--

