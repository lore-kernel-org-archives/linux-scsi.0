From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 2/7] bnx2fc: Remove 'NetXtreme II' from source files.
Date: Mon, 19 Oct 2015 15:40:36 -0400
Message-ID: <1445283641-7358-3-git-send-email-chad.dupuis@qlogic.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:6250 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbbJSUTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:15 -0400
In-Reply-To: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  |    2 +-
 drivers/scsi/bnx2fc/Kconfig            |    5 ++---
 drivers/scsi/bnx2fc/bnx2fc.h           |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_constants.h |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.c     |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c       |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      |    6 +++---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c        |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |    2 +-
 11 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
index 66deff1..ac1c0b6 100644
--- a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
+++ b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
@@ -1,4 +1,4 @@
-/* 57xx_hsi_bnx2fc.h: QLogic NetXtreme II Linux FCoE offload driver.
+/* 57xx_hsi_bnx2fc.h: QLogic Linux FCoE offload driver.
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
diff --git a/drivers/scsi/bnx2fc/Kconfig b/drivers/scsi/bnx2fc/Kconfig
index 0978828..d401a09 100644
--- a/drivers/scsi/bnx2fc/Kconfig
+++ b/drivers/scsi/bnx2fc/Kconfig
@@ -1,5 +1,5 @@
 config SCSI_BNX2X_FCOE
-	tristate "QLogic NetXtreme II FCoE support"
+	tristate "QLogic FCoE offload support"
 	depends on PCI
 	depends on (IPV6 || IPV6=n)
 	depends on LIBFC
@@ -9,5 +9,4 @@ config SCSI_BNX2X_FCOE
 	select NET_VENDOR_BROADCOM
 	select CNIC
 	---help---
-	This driver supports FCoE offload for the QLogic NetXtreme II
-	devices.
+	This driver supports FCoE offload for the QLogic devices.
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 4791b29..0e2aa65 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -1,4 +1,4 @@
-/* bnx2fc.h: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc.h: QLogic Linux FCoE offload driver.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
  * Copyright (c) 2014-2015 QLogic Corporation
diff --git a/drivers/scsi/bnx2fc/bnx2fc_constants.h b/drivers/scsi/bnx2fc/bnx2fc_constants.h
index 52e8297..5b20efb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_constants.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_constants.h
@@ -1,4 +1,4 @@
-/* bnx2fc_constants.h: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_constants.h: QLogic Linux FCoE offload driver.
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.c b/drivers/scsi/bnx2fc/bnx2fc_debug.c
index e3a7ca4..c9e0bc7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.c
@@ -1,4 +1,4 @@
-/* bnx2fc_debug.c: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_debug.c: QLogic Linux FCoE offload driver.
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.h b/drivers/scsi/bnx2fc/bnx2fc_debug.h
index 737398f..34fda3e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.h
@@ -1,4 +1,4 @@
-/* bnx2fc_debug.h: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_debug.h: QLogic Linux FCoE offload driver.
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index d8b1651..49d1e4d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -1,5 +1,5 @@
 /*
- * bnx2fc_els.c: QLogic NetXtreme II Linux FCoE offload driver.
+ * bnx2fc_els.c: QLogic Linux FCoE offload driver.
  * This file contains helper routines that handle ELS requests
  * and responses.
  *
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 4098c35..65ad98c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1,4 +1,4 @@
-/* bnx2fc_fcoe.c: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_fcoe.c: QLogic Linux FCoE offload driver.
  * This file contains the code that interacts with libfc, libfcoe,
  * cnic modules to create FCoE instances, send/receive non-offloaded
  * FIP/FCoE packets, listen to link events etc.
@@ -27,12 +27,12 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 
 static char version[] =
-		"QLogic NetXtreme II FCoE Driver " DRV_MODULE_NAME \
+		"QLogic FCoE Driver " DRV_MODULE_NAME \
 		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 
 MODULE_AUTHOR("Bhanu Prakash Gollapudi <bprakash@broadcom.com>");
-MODULE_DESCRIPTION("QLogic NetXtreme II BCM57710 FCoE Driver");
+MODULE_DESCRIPTION("QLogic FCoE Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 3ef3d72..28c671b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1,4 +1,4 @@
-/* bnx2fc_hwi.c: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_hwi.c: QLogic Linux FCoE offload driver.
  * This file contains the code that low level functions that interact
  * with 57712 FCoE firmware.
  *
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 890baee..520dabe 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1,4 +1,4 @@
-/* bnx2fc_io.c: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_io.c: QLogic Linux FCoE offload driver.
  * IO manager and SCSI IO processing.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 8bcd229..30a8788 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -1,4 +1,4 @@
-/* bnx2fc_tgt.c: QLogic NetXtreme II Linux FCoE offload driver.
+/* bnx2fc_tgt.c: QLogic Linux FCoE offload driver.
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
-- 
1.7.7

