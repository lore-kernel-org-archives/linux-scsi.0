From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 6/7] bnx2fc: Add HZ to task management timeout.
Date: Mon, 19 Oct 2015 15:40:40 -0400
Message-ID: <1445283641-7358-7-git-send-email-chad.dupuis@qlogic.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:1718 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbbJSUTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:15 -0400
In-Reply-To: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index d46267d..d05866d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -129,7 +129,7 @@
 #define BNX2FC_MAX_FCP_TGT		256
 #define BNX2FC_MAX_CMD_LEN		16
 
-#define BNX2FC_TM_TIMEOUT		60	/* secs */
+#define BNX2FC_TM_TIMEOUT		(60 * HZ) /* seconds */
 #define BNX2FC_IO_TIMEOUT		20000UL	/* msecs */
 
 #define BNX2FC_WAIT_CNT			1200
-- 
1.7.7

