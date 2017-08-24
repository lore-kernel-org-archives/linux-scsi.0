From: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] scsi: Fix the kerneldoc for scsi_initialize_rq()
Date: Thu, 24 Aug 2017 16:11:09 -0600
Message-ID: <20170824161109.6e23432b@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:48078 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753456AbdHXWLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 18:11:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org

The kerneldoc comment for scsi_initialize_rq() neglected to document the
"rq" parameter, leading to this docs build warning:

  ./drivers/scsi/scsi_lib.c:1116: warning: No description found for parameter 'rq'

Document the parameter and make the build slightly quieter.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6097b89d5d3..a76515814ee7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1108,6 +1108,7 @@ EXPORT_SYMBOL(scsi_init_io);
 
 /**
  * scsi_initialize_rq - initialize struct scsi_cmnd.req
+ * @rq: Request used to locate the scsi_cmnd structure.
  *
  * Called from inside blk_get_request().
  */
-- 
2.13.4
