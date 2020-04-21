Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EF8C55182
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 05:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95846208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 05:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDUFpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 01:45:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:41188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgDUFpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 01:45:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B660AA55;
        Tue, 21 Apr 2020 05:45:22 +0000 (UTC)
Subject: Re: [PATCH] scsi: fcoe: remove unneeded semicolon in fcoe.c
To:     Jason Yan <yanaijie@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, zhengbin13@huawei.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200421034008.27865-1-yanaijie@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e25d02bd-101a-724a-e4e8-2686efc9a6ff@suse.de>
Date:   Tue, 21 Apr 2020 07:45:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421034008.27865-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/20 5:40 AM, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> drivers/scsi/fcoe/fcoe.c:1918:3-4: Unneeded semicolon
> drivers/scsi/fcoe/fcoe.c:1930:3-4: Unneeded semicolon
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/fcoe/fcoe.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 25dae9f0b205..cb41d166e0c0 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1915,7 +1915,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
>   		case FCOE_CTLR_ENABLED:
>   		case FCOE_CTLR_UNUSED:
>   			fcoe_ctlr_link_up(ctlr);
> -		};
> +		}
>   	} else if (fcoe_ctlr_link_down(ctlr)) {
>   		switch (cdev->enabled) {
>   		case FCOE_CTLR_DISABLED:
> @@ -1927,7 +1927,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
>   			stats->LinkFailureCount++;
>   			put_cpu();
>   			fcoe_clean_pending_queue(lport);
> -		};
> +		}
>   	}
>   out:
>   	return rc;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
