From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/22] advansys: Remove comment around cmd_per_lun
Date: Fri, 24 Apr 2015 10:32:54 +0200
Message-ID: <1429864377-67002-20-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966460AbbDXIdP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:15 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Ancient, and pretty much obsolete by now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 424a08d..4f9392d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11213,23 +11213,7 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		goto err_free_dma;
 	}
 
-	/*
-	 * Following v1.3.89, 'cmd_per_lun' is no longer needed
-	 * and should be set to zero.
-	 *
-	 * But because of a bug introduced in v1.3.89 if the driver is
-	 * compiled as a module and 'cmd_per_lun' is zero, the Mid-Level
-	 * SCSI function 'allocate_device' will panic. To allow the driver
-	 * to work as a module in these kernels set 'cmd_per_lun' to 1.
-	 *
-	 * Note: This is wrong.  cmd_per_lun should be set to the depth
-	 * you want on untagged devices always.
-	 #ifdef MODULE
-	 */
 	shost->cmd_per_lun = 1;
-/* #else
-            shost->cmd_per_lun = 0;
-#endif */
 
 	/*
 	 * Set the maximum number of scatter-gather elements the
-- 
1.8.5.2

