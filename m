From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] 5/6: scsi_inq_timeout
Date: Tue, 20 Apr 2004 13:34:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420113414.GF4356@tpkurt.garloff.de>
References: <20040418185957.GH4868@tpkurt.garloff.de> <20040418202109.C3393@infradead.org> <20040418221610.GN4868@tpkurt.garloff.de> <20040419094106.A31555@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:29833 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262650AbUDTLeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 07:34:20 -0400
Content-Disposition: inline
In-Reply-To: <20040419094106.A31555@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 19, 2004 at 09:41:06AM -0700, Patrick Mansfield wrote:
> Why not increase it for all cases? And/or make it a config value?=20

Config value is stpuid. I made it a boot parameter.

> It won't slow down functioning hardware, just the cases where we get no
> response.

True, you should get selection timeouts there.
(Or the equivalent on non SPI transports.)

Still, 5s is already quite long; I would dislike the kernel needing
25s to recognize a broken device, just because somebody had built
screwed up hardware.

I'll drop the arch specific default.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhQq2xmLh6hyYd04RAvgUAJwMYw6x/cAZ4jaCjelk1UKs3oD7zACgngLz
+ulrL3dOX3IN6r3+1Gc0M8M=
=DbaQ
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
