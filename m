From: Joe Perches <joe@perches.com>
Subject: [PATCH 43/59] drivers/scsi/qla4xxx: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:35 -0800
Message-ID: <769fa1b17e5b66a91e59e7c5899b6747b39b5731.1195454436.git.joe__38176.771955523$1195524408$gmane$org@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
 <1195523331-15303-27-git-send-email-joe@perches.com>
 <1195523331-15303-28-git-send-email-joe@perches.com>
 <1195523331-15303-29-git-send-email-joe@perches.com>
 <1195523331-15303-30-git-send-email-joe@perches.com>
 <1195523331-15303-31-git-send-email-joe@perches.com>
 <1195523331-15303-32-git-send-email-joe@perches.com>
 <1195523331-15303-33-git-send-email-joe@perches.com>
 <1195523331-15303-34-git-send-email-joe@perches.com>
 <1195523331-15303-35-git-send-email-joe@perches.com>
 <1195523331-15303-36-git-send-email-joe@perches.com>
 <1195523331-15303-37-git-send-email-joe@perches.com>
 <1195523331-15303-38-git-send-email-joe@perches.com>
 <1195523331-15303-39-git-send-email-joe@perches.com>
 <1195523331-15303-40-git-send-email-joe@perches.com>
 <1195523331-15303-41-git-send-email-joe@perches.com>
 <1195523331-15303-42-git-send-email-joe@perches.com>
 <1195523331-15303-43-git-send-email-joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761084AbXKTCEs@vger.kernel.org>
In-Reply-To: <1195523331-15303-43-git-send-email-joe@perches.com>
Message-Id: <769fa1b17e5b66a91e59e7c5899b6747b39b5731.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


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
