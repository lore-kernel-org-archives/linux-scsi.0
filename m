From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in
 sd_dif_prepare()
Date: Wed, 7 Mar 2012 20:28:32 +0300
Message-ID: <20120307172832.GR22598@mwanda>
References: <1331139652-25870-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kJZGYML2m3vFaueA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45103 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab2CGR0R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 12:26:17 -0500
Content-Disposition: inline
In-Reply-To: <1331139652-25870-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: JBottomley@parallels.com, matthew@wil.cx, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org


--kJZGYML2m3vFaueA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A patch for this already went in.

commit 9354f1b8e6c55c335d1c4fb10d0ae7a041935240
Author: Muthu Kumar <muthu.lkml@gmail.com>
Date:   Mon Mar 5 14:59:16 2012 -0800

    floppy/scsi: fix setting of BIO flags

Sorry about that.

regards,
dan carpenter



--kJZGYML2m3vFaueA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV5q/AAoJEOnZkXI/YHqRc9AP/Rb/QN03dDqJFs8cscz8tDTj
Zy5Qj61igzY0ZwbzPnOY7+ZcIA337S1qYcBsHxQElWO50oX4D9Pk28FHTdjdAfD8
62o5rdoVDHqI7G+z9m+S8YrTpe5/G7qIXBVKIW7fEHxhsP07o/itLFQEAdYUwC4s
mSJLdC2VctG/NYg40nxSNSFBWpkSxKSBiFWqFFPHR4tVsEHnknr1rBq7FSP85D0Z
vA9zRKBFFb9KgvysdBYlM2CmsBKQYr6Z3MpwKhqRM60XK+d6FXHH+Ck8ar/pukHi
gQAU850Frpgd844ft6r/OY7ZWDo2PrNnlZOxBUpOVDnT2UjJe+brOEb5nnk6i2Tf
NfaWLS4rFCMX8lSH5woNyrrxUYIGgpbeH2U0ddpLL5OVaJte2yBhN9/nAWX/PW5k
WHxR+WsLtORIhtw+uCWcphLpUmUd+40RVAgg2MX2wJ8N+yxPcJfhw0uRcBy/Qryy
GS/hfsNAFLgpnX4wXboWi2AnrOFIdXV9xATqLmC8JDBE3X+EvUhsOcSf46bzGtUx
00V4nTyaljX9jYh7vkrKFkoX5zSSwJ7YYgylggkSlK+qH7av6lc8LdPFy2GCRPS5
K8cFMXdjBIQ23Hv0rv9z05vyonfYC5FqsdVzPrI8JofHrSlxy+Otmlwzoxfm9ft5
Mik8jV14403l+gtaJBNi
=mOHd
-----END PGP SIGNATURE-----

--kJZGYML2m3vFaueA--
