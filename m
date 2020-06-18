Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822EAC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 09:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA6A214DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 09:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgFRJQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 05:16:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:37722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbgFRJQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 05:16:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 371CEADC8;
        Thu, 18 Jun 2020 09:16:00 +0000 (UTC)
Subject: Re: [PATCH 1/4] gdth: reindent and whitespace cleanup
To:     Christoph Hellwig <hch@lst.de>
Cc:     Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200616121821.99113-1-hare@suse.de>
 <20200616121821.99113-2-hare@suse.de>
 <20200617082145.mdsu56bclo3p3dg4@beryllium.lan>
 <2a7473b3-62af-f7d2-f73a-adcabe21701e@suse.de>
 <72827be0-a44a-0163-acb8-04ff3bde86ce@suse.de>
 <20200618081407.qsm4otp2w2bmcuil@beryllium.lan>
 <73b070da-2d27-d731-a8b2-b6a668524330@suse.de> <20200618084756.GA2636@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4f423285-ff7b-476b-6145-5364f1d36857@suse.de>
Date:   Thu, 18 Jun 2020 11:15:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618084756.GA2636@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/20 10:47 AM, Christoph Hellwig wrote:
> Do you actually have a gdth card?  Do we know of other users?
> Maybe just dropping the driver might be a better option..
> 
Yes, no, and possibly :-)

The gdth hardware is based on the i960 chip, and has borrowed quite some 
concepts for the now-defunct I2O design.
Plus it's PCI and SCSI parallel only, so it took me quite some time to 
find a machine where I could fit both in.

So I do agree that this could be classified as obsolete, much like we 
did with the I2O subsystem some years back.
Would actually save me quite some time, as the driver itself is really 
just too ugly to behold in its current state.
And bringing it into this century would amount to basically a rewrite.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
