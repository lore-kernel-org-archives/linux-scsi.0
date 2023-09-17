Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DC6CD13D1
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Sep 2023 20:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbjIQUJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Sep 2023 16:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbjIQUIn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Sep 2023 16:08:43 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7344E103
        for <linux-scsi@vger.kernel.org>; Sun, 17 Sep 2023 13:08:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qhy4D-0005Cq-4d; Sun, 17 Sep 2023 22:08:29 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qhy4B-0073xy-9h; Sun, 17 Sep 2023 22:08:27 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qhy4B-002Q1A-0P; Sun, 17 Sep 2023 22:08:27 +0200
Date:   Sun, 17 Sep 2023 22:08:24 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Convert all platform drivers to return void
Message-ID: <20230917200824.yiubxagpqo5zst3u@pengutronix.de>
References: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5jva6jjq3kza672a"
Content-Disposition: inline
In-Reply-To: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--5jva6jjq3kza672a
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

FTR: This patch was sent (among others) to Pedro Sousa who is listed as
"M" of drivers/ufs/host/*dwc* in MAINTAINERS. The synopsys mail server
however told me that this email address doesn't exist any more.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5jva6jjq3kza672a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmUHXLcACgkQj4D7WH0S
/k5Uygf/TTNz6XVgjO/mBpBcXzkHM0+Szz3924zu+K6ICF1pi9adY63cBSw7B1BT
LiVnvfhuES+qNSunKPpWegQ4i/GKz9PvgmtAYX2r4wLDpSrOUrCsfJUxIRxa9vWo
zhK/VfNMMmRtkU7aI5AjFqgX2bXEEJjvEMzu9BHHfbAVu5AEPqBnB0P+IDt01GJZ
wKxIa82+pR0HoxXdTlv3HyHhkzRYXsK+iv4ZyU/koEvto50f+RS32xhMk4ayACe0
9DpG7nz7/hLekFbtSrVc9IolyNbPbw9mfVVFD+eH+Vklf7ObSV3autMBqwri9qDU
UUSRQE9UD6seD2ZhxU++3buP+SoQbQ==
=hMFV
-----END PGP SIGNATURE-----

--5jva6jjq3kza672a--
