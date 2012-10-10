From: Ben Hutchings <ben@decadent.org.uk>
Subject: [SCSI] hpsa: dial down lockup detection during firmware flash
Date: Wed, 10 Oct 2012 04:47:38 +0100
Message-ID: <1349840858.6336.31.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GsfH6Gr7/BOvtrv5QO23"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab2JJDr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2012 23:47:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-GsfH6Gr7/BOvtrv5QO23
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Should this fix for hpsa be included in stable updates?  It looks like
it would be needed in 3.2.y and 3.4.y, as lockup detection was
introduced in 3.2 and the fix went into 3.5.

commit e85c59746957fd6e3595d02cf614370056b5816e
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Tue May 1 11:43:42 2012 -0500

    [SCSI] hpsa: dial down lockup detection during firmware flash

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-GsfH6Gr7/BOvtrv5QO23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHTv2ue/yOyVhhEJAQqR/A//QKuOjJEp2Z3dRn/nvHNbhoUtPVLy8g0T
usN5ZOCXo58l5+ZG8WN1HagIKTZwrOF5IgeGj8veM2wGyXUw4mrL0MAB+iLO70PG
afk8+hNF/Y2clvk1sb5B0+GmU1iJH3o7m5wou1shyD4w3teRMjD7Mkt+2Yg+SsuQ
UQig9oIUH+wE2pKuffTzoYC9xs1PnrmwKbXByYPcpY1xM6VQFhqLHWYfbm1rOXY3
9Sif0ZIiB3QwIVpEQ0u4ORsuCi7Qg1EqpPUytHXKLpmL2iha0FTJZ24s6kISoJQ8
90Ay0dWl73VW2Njbicg61JD5rEFC6/amqtc4A96Iket6B4jWkANMOw1150kmzezO
B9hM55kPSyWNB9e8CoSeJ+WksT0FMG39sWJ+h2dHiSX4TI8FbX5neMj/0RvpP/Bp
PkngykCh4Bl9BCct2ZT5Ouk7ScOpXUL6PathVpMRnlWYGQPAXyPjIj/w6Kkse4JU
aVFTQVKFGIzylptRhosVnzTcyVdUE0dZuIXs1vGxoFa7x8XGpYEYIbZQzH9EvwIX
4Mcf+723/nsGkOdlNDD05hi+75rOq+zwBN2WiIzvKPOw8kq7D+/6kh/gENqcLBVH
NntAuwuUPmVhFRkHEj8e9+0shA34vb6N074NbzYPFhFk73p57r8YntJnRsFC6YFE
4EE5y9iafEc=
=a+CB
-----END PGP SIGNATURE-----

--=-GsfH6Gr7/BOvtrv5QO23--
