From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Mon, 7 Nov 2016 17:46:29 +0100
Message-ID: <20161107164628.jrft3ovlp5myfvs5@linutronix.de>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
 <20161107161901.GA12297@infradead.org>
 <alpine.DEB.2.20.1611071729030.3709@nanos>
 <20161107163848.GA1421@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52484 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752337AbcKGQrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 11:47:16 -0500
Content-Disposition: inline
In-Reply-To: <20161107163848.GA1421@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>

On 2016-11-07 17:38:48 [+0100], Christoph Hellwig wrote:
> You're right it does - between the incorrect subject and the fact
> that it still keeps the linked list of items arounds instead of fully
> using the workqueue infrastructure I was a bit confused before my
> first coffee this morning.  Same applies to patch 2.

sorry for the confusion in the subject. If I remember correctly you said
that we may not have enough room for a larger / work_struct struct and I
should keep the list for now.

Sebastian
