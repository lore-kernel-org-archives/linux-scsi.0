From: michaelc@cs.wisc.edu
Subject: [PATCH 11/17] be2iscsi:Bump the driver Version
Date: Tue, 20 Mar 2012 20:48:02 -0500
Message-ID: <1332294488-13684-12-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030413Ab2CUBsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:36 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <MinhDuc.Tran@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

	This patch bumps the driver version
Signed-off-by: Minh Tran <MinhDuc.Tran@Emulex.Com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    1 +
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e38d694..5b34f41 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -48,6 +48,7 @@ static unsigned int num_hba = 0;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
+MODULE_VERSION(BUILD_STR);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
 module_param(be_iopoll_budget, int, 0);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 49289ef..13e3bef 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -34,7 +34,7 @@
 
 #include "be.h"
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"4.1.239.0"
+#define BUILD_STR		"4.2.162.0"
 #define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.7.7.6

