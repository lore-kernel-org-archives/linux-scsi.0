Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A285C4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46CB524672
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBZW61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:58:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:57576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgBZW61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:58:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 932DAAD94;
        Wed, 26 Feb 2020 22:58:25 +0000 (UTC)
Subject: Re: [PATCH 02/13] scsi: add scsi_host_complete_all_commands() helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200213140422.128382-1-hare@suse.de>
 <20200213140422.128382-3-hare@suse.de> <20200226173952.GA23141@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ad993d68-cfba-8267-bd48-c33b0df3daeb@suse.de>
Date:   Wed, 26 Feb 2020 23:58:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226173952.GA23141@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/20 6:39 PM, Christoph Hellwig wrote:
> On Thu, Feb 13, 2020 at 03:04:11PM +0100, Hannes Reinecke wrote:
>>   extern void scsi_host_put(struct Scsi_Host *t);
>>   extern struct Scsi_Host *scsi_host_lookup(unsigned short);
>>   extern const char *scsi_host_state_name(enum scsi_host_state);
>> +extern void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status);
> 
> This adds an > 80 char line.  And externs on function declarations in
> headers are never needed anyway.
> 
As for the "extern": I'm just following what all the other function 
declarations in the header file do.

If your argument is valid it would apply to all declarations in this 
file, not just this one.
And that would be a separate patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
