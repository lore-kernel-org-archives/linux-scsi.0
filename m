From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 5/5] kill scsi_wait_req
Date: Fri, 16 Sep 2005 09:40:03 +0200
Message-ID: <200509160940.10846@bilbo.math.uni-mannheim.de>
References: <1126845602.9276.46.camel@max>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16840474.XbN3bR8dUy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:63191 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1161117AbVIPHjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 03:39:08 -0400
In-Reply-To: <1126845602.9276.46.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

--nextPart16840474.XbN3bR8dUy
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Mike Christie wrote:
>cpqfc is the last user of scsi_wait_req. It is too broken to even
>test patches to convert it to other functions though.
>This patch just kills scsi_wait_req and adds to the list
>of things that are broken on cpqfc. I was not sure what
>the proper thing to do in this case when the driver
>is so broken.

If you want to test it you'll find the needed patches on=20
http://opensource.sf-tec.de/kernel/. I found someone with this hardware (or=
=20
he found me) and we're testing this.

If you refuse to touch it I'll try to fix it up once your patches went into=
=20
mainline.

Eike

--nextPart16840474.XbN3bR8dUy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDKnbaXKSJPmm5/E4RAlZRAKCJMh8/tVHOqa3wWNOyaVllPMOUTgCgiK04
sYsaa6VOwwRHT/K40BSOsrU=
=948m
-----END PGP SIGNATURE-----

--nextPart16840474.XbN3bR8dUy--
