From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Tue, 8 Nov 2016 16:02:54 +0100
Message-ID: <214a7d50-672e-bc5e-1dd3-c0c5e8366911@suse.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
 <20161108145802.GB12817@lst.de>
 <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de>
 <20161108150149.GB13184@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57805 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752650AbcKHPDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 10:03:16 -0500
In-Reply-To: <20161108150149.GB13184@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On 11/08/2016 04:01 PM, Christoph Hellwig wrote:
> On Tue, Nov 08, 2016 at 04:00:46PM +0100, Hannes Reinecke wrote:
>> Right. I'll wait for it.
>>
>> If you also happen to have patches for megaraid and mpt3sas I'd be very
>> much interested in looking into them; I'm currently working on converting
>> them, too.
>
> I've looked at the them but haven't started work, so feel free to go
> ahead.  The MSI-X handling in mpt3sas is pretty nasty, so be careful.
>
> I've also started playing with lpfc, something I'll need to send to
> you and James for testing and feedback soon.
>
Bah. Another duplicate then.
Let's see who is faster :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
