From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mpt fusion: fix indentation issues
Date: Thu,  7 Feb 2019 12:44:07 +0000
Message-ID: <20190207124407.2365-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several statements and code blocks there are incorrectly
indented. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/mptctl.c   |  2 +-
 drivers/message/fusion/mptsas.c   | 40 +++++++++++++++----------------
 drivers/message/fusion/mptscsih.c |  2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 8d22d6134a89..0f73f95ba33a 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -565,7 +565,7 @@ mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 	 * TODO - this define is not in MPI spec yet,
 	 * but they plan to set it to 0x21
 	 */
-	 if (event == 0x21 ) {
+	if (event == 0x21) {
 		ioc->aen_event_read_flag=1;
 		dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Raised SIGIO to application\n",
 		    ioc->name));
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 612cb5bc1333..e2de8ea17b95 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2928,27 +2928,27 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 	if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_RF_VALID) {
 		u8 *tmp;
 
-	smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
-	if (le16_to_cpu(smprep->ResponseDataLength) !=
-		sizeof(struct rep_manu_reply))
-			goto out_free;
-
-	manufacture_reply = data_out + sizeof(struct rep_manu_request);
-	strncpy(edev->vendor_id, manufacture_reply->vendor_id,
-		SAS_EXPANDER_VENDOR_ID_LEN);
-	strncpy(edev->product_id, manufacture_reply->product_id,
-		SAS_EXPANDER_PRODUCT_ID_LEN);
-	strncpy(edev->product_rev, manufacture_reply->product_rev,
-		SAS_EXPANDER_PRODUCT_REV_LEN);
-	edev->level = manufacture_reply->sas_format;
-	if (manufacture_reply->sas_format) {
-		strncpy(edev->component_vendor_id,
-			manufacture_reply->component_vendor_id,
+		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
+		if (le16_to_cpu(smprep->ResponseDataLength) !=
+		    sizeof(struct rep_manu_reply))
+			goto out_free;
+
+		manufacture_reply = data_out + sizeof(struct rep_manu_request);
+		strncpy(edev->vendor_id, manufacture_reply->vendor_id,
+			SAS_EXPANDER_VENDOR_ID_LEN);
+		strncpy(edev->product_id, manufacture_reply->product_id,
+			SAS_EXPANDER_PRODUCT_ID_LEN);
+		strncpy(edev->product_rev, manufacture_reply->product_rev,
+			SAS_EXPANDER_PRODUCT_REV_LEN);
+		edev->level = manufacture_reply->sas_format;
+		if (manufacture_reply->sas_format) {
+			strncpy(edev->component_vendor_id,
+				manufacture_reply->component_vendor_id,
 				SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
-		tmp = (u8 *)&manufacture_reply->component_id;
-		edev->component_id = tmp[0] << 8 | tmp[1];
-		edev->component_revision_id =
-			manufacture_reply->component_revision_id;
+			tmp = (u8 *)&manufacture_reply->component_id;
+			edev->component_id = tmp[0] << 8 | tmp[1];
+			edev->component_revision_id =
+				manufacture_reply->component_revision_id;
 		}
 	} else {
 		printk(MYIOC_s_ERR_FMT
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 6ba07c7feb92..587b5daf74b4 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1934,7 +1934,7 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-    retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+	retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
 	if (retval < 0)
 		status = FAILED;
 	else
-- 
2.20.1
