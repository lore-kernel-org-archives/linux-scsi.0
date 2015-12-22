From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v2 17/17] be2iscsi: Update the driver version
Date: Tue, 22 Dec 2015 22:46:02 +0530
Message-ID: <1450804562-11980-18-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:49477 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752665AbbLVRQs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 12:16:48 -0500
In-Reply-To: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Driver version: 11.0.0.0

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 41c708c..16a6fd0 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.6.0.1"
+#define BUILD_STR		"11.0.0.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.9.1

