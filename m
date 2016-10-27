From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/12] dm: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Thu, 27 Oct 2016 10:01:21 -0400
Message-ID: <20161027140121.GA16816@redhat.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <a0733adf-065e-2099-3850-cb1c55df1e35@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a0733adf-065e-2099-3850-cb1c55df1e35@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 26 2016 at  6:54pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Instead of manipulating both QUEUE_FLAG_STOPPED and BLK_MQ_S_STOPPED
> in the dm start and stop queue functions, only manipulate the latter
> flag. Change blk_queue_stopped() tests into blk_mq_queue_stopped().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@redhat.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
