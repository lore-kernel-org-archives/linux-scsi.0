From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: libsas: remove unused variable sas_ha
Date: Tue, 26 Sep 2017 20:17:50 +0100
Message-ID: <20170926191750.25444-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46627 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030327AbdIZTSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2017 15:18:00 -0400
Content-Type: text/plain; charset="utf-8"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Remove unused variable sas_ha to clean up build warning
"unused variable ‘sas_ha’ [-Wunused-variable]"

Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 29d6cb39299c..9e2990268f00 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1046,7 +1046,6 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
 
 static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 {
-	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
 	struct Scsi_Host *shost = hisi_hba->shost;
 	u32 old_state, state;
-- 
2.14.1
