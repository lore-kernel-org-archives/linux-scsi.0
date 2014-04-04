From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/11] lpfc 10.2.8000.0: Update lpfc version to driver
 version 10.2.8000.0
Date: Fri, 4 Apr 2014 13:53:03 -0400
Message-ID: <1396633983.1924.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:53506 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaDDRxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:53:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 10.2.8000.0


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c    |    2 +-
 lpfc_version.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2014-04-03 10:24:27.545308870 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2014-04-03 10:24:37.110309352 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2014-03-31 16:21:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2014-04-03 10:24:37.112309352 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.45"
+#define LPFC_DRIVER_VERSION "10.2.8000.0."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



