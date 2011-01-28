From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:scsi Change initate to initiate.
Date: Fri, 28 Jan 2011 11:49:08 -0800
Message-ID: <1296244148-3808-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Not sure if this is a typo or not. if it is then feel free to take this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6ffbe97..03e028e 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1027,7 +1027,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 					((ddb_entry->default_time2wait +
 					  4) * HZ);
 
-				DEBUG2(printk("scsi%ld: ddb [%d] initate"
+				DEBUG2(printk("scsi%ld: ddb [%d] initiate"
 					      " RELOGIN after %d seconds\n",
 					      ha->host_no,
 					      ddb_entry->fw_ddb_index,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3fc1d25..967836e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -812,7 +812,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 					);
 				start_dpc++;
 				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
-					     "initate relogin after"
+					     "initiate relogin after"
 					     " %d seconds\n",
 					     ha->host_no, ddb_entry->bus,
 					     ddb_entry->target,
-- 
1.6.5.GIT
