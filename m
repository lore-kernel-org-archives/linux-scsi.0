From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] [SCSI] qla2xxx: Remove version.h header file inclusion
Date: Sun,  3 Jun 2012 22:27:01 +0530
Message-ID: <1338742621-11044-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53733 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2FCQ5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2012 12:57:15 -0400
Received: by pbbrp8 with SMTP id rp8so5006556pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jun 2012 09:57:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-driver@qlogic.com, andrew.vasquez@qlogic.com, sachin.kamat@linaro.org, patches@linaro.org

version.h header file is no longer required.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 -
 drivers/scsi/qla2xxx/qla_target.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 04f80eb..f7a49e4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 9ec19bc..9f9ef16 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -919,7 +919,6 @@ struct qla_tgt_srr_ctio {
 #define QLA_TGT_XMIT_STATUS		2
 #define QLA_TGT_XMIT_ALL		(QLA_TGT_XMIT_STATUS|QLA_TGT_XMIT_DATA)
 
-#include <linux/version.h>
 
 extern struct qla_tgt_data qla_target;
 /*
-- 
1.7.5.4

