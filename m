From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: cpqfc
Date: Mon, 13 Feb 2006 10:45:28 +0100
Message-ID: <200602131045.34949@bilbo.math.uni-mannheim.de>
References: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at> <Pine.GSO.4.64.0602071058530.26505@filebunker.xip.at> <Pine.GSO.4.64.0602101220450.2743@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5303806.FufZk5WcZA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:41125 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751204AbWBMJpj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 04:45:39 -0500
In-Reply-To: <Pine.GSO.4.64.0602101220450.2743@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>

--nextPart5303806.FufZk5WcZA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Freitag, 10. Februar 2006 12:26 schrieben Sie:
>Hello again,
>
>I have not received any answer regarding implementation of a new driver
>for the cpqfc adapter.
>
>In one week I will start to port the old 2.4 driver to 2.6; with all its
>"not nice" code, because it works!

It will not (really). cpqfc uses many functions not longer available in 2.6=
 so=20
you will not even get it compile for a long time.

If you still want to do something like that you might want to have a look o=
n=20
http://opensource.sf-tec.de/repos/cpqfc/ where I put my changes to this=20
driver online. The 2.6-branch will not compile by now but it is much cleane=
r=20
than the code that was in 2.6.

Eike

--nextPart5303806.FufZk5WcZA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBD8FU+XKSJPmm5/E4RAj7HAJ0dgliYl2WwJjOuJ8SimHQP7vZ9pgCdGbMt
J4IjQCahchEYafsaiB7Xxk8=
=Q+mu
-----END PGP SIGNATURE-----

--nextPart5303806.FufZk5WcZA--
