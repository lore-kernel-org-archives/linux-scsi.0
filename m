From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Tue, 8 Nov 2016 16:00:46 +0100
Message-ID: <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
 <20161108145802.GB12817@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57065 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752340AbcKHPAu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 10:00:50 -0500
In-Reply-To: <20161108145802.GB12817@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On 11/08/2016 03:58 PM, Christoph Hellwig wrote:
> On Tue, Nov 08, 2016 at 08:12:25AM +0100, Hannes Reinecke wrote:
>> Use pci_alloc_irq_vectors and drop the hand-crafted
>> interrupt affinity routines.
>
> There are a couple more things we can do here.  I actually have a patch
> in my tree that goes a little further, I'll post it in a bit.
>
Right. I'll wait for it.

If you also happen to have patches for megaraid and mpt3sas I'd be very 
much interested in looking into them; I'm currently working on 
converting them, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
