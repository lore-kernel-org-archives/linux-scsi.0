Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC997C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF9BE613F4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFCRk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 13:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhFCRk1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Jun 2021 13:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 196D0613F3;
        Thu,  3 Jun 2021 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622741922;
        bh=vKQVhlbem0NJ4PBaC93vDBnhL2fK29fHIgjPgQlD61w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QUdAJawlVtAkfUFkShTuntsPKOe6tBAdSKVMZVnLD1k195COHQE2W3SM1l4Sq6PK3
         1O4GzffwqtiM6oiRdgnapX8UP8XbkEbY/GXGJyFDY3pTL7Oi7KxLSu/6NQSOMs3dYn
         fyBXEI/EndXBTtrgckjLcEytlcvI2OKVJ5oR+TWM=
Date:   Thu, 3 Jun 2021 19:38:40 +0200
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
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: Re: [PATCH v35 0/4] scsi: ufs: Add Host Performance Booster Support
Message-ID: <YLkToPuEUa1waK6f@kroah.com>
References: <CGME20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
 <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 24, 2021 at 05:43:45PM +0900, Daejun Park wrote:
> Changelog:
> 
> v34 -> v35
> 1. Addressed Bart's comments (type casting)
> 2. Rebase 5.14 scsi-queue

This looks semi-sane.  What's preventing this from being merged?  It's a
ratified spec, and there is hardware out there that has it, so Linux
should support it, right?

thanks,

greg k-h
