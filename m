From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/5] pmcraid: fix a typo in error message
Date: Sat, 16 Feb 2013 23:27:55 +0900
Message-ID: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58587 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3BPO2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 09:28:25 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so998148pbc.5
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2013 06:28:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Remove duplicate "with" in error message.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b46f5e9..073ff48 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6106,7 +6106,7 @@ static int __init pmcraid_init(void)
 
 	if (IS_ERR(pmcraid_class)) {
 		error = PTR_ERR(pmcraid_class);
-		pmcraid_err("failed to register with with sysfs, error = %x\n",
+		pmcraid_err("failed to register with sysfs, error = %x\n",
 			    error);
 		goto out_unreg_chrdev;
 	}
-- 
1.8.1

