From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 9/9] be2iscsi: Update the driver version
Date: Mon, 14 Dec 2015 11:41:06 +0530
Message-ID: <1450073466-21077-10-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54830 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752490AbbLNG2Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 01:28:24 -0500
In-Reply-To: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Driver version: 11.0.0.0

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.1

