From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi:cxgb4i: update module description
Date: Mon, 17 Apr 2017 21:32:41 +0530
Message-ID: <1492444961-8396-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:6882 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754021AbdDQQC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2017 12:02:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 3fb3f57..1076c15 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -36,7 +36,7 @@ static unsigned int dbg_level;
 #include "../libcxgbi.h"
 
 #define	DRV_MODULE_NAME		"cxgb4i"
-#define DRV_MODULE_DESC		"Chelsio T4/T5 iSCSI Driver"
+#define DRV_MODULE_DESC		"Chelsio T4-T6 iSCSI Driver"
 #define	DRV_MODULE_VERSION	"0.9.5-ko"
 #define DRV_MODULE_RELDATE	"Apr. 2015"
 
-- 
2.0.2
