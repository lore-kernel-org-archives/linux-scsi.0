Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4D0C8301D
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B473022206
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 12:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbgLCMvn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 07:51:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:37796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730604AbgLCMvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Dec 2020 07:51:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35897AC2E;
        Thu,  3 Dec 2020 12:51:01 +0000 (UTC)
Subject: Re: [PATCH v2 1/4] add io_uring with IOPOLL support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org
References: <20201203034100.29716-1-kashyap.desai@broadcom.com>
 <20201203034100.29716-2-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1aeeff21-fc84-3893-7613-ae9eafb3d4cb@suse.de>
Date:   Thu, 3 Dec 2020 13:51:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203034100.29716-2-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/20 4:40 AM, Kashyap Desai wrote:
> io_uring with IOPOLL is not currently supported in scsi mid layer.
> Outside of that everything else should work and no extra support
> in the driver is needed.
> 
> Currently io_uring with IOPOLL support is only available in block layer.
> This patch is to extend support of mq_poll in scsi layer.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sumit.saxena@broadcom.com
> Cc: chandrakanth.patil@broadcom.com
> Cc: linux-block@vger.kernel.org
> 
> ---
>   drivers/scsi/scsi_lib.c  | 16 ++++++++++++++++
>   include/scsi/scsi_cmnd.h |  1 +
>   include/scsi/scsi_host.h | 11 +++++++++++
>   3 files changed, 28 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
