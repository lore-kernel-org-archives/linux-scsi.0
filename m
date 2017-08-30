From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 0/3] Improve requeuing behavior
Date: Tue, 29 Aug 2017 17:07:39 -0700
Message-ID: <20170830000742.29653-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27182 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdH3AIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 20:08:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The conclusion of a recent discussion is that .jiffies_at_alloc and .retries
should be set once at the start of a lifetime of a SCSI request instead of
every time a request is requeued. This patch series realizes that. Please
consider these patches for kernel v4.14.

Thanks,

Bart.

Bart Van Assche (3):
  Call scsi_initialize_rq() also for filesystem requests
  Improve requeuing behavior
  Show .retries and .jiffies_at_alloc in debugfs

 drivers/scsi/scsi_debugfs.c |  3 ++-
 drivers/scsi/scsi_lib.c     | 41 +++++++++++++++++++++++++++++++++++------
 include/scsi/scsi_cmnd.h    |  3 +++
 3 files changed, 40 insertions(+), 7 deletions(-)

-- 
2.14.1
