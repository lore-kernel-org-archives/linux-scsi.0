From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 16/16] lpfc 8.1.12 : Change version number to 8.1.12
Date: Wed, 25 Apr 2007 09:53:42 -0400
Message-ID: <1177509222.23155.23.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51848 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031063AbXDYNxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:53:33 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDrWiZ006779
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:53:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change version number to 8.1.12

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2007-04-24 11:12:44.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,12 +18,12 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.11"
+#define LPFC_DRIVER_VERSION "8.1.12"
 
 #define LPFC_DRIVER_NAME "lpfc"
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2006 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2007 Emulex.  All rights reserved."
 
 #define DFC_API_VERSION "0.0.0"


