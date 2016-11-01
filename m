From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 12/14] SRP transport, scsi-mq: Wait for .queue_rq() if necessary
Date: Tue, 01 Nov 2016 12:12:07 -0400
Message-ID: <yq1d1if18o8.fsf@sermon.lab.mkp.net>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
        <32accadb-3ed3-cd5d-e92f-655f8f3cb9bc@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <32accadb-3ed3-cd5d-e92f-655f8f3cb9bc@sandisk.com> (Bart Van
        Assche's message of "Fri, 28 Oct 2016 17:23:00 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?utf-8?Q?Monn=C3=A9?= <roger.pau@citrix.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Ensure that if scsi-mq is enabled that
Bart> scsi_internal_device_block() waits until ongoing
Bart> shost->hostt->queuecommand() calls have finished.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
