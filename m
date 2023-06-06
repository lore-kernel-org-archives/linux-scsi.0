Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8E6C7EE24
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 15:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbjFFPq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 11:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237541AbjFFPqT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 11:46:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A071E43
        for <linux-scsi@vger.kernel.org>; Tue,  6 Jun 2023 08:46:16 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1q6Yst-0007ZJ-SU; Tue, 06 Jun 2023 17:46:11 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1q6Ysq-005XYy-Oe; Tue, 06 Jun 2023 17:46:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1q6Ysp-00BkJs-RD; Tue, 06 Jun 2023 17:46:07 +0200
Date:   Tue, 6 Jun 2023 17:46:07 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     kernel@pengutronix.de, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] scsi: hisi_sas: Convert to platform remove callback
 returning void
Message-ID: <20230606154607.omxmmuckgpzuwm4c@pengutronix.de>
References: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de>
 <yq1353ch738.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2sevzlmmviwrqyju"
Content-Disposition: inline
In-Reply-To: <yq1353ch738.fsf@ca-mkp.ca.oracle.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--2sevzlmmviwrqyju
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Martin,

On Wed, May 31, 2023 at 11:08:25AM -0400, Martin K. Petersen wrote:
> > The .remove() callback for a platform driver returns an int which
> > makes many driver authors wrongly assume it's possible to do error
> > handling by returning an error code. However the value returned is
> > (mostly) ignored and this typically results in resource leaks. To
> > improve here there is a quest to make the remove callback return void.
> > In the first step of this quest all drivers are converted to
> > .remove_new() which already returns void.
>=20
> Applied to 6.5/scsi-staging, thanks!

I don't see it there:

	$ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git ref=
s/heads/6.5/scsi-staging
	From https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi
	 * branch                      6.5/scsi-staging -> FETCH_HEAD

	$ git log --oneline v6.3..FETCH_HEAD --author=3DUwe --grep=3Dhisi_sas | wc=
 -l
	0

What am I missing?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2sevzlmmviwrqyju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmR/VL4ACgkQj4D7WH0S
/k7iNAgAoP1C4DsAi2E5tvXLt9LuCis+3UMkllz/A0fE3/bUv9cOIrEcndpxmefj
Bl8W8oAAznEp49TUxATKx8zuafn/wQftqTYZpFLYWpqjEKxi0nZhuI1bjY6xVMcd
i6e2JViwA9fDMo7vUJhaEJRwGqhM3LBA7ls43pG1p8AkO7nFEQ7xzpFamiXFHisY
OozPOqsSbFeCC5j2OogEPlTxMjfa+q1Wfo+/Gt99j0E7GncvP0mn5vDwbFShBKgU
rtxS3h3dklPMAXoQDonYxc/QX0kFRYSIndlydm+DF7Cjwytxzl9pAN3NJucP/3tI
S4tnUOMGBYm2VteTVN9b+gud0oPTow==
=zVkr
-----END PGP SIGNATURE-----

--2sevzlmmviwrqyju--
