From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/9] blk-mq: Introduce blk_mq_queue_stopped()
Date: Tue, 27 Sep 2016 09:38:08 +0200
Message-ID: <20160927073808.dfza42u2co7t7yi4@linux-x5ow.site>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <b2210943-62b2-959a-569a-a404da03bcae@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59861 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751572AbcI0HiO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 03:38:14 -0400
Content-Disposition: inline
In-Reply-To: <b2210943-62b2-959a-569a-a404da03bcae@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Mon, Sep 26, 2016 at 11:26:26AM -0700, Bart Van Assche wrote:
> The function blk_queue_stopped() allows to test whether or not a
> traditional request queue has been stopped. Introduce a helper
> function that allows block drivers to query easily whether or not
> one or more hardware contexts of a blk-mq queue have been stopped.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
