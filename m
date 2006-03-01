From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 22/22] lpfc 8.1.2: Change version number to 8.1.2
Date: Tue, 28 Feb 2006 19:25:39 -0500
Message-ID: <20060301002539.GA15608@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:64448 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964868AbWCAAZl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:41 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210Pdjq015614
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:39 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PdwX015613
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change version number to 8.1.2

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,12 +18,12 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.1"
+#define LPFC_DRIVER_VERSION "8.1.2"
 
 #define LPFC_DRIVER_NAME "lpfc"
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2005 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2006 Emulex.  All rights reserved."
 
 #define DFC_API_VERSION "0.0.0"
