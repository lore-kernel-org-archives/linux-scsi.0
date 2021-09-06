Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8AFC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D41AF6101C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbhIFIiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 04:38:46 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45764 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240795AbhIFIip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 04:38:45 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 83F5A20097;
        Mon,  6 Sep 2021 08:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630917460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDWTkN/8N4YbWG6A9aGwqWMdZM1Fue9ARJ1BdfJp51E=;
        b=DZgNLRcfHylemuHQk9jhLJNru7VzIeyS/4JSNukBkFXTgpjO/2cbO0dL0R77YpO5sa7UIa
        HwB8oLFewdXF0VUlsrcflXEMGdvMA6HFYe23g6EfZsoH1/Uc28OjXApC1MIE3TAY1PUAl9
        TwEPJvrfECL70go96ofMpNBIJaVyyek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630917460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDWTkN/8N4YbWG6A9aGwqWMdZM1Fue9ARJ1BdfJp51E=;
        b=BpZE0edEBNBC0qQpimgUQTWyra3WkVADC1+kuDSHczhDYrLkSSLSDK7vzE+xPPcY7PZZQJ
        Xxlhz2f/w13iikCw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 60B7713299;
        Mon,  6 Sep 2021 08:37:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id XVq7FVTTNWF1cAAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 06 Sep 2021 08:37:40 +0000
Subject: Re: [PATCH v7 5/5] doc: Fix typo in request queue sysfs documentation
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
 <20210906015810.732799-6-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c8c2ec8c-9c51-323d-913d-d9e20ecb8f16@suse.de>
Date:   Mon, 6 Sep 2021 10:37:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210906015810.732799-6-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/21 3:58 AM, Damien Le Moal wrote:
> Fix a typo (are -> as) in the introduction paragraph of
> Documentation/block/queue-sysfs.rst.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   Documentation/block/queue-sysfs.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
> index b6e8983d8eda..e8c74306f70a 100644
> --- a/Documentation/block/queue-sysfs.rst
> +++ b/Documentation/block/queue-sysfs.rst
> @@ -4,7 +4,7 @@ Queue sysfs files
>   
>   This text file will detail the queue files that are located in the sysfs tree
>   for each block device. Note that stacked devices typically do not export
> -any settings, since their queue merely functions are a remapping target.
> +any settings, since their queue merely functions as a remapping target.
>   These files are the ones found in the /sys/block/xxx/queue/ directory.
>   
>   Files denoted with a RO postfix are readonly and the RW postfix means
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
