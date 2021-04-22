Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3FDC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 08:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE2F61417
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 08:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhDVIxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 04:53:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:48810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhDVIxU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 04:53:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 295EFB040;
        Thu, 22 Apr 2021 08:52:45 +0000 (UTC)
Subject: Re: [PATCH 18/42] dc395: use standard macros to set SCSI result
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-19-hare@suse.de>
 <d92fd9b0-c10d-a3a3-99ba-e4d34e0888a0@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c99025f2-eb24-87ca-61be-97ca11f8945d@suse.de>
Date:   Thu, 22 Apr 2021 10:52:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d92fd9b0-c10d-a3a3-99ba-e4d34e0888a0@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 12:26 AM, Bart Van Assche wrote:
> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>> Use standard macros to set the SCSI result and drop the internal ones.
> 
> This patch looks almost identical to a patch from my patch series?
> 
That might well be; please do note that this patch is from the previous 
version and is dated January 2021, with a previous version dating back 
to mid-2019. I just didn't check your patchset for duplicates, sorry.

Hence the 'RFC' bit :-)

But if you insist I can fold your patch into this series and drop mine.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
