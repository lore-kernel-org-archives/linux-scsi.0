From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 05/11] blk-mq: Add a kick_requeue_list argument to
        blk_mq_requeue_request()
Date: Wed, 19 Oct 2016 15:23:54 +0200
Message-ID: <20161019132354.GE6323@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <7b52319b-03f7-e432-909a-2f46232770c6@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7b52319b-03f7-e432-909a-2f46232770c6@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2016 at 02:51:02PM -0700, Bart Van Assche wrote:
> Most blk_mq_requeue_request() and blk_mq_add_to_requeue_list() calls
> are followed by kicking the requeue list. Hence add an argument to
> these two functions that allows to kick the requeue list. This was
> proposed by Christoph Hellwig.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

Thanks Bart, this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
