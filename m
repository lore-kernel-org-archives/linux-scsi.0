From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH] ufshcd-pltfrm: add missing empty slot in ufs_of_match[]
Date: Sun, 26 May 2013 20:24:41 +0900
Message-ID: <1369567481-30685-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:55236 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3EZLhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 07:37:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

of_match_table member in struct device_driver must be terminated by
empty slot as a sentinel.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 03319ac..0014e28 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -190,6 +190,7 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 static const struct of_device_id ufs_of_match[] = {
 	{ .compatible = "jedec,ufs-1.1"},
+	{},
 };
 
 static const struct dev_pm_ops ufshcd_dev_pm_ops = {
-- 
1.8.1.4

