From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: [RFC] scsi_find_device() int -> unsigned int
Date: Fri, 07 Nov 2003 16:17:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068218244.794.13.camel@lt-sv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9RMWPQFAd7mTLtnyhP8B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ping.topalis.com ([195.243.109.4]:23815 "EHLO ping.topalis.com")
	by vger.kernel.org with ESMTP id S264396AbTKGPSW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2003 10:18:22 -0500
Received: from ping.topalis.com (localhost.localdomain [127.0.0.1])
	by localhost.ping.topalis.com (Postfix) with ESMTP id 0DF9CB2F2E
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2003 16:17:34 +0100 (CET)
Received: from to.com (fw-dmz.topalis.com [195.243.109.1])
	by ping.topalis.com (Postfix) with ESMTP id 767391224A8
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2003 16:17:33 +0100 (CET)
Received: from localhost (elwood.think [192.168.10.15])
	by to.com (Postfix) with ESMTP id 91687C05F8
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2003 16:17:33 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-9RMWPQFAd7mTLtnyhP8B
Content-Type: multipart/mixed; boundary="=-xh3ogjaBc8b3xFB5Z0aS"


--=-xh3ogjaBc8b3xFB5Z0aS
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

after hitting a signed/unsigned bug I turned on -Wsign-compare and found
a warning in scsi_find_device(). Any reason not to do this?

regards
	Stefan
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-xh3ogjaBc8b3xFB5Z0aS
Content-Disposition: attachment; filename=unsigned.diff
Content-Type: text/plain; name=unsigned.diff; charset=iso-8859-15
Content-Transfer-Encoding: base64

LS0tIGhvc3RzLmgJMjAwMy0xMS0wNyAxNTo0ODo1Mi4xNDY2MDI5NTcgKzAxMDANCisrKyAvdG1w
L2hvc3RzLmgJMjAwMy0xMS0wNyAxNTo0ODowOC4xMjY2MDI5NTcgKzAxMDANCkBAIC0zNSw4ICsz
NSwxMCBAQA0KICAqIEBwdW46CVNDU0kgdGFyZ2V0IG51bWJlciAocGh5c2ljYWwgdW5pdCBudW1i
ZXIpDQogICogQGx1bjoJU0NTSSBMb2dpY2FsIFVuaXQgTnVtYmVyDQogICoqLw0KLXN0YXRpYyBp
bmxpbmUgc3RydWN0IHNjc2lfZGV2aWNlICpzY3NpX2ZpbmRfZGV2aWNlKHN0cnVjdCBTY3NpX0hv
c3QgKnNob3N0LA0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aW50IGNoYW5uZWwsIGludCBwdW4sIGludCBsdW4pIHsNCitzdGF0aWMgaW5saW5lIHN0cnVjdCBz
Y3NpX2RldmljZSAqDQorc2NzaV9maW5kX2RldmljZShzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwg
dW5zaWduZWQgaW50IGNoYW5uZWwsDQorCQl1bnNpZ25lZCBpbnQgcHVuLCB1bnNpZ25lZCBpbnQg
bHVuKQ0KK3sNCiAgICAgICAgIHN0cnVjdCBzY3NpX2RldmljZSAqc2RldjsNCiANCiAJbGlzdF9m
b3JfZWFjaF9lbnRyeSAoc2RldiwgJnNob3N0LT5teV9kZXZpY2VzLCBzaWJsaW5ncykNCg==

--=-xh3ogjaBc8b3xFB5Z0aS--

--=-9RMWPQFAd7mTLtnyhP8B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/q7eDtWF28C4HGsQRAs02AKCFMCj7a91vtPuxW3cip2Bg3SoKUgCgubIx
FcMoI1FPbK5MnKPswRvEpW8=
=+SNE
-----END PGP SIGNATURE-----

--=-9RMWPQFAd7mTLtnyhP8B--

