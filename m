From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/6]lpfc 8.3.22: Update Copyright Dates
Date: Fri, 11 Mar 2011 16:06:44 -0500
Message-ID: <1299877618.31589.20.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23199 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754571Ab1CKVHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2011 16:07:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update Copyright Dates


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 Makefile    |    2 +-
 lpfc_bsg.c  |    2 +-
 lpfc_crtn.h |    2 +-
 lpfc_init.c |    2 +-
 lpfc_scsi.c |    2 +-
 lpfc_sli.c  |    2 +-
 lpfc_sli4.h |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2011-03-11 12:14:14.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009-2010 Emulex.  All rights reserved.                *
+ * Copyright (C) 2009-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-03-11 12:13:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-03-11 12:14:14.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-03-11 12:13:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009 Emulex.  All rights reserved.                *
+ * Copyright (C) 2009-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 12:14:14.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
--- a/drivers/scsi/lpfc/Makefile	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/Makefile	2011-03-11 12:14:30.000000000 -0500
@@ -1,7 +1,7 @@
 #/*******************************************************************
 # * This file is part of the Emulex Linux Device Driver for         *
 # * Fibre Channel Host Bus Adapters.                                *
-# * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
+# * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
 # * EMULEX and SLI are trademarks of Emulex.                        *
 # * www.emulex.com                                                  *
 # *                                                                 *


