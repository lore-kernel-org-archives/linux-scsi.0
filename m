From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] pm8001: Fix typo in pm8001_hwi.c
Date: Thu,  2 Feb 2012 23:07:40 +0900
Message-ID: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
List-Id: linux-scsi@vger.kernel.org

Correct typo "deviece" to "device" in
drivers/scsi/pm8001/pm8001_hwi.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b7b92f7..92f3429 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case OPC_OUB_DEREG_DEV:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unresgister the deviece\n"));
+			pm8001_printk("unresgister the device\n"));
 		mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
-- 
1.7.6.5
