From: jayamohank@gmail.com
Subject: [PATCH 15/15] be2iscsi: Bump the driver version
Date: Mon, 11 Mar 2013 21:39:45 -0700
Message-ID: <1363063186-4902-15-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35516 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3CLEkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:21 -0400
Received: by mail-pb0-f49.google.com with SMTP id xa12so4590657pbc.36
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:20 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

	This patch bumps the version number

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 23be676..9ced4af 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 
 #include "be.h"
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.0.272.0"
+#define BUILD_STR		"10.0.442.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.7.10.4

