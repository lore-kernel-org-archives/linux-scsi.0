From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] scsi: isci: Grammar s/the its/its/
Date: Fri,  7 Jun 2019 13:34:26 +0200
Message-ID: <20190607113426.14937-1-geert+renesas@glider.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/isci/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 1b18cf55167e0a2e..c552b4b59717ae9b 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -224,7 +224,7 @@ static void scu_ssp_request_construct_task_context(
 	idev = ireq->target_device;
 	iport = idev->owning_port;
 
-	/* Fill in the TC with the its required data */
+	/* Fill in the TC with its required data */
 	task_context->abort = 0;
 	task_context->priority = 0;
 	task_context->initiator_request = 1;
@@ -506,7 +506,7 @@ static void scu_sata_request_construct_task_context(
 	idev = ireq->target_device;
 	iport = idev->owning_port;
 
-	/* Fill in the TC with the its required data */
+	/* Fill in the TC with its required data */
 	task_context->abort = 0;
 	task_context->priority = SCU_TASK_PRIORITY_NORMAL;
 	task_context->initiator_request = 1;
@@ -3235,7 +3235,7 @@ sci_io_request_construct_smp(struct device *dev,
 	iport = idev->owning_port;
 
 	/*
-	 * Fill in the TC with the its required data
+	 * Fill in the TC with its required data
 	 * 00h
 	 */
 	task_context->priority = 0;
-- 
2.17.1
