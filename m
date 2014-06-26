From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] scsi: Implement sg_printk()
Date: Thu, 26 Jun 2014 00:41:57 -0700
Message-ID: <20140626074157.GB26094@infradead.org>
References: <1403707199-102664-1-git-send-email-hare@suse.de>
 <1403707199-102664-3-git-send-email-hare@suse.de>
 <53AB2F3F.4000607@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaFZHmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 03:42:04 -0400
Content-Disposition: inline
In-Reply-To: <53AB2F3F.4000607@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25, 2014 at 04:21:19PM -0400, Douglas Gilbert wrote:
> That function used to be called sg_cmd_done() but
> another hacker gave it a more reasonable name (?)
> but neglected to fix the printk_s. There are other
> examples, so now I prefer:
> 
>   SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
> 		   "%s: pack_id=%d, res=0x%x\n", __func__,
> 		   srp->header.pack_id, result));
> 
> 
> Oh, and we really shouldn't be printing from this context but
> it works and I have found it useful in debugging :-)

printk from irq context isn't a problem at all.  And just send me the
one liner to use __func__ againat the core-for-3.17 tree.

