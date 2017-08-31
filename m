From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/9] block/scsi: safe SCSI quiescing
Date: Fri, 1 Sep 2017 01:38:34 +0800
Message-ID: <20170831173833.GC5928@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <1576539.niWZoWEnd8@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbdHaRis (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 13:38:48 -0400
Content-Disposition: inline
In-Reply-To: <1576539.niWZoWEnd8@natalenko.name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>

On Thu, Aug 31, 2017 at 07:34:06PM +0200, Oleksandr Natalenko wrote:
> Since I'm in CC, does this series aim to replace 2 patches I've tested before:
> 
> blk-mq: add requests in the tail of hctx->dispatch
> blk-mq: align to legacy's implementation of blk_execute_rq
> 
> ?

Yeah, this solution is more generic, and the old one in above
two patches may run into the same deadlock inevitably.

Oleksandr, could you test this patchset and provide the feedback?

BTW, it fixes the I/O hang in my raid10 test, but I just write
'devices' to pm_test.

Thanks!

-- 
Ming
