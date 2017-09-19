From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH] scsi: ufs: fix a pclint warning
Date: Tue, 19 Sep 2017 16:50:30 +0800
Message-ID: <20170919085030.125435-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6513 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdISIup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 04:50:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 794a4600e952..deb77535b8c9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3586,7 +3586,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	status = ufshcd_get_upmcrs(hba);
 	if (status != PWR_LOCAL) {
 		dev_err(hba->dev,
-			"pwr ctrl cmd 0x%0x failed, host upmcrs:0x%x\n",
+			"pwr ctrl cmd 0x%x failed, host upmcrs:0x%x\n",
 			cmd->command, status);
 		ret = (status != PWR_OK) ? status : -1;
 	}
-- 
2.14.1
