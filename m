From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [Fwd: [SCSI] Delete duplicate driver template.]
Date: Thu, 09 Feb 2006 11:16:38 -0500
Message-ID: <1139501798.3275.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52884 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932580AbWBIQQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 11:16:40 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k19GGd222334
	for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2006 11:16:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

-------- Forwarded Message --------
From: Ralf Baechle <ralf@linux-mips.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [SCSI] Delete duplicate driver template.
Date: Wed, 8 Feb 2006 22:22:57 +0000

Resending yet again.

Stuborn as compilers are they don't like duplicate definitions.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -65,27 +65,6 @@ static int jazz_esp_release(struct Scsi_
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
-	.proc_name		= "jazz_esp",
-	.proc_info		= &esp_proc_info,
-	.name			= "ESP 100/100a/200",
-	.detect			= jazz_esp_detect,
-	.slave_alloc		= esp_slave_alloc,
-	.slave_destroy		= esp_slave_destroy,
-	.release		= jazz_esp_release,
-	.info			= esp_info,
-	.queuecommand		= esp_queue,
-	.eh_abort_handler	= esp_abort,
-	.eh_bus_reset_handler	= esp_reset,
-	.can_queue		= 7,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
-	.use_clustering		= DISABLE_CLUSTERING,
-};
-
-#include "scsi_module.c"
-
 /***************************************************************** Detection */
 static int jazz_esp_detect(struct scsi_host_template *tpnt)
 {

