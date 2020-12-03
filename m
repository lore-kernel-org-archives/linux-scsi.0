Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D849AC83013
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C3C20872
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbgLCM6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 07:58:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:41626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730628AbgLCM6w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Dec 2020 07:58:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E203DAC65;
        Thu,  3 Dec 2020 12:58:10 +0000 (UTC)
Subject: Re: [PATCH v2 3/4] scsi_debug : iouring iopoll support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     dgilbert@interlog.com, linux-block@vger.kernel.org
References: <20201203034100.29716-1-kashyap.desai@broadcom.com>
 <20201203034100.29716-4-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <53469128-7250-adc4-b581-309e7f861372@suse.de>
Date:   Thu, 3 Dec 2020 13:58:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203034100.29716-4-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/20 4:40 AM, Kashyap Desai wrote:
> Add support of iouring iopoll interface in scsi_debug.
> This feature requires shared hosttag support in kernel and driver.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Tested-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> Cc: dgilbert@interlog.com
> Cc: linux-block@vger.kernel.org
> ---
>   drivers/scsi/scsi_debug.c | 130 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 130 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
