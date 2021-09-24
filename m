Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51737C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 07:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255C461090
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 07:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244488AbhIXHzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 03:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237965AbhIXHzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Sep 2021 03:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C556D60E08;
        Fri, 24 Sep 2021 07:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632470026;
        bh=8fYqoGbv6rGS8iVOoENK8YwHUh1U+eyzXgXgigADj5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mmqy6hd5halkLt+zBUSO+MlyGLfLh4NSclOuLs/00RG06D8yZ8xKdMmdgzTpjfbgL
         vxsmptE+CcKnwyohx0YR2UgAD6StsJ3w3PWDKkcAGkFHxiY8Rwa8b9qLftraC9FlnJ
         du0xBqRGTkBvVTTdpEuUFAATJASgb9kzlaNUFtCA=
Date:   Fri, 24 Sep 2021 09:53:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Hsu <jonathan.hsu@mediatek.com>
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        stable@vger.kernel.org, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        powen.kao@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        wsd_upstream@mediatek.com
Subject: Re: [PATCH v1 1/1] scsi: ufs: Fix illegal address reading in upiu
 event trace
Message-ID: <YU2ECLeyfbe7gjFA@kroah.com>
References: <20210924073309.6656-1-jonathan.hsu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924073309.6656-1-jonathan.hsu@mediatek.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 03:33:09PM +0800, Jonathan Hsu wrote:
> Fix incorrect index for UTMRD reference in ufshcd_add_tm_upiu_trace().
> 
> Fixes: 4b42d557a8ad ("scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs")
> Signed-off-by: Jonathan Hsu <jonathan.hsu@mediatek.com>
> Change-Id: I9acab6f3223f96d864948bb5670759d58cf92ad6
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Also, always run checkpatch.pl on your patches, it will show you that
the "Change-Id" field is not valid here.

thanks,

greg k-h
