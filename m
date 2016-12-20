From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] SRP transport, scsi-mq: Wait for .queue_rq() if necessary
Date: Tue, 20 Dec 2016 17:14:53 -0500
Message-ID: <yq1pokm2qoy.fsf@sermon.lab.mkp.net>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
        <7c9a22c1-9940-7a8d-a479-c8cc5d274c60@sandisk.com>
        <6c4aa0b2-20ec-3ad8-065d-7288cf78fc23@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28576 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752686AbcLTWPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 17:15:15 -0500
In-Reply-To: <6c4aa0b2-20ec-3ad8-065d-7288cf78fc23@sandisk.com> (Bart Van
        Assche's message of "Fri, 16 Dec 2016 13:39:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@gmail.com> writes:

Bart> It seems like patch 1/2 of this series is already present in
Bart> Linus' tree but patch 2/2 not yet? Can you queue this patch for
Bart> the next pull request that will be sent to Linus?

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
