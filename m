From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH][SCSI] ufs: fix a wrong string in power mode change
Date: Thu, 08 Sep 2016 16:50:02 +0900
Message-ID: <003001d209a5$9afb9b00$d0f2d100$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56093 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752115AbcIHHuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2016 03:50:04 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0OD601ZBKDREZ9D0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Sep 2016 16:50:02 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

From: Kiwoong Kim <kwmad.kim@samsung.com>

I modified a string as described in UFS spec as follow:
umpcrs -> upmcrs 

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b0ade73..e8a706b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2268,7 +2268,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
        status = ufshcd_get_upmcrs(hba);
        if (status != PWR_LOCAL) {
                dev_err(hba->dev,
-                       "pwr ctrl cmd 0x%0x failed, host umpcrs:0x%x\n",
+                       "pwr ctrl cmd 0x%0x failed, host upmcrs:0x%x\n",
                        cmd->command, status);
                ret = (status != PWR_OK) ? status : -1;
        }
--
1.7.9.5

