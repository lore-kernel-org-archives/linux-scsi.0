From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/4] qla4xxx: Fix a Sparse warning message
Date: Thu, 14 Jun 2012 06:35:49 -0400
Message-ID: <1339670151-26289-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:37070 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755729Ab2FNKwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2012 06:52:05 -0400
In-Reply-To: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Fix following message:-
drivers/scsi/qla4xxx/ql4_os.c:3266:5: error: symbol 'qla4xxx_post_aen_work' redeclared with different type (originally declared at drivers/scsi/qla4xxx/ql4_glbl.h:186) - incompatible argument 2 (different signedness)

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 20b49d0..5b2525c 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -183,7 +183,8 @@ int qla4xxx_flash_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		       struct ddb_entry *ddb_entry, uint32_t state);
 void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset);
-int qla4xxx_post_aen_work(struct scsi_qla_host *ha, uint32_t aen_code,
+int qla4xxx_post_aen_work(struct scsi_qla_host *ha,
+			  enum iscsi_host_event_code aen_code,
 			  uint32_t data_size, uint8_t *data);
 int qla4xxx_ping_iocb(struct scsi_qla_host *ha, uint32_t options,
 		      uint32_t payload_size, uint32_t pid, uint8_t *ipaddr);
-- 
1.7.9.1.265.gb3a76

