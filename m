From: Mark Brown <broonie@kernel.org>
Subject: Re: next-20140925 build: 1 failures 106 warnings (next-20140925)
Date: Thu, 25 Sep 2014 16:31:20 +0100
Message-ID: <20140925153120.GX27755@sirena.org.uk>
References: <E1XX7vn-0003PS-Vu@cassiel.sirena.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R0SsnouPYaG+7rP6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41613 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaIYPc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 11:32:28 -0400
Content-Disposition: inline
In-Reply-To: <E1XX7vn-0003PS-Vu@cassiel.sirena.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org


--R0SsnouPYaG+7rP6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 25, 2014 at 01:13:56PM +0100, Build bot for Mark Brown wrote:

> 	arm-allmodconfig
> ERROR: "__aeabi_uldivmod" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!

Today's ARM allmodconfig fails to build due to a call to a GCC intrinsic
being emitted from the mpt2sas module - I've not made any effort to
investigate this myself yet, unfortunately there's been a build error in
this configuration for arch/arm for the past week or so which means that
the error may not have been introduced today.

--R0SsnouPYaG+7rP6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJDVHAAoJECTWi3JdVIfQe20H/0xvWaMdnod5BFWjguOnjdal
uRO8Jo1pOtl+yltieijX0AevhUiVk1pSZlP4fSQvDF30z/XMhMhuYh5GGGJM3lJG
xiaxJ3f3G8yARZh2SC19Lh8hFnJnrj1FdC2Glv6njkjUiKLLRphyAmpfGLOXgdAH
aY/JMwh+EPqIlqwfWNFqfAKw+8cJgGrf6lxqatMxq2wijnVvmfCDJDQm7kMlE7/t
zOdkhgGvG08bf4HPnefCwc9HgVUOrx2jymc6maLK0oJkxToSZ+DWtddJb2E1ogOw
Kr8BryYNakgLomKYjv1aV/r0gRpcLkNj9NPMi8IyNqik/JNETG389Rd1nIWasWY=
=7Hjn
-----END PGP SIGNATURE-----

--R0SsnouPYaG+7rP6--
