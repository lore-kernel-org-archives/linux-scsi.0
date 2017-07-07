From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to workqueue
Date: Fri, 7 Jul 2017 15:14:19 +0200
Message-ID: <20170707131419.bfglh4kqwwuowyej@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-2-bigeasy@linutronix.de>
 <20170629135756.GP3808@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60304 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdGGNO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2017 09:14:26 -0400
Content-Disposition: inline
In-Reply-To: <20170629135756.GP3808@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>

On 2017-06-29 15:57:56 [+0200], Johannes Thumshirn wrote:
> So here we are again,
> Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> FCoE will follow as soon as my setup can speak FCoE again.

So it all looks good, doesn't it? Chad never responded to my question
on his patch. I still doubt that it fixes the problem he observed.

Sebastian
