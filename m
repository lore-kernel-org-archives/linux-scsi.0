Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE56C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C071764E3F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhCAH0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:26:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:33710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232348AbhCAH02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:26:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07D5BAAC5;
        Mon,  1 Mar 2021 07:25:47 +0000 (UTC)
Subject: Re: [PATCH v5 02/31] elx: libefc_sli: SLI Descriptors and Queue
 entries
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-3-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6c7adf4d-703a-3eb4-e02a-312c28b99a31@suse.de>
Date:   Mon, 1 Mar 2021 08:25:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210103171134.39878-3-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/3/21 6:11 PM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch add SLI-4 Data structures and defines for:
> - Buffer Descriptors (BDEs)
> - Scatter/Gather List elements (SGEs)
> - Queues and their Entry Descriptions for:
>     Event Queues (EQs), Completion Queues (CQs),
>     Receive Queues (RQs), and the Mailbox Queue (MQ).
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> ---
>   drivers/scsi/elx/include/efc_common.h |   25 +
>   drivers/scsi/elx/libefc_sli/sli4.h    | 1776 +++++++++++++++++++++++++
>   2 files changed, 1801 insertions(+)
>   create mode 100644 drivers/scsi/elx/include/efc_common.h
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
