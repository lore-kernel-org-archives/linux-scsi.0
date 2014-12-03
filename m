From: Christoph Hellwig <hch@infradead.org>
Subject: Re: queue_type fixups
Date: Wed, 3 Dec 2014 01:32:36 -0800
Message-ID: <20141203093236.GC17698@infradead.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaLCJci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 04:32:38 -0500
Content-Disposition: inline
In-Reply-To: <1416839781-26988-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "Ewan D. Milne" <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Robert Elliott <elliott@hp.com>

Any chance to get another review for these to complete the queue depth /
type changes for this merge window?

On Mon, Nov 24, 2014 at 03:36:17PM +0100, Christoph Hellwig wrote:
> These are a few patches that follow up my previous cleanups for the
> queue depth and type handling.
> 
> The first patch removes the now pointless write support for the queue_type
> sysfs attribute.  The second changes the queue full tracking code to
> never drop out of tagged mode, as we can't recover from that, and the
> last two are random cleanups.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
