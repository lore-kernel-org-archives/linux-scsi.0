From: Weitao Hou <houweitaoo@gmail.com>
Subject: [PATCH] scsi: fix typos in code comments
Date: Mon, 20 May 2019 11:24:03 +0800
Message-ID: <20190520032403.12513-1-houweitaoo@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jinpu.wang@profitbricks.com, lindar_liu@usish.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Weitao Hou <houweitaoo@gmail.com>
List-Id: linux-scsi@vger.kernel.org

fix abord to abort

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 88eef3b18e41..3de57c5a3299 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1181,7 +1181,7 @@ int pm8001_query_task(struct sas_task *task)
 	return rc;
 }
 
-/*  mandatory SAM-3, still need free task/ccb info, abord the specified task */
+/*  mandatory SAM-3, still need free task/ccb info, abort the specified task */
 int pm8001_abort_task(struct sas_task *task)
 {
 	unsigned long flags;
-- 
2.18.0
