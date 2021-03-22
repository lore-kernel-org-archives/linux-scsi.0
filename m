Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6215CC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 22:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C1F61934
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 22:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCVWnV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 18:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhCVWnR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 18:43:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A911FC061574;
        Mon, 22 Mar 2021 15:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=9YTzv0k/0bqNaGXA3Rty/m7xcWWiXCK/jySxxAF8xE8=; b=nJzak8UpA+b/ADMuG7IP1dMbb9
        x+pFVQM3dVMUps/rCCi18MlVTl26xTJ89QgD8tu6gML3aihBncnVqWa2EMxbXj5OxtB49tCSVMeKG
        fOZz8kMq7IaVjVH4RV0SUM0Jv7Ly5TmkdJNadFGPSZvttXTTwcPtmRuaQbRSbZbQFlfLxK/oWN7uQ
        HbNWK+nrHt+Wk7ggpN09mnNhCnLECb8/uECujxRbMRt41oRGKE/0oq6Ja6h+hgdQXyW5wU2LrXils
        6pC06at4t9tsZPpNbgH9OeIxfG4Kj3jAFTLCckJavfIBVWqHQ4brv5gH/LfEsADfZ7XOp320Rzy2B
        UdDoDzQA==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOTGK-009BPM-Cx; Mon, 22 Mar 2021 22:43:07 +0000
Subject: Re: [PATCH] scsi: bfa: Fix a typo in two places
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210322205821.1449844-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d9f3d7e5-4a52-6f93-1db4-6ef9cf93b736@infradead.org>
Date:   Mon, 22 Mar 2021 15:43:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322205821.1449844-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 1:58 PM, Bhaskar Chowdhury wrote:
> 
> s/defintions/definitions/  ....two different places.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/scsi/bfa/bfa_fc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
> index d536270bbe9f..0314e4b9e1fb 100644
> --- a/drivers/scsi/bfa/bfa_fc.h
> +++ b/drivers/scsi/bfa/bfa_fc.h
> @@ -1193,7 +1193,7 @@ enum {
>  };
> 
>  /*
> - * defintions for CT reason code
> + * definitions for CT reason code
>   */
>  enum {
>  	CT_RSN_INV_CMD		= 0x01,
> @@ -1240,7 +1240,7 @@ enum {
>  };
> 
>  /*
> - * defintions for the explanation code for all servers
> + * definitions for the explanation code for all servers
>   */
>  enum {
>  	CT_EXP_AUTH_EXCEPTION		= 0xF1,
> --


-- 
~Randy

