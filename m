Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0352C63798
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B6FD223B0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 07:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgKTHQj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 02:16:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:44860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgKTHQi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 02:16:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8DA7CAB3D;
        Fri, 20 Nov 2020 07:16:36 +0000 (UTC)
Subject: Re: [PATCH v1 1/3] add io_uring with IOPOLL support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org
References: <20201015133633.61836-1-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <63d3110f-85c3-5b8d-7fbf-234ea1201980@suse.de>
Date:   Fri, 20 Nov 2020 08:16:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201015133633.61836-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/20 3:36 PM, Kashyap Desai wrote:
> io_uring with IOPOLL is not currently supported in scsi mid layer.
> Outside of that everything else should work and no extra support in the driver is needed.
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
