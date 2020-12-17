Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081B7C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B610223731
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgLQGQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgLQGQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 01:16:31 -0500
Date:   Thu, 17 Dec 2020 07:17:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608185751;
        bh=PIn5OBx7RhcsP9rYcudnU5r7J90B7Qrgo5JSzUWoqK4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=luFOf95dYRaQolBeW0f09ZSOOw2ewD2udyCjvDYM0CqNvht1v9LLWrFx+5xo/fFyB
         Sw3+fCoZrH/YzX/SuvyAbmaWkLot/jJFopFbukAqDX85dSujfHTtsBOzt/aKBXHUto
         K9uaichGcKtlhDWBvo/Ez4FiLouJ0rfP0NY3iS58=
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
Subject: Re: Re: Subject: [PATCH v14 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <X9r36HWF80Nh1ZNI@kroah.com>
References: <X9nM5b4xK+QSFLpq@kroah.com>
 <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
 <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
 <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p1>
 <20201217052136epcms2p175d2c38536ad1b83e7b24c190d3346d8@epcms2p1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217052136epcms2p175d2c38536ad1b83e7b24c190d3346d8@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 17, 2020 at 02:21:36PM +0900, Daejun Park wrote:
> On Wed, Dec 16, 2020 at 11:45:32AM +0900, Daejun Park wrote:
> > > This is a patch for the HPB initialization and adds HPB function calls to
> > > UFS core driver.
> > 
> > <snip>
> > 
> > Your "subject" is odd, it has "Subject:" in it twice, did git
> > format-patch create that?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Sorry, It is my mistake.
> Should I resend this patch with proper subject?

Eventually yes.  Nothing anyone can do with this before 5.11-rc1 is out
anyway, so you might want to wait.

thanks,

greg k-h
