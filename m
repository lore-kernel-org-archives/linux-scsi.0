From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to workqueue
Date: Fri, 7 Jul 2017 09:20:02 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1707070918420.891@administrators-MacBook-Pro.local>
References: <20170410171254.30367-1-bigeasy@linutronix.de> <20170410171254.30367-2-bigeasy@linutronix.de> <20170629135756.GP3808@linux-x5ow.site> <20170707131419.bfglh4kqwwuowyej@linutronix.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0083.outbound.protection.outlook.com ([104.47.42.83]:41903
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750778AbdGGNU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Jul 2017 09:20:26 -0400
In-Reply-To: <20170707131419.bfglh4kqwwuowyej@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>



On Fri, 7 Jul 2017, 9:14am, Sebastian Andrzej Siewior wrote:

> On 2017-06-29 15:57:56 [+0200], Johannes Thumshirn wrote:
> > So here we are again,
> > Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
> > 
> > FCoE will follow as soon as my setup can speak FCoE again.
> 
> So it all looks good, doesn't it? Chad never responded to my question
> on his patch. I still doubt that it fixes the problem he observed.
> 
> Sebastian
> 

What was the question?  My observation is that the patch I proposed fixed 
the issue we saw on testing the patch set.  With that small change 
(essentially modulo by the number of active CPUs vs. the total number) 
your patch set worked ok.
