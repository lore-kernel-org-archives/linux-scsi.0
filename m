From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/9] block/scsi: safe SCSI quiescing
Date: Fri, 1 Sep 2017 14:30:08 +0800
Message-ID: <20170901063007.GA2424@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <1576539.niWZoWEnd8@natalenko.name>
 <20170831173833.GC5928@ming.t460p>
 <14328863.IIXMb7O2AM@natalenko.name>
 <20170901034532.GD16525@ming.t460p>
 <eeb514d8aab51d4713f18636adb6be03@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdIAGaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Sep 2017 02:30:25 -0400
Content-Disposition: inline
In-Reply-To: <eeb514d8aab51d4713f18636adb6be03@natalenko.name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oleksandr@natalenko.name
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>

On Fri, Sep 01, 2017 at 08:24:46AM +0200, oleksandr@natalenko.name wrote:
> Hi.
> 
> 01.09.2017 05:45, Ming Lei wrote:
> > Could you try the following patch against this patchset to see
> > if there is still the warning?
> 
> With this patch I wasn't able to trigger per-CPU-related warning.

That is great!

> 
> Also, for 8th patch you've written:
> 
> > I have sent one delta patch in list, which will only call
> > blk_queue_enter_live() iff SCSI device is in QUIESCE.
> 
> This refers to the patch I've just tested, right?

Yeah, you are right, thanks again for your test!

I will prepare V2 and send it out soon.

-- 
Ming
