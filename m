From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/28] 53c700: move bus reset to host reset
Date: Wed, 28 Jun 2017 16:05:27 +0200
Message-ID: <20170628140527.GL1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49622 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbdF1OF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 10:05:28 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-23-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:25:10AM +0200, Hannes Reinecke wrote:
> bus reset always returns SUCCESS, meaning host reset was never
> tested. At the same time the only difference to the HBA is a
> missing call to NCR_700_chip_reset().
> So add the missing call to bus reset, drop host reset, and move
> bus reset to host reset.

Given that all the 53c700-based drivers only support a single channel
this looks correct:

Reviewed-by: Christoph Hellwig <hch@lst.de>
