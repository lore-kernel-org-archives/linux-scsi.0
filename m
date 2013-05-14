From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 1/3] ufs: Remove redundant platform_set_drvdata()
Date: Tue, 14 May 2013 21:34:13 +0530
Message-ID: <1368547455-5211-2-git-send-email-santoshsy@gmail.com>
References: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49410 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3ENQEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 12:04:48 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa10so653711pad.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2013 09:04:47 -0700 (PDT)
In-Reply-To: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sachin Kamat <sachin.kamat@linaro.org>, Santosh Y <santoshsy@gmail.com>

From: Sachin Kamat <sachin.kamat@linaro.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

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
1.8.1.2

