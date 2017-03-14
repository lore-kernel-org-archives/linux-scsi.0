From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 9/9] be2iscsi: Update driver version
Date: Tue, 14 Mar 2017 13:31:34 +0530
Message-ID: <1489478494-5432-10-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38279 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdCNIC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2017 04:02:27 -0400
Received: by mail-wm0-f47.google.com with SMTP id t189so57140834wmt.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 01:02:26 -0700 (PDT)
In-Reply-To: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Version 11.4.0.0

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 9883a85..0f826fe 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"11.2.1.0"
+#define BUILD_STR		"11.4.0.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
2.7.4
