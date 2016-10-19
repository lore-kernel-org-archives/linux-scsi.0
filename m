From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 02/11] blk-mq: Introduce blk_mq_hctx_stopped()
Date: Wed, 19 Oct 2016 08:58:55 -0700
Message-ID: <4c09e48d-4b23-915a-bf60-c58d0aae6007@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <b5b0ffcc-767d-1b90-9c5a-52c57690dea8@sandisk.com>
 <20161019131900.GB6323@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0079.outbound.protection.outlook.com ([104.47.38.79]:18080
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941358AbcJSP7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 11:59:11 -0400
In-Reply-To: <20161019131900.GB6323@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On 10/19/2016 06:19 AM, Christoph Hellwig wrote:
> On Tue, Oct 18, 2016 at 02:49:09PM -0700, Bart Van Assche wrote:
>> Multiple functions test the BLK_MQ_S_STOPPED bit so introduce
>> a helper function that performs this test.
>
> Looks sensible.  Any reason to have it in the public blk-mq.h instead
> of the private one, though?  I see that dm is using it with this patch,
> but that usage should go away once your full series is merged, right?

Hello Christoph,

Moving the blk_mq_hctx_stopped() declaration from the public to the 
private blk-mq.h header file should be possible. I will look into this.

Bart.
