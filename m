From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 6/6] be2iscsi: Bump the driver version.
Date: Thu, 27 Mar 2014 12:39:30 -0400
Message-ID: <1395938371-2149-6-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54181 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaC0Qjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:39:48 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so3734664pad.35
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 09:39:48 -0700 (PDT)
In-Reply-To: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

	Bump driver version

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b3716e3..43f0b38 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.2.125.0"
+#define BUILD_STR		"10.2.218.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.8.5.3

