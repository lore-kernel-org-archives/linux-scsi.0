From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: mq queue stall during command requeue
Date: Thu, 19 Jan 2017 15:52:43 +0100
Message-ID: <0a922801-a30b-7d3e-f871-e5401ad1b9b1@suse.de>
References: <1484835465-66514-1-git-send-email-hare@suse.de>
 <20170119144651.GA31548@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35085 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753579AbdASQoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 11:44:22 -0500
In-Reply-To: <20170119144651.GA31548@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>

On 01/19/2017 03:46 PM, Christoph Hellwig wrote:
> On Thu, Jan 19, 2017 at 03:17:45PM +0100, Hannes Reinecke wrote:
>> When we're hitting a busy condition in queuecommand() we need to
>> stop the hardware queue before calling blk_mq_delay_queue(); if
>> we don't blk_mq_delay_queue() will not do anything and requeue
>> will never triggered.
> 
> I suspect the stop needs to move into blk_mq_delay_queue to make
> it more useful.
> 
Which is what I've suggested to Jens, too.
And he even agreed to it :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
