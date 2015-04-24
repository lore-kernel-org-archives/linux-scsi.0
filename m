From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/23] advansys: Remove cmd_per_lun setting
Date: Fri, 24 Apr 2015 13:18:38 +0200
Message-ID: <1429874322-85488-21-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967107AbbDXLSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:52 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Ancient, and pretty much obsolete by now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 74e5518..5a55272 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11212,24 +11212,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 	}
 
 	/*
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
-	shost->cmd_per_lun = 1;
-/* #else
-            shost->cmd_per_lun = 0;
-#endif */
-
-	/*
 	 * Set the maximum number of scatter-gather elements the
 	 * adapter can handle.
 	 */
-- 
1.8.5.2

