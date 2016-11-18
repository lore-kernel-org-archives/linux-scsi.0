From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Fri, 18 Nov 2016 15:55:04 +0100
Message-ID: <20161118145504.GA9405@lst.de>
References: <20161118101019.2317-1-bigeasy@linutronix.de> <20161118101019.2317-2-bigeasy@linutronix.de> <20161118125622.GA6423@lst.de> <20161118143932.jqjjwa6tjzyxwtup@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48932 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbcKROzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 09:55:06 -0500
Content-Disposition: inline
In-Reply-To: <20161118143932.jqjjwa6tjzyxwtup@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Chad Dupuis <chad.dupuis@qlogic.com>

On Fri, Nov 18, 2016 at 03:39:32PM +0100, Sebastian Andrzej Siewior wrote:
> On 2016-11-18 13:56:22 [+0100], Christoph Hellwig wrote:
> > still says kwork in the subject..
> 
> I was thinking about this before sending it out. But then it uses the
> generic workqueue / kworker and a custom kthread like it did before.
> What would you prefer to call it then? Just workqueue?

Just workqueue.
