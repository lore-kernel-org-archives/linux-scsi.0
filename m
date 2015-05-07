From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: [PATCH] scsi: ufs: enable no_write_same for ufs
Date: Thu,  7 May 2015 22:06:21 +0900
Message-ID: <1431003981-7106-1-git-send-email-kyuho.choi@sk.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35731 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbEGNGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2015 09:06:32 -0400
Received: by pabtp1 with SMTP id tp1so39833885pab.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2015 06:06:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, Kyuho Choi <kyuho.choi@sk.com>

This patch disables write_same for ufs.

Signed-off-by: Kyuho Choi <kyuho.choi@sk.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 648a446..6f770cd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4255,6 +4255,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
+	.no_write_same		= 1,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
-- 
1.9.1

