From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 10/12] SRP transport, scsi-mq: Wait for .queue_rq() if
 necessary
Date: Thu, 27 Oct 2016 15:19:15 +0300
Message-ID: <ee78f333-3200-0f59-40a9-1ae1c4e04b62@grimberg.me>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <0cd77719-1f11-d5c3-3186-1c7c3cfd6886@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34871 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936559AbcJ0OM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 10:12:27 -0400
In-Reply-To: <0cd77719-1f11-d5c3-3186-1c7c3cfd6886@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <keith.busch@intel.com>, Doug Ledford <dledford@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Laurence Oberman <loberman@redhat.com>, Christoph Hellwig <hch@lst.de>

Thanks for moving it,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
