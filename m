From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 22/22] lpfc 8.1.2 : Change version number to 8.1.2
Date: Wed, 08 Feb 2006 10:43:38 -0500
Message-ID: <43EA11AA.90400@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59021 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161076AbWBHPnl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:43:41 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fherf011964
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:43:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Change version number to 8.1.2

Signed-off-by: James Smart <James.Smart@emulex.com>

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

