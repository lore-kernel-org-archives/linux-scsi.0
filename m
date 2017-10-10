From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 10/10] scsi: be2iscsi: Update driver version
Date: Tue, 10 Oct 2017 16:18:20 +0530
Message-ID: <1507632500-26445-11-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:55935 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755587AbdJJKtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:49:05 -0400
Received: by mail-pf0-f179.google.com with SMTP id 17so8470049pfn.12
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:49:05 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Version 11.4.0.1

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 3d21849..9bc7ef9 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -31,7 +31,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"11.4.0.0"
+#define BUILD_STR		"11.4.0.1"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
2.7.4
