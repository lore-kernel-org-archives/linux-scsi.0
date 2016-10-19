From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 10/11] nvme: Use BLK_MQ_S_STOPPED instead of
        QUEUE_FLAG_STOPPED in blk-mq code
Date: Wed, 19 Oct 2016 15:39:39 +0200
Message-ID: <20161019133939.GC6809@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <39c07429-2508-4123-8fe1-ecf407f8571d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41724 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941093AbcJSOQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 10:16:34 -0400
Content-Disposition: inline
In-Reply-To: <39c07429-2508-4123-8fe1-ecf407f8571d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
