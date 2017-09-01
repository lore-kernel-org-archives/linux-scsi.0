From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 6/9] blk-mq: rename blk_mq_freeze_queue_wait as
 blk_freeze_queue_wait
Date: Fri, 1 Sep 2017 11:53:17 +0800
Message-ID: <20170901035315.GH16525@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-7-ming.lei@redhat.com>
 <1504219064.31872.68.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbdIADxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 23:53:31 -0400
Content-Disposition: inline
In-Reply-To: <1504219064.31872.68.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>

On Thu, Aug 31, 2017 at 10:37:46PM +0000, Bart Van Assche wrote:
> On Fri, 2017-09-01 at 01:27 +0800, Ming Lei wrote:
> > The only change on legacy is that blk_drain_queue() is run
> > from blk_freeze_queue(), which is called in blk_cleanup_queue().
> > 
> > So this patch removes the explicite __blk_drain_queue() in
> > blk_cleanup_queue().
> 
> Hello Ming,
> 
> Shouldn't the rename and the move of the __blk_drain_queue() be
> separate patches?

OK.

-- 
Ming
