Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0340EC28CBC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9B3206D5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgEFNmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 09:42:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:53040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgEFNmG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 May 2020 09:42:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4FADEAD26;
        Wed,  6 May 2020 13:42:07 +0000 (UTC)
Subject: Re: [PATCH v4 03/11] qla2xxx: Sort BUILD_BUG_ON() statements
 alphabetically
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-4-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <48f73c51-e654-0b22-8db2-2418f24f684f@suse.de>
Date:   Wed, 6 May 2020 15:42:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/20 5:03 AM, Bart Van Assche wrote:
> Before adding more BUILD_BUG_ON() statements, sort the existing statements
> alphabetically.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d190db5ea7d9..497544413aa0 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7835,11 +7835,11 @@ qla2x00_module_init(void)
>   	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
>   	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
>   	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
> +	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
> +	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
>   	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
>   	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
>   	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
> -	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> -	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>   
>   	/* Allocate cache for SRBs. */
>   	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
