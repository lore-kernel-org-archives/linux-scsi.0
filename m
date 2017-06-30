From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Drop legacy megaraid controller
Date: Fri, 30 Jun 2017 20:15:56 +0200
Message-ID: <281a2a28-ff8d-8c65-6d53-ee393ca08e24@suse.de>
References: <1498820754-51032-1-git-send-email-hare@suse.de>
 <1498820754-51032-2-git-send-email-hare@suse.de>
 <20170630173347.GA11420@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752381AbdF3SQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 14:16:00 -0400
In-Reply-To: <20170630173347.GA11420@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 06/30/2017 07:33 PM, Christoph Hellwig wrote:
> On Fri, Jun 30, 2017 at 01:05:53PM +0200, Hannes Reinecke wrote:
>> The hardware is ancient, and support for most cards has been moved
>> to megaraid_mbox. So drop it.
> 
> 
> This seems to drop support for the PCI_DEVICE_ID_AMI_MEGARAID
> and PCI_DEVICE_ID_AMI_MEGARAID2 cards.  Do we have any suggestions
> this code is so broken to not care anymore? Is there any reason why
> they can't just work with the megaraid_mbox driver?
> 
Hmm. Probably no good reason at all.
I'll check which version I have here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
