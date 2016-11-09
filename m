From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Wed, 9 Nov 2016 16:36:28 +0100
Message-ID: <20161109153628.GA23452@lst.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de> <4993A297653ECB4581FA5C3C31323D193B083C61@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55041 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbcKIPga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 10:36:30 -0500
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D193B083C61@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On Wed, Nov 09, 2016 at 03:32:48PM +0000, Don Brace wrote:
> Do we need to add an entry for map_queues?

The existing driver only supports a single submission queue.
If some of the devices support more than one submission queue
we could enhance the driver to support it, but we'd need docs
and hardware.

> Are you and Christoph still working on this patch? :)

I just need to post the version I have here after rebasing it.
Shouldn't take long, but I'm fighting a few fires at the moment,
hopefully later today.
