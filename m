From: vikas.chaudhary@qlogic.com
Subject: [PATCH 03/12] qla4xxx: Update func name from ql4_ to qla4_
Date: Wed, 22 Aug 2012 07:55:01 -0400
Message-ID: <1345636510-23131-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:53184 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754070Ab2HVMLw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:11:52 -0400
In-Reply-To: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

ql4_8xxx_mark_entry_skipped to qla4_8xxx_mark_entry_skipped
ql4_attr_is_visible to qla4_attr_is_visible

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   12 ++++++------
 drivers/scsi/qla4xxx/ql4_os.c |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index fa34e20..7764c3f 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2077,7 +2077,7 @@ static int qla4_8xxx_minidump_process_rdmem(struct scsi_qla_host *ha,
 	return QLA_SUCCESS;
 }
 
-static void ql4_8xxx_mark_entry_skipped(struct scsi_qla_host *ha,
+static void qla4_8xxx_mark_entry_skipped(struct scsi_qla_host *ha,
 				struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				int index)
 {
@@ -2161,13 +2161,13 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 		 */
 		switch (entry_hdr->entry_type) {
 		case QLA82XX_RDEND:
-			ql4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
+			qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 			break;
 		case QLA82XX_CNTRL:
 			rval = qla4_8xxx_minidump_process_control(ha,
 								  entry_hdr);
 			if (rval != QLA_SUCCESS) {
-				ql4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
+				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 				goto md_failed;
 			}
 			break;
@@ -2179,7 +2179,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 			rval = qla4_8xxx_minidump_process_rdmem(ha, entry_hdr,
 								&data_ptr);
 			if (rval != QLA_SUCCESS) {
-				ql4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
+				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 				goto md_failed;
 			}
 			break;
@@ -2195,7 +2195,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 			rval = qla4_8xxx_minidump_process_l2tag(ha, entry_hdr,
 								&data_ptr);
 			if (rval != QLA_SUCCESS) {
-				ql4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
+				qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 				goto md_failed;
 			}
 			break;
@@ -2218,7 +2218,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 			break;
 		case QLA82XX_RDNOP:
 		default:
-			ql4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
+			qla4_8xxx_mark_entry_skipped(ha, entry_hdr, i);
 			break;
 		}
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a3a26e4..89c2576 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -160,7 +160,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static int qla4xxx_slave_configure(struct scsi_device *device);
 static void qla4xxx_slave_destroy(struct scsi_device *sdev);
-static umode_t ql4_attr_is_visible(int param_type, int param);
+static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
 static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
 				      int reason);
@@ -203,7 +203,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 				  CAP_DATA_PATH_OFFLOAD | CAP_HDRDGST |
 				  CAP_DATADGST | CAP_LOGIN_OFFLOAD |
 				  CAP_MULTI_R2T,
-	.attr_is_visible	= ql4_attr_is_visible,
+	.attr_is_visible	= qla4_attr_is_visible,
 	.create_session         = qla4xxx_session_create,
 	.destroy_session        = qla4xxx_session_destroy,
 	.start_conn             = qla4xxx_conn_start,
@@ -315,7 +315,7 @@ exit_send_ping:
 	return rval;
 }
 
-static umode_t ql4_attr_is_visible(int param_type, int param)
+static umode_t qla4_attr_is_visible(int param_type, int param)
 {
 	switch (param_type) {
 	case ISCSI_HOST_PARAM:
-- 
1.7.8.GIT

