Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1BBC38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 08:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F36E2080D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 08:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgEGIbK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 04:31:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:38562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGIbK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 04:31:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F6F3ADC2;
        Thu,  7 May 2020 08:31:12 +0000 (UTC)
Subject: Re: [PATCH v5 10/11] qla2xxx: Fix endianness annotations in header
 files
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
 <20200507042835.9135-11-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <141e8525-f7bf-97b9-dfca-e938ab17d002@suse.de>
Date:   Thu, 7 May 2020 10:31:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507042835.9135-11-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/7/20 6:28 AM, Bart Van Assche wrote:
> Annotate members of FC protocol and firmware dump data structures as big
> endian. Annotate members of RISC control structures as little endian.
> Annotate mailbox registers as little endian. Annotate the mb[] arrays as
> CPU-endian because communication of the mb[] values with the hardware
> happens through the readw() and writew() functions. readw() converts from
> __le16 to u16 and writew() converts from u16 to __le16.
> 
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.h    | 444 +++++++++---------
>   drivers/scsi/qla2xxx/qla_def.h    | 646 +++++++++++++-------------
>   drivers/scsi/qla2xxx/qla_fw.h     | 738 +++++++++++++++---------------
>   drivers/scsi/qla2xxx/qla_inline.h |   2 +-
>   drivers/scsi/qla2xxx/qla_mr.h     |   8 +-
>   drivers/scsi/qla2xxx/qla_nvme.h   |  46 +-
>   drivers/scsi/qla2xxx/qla_nx.h     |  36 +-
>   drivers/scsi/qla2xxx/qla_target.h | 208 ++++-----
>   8 files changed, 1064 insertions(+), 1064 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
