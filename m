From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 07/11] dm: Fix a race condition related to stopping
        and starting queues
Date: Wed, 19 Oct 2016 15:30:50 +0200
Message-ID: <20161019133050.GG6323@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <1e89a7d7-5cae-40b1-ce31-09d630e6f33d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41990 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942005AbcJSOqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 10:46:34 -0400
Content-Disposition: inline
In-Reply-To: <1e89a7d7-5cae-40b1-ce31-09d630e6f33d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

FYI, I wonder how many of the blk_mq_stop_hw_queues do not need
the quiesce call.  In the long run it might be better to have
blk_mq_stop_hw_queues to stop an quiesce, and have a
__blk_mq_stop_hw_queues variant to just stop.
