From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/12] blk-mq: Add a kick_requeue_list argument to
        blk_mq_requeue_request()
Date: Thu, 27 Oct 2016 14:44:09 +0200
Message-ID: <20161027124409.GE13200@lst.de>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com> <3944826d-bfde-f1e6-40ec-2c9a3c259e3a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55832 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965020AbcJ0OBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 10:01:48 -0400
Content-Disposition: inline
In-Reply-To: <3944826d-bfde-f1e6-40ec-2c9a3c259e3a@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Wed, Oct 26, 2016 at 03:53:39PM -0700, Bart Van Assche wrote:
> Most blk_mq_requeue_request() and blk_mq_add_to_requeue_list() calls
> are followed by kicking the requeue list. Hence add an argument to
> these two functions that allows to kick the requeue list. This was
> proposed by Christoph Hellwig.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
