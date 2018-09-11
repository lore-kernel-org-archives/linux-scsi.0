From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Fix comment in MODULE_PARM_DESC in qla2xxx
Date: Tue, 11 Sep 2018 18:48:11 +0900
Message-ID: <20180911094811.12681-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, himanshu.madhani@cavium.com, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Default value of ql2xasynctmfenable for qla2xxx driver was
set to 1 in commit 043dc1d7e8501.
But comment in MODULE_PARAM_DESC was not modified.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 42b8f0d3e580..fe5404be73c5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -204,7 +204,7 @@ int ql2xasynctmfenable = 1;
 module_param(ql2xasynctmfenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xasynctmfenable,
 		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
-		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
+		"Default is 1 - Issue TM IOCBs via mailbox mechanism.");
 
 int ql2xdontresethba;
 module_param(ql2xdontresethba, int, S_IRUGO|S_IWUSR);
-- 
2.19.0
