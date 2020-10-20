Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82854C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 06:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6D82237B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 06:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404620AbgJTG6k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 02:58:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:40404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404609AbgJTG6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 02:58:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 219F2AEEE;
        Tue, 20 Oct 2020 06:58:39 +0000 (UTC)
Subject: Re: [PATCH v4 24/31] elx: efct: SCSI IO handling routines
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-25-james.smart@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <15965448-0726-abf8-f53c-472948062b61@suse.de>
Date:   Tue, 20 Oct 2020 08:58:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012225147.54404-25-james.smart@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/20 12:51 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines for SCSI transport IO alloc, build and send IO.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> v4:
>    Changes to reduce function params for efct_hw_io_send
> ---
>   drivers/scsi/elx/efct/efct_scsi.c | 1164 +++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_scsi.h |  214 ++++++
>   2 files changed, 1378 insertions(+)
>   create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
>   create mode 100644 drivers/scsi/elx/efct/efct_scsi.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
