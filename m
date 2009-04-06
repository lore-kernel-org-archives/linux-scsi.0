From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/7] lpfc 8.3.1 : Update version to 8.3.1
Date: Mon, 6 Apr 2009 18:48:17 -0400
Message-ID: <1239058097.2344.33.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43082 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbZDFWs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 18:48:29 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n36MmPLC017107
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 15:48:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update driver version to 8.3.1
Also update copyright end year for driver.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_version.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.0"
+#define LPFC_DRIVER_VERSION "8.3.1"
 
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
@@ -26,4 +26,4 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2008 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2009 Emulex.  All rights reserved."


