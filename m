From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Q: aacraid stability on 64-bit Linux?
Date: Thu, 15 Apr 2004 12:45:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082025957.4691.2.camel@laptop.fenrus.com>
References: <407E18B1.30508@neopathnetworks.com>
	 <m3ad1dy154.fsf@averell.firstfloor.org>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-axj5Xk7jiD051c87fTyg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:6326 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262142AbUDOKqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 06:46:07 -0400
In-Reply-To: <m3ad1dy154.fsf@averell.firstfloor.org>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Dimitris Michailidis <dm@neopathnetworks.com>, linux-scsi@vger.kernel.org


--=-axj5Xk7jiD051c87fTyg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The I2O based Adaptec drivers are not 64bit clean at all and there
> seems to be nobody interested in fixing this (it's a huge task)=20
> The aacraid driver seems to mostly work if you use the latest=20
> version.

this is not quite true anymore; someone is fixing generic I2O to work
with the adaptec hardware and he's quite interested (and actually
working on) making that 64 bit clean/

--=-axj5Xk7jiD051c87fTyg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAfmfkxULwo51rQBIRAuD7AJ4iUlHAdHlFLZ3SFbFNukDnKOjvrgCgpoBJ
p1NIiC2tG8tivNYuNtf+EhM=
=OoRG
-----END PGP SIGNATURE-----

--=-axj5Xk7jiD051c87fTyg--

