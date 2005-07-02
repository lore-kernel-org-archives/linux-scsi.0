From: Tony Vroon <chainsaw@gentoo.org>
Subject: Re: aic7xxx regression occuring after 2.6.12 final
Date: Sat, 02 Jul 2005 18:13:46 +0100
Message-ID: <1120324426.21967.1.camel@localhost>
References: <1120085446.9743.11.camel@localhost>
	 <1120318925.21935.9.camel@localhost>  <1120321322.5073.4.camel@mulgrave>
	 <1120322788.22046.2.camel@localhost>  <1120323691.5073.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qicqJD6qwVjJZ4sUp8BJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.irishbroadband.ie ([62.231.32.12]:29899 "EHLO
	smtp1.irishbroadband.ie") by vger.kernel.org with ESMTP
	id S261160AbVGBROk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Jul 2005 13:14:40 -0400
In-Reply-To: <1120323691.5073.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>


--=-qicqJD6qwVjJZ4sUp8BJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2005-07-02 at 13:01 -0400, James Bottomley wrote:
> Could you try booting with aic7xxx=3Dverbose to see what the device think=
s
> its negotiating?

scsi0: Slave Alloc 0
(scsi0:A:0:0): Sending WDTR 0
(scsi0:A:0:0): Received WDTR 0 filtered to 0
 target0:0:0: FAST-5 SCSI 1.0 MB/s ST (1020 ns, offset 255)
scsi0: target 0 using 8bit transfers
(scsi0:A:0:0): Sending SDTR period 45, offset 0
(scsi0:A:0:0): Received SDTR period 45, offset 0
Filtered to period 0, offset 0
 target0:0:0: asynchronous
scsi0: target 0 using asynchronous transfers
[vendor information follows; Fujitsu MAP 36.7GB drive]


> James
Tony.


--=-qicqJD6qwVjJZ4sUp8BJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1-ecc0.1.6 (GNU/Linux)

iD8DBQBCxstKp5vW4rUFj5oRAn+BAKCSrziWgP+SssyrUtRvdJyJwFxFtwCgj0Y4
kLcsiOjjDdGau55hHGBmm0o=
=lBmp
-----END PGP SIGNATURE-----

--=-qicqJD6qwVjJZ4sUp8BJ--

