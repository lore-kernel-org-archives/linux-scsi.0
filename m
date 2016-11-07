From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Mon, 7 Nov 2016 18:04:21 +0100
Message-ID: <20161107170420.gc6jhsewglgkfsdi@linutronix.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
 <20161107161901.GA12297@infradead.org>
 <alpine.DEB.2.20.1611071729030.3709@nanos>
 <20161107163848.GA1421@lst.de>
 <20161107164628.jrft3ovlp5myfvs5@linutronix.de>
 <20161107164846.GA1966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52562 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753308AbcKGREe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 12:04:34 -0500
Content-Disposition: inline
In-Reply-To: <20161107164846.GA1966@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>

On 2016-11-07 17:48:46 [+0100], Christoph Hellwig wrote:
> On Mon, Nov 07, 2016 at 05:46:29PM +0100, Sebastian Andrzej Siewior wrote:
> > sorry for the confusion in the subject. If I remember correctly you said
> > that we may not have enough room for a larger / work_struct struct and I
> > should keep the list for now.
> 
> But that was for libfc where it only has a tiny bit of private data
> i nthe skb - this is for cnix which has plenty of space, and in fact

Right. now I remember.

> probably should do the workqueue offload in the core before invoking
> the protocol drivers.

So we keep things as they are right now or are we getting also rid of
the internal list? This was tested by Johannes and Chad (claimed to do
testing) and the removal the internal list afterwards shouldn't be that
big deal. Not sure what the last point is about.

Sebastian
