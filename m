From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/9] block: Extend blk_freeze_queue_start() to the
 non-blk-mq path
Date: Tue, 27 Sep 2016 09:50:56 +0200
Message-ID: <20160927075056.dchqs4kgwem6rkrf@linux-x5ow.site>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <7c8af8d2-2ac9-2767-5e5f-8de72eba3814@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbcI0Hu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 03:50:58 -0400
Content-Disposition: inline
In-Reply-To: <7c8af8d2-2ac9-2767-5e5f-8de72eba3814@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Mon, Sep 26, 2016 at 11:27:49AM -0700, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
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
