From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] Drop legacy megaraid controller
Date: Fri, 30 Jun 2017 19:33:47 +0200
Message-ID: <20170630173347.GA11420@lst.de>
References: <1498820754-51032-1-git-send-email-hare@suse.de> <1498820754-51032-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32888 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbdF3Rdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:33:49 -0400
Content-Disposition: inline
In-Reply-To: <1498820754-51032-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Jun 30, 2017 at 01:05:53PM +0200, Hannes Reinecke wrote:
> The hardware is ancient, and support for most cards has been moved
> to megaraid_mbox. So drop it.


This seems to drop support for the PCI_DEVICE_ID_AMI_MEGARAID
and PCI_DEVICE_ID_AMI_MEGARAID2 cards.  Do we have any suggestions
this code is so broken to not care anymore? Is there any reason why
they can't just work with the megaraid_mbox driver?
