From: Yves-Alexis Perez <corsac@debian.org>
Subject: Re: [PATCH] libsas: Disable asynchronous aborts for SATA devices
Date: Wed, 10 Jan 2018 09:27:27 +0100
Message-ID: <1515572847.3305.100.camel@debian.org>
References: <1515512632-115483-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-j2uNrPwtgil6H8pmeopH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:59082
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbeAJI1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 03:27:35 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e21::1])
        by mail.corsac.net (Postfix) with ESMTPS id 3B5A38F
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2018 09:27:34 +0100 (CET)
In-Reply-To: <1515512632-115483-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


--=-j2uNrPwtgil6H8pmeopH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 16:43 +0100, Hannes Reinecke wrote:
> Handling CD-ROM devices from libsas is decidedly odd, as libata
> relies on SCSI EH to be started to figure out that no medium is
> present.
> So we cannot do asynchronous aborts for SATA devices.

The box boots fine with this change, thanks!

Tested-by: Yves-Alexis Perez <corsac@debian.org>
--=20
Yves-Alexis
--=-j2uNrPwtgil6H8pmeopH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAlpVzm8ACgkQ3rYcyPpX
RFuNewf/X+XdBEnrtyECU9Gm7AjTOgwrd2ToALc8VC/pBhlPEUXXKsQo/dDb9Pzg
kBupZ5jdiNDHZQksctJ4PZ09+Ern9g8ZJS/IFYHVqEZCkcUhlr8ZefGh+7E9Zido
Bnbrh07Yfy/1l7+/60Q9nnSIo+IfPlsUvd/pEqFDicaDXwY14q4tR+m0qli2P5g5
12obX1p74MgMTbr3F40b/3yj/u30HIemfgDNsz8uTb8AdoQbMD5Z+smlNxv9uZVB
Ts+Cl5DuND204LQ8G2UNQpJYJ2aJ66ZZfQudD+ijmBeObRDQojyhg+bKKzSspkU0
en6Ww6lhglCGhEaRxeM40MkbNeZOoQ==
=6JwN
-----END PGP SIGNATURE-----

--=-j2uNrPwtgil6H8pmeopH--
