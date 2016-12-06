From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 03/22] qla2xxx: Set tcm_qla2xxx version to automatically track qla2xxx version.
Date: Tue, 6 Dec 2016 12:30:32 -0800
Message-ID: <1481056251-2310-4-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0076.outbound.protection.outlook.com ([104.47.42.76]:30525
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752171AbcLFUbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:05 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 37e026a..37e9f57 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -1,7 +1,7 @@
 #include <target/target_core_base.h>
 #include <linux/btree.h>
 
-#define TCM_QLA2XXX_VERSION	"v0.1"
+#define TCM_QLA2XXX_VERSION	QLA2XXX_VERSION
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN	32
 /*
-- 
1.8.3.1

