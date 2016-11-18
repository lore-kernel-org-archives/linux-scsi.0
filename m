From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Fri, 18 Nov 2016 15:39:32 +0100
Message-ID: <20161118143932.jqjjwa6tjzyxwtup@linutronix.de>
References: <20161118101019.2317-1-bigeasy@linutronix.de>
 <20161118101019.2317-2-bigeasy@linutronix.de>
 <20161118125622.GA6423@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52170 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbcKROji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 09:39:38 -0500
Content-Disposition: inline
In-Reply-To: <20161118125622.GA6423@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Chad Dupuis <chad.dupuis@qlogic.com>

On 2016-11-18 13:56:22 [+0100], Christoph Hellwig wrote:
> still says kwork in the subject..

I was thinking about this before sending it out. But then it uses the
generic workqueue / kworker and a custom kthread like it did before.
What would you prefer to call it then? Just workqueue?

Sebastian
