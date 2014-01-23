From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH] scsi-sd: removed unused SD_PASSTHROUGH_RETRIES
Date: Thu, 23 Jan 2014 16:56:42 +0800
Message-ID: <1390467402-30339-1-git-send-email-handai.szj@taobao.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37094 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaAWI5E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2014 03:57:04 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so1586664pad.25
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2014 00:57:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, martin.petersen@oracle.com, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 drivers/scsi/sd.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 26895ff..3bbe4df 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -24,7 +24,6 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
-#define SD_PASSTHROUGH_RETRIES	1
 #define SD_MAX_MEDIUM_TIMEOUTS	2
 
 /*
-- 
1.7.9.5

