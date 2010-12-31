From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/7] scsi/aic7xxx/aic7xxx.h Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:39:22 -0800
Message-ID: <1293817162-8046-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f66.google.com ([209.85.160.66]:47976 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0LaRjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Dec 2010 12:39:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aic7xxx/aic7xxx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index e4e651c..17444bc 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -618,7 +618,7 @@ struct scb_data {
 /************************ Target Mode Definitions *****************************/
 
 /*
- * Connection desciptor for select-in requests in target mode.
+ * Connection descriptor for select-in requests in target mode.
  */
 struct target_cmd {
 	uint8_t scsiid;		/* Our ID and the initiator's ID */
-- 
1.6.5.2.180.gc5b3e

