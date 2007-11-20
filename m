From: Joe Perches <joe@perches.com>
Subject: [PATCH 43/59] drivers/scsi/qla4xxx: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:30 -0800
Message-ID: <1195523627-15389-1-git-send-email-joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2194 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485AbXKTBxr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:47 -0500
In-Reply-To: 1234567
References: 1234567
Message-Id: <769fa1b17e5b66a91e59e7c5899b6747b39b5731.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index d692c71..ab619a8 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1184,7 +1184,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 		 */
 		status = qla4xxx_initialize_ddb_list(ha);
 		if (status == QLA_ERROR) {
-			DEBUG2(printk("%s(%ld) Error occurred during build"
+			DEBUG2(printk("%s(%ld) Error occurred during build "
 				      "ddb list\n", __func__, ha->host_no));
 			goto exit_init_hba;
 		}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 89460d2..7aa64ca 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1016,7 +1016,7 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 	struct ddb_entry *ddb_entry, *dtemp;
 	int status = QLA_ERROR;
 
-	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
+	DEBUG2(printk("scsi%ld: %s: DPC handler waking up. "
 		"flags = 0x%08lx, dpc_flags = 0x%08lx ctrl_stat = 0x%08x\n",
 		ha->host_no, __func__, ha->flags, ha->dpc_flags,
 		readw(&ha->reg->ctrl_status)));
@@ -1563,7 +1563,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	DEBUG2(printk(KERN_INFO
-		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
+		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x, "
 		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
 		      cmd, jiffies, cmd->timeout_per_command / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
-- 
1.5.3.5.652.gf192c

