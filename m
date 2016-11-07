From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Mon, 7 Nov 2016 08:19:01 -0800
Message-ID: <20161107161901.GA12297@infradead.org>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36297 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932187AbcKGQTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 11:19:07 -0500
Content-Disposition: inline
In-Reply-To: <20160817101003.30055-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>

It seems like the whole damn driver should just use threaded interrupts.
Of course it's a giant beast and not just the iSCSI one.  But even
if we don't go all the way I'd much prefer workqueues.  kthread work
is simply the worst API ever and I'd prefer to not have it proliferate.
