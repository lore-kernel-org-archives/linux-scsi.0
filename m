From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 03/24] qla4xxx: Fix comments in code
Date: Mon, 16 Dec 2013 06:49:33 -0500
Message-ID: <1387194594-29817-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:27921 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab3LPMX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:26 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index aa67bb9..e9df4ad 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -595,10 +595,10 @@ struct scsi_qla_host {
 #define DPC_AEN				9 /* 0x00000200 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
 #define DPC_LINK_CHANGED		18 /* 0x00040000 */
-#define DPC_RESET_ACTIVE		20 /* 0x00040000 */
-#define DPC_HA_UNRECOVERABLE		21 /* 0x00080000 ISP-82xx only*/
-#define DPC_HA_NEED_QUIESCENT		22 /* 0x00100000 ISP-82xx only*/
-#define DPC_POST_IDC_ACK		23 /* 0x00200000 */
+#define DPC_RESET_ACTIVE		20 /* 0x00100000 */
+#define DPC_HA_UNRECOVERABLE		21 /* 0x00200000 ISP-82xx only*/
+#define DPC_HA_NEED_QUIESCENT		22 /* 0x00400000 ISP-82xx only*/
+#define DPC_POST_IDC_ACK		23 /* 0x00800000 */
 #define DPC_RESTORE_ACB			24 /* 0x01000000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
-- 
1.8.2.GIT

