From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/8] lpfc 8.3.8: Update Driver version to 8.3.8
Date: Tue, 26 Jan 2010 23:10:40 -0500
Message-ID: <1264565460.2972.8.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39349 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033Ab0A0ELS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:11:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update Driver version to 8.3.8


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2010-01-22 12:03:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2010-01-22 21:45:44.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.7"
+#define LPFC_DRIVER_VERSION "8.3.8"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


