From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 22/22] be2iscsi: Bump driver version
Date: Thu, 12 Sep 2013 22:10:12 -0700
Message-ID: <1379049014-32716-22-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40166 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3IMFgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:55 -0400
Received: by mail-pd0-f173.google.com with SMTP id p10so779580pdj.32
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:55 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

	Bump the driver version

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 31ac059..c8ed461 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.0.467.0"
+#define BUILD_STR		"10.0.635.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.7.10.4

