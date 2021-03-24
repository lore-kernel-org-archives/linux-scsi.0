Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E221C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 21:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685D261A13
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 21:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhCXVzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbhCXVzt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 17:55:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE27C06174A;
        Wed, 24 Mar 2021 14:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=XUb+BQanDBoDTDTC63k606fqfZtavrU2Q8tHp0ZZT2g=; b=J0CwAq6eEwi7Ph3FZkUtCZIBW7
        v0HOzn9n3VL5O+v0lR7yu2WEw11rGGvz/LPf2kT3nnYLUW/b7m+gKydSODJTnxRmXGujpNen+Ooew
        sQjYXK3uYAHorSeqdHs4Q22QF2To/5T7eEuWC9l9aSprXjki1jgBujNSsxnr2DB5TyvnfQ5vF39u6
        JOxx7FUlDKwR21CkjWi4D98yYOPllsuRdegjEnSsRbGlb3ntmGi3SDkWB8U3WSi9YnMTfN29fizaV
        MWZhYxGA2tk2XW/6J4WNNkGj+ksCGqcSkL0qnhjWp9wrUFOl69VSPIizG0d9mA2R1EZ0PkNqF8D4a
        /YIB3q/g==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPBTZ-000GGP-IT; Wed, 24 Mar 2021 21:55:46 +0000
Subject: Re: [PATCH] scsi: esp_scsi: Trivial typo fixes
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210324061318.5744-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3d732769-e4f3-e5d8-e848-101ccff9eab7@infradead.org>
Date:   Wed, 24 Mar 2021 14:55:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210324061318.5744-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/21 11:13 PM, Bhaskar Chowdhury wrote:
> 
> s/conditon/condition/
> s/pecularity/peculiarity/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/scsi/esp_scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 007ccef5d1e2..342535ac0570 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -647,7 +647,7 @@ static void esp_unmap_sense(struct esp *esp, struct esp_cmd_entry *ent)
>  	ent->sense_ptr = NULL;
>  }
> 
> -/* When a contingent allegiance conditon is created, we force feed a
> +/* When a contingent allegiance condition is created, we force feed a
>   * REQUEST_SENSE command to the device to fetch the sense data.  I
>   * tried many other schemes, relying on the scsi error handling layer
>   * to send out the REQUEST_SENSE automatically, but this was difficult
> @@ -1341,7 +1341,7 @@ static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
>  	bytes_sent -= esp->send_cmd_residual;
> 
>  	/*
> -	 * The am53c974 has a DMA 'pecularity'. The doc states:
> +	 * The am53c974 has a DMA 'peculiarity'. The doc states:
>  	 * In some odd byte conditions, one residual byte will
>  	 * be left in the SCSI FIFO, and the FIFO Flags will
>  	 * never count to '0 '. When this happens, the residual
> --


-- 
~Randy

