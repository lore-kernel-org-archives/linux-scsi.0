From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 18/28] ppa: drop duplicate bus_reset handler
Date: Wed, 28 Jun 2017 15:58:01 +0200
Message-ID: <20170628135801.GH1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49547 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbdF1N6C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 09:58:02 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:25:06AM +0200, Hannes Reinecke wrote:
> bus_reset and host_reset are the same functions, so drop bus_reset.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
