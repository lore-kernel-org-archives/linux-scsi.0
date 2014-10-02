From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] scsi: Remove scmd->tag
Date: Thu, 2 Oct 2014 13:22:31 +0200
Message-ID: <20141002112230.GB31346@lst.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de> <1412246593-107001-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44653 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaJBLWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 07:22:34 -0400
Content-Disposition: inline
In-Reply-To: <1412246593-107001-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Finn Thain <fthain@telegraphics.com.au>, James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index a0c8c5d..cb68089 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1527,7 +1527,6 @@ part2:
>  	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
>  
>  	len = 1;
> -	cmd->tag = 0;

The driver was explicitly setting the tag to zero here, so this needs
a good explanation instead of a blind removal.

But given how nice the code that Finn delivered in the past is I have high
hopes that his NCR5380 overhaul will get rid of a lot of this cruft :)

