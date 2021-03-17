Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AB5C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14E7064EF9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhCQR2t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhCQR2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 13:28:22 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09830C06174A;
        Wed, 17 Mar 2021 10:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=ertBtedytz3hAjMR2bAzMjCqr8kS1rZsmb66swK6fUQ=; b=t2NWRgGsQdPuahOpe/+HPUMUW7
        dFAC1JCC1dmo6wYV5XRE2PP84xw49Eq3+2Gh9nap3px6/o7TaumLNfdhtvW8BGweTGnLF4UVzRoAw
        nRcB2z4uQD1zz3J7v625WAjeyjuHxGXDj5WEKlvcuPS5GACtBchZ3gP3zMRqrQBctuFXhU82Zua0B
        A6zNa0inHXYoSQh6CjT6I4qkw62YuDTM0QuFBu8GWl1R8SNqqDHYQx7LeTUFVwK9IqhnDjO+dQW4l
        EOrCvmaOC0w6mrnnxurQdpngDDfv/St/N+yVoQjEHTr97yZkPZ6zRdKR6CheJNrRDRPVa0y63HYT0
        AMsknf6A==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMZxy-001fQy-Ki; Wed, 17 Mar 2021 17:28:19 +0000
Subject: Re: [PATCH] message: fusion: Fix a typo in the file mptbase.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210317101238.2627574-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <19223085-837e-a538-1769-626c0aaf7601@infradead.org>
Date:   Wed, 17 Mar 2021 10:28:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317101238.2627574-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 3:12 AM, Bhaskar Chowdhury wrote:
> 
> s/contets/contents/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/message/fusion/mptbase.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
> index 813d46311f6a..b9e0376be723 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -274,7 +274,7 @@ typedef union _MPT_FRAME_TRACKER {
>  	} linkage;
>  	/*
>  	 * NOTE: When request frames are free, on the linkage structure
> -	 * contets are valid.  All other values are invalid.
> +	 * contents are valid.  All other values are invalid.
>  	 * In particular, do NOT reply on offset [2]
>  	 * (in words) being the * message context.
>  	 * The message context must be reset (computed via base address
> --


-- 
~Randy

