From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libfc: do not flood console with messages 'libfc: queue
 full ...'
Date: Mon, 8 May 2017 10:48:45 +0200
Message-ID: <20170508084845.GF3982@linux-x5ow.site>
References: <1493303103-113774-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42590 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751055AbdEHIsw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 May 2017 04:48:52 -0400
Content-Disposition: inline
In-Reply-To: <1493303103-113774-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Apr 27, 2017 at 04:25:03PM +0200, Hannes Reinecke wrote:
> When the FCoE sending side becomes congested libfc tries to
> reduce the queue depth on the host; however due to the built-in
> lag before attempting to ramp down the queue depth _again_ the
> message log is flooded with messages
> 
> libfc: queue full, reducing can_queue to 512
> 
> With this patch the message is printed only once (ie when it's
> actually changed).
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
