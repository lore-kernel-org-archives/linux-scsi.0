From: akpm@linux-foundation.org
Subject: [patch 21/30] drivers/scsi/lpfc/lpfc_debugfs.c: kmalloc + memset conversion to kcalloc
Date: Fri, 10 Aug 2007 14:50:47 -0700
Message-ID: <200708102150.l7ALolB5011381@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208AbXHJWBY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl, James.Smart@Emulex.Com

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_debugfs.c | 13809 -> 13716 (-93 bytes)
 drivers/scsi/lpfc/lpfc_debugfs.o | 146124 -> 146124 (0 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_debugfs.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -901,7 +901,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		}
 	}
 
-	vport->disc_trc = kmalloc(
+	vport->disc_trc = kzalloc(
 		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc),
 		GFP_KERNEL);
 
@@ -912,8 +912,6 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		goto debug_failed;
 	}
 	atomic_set(&vport->disc_trc_cnt, 0);
-	memset(vport->disc_trc, 0,
-		(sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_disc_trc));
 
 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
_
