From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 7/7] be2iscsi : Bump driver version
Date: Sun, 12 Jan 2014 16:42:20 -0800
Message-ID: <1389573741-3523-7-git-send-email-jayamohan.kallickal@emulex.com>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42425 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAMCiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 21:38:21 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so6789519pdj.40
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 18:38:20 -0800 (PST)
In-Reply-To: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 3806a09..ea98713 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.0.659.0"
+#define BUILD_STR		"10.2.84.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.7.10.4

