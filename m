From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/5] qla4xxx: Fix sparse warning for qla4xxx_sysfs_ddb_tgt_create
Date: Wed, 17 Apr 2013 05:15:27 -0400
Message-ID: <1366190130-16556-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:61669 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754360Ab3DQJjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 05:39:14 -0400
In-Reply-To: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Fix following warning:
drivers/scsi/qla4xxx/ql4_os.c:5507:5:
warning: symbol 'qla4xxx_sysfs_ddb_tgt_create' was not declared. Should it be
static?

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5479cd3..3682fbd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5504,9 +5504,9 @@ static int qla4xxx_sysfs_ddb_is_non_persistent(struct device *dev, void *data)
  * If this is invoked as a result of a userspace call then the entry is marked
  * as nonpersistent using flash_state field.
  **/
-int qla4xxx_sysfs_ddb_tgt_create(struct scsi_qla_host *ha,
-				 struct dev_db_entry *fw_ddb_entry,
-				 uint16_t *idx, int user)
+static int qla4xxx_sysfs_ddb_tgt_create(struct scsi_qla_host *ha,
+					struct dev_db_entry *fw_ddb_entry,
+					uint16_t *idx, int user)
 {
 	struct iscsi_bus_flash_session *fnode_sess = NULL;
 	struct iscsi_bus_flash_conn *fnode_conn = NULL;
-- 
1.8.2.GIT

