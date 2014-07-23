From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 1/2] scsi: ufs: make undeclared functions static
Date: Wed, 23 Jul 2014 09:31:11 +0300
Message-ID: <1406097072-18148-2-git-send-email-draviv@codeaurora.org>
References: <1406097072-18148-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:35590 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaGWGbe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2014 02:31:34 -0400
In-Reply-To: <1406097072-18148-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Make undeclared functions static to suppress warnings
from sparse tool.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d412339..a450407 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1314,7 +1314,7 @@ out:
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  */
-int ufshcd_query_descriptor(struct ufs_hba *hba,
+static int ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
 			u8 selector, u8 *desc_buf, int *buf_len)
 {
@@ -2018,7 +2018,8 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  * Change queue depth according to the reason and make sure
  * the max. limits are not crossed.
  */
-int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
+static int ufshcd_change_queue_depth(struct scsi_device *sdev,
+		int depth, int reason)
 {
 	struct ufs_hba *hba = shost_priv(sdev->host);
 
-- 
1.8.5.2

--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

