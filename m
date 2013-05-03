From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] [scsi] ufs: Remove redundant platform_set_drvdata()
Date: Fri,  3 May 2013 15:32:28 +0530
Message-ID: <1367575348-20068-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43429 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945Ab3ECKPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 06:15:25 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz17so832771pbc.31
        for <linux-scsi@vger.kernel.org>; Fri, 03 May 2013 03:15:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, vinholikatti@gmail.com, santoshsy@gmail.com, sachin.kamat@linaro.org, patches@linaro.org

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 03319ac..3db2ee1 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -184,7 +184,6 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 		mem_size = resource_size(mem_res);
 		release_mem_region(mem_res->start, mem_size);
 	}
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.9.5

