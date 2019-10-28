Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DEDCA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9546D21721
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572294296;
	bh=yPE0SEZPz8Tc+OMS4kFqOGsFj5A2ktZo+Yyz/KZ1TQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dON0FO1YXld5FnqYs2iW1nEYyErQjW4PSANS2dWLp/O/n5a+hlEh5Pfsn64xMepiJ
	 ydx7idA1BWCgBAZngr5l/U9CfFyATd89w1517eYvipOQf34Y6fpMPAvwS/zFnDiJGu
	 OCbkZjJwTDHIamAgRJCaoU9swFgw99JUHo1asjD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbfJ1UY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:24:56 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:54800 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfJ1UYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yPE0SEZPz8Tc+OMS4kFqOGsFj5A2ktZo+Yyz/KZ1TQE=; b=ILqfyNeJxEWgr49oAyTomKf5U
        ZB9SUmnCLyq3+XdiArCsYn43E/7kA1ds75Is/qGUZOtd0NYLSAOrTJ4Pjhq7nXGq4b5kjg4ZTAzFb
        qafGcD0CH0klR5B0GktMCkCvpC/ywNHI+CfXlSCYYbw3l8Et5KvYNMcgS4JxWgBNV/d4c=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iPBYl-0000aR-7O; Mon, 28 Oct 2019 20:24:15 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id B2C9527403EE; Mon, 28 Oct 2019 20:24:14 +0000 (GMT)
Date:   Mon, 28 Oct 2019 20:24:14 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Subject: Re: [PATCH 9/9] ASoC/fsl_spdif: Use put_unaligned_be24() instead of
 open-coding it
Message-ID: <20191028202414.GK5015@sirena.co.uk>
References: <20191028200700.213753-1-bvanassche@acm.org>
 <20191028200700.213753-10-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8tUgZ4IE8L4vmMyh"
Content-Disposition: inline
In-Reply-To: <20191028200700.213753-10-bvanassche@acm.org>
X-Cookie: The Moral Majority is neither.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2019 at 01:07:00PM -0700, Bart Van Assche wrote:
> This patch makes the code easier to read.

I only have this patch from the series but no cover letter, what's the
story with dependencies?

--8tUgZ4IE8L4vmMyh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl23Tm0ACgkQJNaLcl1U
h9C0bQf/dKHPtMdfD3BnbaQDGmpdXBeC3ulHsdo6am7obLNTi3STvqJQub0n+xvl
0qwhNlf7hP6A2S5amw7CHIhgZMaxiedFnckBA6lRfEeIBfsM724qWgEk9DX8csXG
XyPbE35qiNCulfilLLbu7kgZn+jQrzur9qDJjI0c8L7nqhws/aShY2g/nOWu770z
+7KeMdWAPXyeTjXIiERD52wrk0XzOQe0b3vzplWRLeKBY/g7TILWzAEDU5woe1J7
jXew9M8Eob3+GiW2vCXslP0eSrnVcibOVZ+0HIIhb+EPiyqUYn3i3TmSAXV8H7Rd
EA2uR23tqoeMhbbUjytGXEtrrdDTkw==
=38LL
-----END PGP SIGNATURE-----

--8tUgZ4IE8L4vmMyh--
