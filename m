Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB856C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92176207DD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgELGNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 02:13:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:51458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgELGNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 02:13:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83342AC84;
        Tue, 12 May 2020 06:13:09 +0000 (UTC)
Subject: Re: [PATCH v5 12/15] qla2xxx: Cast explicitly to uint16_t / uint32_t
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200511200946.7675-1-bvanassche@acm.org>
 <20200511200946.7675-13-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9114a1c6-47a3-3d48-613c-6f471d6bfc70@suse.de>
Date:   Tue, 12 May 2020 08:13:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200511200946.7675-13-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/20 10:09 PM, Bart Van Assche wrote:
> Casting a pointer to void * and relying on an implicit cast from void *
> to uint16_t or uint32_t suppresses sparse warnings about endianness. Hence
> cast explicitly to uint16_t and uint32_t. Additionally, remove superfluous
> void * casts.
> 
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.c    |  4 ++--
>   drivers/scsi/qla2xxx/qla_init.c   | 26 +++++++++++++-------------
>   drivers/scsi/qla2xxx/qla_mbx.c    |  6 +++---
>   drivers/scsi/qla2xxx/qla_mid.c    |  4 ++--
>   drivers/scsi/qla2xxx/qla_mr.c     |  4 ++--
>   drivers/scsi/qla2xxx/qla_nvme.c   |  4 ++--
>   drivers/scsi/qla2xxx/qla_nx2.c    |  4 ++--
>   drivers/scsi/qla2xxx/qla_os.c     | 10 +++++-----
>   drivers/scsi/qla2xxx/qla_sup.c    | 12 ++++++------
>   drivers/scsi/qla2xxx/qla_target.c |  4 ++--
>   10 files changed, 39 insertions(+), 39 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
