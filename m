Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9504C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 19:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A628B61934
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 19:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCVTl4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 15:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCVTlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 15:41:37 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E7C061574;
        Mon, 22 Mar 2021 12:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=+64LpoByvW5my2Y2IrRfb8I9wyVK6JAmt3RKeaYu5to=; b=YKD3eVLi8cNanRsSkiIfYA3EHF
        jIRASZ/qXtv+icpJ8c/SToCVDMKeblpUEN7lzvwSJVM763wiUCENKfJiy9wbGYG2pyOJ/p1HCK4tE
        WD1P6ynqVlhlQWzHD7iF8tRMKFkgLcIrTta7F77YN/qeyjVfPTCc3uNkqnUCiG9yrfpPrsit7UoDX
        GnR24dATBDgYTplKsPhnBWM8IxxHVwLJ1tEBfSQwBekBrzLOYVeiuPnLeJkIxGAaDLCgD496wo8Sf
        AHCqbyLPeOJgxmZjPZwJ7nlaaNS2dBiCYhgaThtDwbm5weOv3jTCkXaHpgr60WAY04dFlwS9IMg+Y
        KKfEfshg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOQQg-00CRm9-RQ; Mon, 22 Mar 2021 19:41:35 +0000
Subject: Re: [PATCH] scsi: scsi_dh: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322064724.4108343-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <676f6274-6149-694b-80aa-99ce06089e03@infradead.org>
Date:   Mon, 22 Mar 2021 12:41:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322064724.4108343-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/21/21 11:47 PM, Bhaskar Chowdhury wrote:
> 
> s/infrastruture/infrastructure/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Please combine the 2 scsi_dh patches.

> ---
>  drivers/scsi/scsi_dh.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 6f41e4b5a2b8..7b56e00c7df6 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  /*
> - * SCSI device handler infrastruture.
> + * SCSI device handler infrastructure.
>   *
>   * Copyright IBM Corporation, 2007
>   *      Authors:
> --


-- 
~Randy

