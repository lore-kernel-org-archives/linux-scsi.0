Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13548C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 09:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C41230FF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 09:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgLPJCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 04:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgLPJCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Dec 2020 04:02:10 -0500
Date:   Wed, 16 Dec 2020 10:01:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608109289;
        bh=z/eh3EUywzyjkSVYz4rpt0WtGd9ivWrDnhRe9zirCh4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3y4xGaf9B8BBqMmoHqAUB2OyAAS7vT0nO33cCn88LcDiDECpFbs/U17HZMkkjzwo
         dZVGIaSgUvNvdo47UE8Lx/iBmcvQ6FTk39Xtky2HUC47FBijvVfEXCsr9EFCyPrVdQ
         A3N/q/sgJppm9htVv4bXpYbi4O8wxgOh9O7cPOFA=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: Subject: [PATCH v14 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <X9nM5b4xK+QSFLpq@kroah.com>
References: <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
 <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p2>
 <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 16, 2020 at 11:45:32AM +0900, Daejun Park wrote:
> This is a patch for the HPB initialization and adds HPB function calls to
> UFS core driver.

<snip>

Your "subject" is odd, it has "Subject:" in it twice, did git
format-patch create that?

thanks,

greg k-h
