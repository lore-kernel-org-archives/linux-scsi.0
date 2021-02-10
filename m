Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458ACC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 21:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B2F64E32
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 21:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhBJU76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 15:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBJU75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 15:59:57 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621F4C06174A;
        Wed, 10 Feb 2021 12:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=9IRtNqEmK8Laefd+/4Ewdw8Hx7Xiy1aEskWzH6jRsIU=; b=apJMwiwwQiyxEeakKKM35sEEpp
        TqDhuh2JkGfyfE+v6rm1NDGbP7fTI/kwDaVioxWbwnVNM/sk/h5Hc8YlkRerphKRgPvWAEmyX7tv7
        +5/s6opzHhga9VTbn3OJ6x3nvtWbmfGu88qFLYcaCUK+F7LUUTyZyA5HYvjEBeTAX7yeTjYjYFakh
        Eh07w3+TZFmDk0R3F+BGkZr0Wr6qrEePK/f96y+fLWMTI+VJaHKdAwsLDrBeGuTOuKA/GqRqGubD1
        bdFI6uVWvI+PcXxM8WFOFtuWb/t+qUspqwV+2iVY1cvbapaZdvNRaS+oZaQeXvyAK3+VYZT7hJUle
        xTkRkdXg==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9wZu-0004OD-TH; Wed, 10 Feb 2021 20:59:15 +0000
Subject: Re: [PATCH] drivers: scsi: aic7xxx: Fix the spelling verson to
 version in the file aic79xx.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, hare@suse.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210209143146.3987352-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1737dbee-40ea-41f4-8453-38b7c435290c@infradead.org>
Date:   Wed, 10 Feb 2021 12:59:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209143146.3987352-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 6:31 AM, Bhaskar Chowdhury wrote:
> 
> s/verson/version/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  drivers/scsi/aic7xxx/aic79xx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
> index dd5dfd4f30a5..c31e48fcebc7 100644
> --- a/drivers/scsi/aic7xxx/aic79xx.h
> +++ b/drivers/scsi/aic7xxx/aic79xx.h
> @@ -1175,7 +1175,7 @@ struct ahd_softc {
>  	uint8_t			  tqinfifonext;
> 
>  	/*
> -	 * Cached verson of the hs_mailbox so we can avoid
> +	 * Cached version of the hs_mailbox so we can avoid
>  	 * pausing the sequencer during mailbox updates.
>  	 */
>  	uint8_t			  hs_mailbox;
> --


-- 
~Randy

