From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [janitor] (1/5) aic7xyz: use kernel.h min/max/ARRAY_SIZE
Date: Mon, 03 May 2004 21:21:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1083612090.3843.8.camel@laptop.fenrus.com>
References: <20040427110417.6a7c35ff.rddunlap@osdl.org>
	 <596965408.1083611410@aslan.scsiguy.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3r7t4m2EdIlJzb1vTxbG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54485 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263885AbUECTWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2004 15:22:16 -0400
In-Reply-To: <596965408.1083611410@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>


--=-3r7t4m2EdIlJzb1vTxbG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> With the exception of two files, this patch changes the driver core.
> These files must compile on several different OSes and thus must not
> become dependent on Linux specific macros.

since when is min() linux specific? Maybe your other OS has it too.. if
so I doubt it'll have any other semantics than the linux one, and if it
doesn't have it, it's like REALLY easy to just add one in the compat
layer for that OS.


--=-3r7t4m2EdIlJzb1vTxbG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAlpu6xULwo51rQBIRAtvoAJ9oHiI0yKFCgHLSm72xUxAHzanV8QCgk5wU
cLX6ocrGuvUzdjRHvnN+TfE=
=b+7Y
-----END PGP SIGNATURE-----

--=-3r7t4m2EdIlJzb1vTxbG--

