From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] scsi: fix typo s/scsi_dispatch_cmnd/scsi_dispatch_cmd/
Date: Sat, 16 Feb 2013 23:26:41 +0900
Message-ID: <1361024801-12836-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42121 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3BPO1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 09:27:21 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so2155159pab.31
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2013 06:27:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Logging message contains a mistake in its own function name.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2c0d0ec..39acb6a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -765,7 +765,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	}
 
  out:
-	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
+	SCSI_LOG_MLQUEUE(3, printk("leaving %s()\n", __func__));
 	return rtn;
 }
 
-- 
1.8.1

