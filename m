Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1789AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 09:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029FF2075A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 09:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgG0JeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 05:34:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38698 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0Jd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 05:33:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4680A1C0BE1; Mon, 27 Jul 2020 11:33:57 +0200 (CEST)
Date:   Mon, 27 Jul 2020 11:33:56 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Message-ID: <20200727093356.nanldba3nfocw3z3@duo.ucw.cz>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <20200722063937.GA21117@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kpyakbql6kpucp7b"
Content-Disposition: inline
In-Reply-To: <20200722063937.GA21117@infradead.org>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--kpyakbql6kpucp7b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-07-22 07:39:37, Christoph Hellwig wrote:
> As this monster seesm to come back again and again let me re-iterate
> my statement:
>=20
> I do not think Linux should support a broken standards extensions that
> creates a huge share state between the Linux initator and the target
> device like this with all its associated problems.
>=20
> Nacked-by: Christoph Hellwig <hch@lst.de>

To be a bit more constructive.

Yes, pushing (parts) of FTL to the host makes some kind of sense. IIRC
lightnvm is a step into that direction.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--kpyakbql6kpucp7b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXx6fhAAKCRAw5/Bqldv6
8g7KAKCbhn9XZy4IFL5Twgx9bWNrOXjMiACfZvGlJ9CAesnthDvJIhyK0AnZq7o=
=+TIT
-----END PGP SIGNATURE-----

--kpyakbql6kpucp7b--
