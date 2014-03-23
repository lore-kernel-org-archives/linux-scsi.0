From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 4/4] be2iscsi: Bump the driver version
Date: Sun, 23 Mar 2014 18:10:48 -0400
Message-ID: <1395612648-25851-4-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395612648-25851-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55630 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaCWWLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2014 18:11:09 -0400
Received: by mail-pd0-f181.google.com with SMTP id p10so4502118pdj.40
        for <linux-scsi@vger.kernel.org>; Sun, 23 Mar 2014 15:11:09 -0700 (PDT)
In-Reply-To: <1395612648-25851-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

	Bumping the driver version

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 581ebdb..cd781bb 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.2.125.0"
+#define BUILD_STR		"10.2.214.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.8.5.3

