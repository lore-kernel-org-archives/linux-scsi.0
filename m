From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH 1/3] bnx2fc: remove unused variable hash_table_size
Date: Tue,  1 Apr 2014 13:58:20 +0200
Message-ID: <1396353502-30083-2-git-send-email-mlombard@redhat.com>
References: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaDAL6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2014 07:58:42 -0400
In-Reply-To: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, m.lombardi85@gmail.com, eddie.wai@broadcom.com

hash_table_size is not used by the bnx2fc_free_hash_table() function.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 46a3765..261af2a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1966,12 +1966,9 @@ static void bnx2fc_free_hash_table(struct bnx2fc_hba *hba)
 {
 	int i;
 	int segment_count;
-	int hash_table_size;
 	u32 *pbl;
 
 	segment_count = hba->hash_tbl_segment_count;
-	hash_table_size = BNX2FC_NUM_MAX_SESS * BNX2FC_MAX_ROWS_IN_HASH_TBL *
-		sizeof(struct fcoe_hash_table_entry);
 
 	pbl = hba->hash_tbl_pbl;
 	for (i = 0; i < segment_count; ++i) {
-- 
Maurizio Lombardi

