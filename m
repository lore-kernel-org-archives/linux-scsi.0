From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] bsg-lib interface cleanup
Date: Mon, 16 Oct 2017 23:50:49 -0400
Message-ID: <yq1d15mzb3a.fsf@oracle.com>
References: <20171003104845.10417-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-1-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 3 Oct 2017 12:48:36 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Christoph,

> this series cleans up various abuses of the bsg interfaces, and then
> splits bsg for SCSI passthrough from bsg for arbitrary transport
> passthrough.  This removes the scsi_request abuse in bsg-lib that is
> very confusing, and also makes sure we can sanity check the requests
> we get.  The current code will happily execute scsi commands against
> bsg-lib queues, and transport pass through against scsi nodes, without
> any indication to the driver that we are doing the wrong thing.

I applied patches 2-5 to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
