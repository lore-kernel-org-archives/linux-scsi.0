From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 02/11] blk-mq: Introduce blk_mq_hctx_stopped()
Date: Wed, 19 Oct 2016 15:19:00 +0200
Message-ID: <20161019131900.GB6323@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <b5b0ffcc-767d-1b90-9c5a-52c57690dea8@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b5b0ffcc-767d-1b90-9c5a-52c57690dea8@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2016 at 02:49:09PM -0700, Bart Van Assche wrote:
> Multiple functions test the BLK_MQ_S_STOPPED bit so introduce
> a helper function that performs this test.

Looks sensible.  Any reason to have it in the public blk-mq.h instead
of the private one, though?  I see that dm is using it with this patch,
but that usage should go away once your full series is merged, right?
