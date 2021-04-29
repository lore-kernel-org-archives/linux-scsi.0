Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43648C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 07:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E705961431
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 07:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhD2Had (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 03:30:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:50926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhD2HaS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 03:30:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB9CBB038;
        Thu, 29 Apr 2021 07:29:06 +0000 (UTC)
Subject: Re: [PATCH 40/40] scsi: drop obsolete linux-specific SCSI status
 codes
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20210427083046.31620-1-hare@suse.de>
 <20210427083046.31620-41-hare@suse.de> <20210429064837.GA2882@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <80d383b4-fb9c-1e67-d578-9e8a35bb1e6d@suse.de>
Date:   Thu, 29 Apr 2021 09:29:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429064837.GA2882@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/29/21 8:48 AM, Christoph Hellwig wrote:
> On Tue, Apr 27, 2021 at 10:30:46AM +0200, Hannes Reinecke wrote:
>> +/*
>> + *  Original linux SCSI Status codes. They are shifted 1 bit right
>> + *  from those found in the SCSI standards.
>> + */
>> +
>> +#define GOOD                 0x00
>> +#define CHECK_CONDITION      0x01
>> +#define CONDITION_GOOD       0x02
>> +#define BUSY                 0x04
>> +#define INTERMEDIATE_GOOD    0x08
>> +#define INTERMEDIATE_C_GOOD  0x0a
>> +#define RESERVATION_CONFLICT 0x0c
>> +#define COMMAND_TERMINATED   0x11
>> +#define QUEUE_FULL           0x14
>> +#define ACA_ACTIVE           0x18
>> +#define TASK_ABORTED         0x20
> 
> I don't think there is any need to keep defining them, is there?
> 
Probably not. I'll drop them for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
