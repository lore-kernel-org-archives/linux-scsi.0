Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA48C38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 08:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3713207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 08:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgEGIa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 04:30:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:38152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGIa2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 04:30:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 950ECAE72;
        Thu,  7 May 2020 08:30:29 +0000 (UTC)
Subject: Re: [PATCH v5 09/11] qla2xxx: Change {RD,WRT}_REG_*() function names
 from upper case into lower case
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200507042835.9135-1-bvanassche@acm.org>
 <20200507042835.9135-10-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d0ddc364-6f02-c18f-d08b-c5e0341d1882@suse.de>
Date:   Thu, 7 May 2020 10:30:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507042835.9135-10-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/7/20 6:28 AM, Bart Van Assche wrote:
> This was suggested by Daniel Wagner.
> 
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.c    | 582 +++++++++++++++---------------
>   drivers/scsi/qla2xxx/qla_def.h    |  30 +-
>   drivers/scsi/qla2xxx/qla_init.c   | 205 ++++++-----
>   drivers/scsi/qla2xxx/qla_inline.h |   6 +-
>   drivers/scsi/qla2xxx/qla_iocb.c   |  64 ++--
>   drivers/scsi/qla2xxx/qla_isr.c    | 128 +++----
>   drivers/scsi/qla2xxx/qla_mbx.c    |  74 ++--
>   drivers/scsi/qla2xxx/qla_mr.c     |  94 ++---
>   drivers/scsi/qla2xxx/qla_mr.h     |  24 +-
>   drivers/scsi/qla2xxx/qla_nvme.c   |   4 +-
>   drivers/scsi/qla2xxx/qla_nx.c     |  68 ++--
>   drivers/scsi/qla2xxx/qla_nx2.c    |  12 +-
>   drivers/scsi/qla2xxx/qla_os.c     |  26 +-
>   drivers/scsi/qla2xxx/qla_sup.c    | 270 +++++++-------
>   drivers/scsi/qla2xxx/qla_target.c |  10 +-
>   drivers/scsi/qla2xxx/qla_tmpl.c   |   8 +-
>   16 files changed, 802 insertions(+), 803 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
