From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/3] Use sgl_alloc_order() and sgl_free_order()
Date: Mon, 12 Feb 2018 08:58:16 -0800
Message-ID: <20180212165819.11953-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42700 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbeBLQ6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 11:58:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

In kernel v4.16-rc1 the functions sgl_alloc_order() and sgl_free_order() were
introduced in lib/scatterlist.c. This patch series introduces these functions
in the ipr and pmcraid SCSI drivers. Please consider these patches for kernel
v4.17.

Thanks,

Bart.

Bart Van Assche (3):
  scsi/ipr: Use sgl_alloc_order() and sgl_free_order()
  scsi/pmcraid: Remove an unused structure member
  scsi/pmcraid: Use sgl_alloc_order() and sgl_free_order()

 drivers/scsi/Kconfig   |  2 ++
 drivers/scsi/ipr.c     | 49 ++++++++-----------------------------------------
 drivers/scsi/ipr.h     |  2 +-
 drivers/scsi/pmcraid.c | 43 ++++---------------------------------------
 drivers/scsi/pmcraid.h |  3 +--
 5 files changed, 16 insertions(+), 83 deletions(-)

-- 
2.16.1
