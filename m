From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] lpfc: Grammar s/an negative/a negative/
Date: Thu, 21 May 2015 14:11:33 +0200
Message-ID: <1432210293-22684-1-git-send-email-geert+renesas@glider.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:39542 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbbEUMLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 08:11:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 513edcb0c2dae379..25aa9b98d53aa345 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -710,7 +710,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
  * returns a pointer to that log in the private_data field in @file.
  *
  * Returns:
- * This function returns zero if successful. On error it will return an negative
+ * This function returns zero if successful. On error it will return a negative
  * error value.
  **/
 static int
@@ -760,7 +760,7 @@ out:
  * returns a pointer to that log in the private_data field in @file.
  *
  * Returns:
- * This function returns zero if successful. On error it will return an negative
+ * This function returns zero if successful. On error it will return a negative
  * error value.
  **/
 static int
@@ -810,7 +810,7 @@ out:
  * returns a pointer to that log in the private_data field in @file.
  *
  * Returns:
- * This function returns zero if successful. On error it will return an negative
+ * This function returns zero if successful. On error it will return a negative
  * error value.
  **/
 static int
@@ -852,7 +852,7 @@ out:
  * returns a pointer to that log in the private_data field in @file.
  *
  * Returns:
- * This function returns zero if successful. On error it will return an negative
+ * This function returns zero if successful. On error it will return a negative
  * error value.
  **/
 static int
@@ -894,7 +894,7 @@ out:
  * returns a pointer to that log in the private_data field in @file.
  *
  * Returns:
- * This function returns zero if successful. On error it will return an negative
+ * This function returns zero if successful. On error it will return a negative
  * error value.
  **/
 static int
@@ -1115,7 +1115,7 @@ lpfc_debugfs_dif_err_release(struct inode *inode, struct file *file)
  * returns a pointer to that log in the private_data field in @file.
  *
  * Returns:
- * This function returns zero if successful. On error it will return an negative
+ * This function returns zero if successful. On error it will return a negative
  * error value.
  **/
 static int
-- 
1.9.1

