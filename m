From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/28] imm: drop duplicate bus_reset handler
Date: Wed, 28 Jun 2017 15:57:49 +0200
Message-ID: <20170628135749.GG1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49540 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751502AbdF1N5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 09:57:50 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-18-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:25:05AM +0200, Hannes Reinecke wrote:
> host_reset and bus_reset is the same function, so drop bus reset.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
