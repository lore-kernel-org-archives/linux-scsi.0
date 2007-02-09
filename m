From: Swen Schillig <swen.schillig@freenet.de>
Subject: [PATCH] zfcp: removed wrong comment
Date: Fri, 9 Feb 2007 10:01:40 +0100
Message-ID: <200702091001.41038.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout0.freenet.de ([194.97.50.131]:59447 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946234AbXBIJBU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 04:01:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

commit 07a105136f07f0cf1b476383e43033b8a65e13ff
Author: Swen Schillig <swen@vnet.ibm.com>
Date:   Fri Feb 9 09:58:09 2007 +0100

removed wrong comment
    
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

---
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index cbe47a2..0cc8603 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -838,8 +838,6 @@ zfcp_erp_action_exists(struct zfcp_erp_action *erp_action)
  *		and does appropriate preparations (dismiss fsf request, ...)
  *
  * locks:	called under erp_lock (disabled interrupts)
- *
- * returns:	0
  */
 static void
 zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *erp_action)
