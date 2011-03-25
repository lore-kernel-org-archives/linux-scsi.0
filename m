From: <jayamohan.kallickal@emulex.com>
Subject: [PATCH 1/5] be2iscsi: change in copyright notice
Date: Fri, 25 Mar 2011 14:23:57 -0700
Message-ID: <6b10c223-743e-46e6-a079-63cd354bc89c@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:59741 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755092Ab1CYVYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 17:24:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

   - Modifying copyright year to 2011
   - Replacing Serverengines with Emulex as Serverengines Corp
	 has been acquired by Emulex Corp

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h       |   10 +++++-----
 drivers/scsi/be2iscsi/be_cmds.c  |   10 +++++-----
 drivers/scsi/be2iscsi/be_cmds.h  |   10 +++++-----
 drivers/scsi/be2iscsi/be_iscsi.c |   13 ++++++-------
 drivers/scsi/be2iscsi/be_iscsi.h |   13 ++++++-------
 drivers/scsi/be2iscsi/be_main.c  |   14 +++++++-------
 drivers/scsi/be2iscsi/be_main.h  |   13 ++++++-------
 drivers/scsi/be2iscsi/be_mgmt.c  |   13 ++++++-------
 drivers/scsi/be2iscsi/be_mgmt.h  |   13 ++++++-------
 9 files changed, 52 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 1cb8a5e..1d7b976 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,11 +8,11 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@serverengines.com
+ * linux-drivers@emulex.com
  *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #ifndef BEISCSI_H
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index ad24636..4ffcbf7 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,11 +8,11 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@serverengines.com
+ * linux-drivers@emulex.com
  *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #include "be.h"
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 5218de4..9441314 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,11 +8,11 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@serverengines.com
+ * linux-drivers@emulex.com
  *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #ifndef BEISCSI_CMDS_H
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 868cc55..3cad106 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,15 +7,14 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
  *
  * Contact Information:
- * linux-drivers@serverengines.com
- *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * linux-drivers@emulex.com
  *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #include <scsi/libiscsi.h>
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 9c53279..ff60b7f 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,15 +7,14 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
  *
  * Contact Information:
- * linux-drivers@serverengines.com
- *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * linux-drivers@emulex.com
  *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #ifndef _BE_ISCSI_
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 24e20ba..7fe38a4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,16 +7,16 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
  *
  * Contact Information:
- * linux-drivers@serverengines.com
- *
- *  ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * linux-drivers@emulex.com
  *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
+
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 90eb74f..1f7c495 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,15 +7,14 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
  *
  * Contact Information:
- * linux-drivers@serverengines.com
- *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * linux-drivers@emulex.com
  *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #ifndef _BEISCSI_MAIN_
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 877324f..65a402b 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,15 +7,14 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
  *
  * Contact Information:
- * linux-drivers@serverengines.com
- *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * linux-drivers@emulex.com
  *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #include "be_mgmt.h"
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index b9acedf..0842882 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2010 ServerEngines
+ * Copyright (C) 2005 - 2011 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,15 +7,14 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
  *
  * Contact Information:
- * linux-drivers@serverengines.com
- *
- * ServerEngines
- * 209 N. Fair Oaks Ave
- * Sunnyvale, CA 94085
+ * linux-drivers@emulex.com
  *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
  */
 
 #ifndef _BEISCSI_MGMT_
-- 
1.7.4.1

