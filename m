From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sd: always scan VPD pages if thin provisioning is enabled
Date: Wed, 25 Jan 2017 08:57:55 +0100
Message-ID: <20170125075755.GA3568@linux-x5ow.site>
References: <1485329165-64825-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751309AbdAYH6C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 02:58:02 -0500
Content-Disposition: inline
In-Reply-To: <1485329165-64825-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Jan 25, 2017 at 08:26:05AM +0100, Hannes Reinecke wrote:
> For any device with an older SCSI revision we might not
> be scanning VPD pages, which results in a wrongly configured
> discard mode if thin provisioned is enabled.
> According to sbc3 any thin provisioned device (ie devices which
> have the LBPME bit set in the output of READ CAPACITY(16)) need
> to support VPD pages. So this patch always enables VPD pages
> even for older SCSI revisions if thin provisioning is enabled.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---


Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
