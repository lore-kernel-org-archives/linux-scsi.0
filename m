From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 20/28] nsp32: drop bus reset
Date: Wed, 28 Jun 2017 16:00:12 +0200
Message-ID: <20170628140012.GJ1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49594 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751522AbdF1OAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 10:00:13 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:25:08AM +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> bus reset is essentially identical to host reset, and will always
> return SUCCESS, thus disabling the use of host reset.
> So drop bus reset in favour of host reset.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

nsp32_eh_host_reset additionally calls nsp32hw_init, so they
don't really look "mostly" the same.  That being said I think
the bus_reset as-is is probably rather useless.
