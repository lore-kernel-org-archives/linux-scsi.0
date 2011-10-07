From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 01/14] qla4xxx: Add new FLT firmware region
Date: Fri, 7 Oct 2011 16:55:39 -0700
Message-ID: <1318031752-3836-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:22722
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776Ab1JHAH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:26 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h |    1 +
 drivers/scsi/qla4xxx/ql4_nx.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 0e24c7a..597875f 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -306,6 +306,7 @@ struct qla_flt_header {
 #define FLT_REG_FLT		0x1c
 #define FLT_REG_BOOTLOAD_82	0x72
 #define FLT_REG_FW_82		0x74
+#define FLT_REG_FW_82_1		0x97
 #define FLT_REG_GOLD_FW_82	0x75
 #define FLT_REG_BOOT_CODE_82	0x78
 #define FLT_REG_ISCSI_PARAM	0x65
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index a539e17..84c254a 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2015,6 +2015,7 @@ qla4_8xxx_get_flt_info(struct scsi_qla_host *ha, uint32_t flt_addr)
 			hw->flt_region_boot = start;
 			break;
 		case FLT_REG_FW_82:
+		case FLT_REG_FW_82_1:
 			hw->flt_region_fw = start;
 			break;
 		case FLT_REG_BOOTLOAD_82:
-- 
1.7.6


