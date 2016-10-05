From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 7/7] [RFC] nvme: Fix a race condition
Date: Wed, 5 Oct 2016 20:40:24 +0300
Message-ID: <08fab9f6-f928-4cec-b616-317a52361557@grimberg.me>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <ff412bfb-548c-c4fc-5180-78ede8a19ef2@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ff412bfb-548c-c4fc-5180-78ede8a19ef2@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org


> Avoid that nvme_queue_rq() is still running when nvme_stop_queues()
> returns. Untested.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>

Bart this looks really good! and possibly fixes an issue
I've been chasing with fabrics a while ago. I'll take it
for testing but you can add my:

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
