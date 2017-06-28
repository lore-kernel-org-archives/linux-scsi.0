From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/28] qedf: drop bus reset handler
Date: Wed, 28 Jun 2017 15:58:58 +0200
Message-ID: <20170628135858.GI1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49555 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbdF1N67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 09:58:59 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Chad Dupuis <chad.dupuis@cavium.com>

On Wed, Jun 28, 2017 at 10:25:07AM +0200, Hannes Reinecke wrote:
> qedf has a host reset handler, but as the bus reset handler is
> a stub always returning SUCCESS the host reset is never invoked.
> So drop the bus reset handler.

Given that comment this needs a lot more explanation, as the current
behavior seems to be an odd/buggy workaround.

I hope this patch won't block the rest of the series, which all seems
nice and simple material for this late merge window :(
