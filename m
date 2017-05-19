From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 2/7] qedi: Correctly set firmware max supported BDs.
Date: Fri, 19 May 2017 01:33:16 -0700
Message-ID: <20170519083321.18030-3-manish.rangankar@cavium.com>
References: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:15076
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752145AbdESIdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:36 -0400
In-Reply-To: <20170519083321.18030-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 5ca3e8c..269dac6 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -38,7 +38,7 @@
 #define QEDI_MAX_ISCSI_TASK		4096
 #define QEDI_MAX_TASK_NUM		0x0FFF
 #define QEDI_MAX_ISCSI_CONNS_PER_HBA	1024
-#define QEDI_ISCSI_MAX_BDS_PER_CMD	256	/* Firmware max BDs is 256 */
+#define QEDI_ISCSI_MAX_BDS_PER_CMD	255	/* Firmware max BDs is 255 */
 #define MAX_OUSTANDING_TASKS_PER_CON	1024
 
 #define QEDI_MAX_BD_LEN		0xffff
-- 
1.8.3.1
