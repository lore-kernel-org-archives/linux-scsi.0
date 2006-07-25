From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 3/3] scsi : megaraid_{mm,mbox}: a fix on "kernel unaligned access address" issue
Date: Tue, 25 Jul 2006 17:05:25 +0200
Message-ID: <200607251705.26361.eike-kernel@sf-tec.de>
References: <890BF3111FB9484E9526987D912B261932E2D1@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1373950.GfavpgCPCk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:27324 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751280AbWGYPDo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 11:03:44 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261932E2D1@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: sakurai_hiro@soft.fujitsu.com, James.Bottomley@steeleye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@engenio.com>, "Yang, Bo" <Bo.Yang@engenio.com>

--nextPart1373950.GfavpgCPCk
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Ju, Seokmann wrote:
> Hi,
>
> This is a third patch which follows prevous two patches ([PATCH 1/3] and
> [PATCH 2/3]).

Either use a [0/3] mail that describes the complete changeset or just send=
=20
each patch as a reply to the previous one. This way they are grouped togeth=
er=20
in the mail programs. That keeps the inbox clean and the relationsship is=20
clearer.

> Signed-Off By: Seokmann Ju <seokmann.ju@lsil.com>
> ---
> diff -Naur inqwithevpd/Documentation/scsi/ChangeLog.megaraid
> unaligned/Documentation/scsi/ChangeLog.megaraid
> --- inqwithevpd/Documentation/scsi/ChangeLog.megaraid	2006-07-24
> 15:35:02.000000000 -0400
> +++ unaligned/Documentation/scsi/ChangeLog.megaraid	2006-07-24
> 15:41:49.000000000 -0400
> @@ -66,6 +66,61 @@
>  	Fix: MegaRAID F/W has fixed the problem and being process of
> release,
>  	soon. Meanwhile, driver will filter out the request.
>
> +3.	One of member in the data structure of the driver leads unaligne
                                                                ^^^^^^^^
> +	issue on 64-bit platform.
> +	Customer reporeted "kernel unaligned access addrss" issue when
                                                   ^^^^^^

Typos.

> +	> -----Original Message-----
[...]

This is IMHO too much data for an in-kernel changelog. I would vote for=20
including this in your commit comments, then it will be available as git=20
comment and not inflate the kernel tree itself with text that's useless for=
=20
most users. This is really only of interest if someone tries to find out=20
something about the changes in this driver and then he's normally also=20
interested in the diffs itself.

Eike

--nextPart1373950.GfavpgCPCk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBExjM2XKSJPmm5/E4RAgCiAJ4qxf95e9bSKuriFyssFEgKT+5ZxACeNGps
0+v4e1TqA/WPF0SO1Lay5eY=
=WyO2
-----END PGP SIGNATURE-----

--nextPart1373950.GfavpgCPCk--
