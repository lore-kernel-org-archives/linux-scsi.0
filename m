Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDAACA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED99217D9
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfKAQkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:40:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:44616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727426AbfKAQkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Nov 2019 12:40:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB6D6B3BD;
        Fri,  1 Nov 2019 16:40:06 +0000 (UTC)
Subject: Re: [PATCH 04/24] acornscsi: use standard defines
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-5-hare@suse.de>
 <6cb47b1f-1468-9abe-7da4-a22c2b7c6454@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <678538e3-a613-00e3-9c0a-0e0dccf414b8@suse.de>
Date:   Fri, 1 Nov 2019 17:40:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6cb47b1f-1468-9abe-7da4-a22c2b7c6454@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/19 5:18 PM, Bart Van Assche wrote:
> On 10/31/19 4:04 AM, Hannes Reinecke wrote:
>> Use midlayer-defined values and drop the non-existing QUEUE_FULL
>> case.
>>
>> [ ... ]
>> -    case QUEUE_FULL:
>> -    /* TODO: target queue is full */
>> -    break;
> 
> Please clarify in the commit message why it is OK to drop this code.
> 
Because QUEUE_FULL doesn't exist in this context; QUEUE_FULL is a SCSI 
status, but the switch is checking SCSI messages.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
