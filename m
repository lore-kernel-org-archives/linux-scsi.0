From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Drop legacy megaraid controller
Date: Tue, 4 Jul 2017 17:09:16 +0200
Message-ID: <b99c29cf-0245-8e08-24c0-e36a840f119e@suse.de>
References: <1498820754-51032-1-git-send-email-hare@suse.de>
 <1498820754-51032-2-git-send-email-hare@suse.de>
 <20170630173347.GA11420@lst.de>
 <281a2a28-ff8d-8c65-6d53-ee393ca08e24@suse.de>
 <0f96d4aca1a7d4c56a70607012a26a68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752430AbdGDPJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Jul 2017 11:09:20 -0400
In-Reply-To: <0f96d4aca1a7d4c56a70607012a26a68@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 07/03/2017 09:50 AM, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, June 30, 2017 11:46 PM
>> To: Christoph Hellwig
>> Cc: Martin K. Petersen; James Bottomley; Kashyap Desai; Sumit Saxena;
>> linux-
>> scsi@vger.kernel.org; Hannes Reinecke
>> Subject: Re: [PATCH 1/2] Drop legacy megaraid controller
>>
>> On 06/30/2017 07:33 PM, Christoph Hellwig wrote:
>>> On Fri, Jun 30, 2017 at 01:05:53PM +0200, Hannes Reinecke wrote:
>>>> The hardware is ancient, and support for most cards has been moved to
>>>> megaraid_mbox. So drop it.
>>>
>>>
>>> This seems to drop support for the PCI_DEVICE_ID_AMI_MEGARAID and
>>> PCI_DEVICE_ID_AMI_MEGARAID2 cards.  Do we have any suggestions this
>>> code is so broken to not care anymore? Is there any reason why they
>>> can't just work with the megaraid_mbox driver?
>>>
>> Hmm. Probably no good reason at all.
>> I'll check which version I have here.
> 
> Hannes,
> We are willing to keep only megaraid_sas driver and intent is rest of
> megaraid* drivers
> (it includes megaraid, megaraid_mm, megaraid_mbox) should be removed.
> Broadcom(LSI) has stopped supporting hardware associated with these old
> drivers.
> 
I'd be willing to take over maintainership of the old megaraid_mbox
driver; I'm working on moving PIO support into the megaraid_mbox code,
and with that we can drop the old megaraid.c driver.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
