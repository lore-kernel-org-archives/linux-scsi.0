From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Scsi midlayer question
Date: Fri, 16 Jul 2004 20:08:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090001284.2805.10.camel@laptop.fenrus.com>
References: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KznSmDd24Iv1cKhZb2H0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56715 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266567AbUGPSLu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 14:11:50 -0400
In-Reply-To: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com>
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org


--=-KznSmDd24Iv1cKhZb2H0
Content-Type: multipart/mixed; boundary="=-umPZBkRYmS+w84hYgNAF"


--=-umPZBkRYmS+w84hYgNAF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-07-16 at 19:55, Frank Borich wrote:
> I can see from a fibre channel trace that my 1 MB I/O transfers are
> getting cut up into little chunks.
> Is there any options that can be set when loading the scsi mid layer as
> a module that will improve
> io performance or prevent this breakdown for the sg,sd, or even raw
> drivers.  I am not a driver developer=20
> so please excuse my ignorance here.   Any info or points in the right
> direction would be greatly apprecited.
> I am using the 2.4.20 kernel. =20

try the patch I attached.


--=-umPZBkRYmS+w84hYgNAF
Content-Disposition: attachment; filename=w.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=w.patch; charset=UTF-8

LS0tIGxpbnV4L21tL3BhZ2VfYWxsb2MuYy5vcmcJMjAwNC0wNi0yNCAxNzozNjoyMi4wNDI0NjA5
MjAgKzAyMDANCisrKyBsaW51eC9tbS9wYWdlX2FsbG9jLmMJMjAwNC0wNi0yNCAxNzozODoxMi4z
NjE2ODk4NDggKzAyMDANCkBAIC0yODIsMTUgKzI4MiwxMyBAQA0KIAl1bnNpZ25lZCBsb25nIHNp
emUgPSAxIDw8IGhpZ2g7DQogDQogCXdoaWxlIChoaWdoID4gbG93KSB7DQotCQlpZiAoQkFEX1JB
TkdFKHpvbmUscGFnZSkpDQotCQkJQlVHKCk7DQogCQlhcmVhLS07DQogCQloaWdoLS07DQogCQlz
aXplID4+PSAxOw0KLQkJbGlzdF9hZGQoJihwYWdlKS0+bGlzdCwgJihhcmVhKS0+ZnJlZV9saXN0
KTsNCi0JCU1BUktfVVNFRChpbmRleCwgaGlnaCwgYXJlYSk7DQotCQlpbmRleCArPSBzaXplOw0K
LQkJcGFnZSArPSBzaXplOw0KKwkJaWYgKEJBRF9SQU5HRSh6b25lLCZwYWdlW3NpemVdKSkNCisJ
CQlCVUcoKTsNCisJCWxpc3RfYWRkKCZwYWdlW3NpemVdLmxpc3QsICYoYXJlYSktPmZyZWVfbGlz
dCk7DQorCQlNQVJLX1VTRUQoaW5kZXggKyBzaXplLCBoaWdoLCBhcmVhKTsNCiAJfQ0KIAlpZiAo
QkFEX1JBTkdFKHpvbmUscGFnZSkpDQogCQlCVUcoKTsNCg==

--=-umPZBkRYmS+w84hYgNAF--

--=-KznSmDd24Iv1cKhZb2H0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA+BmExULwo51rQBIRAkkjAJ47LgkWBcPNBRDZBWHglZctmrrjBQCggu0e
z88wUI2HWrRIcWrBVcDIfBo=
=lV0E
-----END PGP SIGNATURE-----

--=-KznSmDd24Iv1cKhZb2H0--

