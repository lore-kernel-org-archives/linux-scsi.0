From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 11/16] pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (scsi)
Date: Sat, 24 Oct 2009 22:16:49 +0200
Message-ID: <200910242216.55136.eike-kernel@sf-tec.de>
References: <20091024194219.GA19546@comet.dominikbrodowski.net> <1256413386-20501-11-git-send-email-linux@dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1914948.IGx8XWOrNp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:60117 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbZJXUXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2009 16:23:01 -0400
In-Reply-To: <1256413386-20501-11-git-send-email-linux@dominikbrodowski.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org, linux-scsi@vger.kernel.org

--nextPart1914948.IGx8XWOrNp
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dominik Brodowski wrote:

> @@ -164,19 +152,21 @@ static int aha152x_config_cs(struct pcmcia_device
>  *link) {
>      scsi_info_t *info = link->priv;
>      struct aha152x_setup s;
> -    int last_ret, last_fn;
> +    int ret
>      struct Scsi_Host *host;

This looks not even compile tested, there is a semicolon missing.

Eike

--nextPart1914948.IGx8XWOrNp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrjYLcACgkQXKSJPmm5/E5nlQCgjFGq6kHiBUr1DM5Q0F3tIrYL
CPoAmwUPB9oPRbOy4U5lIDrJFxmwRkeI
=wEke
-----END PGP SIGNATURE-----

--nextPart1914948.IGx8XWOrNp--
