From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PREEMPT-RT] bnx2i + bnx2fc: convert to generic workqueue (#2)
Date: Fri, 9 Dec 2016 12:33:11 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1612091232230.3794@nanos>
References: <20161122174813.16184-1-bigeasy@linutronix.de> <yq160n6ns12.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:48428 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932468AbcLILf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 06:35:59 -0500
In-Reply-To: <yq160n6ns12.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

On Tue, 29 Nov 2016, Martin K. Petersen wrote:

> >>>>> "Sebastian" == Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
> 
> Sebastian> This is the a repost + fixups to get the patches applied
> Sebastian> against v4.9-rc4.  mkp's scsi for-next tree can be merged
> Sebastian> with no conflicts.
> 
> Chad?

Polite ping on this. We really want to get rid of the hotplug notifier crap
in 4.10. This one of the last holdouts.

Thanks,

	tglx
