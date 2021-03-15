Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE71C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 02:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A4A364E5C
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 02:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhCOCZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Mar 2021 22:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhCOCZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Mar 2021 22:25:26 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DCBC061574;
        Sun, 14 Mar 2021 19:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Zo25TViFb81hk3lk4Uw9qQi3ea6GhYd1rPSkag+BnRc=; b=GlMnf2+kuE1WGmRpU22/CTRWYP
        qOCHzzAbZ8v+xxmcn8RxJi/7MlKBRewgV13BUDaapGvPHY9D1hfGtHchO9vpvg6TyQvV2CKj9L4lO
        /+Nvv8PToafMk8+cj8XD0LrFyQ/+roVwtzuJhBAYCfEE8sC9nfvkeRKrBWW4XzPyTvqoDWyqLuU0C
        kOpyMgLaafOu1ZGqkrJGL8HD5fhY6jCyUqRUxU/N2G1sCHbOnykrEvhFBLpAOcQKc6LG7JUiQDAFR
        3WDNIlSymKF2ZYmW8nwRRQkNOABmdIpEdXm/ESoUzLyDX10F+umq4j6SNa4fZjO2ycf9u+dz7R5bb
        Z8jDgLkg==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lLcur-001FO4-EC; Mon, 15 Mar 2021 02:25:18 +0000
Subject: Re: [PATCH] scsi: Mundane spelling fixes in the file qla1280.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, mdr@sgi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315021610.2089087-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <410164a3-d00f-f2bf-3eb2-49a163add143@infradead.org>
Date:   Sun, 14 Mar 2021 19:25:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315021610.2089087-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/14/21 7:16 PM, Bhaskar Chowdhury wrote:
> 
> s/quantites/quantities/
> s/Unfortunely/Unfortunately/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  drivers/scsi/qla1280.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 46de2541af25..95008811b2d2 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -633,13 +633,13 @@ static int qla1280_read_nvram(struct scsi_qla_host *ha)
>  	 * to be read a word (two bytes) at a time.
>  	 *
>  	 * The net result of this would be that the word (and
> -	 * doubleword) quantites in the firmware would be correct, but
> +	 * doubleword) quantities in the firmware would be correct, but
>  	 * the bytes would be pairwise reversed.  Since most of the
> -	 * firmware quantites are, in fact, bytes, we do an extra
> +	 * firmware quantities are, in fact, bytes, we do an extra
>  	 * le16_to_cpu() in the firmware read routine.
>  	 *
>  	 * The upshot of all this is that the bytes in the firmware
> -	 * are in the correct places, but the 16 and 32 bit quantites
> +	 * are in the correct places, but the 16 and 32 bit quantities
>  	 * are still in little endian format.  We fix that up below by
>  	 * doing extra reverses on them */
>  	nv->isp_parameter = cpu_to_le16(nv->isp_parameter);
> @@ -687,7 +687,7 @@ qla1280_info(struct Scsi_Host *host)
>   * The mid-level driver tries to ensures that queuecommand never gets invoked
>   * concurrently with itself or the interrupt handler (although the
>   * interrupt handler may call this routine as part of request-completion
> - * handling).   Unfortunely, it sometimes calls the scheduler in interrupt
> + * handling).   Unfortunately, it sometimes calls the scheduler in interrupt
>   * context which is a big NO! NO!.
>   **************************************************************************/
>  static int
> --


-- 
~Randy

