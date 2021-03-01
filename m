Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBBBC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A810164E3F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhCAHQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:16:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:58640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232224AbhCAHQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:16:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A103AAFF6;
        Mon,  1 Mar 2021 07:16:09 +0000 (UTC)
Subject: Re: [PATCH 18/24] mpi3mr: add complete support of soft reset
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-19-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <60c6c145-4ff2-d745-a09c-f11d6a648caa@suse.de>
Date:   Mon, 1 Mar 2021 08:16:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-19-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Unlock the host diagnostic registers and write the specific
> reset type to that, wait for reset acknowledgment from the
> controller, if the reset is not successful retry for the
> predefined number of times
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
>   drivers/scsi/mpi3mr/mpi3mr_fw.c | 245 +++++++++++++++++++++++++++++++-
>   2 files changed, 246 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
