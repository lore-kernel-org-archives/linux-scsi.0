From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Wed, 9 Nov 2016 16:45:22 +0100
Message-ID: <dc7c9c33-7a88-bd4f-c330-16c8f447e4cc@suse.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D193B083C61@avsrvexchmbx1.microsemi.net>
 <20161109153628.GA23452@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45161 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752870AbcKIPp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 10:45:26 -0500
In-Reply-To: <20161109153628.GA23452@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On 11/09/2016 04:36 PM, Christoph Hellwig wrote:
> On Wed, Nov 09, 2016 at 03:32:48PM +0000, Don Brace wrote:
>> Do we need to add an entry for map_queues?
>
> The existing driver only supports a single submission queue.
> If some of the devices support more than one submission queue
> we could enhance the driver to support it, but we'd need docs
> and hardware.
>
Hardware is not an issue :-)

However, I'm still curious about the layout of the queues.
Are all queues (in performant mode) identical and can we use them for 
parallel submission? Or do we have to treat them differently?
(There were some rumours that it actually uses the queues for different 
I/O sizes ...)

Once that is cleared up it shouldn't be too hard moving to full 
multiqueue support.
(If we have identical queues, that is :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
