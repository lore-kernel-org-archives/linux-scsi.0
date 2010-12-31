From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/7] scsi/aic7xxx/aic79xx.h Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:39:42 -0800
Message-ID: <1293817182-8081-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aic7xxx/aic79xx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index be5558a..95ee503 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -672,7 +672,7 @@ struct scb_data {
 /************************ Target Mode Definitions *****************************/
 
 /*
- * Connection desciptor for select-in requests in target mode.
+ * Connection descriptor for select-in requests in target mode.
  */
 struct target_cmd {
 	uint8_t scsiid;		/* Our ID and the initiator's ID */
-- 
1.6.5.2.180.gc5b3e
