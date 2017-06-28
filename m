From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/47] aacraid: split off host reset
Date: Wed, 28 Jun 2017 11:10:29 +0200
Message-ID: <20170628091029.GB4185@linux-x5ow.site>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751489AbdF1JKb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 05:10:31 -0400
Content-Disposition: inline
In-Reply-To: <1498638793-44672-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jun 28, 2017 at 10:32:28AM +0200, Hannes Reinecke wrote:
> +	struct scsi_device * dev = cmd->device;
> +	struct Scsi_Host * host = dev->host;
> +	struct aac_dev * aac = (struct aac_dev *)host->hostdata;

Minor nit, if you happen to re-send, please remove the space between the
asterisk and the variable names.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
