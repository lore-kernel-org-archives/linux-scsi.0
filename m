From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/2] [SCSI] ufs: Add missing UFS_MASK macro definition
Date: Mon,  9 Apr 2012 21:43:13 +0530
Message-ID: <1333987993-32219-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35900 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2DIQNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 12:13:45 -0400
Received: by dake40 with SMTP id e40so5447104dak.11
        for <linux-scsi@vger.kernel.org>; Mon, 09 Apr 2012 09:13:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Reported-by: Venkatraman S <venkat@linaro.org>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Y <santoshsy@gmail.com>
---
 drivers/scsi/ufs/ufshci.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6e3510f..f5b9af1 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -93,6 +93,8 @@ enum {
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 };
 
+#define UFS_MASK(mask, offset)		((mask) << (offset))
+
 /* UFS Version 08h */
 #define MINOR_VERSION_NUM_MASK		UFS_MASK(0xFFFF, 0)
 #define MAJOR_VERSION_NUM_MASK		UFS_MASK(0xFFFF, 16)
-- 
1.7.5.4

