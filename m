From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to dma_alloc_coherent
Date: Fri, 2 May 2008 13:25:29 +0200
Message-ID: <200805021325.30504.eike-kernel@sf-tec.de>
References: <20080501230632.GA19832@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1825350.UfI1Kgzp8m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:36780 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbYEBLeh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 May 2008 07:34:37 -0400
In-Reply-To: <20080501230632.GA19832@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org

--nextPart1825350.UfI1Kgzp8m
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Miquel van Smoorenburg wrote:
> [PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to
> dma_alloc_coherent
>
> Remove virt_to_bus/bus_to_virt code from dpt_i2o, and use
> dma_alloc_coherent() / dma_free_coherent().
>
> *==========================================================================
>== */
>
> +static inline u32 dma_high(dma_addr_t addr)
> +{
> +	return upper_32_bits(addr);
> +}
> +
> +static inline u32 dma_low(dma_addr_t addr)
> +{
> +	return (u32)addr;
> +}
> +

Just use these instructions directly, no need to introduce functions for that.

Eike

--nextPart1825350.UfI1Kgzp8m
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIGvoqXKSJPmm5/E4RApYAAJ4utHk4RbBL3Hx8aRq4vAblRg5/kQCeJVfv
bdhboeEi40hd4JFJxRynwKo=
=8a/T
-----END PGP SIGNATURE-----

--nextPart1825350.UfI1Kgzp8m--
