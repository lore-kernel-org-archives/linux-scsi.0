From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 07/10] ufshcd-pltfrm: add missing empty slot in ufs_of_match[]
Date: Wed, 26 Jun 2013 22:39:32 +0530
Message-ID: <1372266575-3468-8-git-send-email-santoshsy@gmail.com>
References: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51758 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FZRKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:10:18 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so14527693pad.30
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:10:17 -0700 (PDT)
In-Reply-To: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Akinobu Mita <mita@fixstars.com>

of_match_table member in struct device_driver must be terminated by
empty slot as a sentinel.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 0e48827..6829a16 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -157,6 +157,7 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 static const struct of_device_id ufs_of_match[] = {
 	{ .compatible = "jedec,ufs-1.1"},
+	{},
 };
 
 static const struct dev_pm_ops ufshcd_dev_pm_ops = {
-- 
1.8.3.1

