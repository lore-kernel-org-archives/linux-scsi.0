From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 3/4] dpt_i2o: 64 bit support
Date: Fri, 2 May 2008 13:32:12 +0200
Message-ID: <200805021332.13252.eike-kernel@sf-tec.de>
References: <20080501230724.GA19844@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2219090.ghy0T9c5S4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:39888 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbYEBLeh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2008 07:34:37 -0400
In-Reply-To: <20080501230724.GA19844@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org

--nextPart2219090.ghy0T9c5S4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Miquel van Smoorenburg wrote:
> [PATCH 3/4] dpt_i2o: 64 bit support
>
> This is the code to actually support 64 bit platforms. 64 bit
> DMA is enabled on both x86_32 PAE and 64 bit platforms.
>
> This code is based in part on the unofficial adaptec 64-bit
> dpt_i2o driver update that I got from Mark Salyzyn at Adaptec.

> +static inline int dpt_dma64(adpt_hba *pHba)
> +{
> +	return (sizeof(dma_addr_t) > 4 && (pHba)->dma64);
> +}
> +

Just a note: you never set dma64 if sizeof(dma_addr_t) =3D=3D 4. Doing it t=
his way=20
has the advantage that the compiler can optimize that away completely.

Eike

--nextPart2219090.ghy0T9c5S4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIGvu9XKSJPmm5/E4RAkFxAJ4kO3rG2wCVC6Y8a/GB4E0zEIoGLACfai8D
uyyGr63PvyGx7WkDZTqRJpU=
=TJbL
-----END PGP SIGNATURE-----

--nextPart2219090.ghy0T9c5S4--
