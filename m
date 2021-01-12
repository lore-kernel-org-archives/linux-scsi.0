Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB80FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70C392312F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391743AbhALPk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:40:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:60784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391706AbhALPk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 10:40:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1D49AF24;
        Tue, 12 Jan 2021 15:39:44 +0000 (UTC)
Subject: Re: [PATCH 3/3] aha1542: fix multi-line comment style
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
 <08c231e5-d86f-9d0b-19ac-ad46fa0c0b58@omprussia.ru>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9f6278b6-7aa1-a867-e8b1-772e5bf1a02e@suse.de>
Date:   Tue, 12 Jan 2021 16:39:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <08c231e5-d86f-9d0b-19ac-ad46fa0c0b58@omprussia.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/10/21 5:49 PM, Sergey Shtylyov wrote:
> Some comments in this driver don't comply with the preferred multi-line
> comment style, as reported by 'scripts/checkpatch.pl':
> 
> WARNING: Block comments use * on subsequent lines
> WARNING: Block comments use a trailing */ on a separate line
> 
> Fix those comments, along with the (unreported for some reason?) starts
> of the multi-line comments not being /* on their own line...
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> ---
>   drivers/scsi/aha1542.c |  119 ++++++++++++++++++++++++++++++-------------------
>   1 file changed, 75 insertions(+), 44 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
