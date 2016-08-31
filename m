From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 02/15] smartpqi: change tmf macro names
Date: Wed, 31 Aug 2016 14:54:17 -0500
Message-ID: <147267325701.22907.17034286428969566564.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0057.outbound.protection.outlook.com ([104.47.41.57]:7424
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752879AbcHaTy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:54:26 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

small change to make code look cleaner

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    6 ++----
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index ea49005..dbcdb03 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -545,10 +545,8 @@ typedef u32 pqi_index_t;
 #define SOP_TASK_ATTRIBUTE_ORDERED		2
 #define SOP_TASK_ATTRIBUTE_ACA			4
 
-#define SOP_TASK_MANAGEMENT_FUNCTION_COMPLETE	0x0
-#define SOP_TASK_MANAGEMENT_FUNCTION_REJECTED	0x4
-#define SOP_TASK_MANAGEMENT_FUNCTION_FAILED	0x5
-#define SOP_TASK_MANAGEMENT_FUNCTION_SUCCEEDED	0x8
+#define SOP_TMF_COMPLETE		0x0
+#define SOP_TMF_FUNCTION_SUCCEEDED	0x8
 
 /* additional CDB bytes usage field codes */
 #define SOP_ADDITIONAL_CDB_BYTES_0	0	/* 16-byte CDB */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 418f636..6eab38e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2469,8 +2469,8 @@ static int pqi_interpret_task_management_response(
 	int rc;
 
 	switch (response->response_code) {
-	case SOP_TASK_MANAGEMENT_FUNCTION_COMPLETE:
-	case SOP_TASK_MANAGEMENT_FUNCTION_SUCCEEDED:
+	case SOP_TMF_COMPLETE:
+	case SOP_TMF_FUNCTION_SUCCEEDED:
 		rc = 0;
 		break;
 	default:

