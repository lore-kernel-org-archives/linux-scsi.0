From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 10/10] lpfc 8.2.4 : Update lpfc driver version to 8.2.4
Date: Fri, 11 Jan 2008 01:53:33 -0500
Message-ID: <1200034413.27954.33.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51554 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYAKGxj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:53:39 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6rcjf021686
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:53:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc driver version to 8.2.4

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2007-11-09 15:54:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2008-01-11 01:32:51.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,10 +18,10 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.3"
+#define LPFC_DRIVER_VERSION "8.2.4"
 
 #define LPFC_DRIVER_NAME "lpfc"
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2007 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2008 Emulex.  All rights reserved."


