Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC974C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Apr 2022 20:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiDPUDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Apr 2022 16:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiDPUDq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2022 16:03:46 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72A36333;
        Sat, 16 Apr 2022 13:01:13 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6DD421C0B8C; Sat, 16 Apr 2022 22:01:11 +0200 (CEST)
Date:   Sat, 16 Apr 2022 22:01:10 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 2/7] scsi: lpfc: Fix queue failures when
 recovering from PCI parity error
Message-ID: <20220416200110.GA28827@duo.ucw.cz>
References: <20220412005248.351701-1-sashal@kernel.org>
 <20220412005248.351701-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20220412005248.351701-2-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: James Smart <jsmart2021@gmail.com>
>=20
> [ Upstream commit df0101197c4d9596682901631f3ee193ed354873 ]

There's something strange going on with this commit. It is in autosel
for 4.9 and 5.10, but not 4.19. Mistake?

Best regards,

								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYlsghgAKCRAw5/Bqldv6
8hdUAKDAkGNAr1ZV9TpeilaOQDOjqIYXSwCgrzgwprwzs5vBrPVgEXaCK1DhutI=
=Guue
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
