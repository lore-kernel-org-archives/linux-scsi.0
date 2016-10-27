From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 01/12] blk-mq: Do not invoke .queue_rq() for a stopped
 queue
Date: Thu, 27 Oct 2016 15:14:23 +0300
Message-ID: <afc6b4e8-4731-9bd0-becb-02ea20d5d3a8@grimberg.me>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <1debcf7f-c950-308b-d297-3e48a77e08d7@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36020 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942431AbcJ0OGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 10:06:50 -0400
In-Reply-To: <1debcf7f-c950-308b-d297-3e48a77e08d7@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
