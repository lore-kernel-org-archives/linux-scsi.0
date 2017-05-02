From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] scsi_lib: Add #include <scsi/scsi_transport.h>
Date: Tue, 2 May 2017 10:45:03 -0700
Message-ID: <20170502174503.13277-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12251 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdEBRpN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 13:45:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that when building with W=1 the compiler
complains that __scsi_init_queue() has not been declared.
See also commit d48777a633d6 ("scsi: remove __scsi_alloc_queue").

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d698364df072..b7b340c494ab 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -30,6 +30,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h> /* __scsi_init_queue() */
 #include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
-- 
2.12.2
