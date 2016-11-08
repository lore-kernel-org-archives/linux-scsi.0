From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Tue, 8 Nov 2016 16:01:49 +0100
Message-ID: <20161108150149.GB13184@lst.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de> <20161108145802.GB12817@lst.de> <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41938 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbcKHPBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 10:01:50 -0500
Content-Disposition: inline
In-Reply-To: <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On Tue, Nov 08, 2016 at 04:00:46PM +0100, Hannes Reinecke wrote:
> Right. I'll wait for it.
>
> If you also happen to have patches for megaraid and mpt3sas I'd be very 
> much interested in looking into them; I'm currently working on converting 
> them, too.

I've looked at the them but haven't started work, so feel free to go
ahead.  The MSI-X handling in mpt3sas is pretty nasty, so be careful.

I've also started playing with lpfc, something I'll need to send to
you and James for testing and feedback soon.
