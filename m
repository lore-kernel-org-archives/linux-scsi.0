From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 09/12] SRP transport: Move queuecommand() wait code to
 SCSI core
Date: Thu, 27 Oct 2016 15:20:59 +0300
Message-ID: <82964ec5-6ba2-d55a-6507-4094a8b51b02@grimberg.me>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <e86cdaf9-6305-d2cb-6068-0a050c023d73@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:32884 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965925AbcJ0OJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 10:09:31 -0400
In-Reply-To: <e86cdaf9-6305-d2cb-6068-0a050c023d73@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
