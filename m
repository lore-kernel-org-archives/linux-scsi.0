From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/6] qla2xxx: Use %p for printing pointers
Date: Tue, 23 Jan 2018 16:33:47 -0800
Message-ID: <20180124003351.2616-3-bart.vanassche@wdc.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752455AbeAXAdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:33:52 -0500
In-Reply-To: <20180124003351.2616-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Using %p instead of %lx to print a pointer allows to remove a cast.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aececf664654..995579ea0f7f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2688,8 +2688,8 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	/* Assume a failed state */
 	rval = QLA_FUNCTION_FAILED;
 
-	ql_dbg(ql_dbg_init, vha, 0x007b,
-	    "Testing device at %lx.\n", (u_long)&reg->flash_address);
+	ql_dbg(ql_dbg_init, vha, 0x007b, "Testing device at %p.\n",
+	       &reg->flash_address);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-- 
2.15.1
