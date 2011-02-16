From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/6] lpfc 8.3.21: Change lpfc driver version to 8.3.21
Date: Wed, 16 Feb 2011 12:40:15 -0500
Message-ID: <1297878015.1492.29.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:7552 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753653Ab1BPRkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 12:40:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change lpfc driver version to 8.3.21.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2011-02-16 11:36:17.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.20"
+#define LPFC_DRIVER_VERSION "8.3.21"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


