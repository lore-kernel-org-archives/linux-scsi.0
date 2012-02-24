From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces to error messages
Date: Fri, 24 Feb 2012 16:32:59 +0100
Message-ID: <1330097579-25679-1-git-send-email-petr.uzel@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "supporter:QLOGIC QLA4XXX iS..." <iscsi-driver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jiri Kosina <trivial@kernel.org>, "open list:QLOGIC QLA4XXX iS..." <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ce6d3b7..edf5034 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3382,7 +3382,7 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		if (qla4xxx_get_flash(ha, buf_dma, addr,
 				      13 * sizeof(uint8_t)) != QLA_SUCCESS) {
 			DEBUG2(ql4_printk(KERN_ERR, ha, "scsi%ld: %s: Get Flash"
-					  "failed\n", ha->host_no, __func__));
+					  " failed\n", ha->host_no, __func__));
 			ret = QLA_ERROR;
 			goto exit_boot_info_free;
 		}
@@ -3620,7 +3620,7 @@ static int qla4xxx_setup_boot_info(struct scsi_qla_host *ha)
 
 	if (ql4xdisablesysfsboot) {
 		ql4_printk(KERN_INFO, ha,
-			   "%s: syfsboot disabled - driver will trigger login"
+			   "%s: syfsboot disabled - driver will trigger login "
 			   "and publish session for discovery .\n", __func__);
 		return QLA_SUCCESS;
 	}
-- 
1.7.7
