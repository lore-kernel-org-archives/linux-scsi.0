From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH V2 7/7] SCSI: esas2r: Remove null test for stack allocated fw_coredump_buffer
Date: Thu, 5 Sep 2013 13:08:00 -0400
Message-ID: <1378400880-14640-8-git-send-email-bgrove@attotech.com>
References: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:32601 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752250Ab3IERIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 13:08:37 -0400
In-Reply-To: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, davej@redhat.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 9aaad0d..da1869d 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -1551,8 +1551,7 @@ void esas2r_reset_chip(struct esas2r_adapter *a)
 	 * to not overwrite a previous crash that was saved.
 	 */
 	if ((a->flags2 & AF2_COREDUMP_AVAIL)
-	    && !(a->flags2 & AF2_COREDUMP_SAVED)
-	    && a->fw_coredump_buff) {
+	    && !(a->flags2 & AF2_COREDUMP_SAVED)) {
 		esas2r_read_mem_block(a,
 				      a->fw_coredump_buff,
 				      MW_DATA_ADDR_SRAM + 0x80000,
-- 
1.8.1.4

