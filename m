From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] SRP transport, scsi-mq: Wait for .queue_rq() if necessary
Date: Fri, 25 Nov 2016 10:12:14 -0500
Message-ID: <yq1d1hjtwz5.fsf@sermon.lab.mkp.net>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22171 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755094AbcKYPMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2016 10:12:51 -0500
In-Reply-To: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com> (Bart Van
        Assche's message of "Tue, 22 Nov 2016 16:16:06 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> The SRP transport code must wait until ongoing .queuecommand() /
Bart> .queue_rq() callback function invocations have finished before
Bart> reconnecting at the transport layer level and also before invoking
Bart> .terminate_rport_io(). This is already the case for the single
Bart> queue path but not yet for the scsi-mq path. This patch series
Bart> realizes the proper serialization for the scsi-mq path. Compared
Bart> to last time these patches were posted, only the patch
Bart> descriptions and one comment have been changed.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
