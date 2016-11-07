From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to
 kworker
Date: Mon, 7 Nov 2016 17:31:03 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1611071729030.3709@nanos>
References: <20160817101003.30055-1-bigeasy@linutronix.de> <20161107161901.GA12297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52423 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932295AbcKGQdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 11:33:45 -0500
In-Reply-To: <20161107161901.GA12297@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, 7 Nov 2016, Christoph Hellwig wrote:

> It seems like the whole damn driver should just use threaded interrupts.
> Of course it's a giant beast and not just the iSCSI one.  But even
> if we don't go all the way I'd much prefer workqueues.  kthread work
> is simply the worst API ever and I'd prefer to not have it proliferate.

That's what the patch is doing. It uses INIT_WORK() and
schedule_work[_on](). I can't find any reference to kthread work.

Thanks,

	tglx
