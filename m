From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/21] lpfc 8.3.30: Update copyright date for files modified
 in 2012
Date: Thu, 1 Mar 2012 22:37:07 -0500
Message-ID: <1330659430.18500.40.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38861 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118Ab2CBDhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:37:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update copyright date for files modified in 2012.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 Makefile         |    2 +-
 lpfc.h           |    2 +-
 lpfc_els.c       |    2 +-
 lpfc_hbadisc.c   |    2 +-
 lpfc_hw4.h       |    2 +-
 lpfc_init.c      |    2 +-
 lpfc_nportdisc.c |    2 +-
 lpfc_version.h   |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-03-01 17:33:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-03-01 17:33:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-03-01 17:33:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-03-01 17:33:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009 Emulex.  All rights reserved.                *
+ * Copyright (C) 2009-2012 Emulex.  All rights reserved.                *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:42.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-03-01 17:33:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
  /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff -upNr a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
--- a/drivers/scsi/lpfc/Makefile	2012-03-01 17:33:44.000000000 -0500
+++ b/drivers/scsi/lpfc/Makefile	2012-03-01 17:33:47.000000000 -0500
@@ -1,7 +1,7 @@
 #/*******************************************************************
 # * This file is part of the Emulex Linux Device Driver for         *
 # * Fibre Channel Host Bus Adapters.                                *
-# * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+# * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
 # * EMULEX and SLI are trademarks of Emulex.                        *
 # * www.emulex.com                                                  *
 # *                                                                 *



