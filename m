From: vikas.chaudhary@qlogic.com
Subject: [PATCH 02/10] qla4xxx: Rename MBOX_ASTS_IDC_NOTIFY to MBOX_ASTS_IDC_REQUEST_NOTIFICATION
Date: Sun, 20 Jan 2013 23:50:57 -0500
Message-ID: <1358743865-435-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:39076 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750757Ab3AUFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:39 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 1c47950..6ee18a9 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -495,7 +495,7 @@ struct qla_flt_region {
 #define MBOX_ASTS_IPV6_LCL_PREFIX_IGNORED	0x802D
 #define MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD		0x802E
 #define MBOX_ASTS_IDC_COMPLETE			0x8100
-#define MBOX_ASTS_IDC_NOTIFY			0x8101
+#define MBOX_ASTS_IDC_REQUEST_NOTIFICATION	0x8101
 #define MBOX_ASTS_TXSCVR_INSERTED		0x8130
 #define MBOX_ASTS_TXSCVR_REMOVED		0x8131
 
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 39669b5..81909d9 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -806,7 +806,7 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			    " removed\n",  ha->host_no, mbox_sts[0]));
 			break;
 
-		case MBOX_ASTS_IDC_NOTIFY:
+		case MBOX_ASTS_IDC_REQUEST_NOTIFICATION:
 		{
 			uint32_t opcode;
 			if (is_qla8032(ha)) {
-- 
1.7.8.GIT

