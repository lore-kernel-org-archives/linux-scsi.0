From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Tue, 8 Nov 2016 15:58:02 +0100
Message-ID: <20161108145802.GB12817@lst.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41885 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752013AbcKHO6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 09:58:04 -0500
Content-Disposition: inline
In-Reply-To: <1478589145-74280-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On Tue, Nov 08, 2016 at 08:12:25AM +0100, Hannes Reinecke wrote:
> Use pci_alloc_irq_vectors and drop the hand-crafted
> interrupt affinity routines.

There are a couple more things we can do here.  I actually have a patch
in my tree that goes a little further, I'll post it in a bit.
