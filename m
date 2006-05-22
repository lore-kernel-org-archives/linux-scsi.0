From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 1/8] zfcp: (cleanup) shortened copyright and author information
Date: Mon, 22 May 2006 18:14:08 +0200
Message-ID: <20060522161408.GA25228@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:48725 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750942AbWEVQQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:16:41 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGGee5077854
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:16:40 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGHf2o143078
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:17:41 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGGew7012988
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:16:40 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: (cleanup) shortened copyright and author information

Copyright update, shortened file headers, shortened author information.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

aebb32a48c2260257fa0a7a80d4922a85b2d8b52
 drivers/s390/scsi/zfcp_aux.c           |   40 +++++++++++++++-----------------
 drivers/s390/scsi/zfcp_ccw.c           |   14 ++---------
 drivers/s390/scsi/zfcp_dbf.c           |   10 ++------
 drivers/s390/scsi/zfcp_def.h           |   17 ++------------
 drivers/s390/scsi/zfcp_erp.c           |   18 +++-----------
 drivers/s390/scsi/zfcp_ext.h           |   16 ++-----------
 drivers/s390/scsi/zfcp_fsf.c           |   17 ++------------
 drivers/s390/scsi/zfcp_fsf.h           |   17 ++------------
 drivers/s390/scsi/zfcp_qdio.c          |   16 ++-----------
 drivers/s390/scsi/zfcp_scsi.c          |   16 ++-----------
 drivers/s390/scsi/zfcp_sysfs_adapter.c |   14 ++---------
 drivers/s390/scsi/zfcp_sysfs_driver.c  |   14 ++---------
 drivers/s390/scsi/zfcp_sysfs_port.c    |   15 ++----------
 drivers/s390/scsi/zfcp_sysfs_unit.c    |   15 ++----------
 14 files changed, 59 insertions(+), 180 deletions(-)

aebb32a48c2260257fa0a7a80d4922a85b2d8b52
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 395cfc6..12bc8f2 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -1,18 +1,8 @@
 /*
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * linux/drivers/s390/scsi/zfcp_aux.c
- *
- * FCP adapter driver for IBM eServer zSeries
- *
- * (C) Copyright IBM Corp. 2002, 2004
- *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com>
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com>
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com>
- *            Heiko Carstens <heiko.carstens@de.ibm.com>
- *            Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -29,6 +19,20 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+/*
+ * Driver authors:
+ *            Martin Peschke (originator of the driver)
+ *            Raimund Schroeder
+ *            Aron Zeh
+ *            Wolfgang Taphorn
+ *            Stefan Bader
+ *            Heiko Carstens (kernel 2.6 port of the driver)
+ *            Andreas Herrmann
+ *            Maxim Shchetynin
+ *            Volker Sameske
+ *            Ralph Wuerthner
+ */
+
 #include "zfcp_ext.h"
 
 /* accumulated log level (module parameter) */
@@ -75,15 +79,9 @@ static struct miscdevice zfcp_cfdc_misc 
 /* declare driver module init/cleanup functions */
 module_init(zfcp_module_init);
 
-MODULE_AUTHOR("Heiko Carstens <heiko.carstens@de.ibm.com>, "
-	      "Andreas Herrman <aherrman@de.ibm.com>, "
-	      "Martin Peschke <mpeschke@de.ibm.com>, "
-	      "Raimund Schroeder <raimund.schroeder@de.ibm.com>, "
-	      "Wolfgang Taphorn <taphorn@de.ibm.com>, "
-	      "Aron Zeh <arzeh@de.ibm.com>, "
-	      "IBM Deutschland Entwicklung GmbH");
+MODULE_AUTHOR("IBM Deutschland Entwicklung GmbH - linux390@de.ibm.com");
 MODULE_DESCRIPTION
-    ("FCP (SCSI over Fibre Channel) HBA driver for IBM eServer zSeries");
+    ("FCP (SCSI over Fibre Channel) HBA driver for IBM System z9 and zSeries");
 MODULE_LICENSE("GPL");
 
 module_param(device, charp, 0400);
diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index 241136d..57d8e4b 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -1,16 +1,8 @@
 /*
- * linux/drivers/s390/scsi/zfcp_ccw.c
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * FCP adapter driver for IBM eServer zSeries
- *
- * CCW driver related routines
- *
- * (C) Copyright IBM Corp. 2003, 2004
- *
- * Authors:
- *      Martin Peschke <mpeschke@de.ibm.com>
- *	Heiko Carstens <heiko.carstens@de.ibm.com>
- *      Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index a5f2ba9..c033145 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -1,12 +1,8 @@
 /*
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * linux/drivers/s390/scsi/zfcp_dbf.c
- *
- * FCP adapter driver for IBM eServer zSeries
- *
- * Debugging facilities
- *
- * (C) Copyright IBM Corp. 2005
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 6eba56c..362af4d 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -1,19 +1,8 @@
 /* 
- * 
- * linux/drivers/s390/scsi/zfcp_def.h
- * 
- * FCP adapter driver for IBM eServer zSeries 
- * 
- * (C) Copyright IBM Corp. 2002, 2004
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com> 
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com> 
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com> 
- *            Heiko Carstens <heiko.carstens@de.ibm.com> 
- *            Andreas Herrmann <aherrman@de.ibm.com>
- *            Volker Sameske <sameske@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  * 
  * This program is free software; you can redistribute it and/or modify 
  * it under the terms of the GNU General Public License as published by 
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 57cb628..e2dac3d 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1,18 +1,8 @@
 /* 
- * 
- * linux/drivers/s390/scsi/zfcp_erp.c 
- * 
- * FCP adapter driver for IBM eServer zSeries 
- * 
- * (C) Copyright IBM Corp. 2002, 2004
- *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com> 
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com> 
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com> 
- *            Heiko Carstens <heiko.carstens@de.ibm.com> 
- *            Andreas Herrmann <aherrman@de.ibm.com>
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
+ *
+ * (C) Copyright IBM Corp. 2002, 2006
  * 
  * This program is free software; you can redistribute it and/or modify 
  * it under the terms of the GNU General Public License as published by 
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 700f540..6be2bb7 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -1,18 +1,8 @@
 /* 
- * 
- * linux/drivers/s390/scsi/zfcp_ext.h
- * 
- * FCP adapter driver for IBM eServer zSeries 
- * 
- * (C) Copyright IBM Corp. 2002, 2004
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com> 
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com> 
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com> 
- *            Heiko Carstens <heiko.carstens@de.ibm.com> 
- *            Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  * 
  * This program is free software; you can redistribute it and/or modify 
  * it under the terms of the GNU General Public License as published by 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 662ec57..4a35960 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1,19 +1,8 @@
 /*
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * linux/drivers/s390/scsi/zfcp_fsf.c
- *
- * FCP adapter driver for IBM eServer zSeries
- *
- * (C) Copyright IBM Corp. 2002, 2004
- *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com>
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com>
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com>
- *            Heiko Carstens <heiko.carstens@de.ibm.com>
- *            Andreas Herrmann <aherrman@de.ibm.com>
- *            Volker Sameske <sameske@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index e734415..ca16dca 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -1,19 +1,8 @@
 /* 
- * 
- * linux/drivers/s390/scsi/zfcp_fsf.h
- * 
- * FCP adapter driver for IBM eServer zSeries 
- * 
- * (C) Copyright IBM Corp. 2002, 2004
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com> 
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com> 
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com> 
- *            Heiko Carstens <heiko.carstens@de.ibm.com>
- *            Andreas Herrmann <aherrman@de.ibm.com>
- *            Volker Sameske <sameske@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  * 
  * This program is free software; you can redistribute it and/or modify 
  * it under the terms of the GNU General Public License as published by 
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 1c32751..dfb6644 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -1,18 +1,8 @@
 /*
- * linux/drivers/s390/scsi/zfcp_qdio.c
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * FCP adapter driver for IBM eServer zSeries
- *
- * QDIO related routines
- *
- * (C) Copyright IBM Corp. 2002, 2004
- *
- * Authors:
- *      Martin Peschke <mpeschke@de.ibm.com>
- *      Raimund Schroeder <raimund.schroeder@de.ibm.com>
- *      Wolfgang Taphorn
- *      Heiko Carstens <heiko.carstens@de.ibm.com>
- *      Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9e6d07d..4b4041a 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -1,18 +1,8 @@
 /* 
- * 
- * linux/drivers/s390/scsi/zfcp_scsi.c
- * 
- * FCP adapter driver for IBM eServer zSeries 
- * 
- * (C) Copyright IBM Corp. 2002, 2004
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * Author(s): Martin Peschke <mpeschke@de.ibm.com> 
- *            Raimund Schroeder <raimund.schroeder@de.ibm.com> 
- *            Aron Zeh
- *            Wolfgang Taphorn
- *            Stefan Bader <stefan.bader@de.ibm.com> 
- *            Heiko Carstens <heiko.carstens@de.ibm.com> 
- *            Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  * 
  * This program is free software; you can redistribute it and/or modify 
  * it under the terms of the GNU General Public License as published by 
diff --git a/drivers/s390/scsi/zfcp_sysfs_adapter.c b/drivers/s390/scsi/zfcp_sysfs_adapter.c
index b29ac25..705c6d4 100644
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c
@@ -1,16 +1,8 @@
 /*
- * linux/drivers/s390/scsi/zfcp_sysfs_adapter.c
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * FCP adapter driver for IBM eServer zSeries
- *
- * sysfs adapter related routines
- *
- * (C) Copyright IBM Corp. 2003, 2004
- *
- * Authors:
- *      Martin Peschke <mpeschke@de.ibm.com>
- *	Heiko Carstens <heiko.carstens@de.ibm.com>
- *      Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_sysfs_driver.c b/drivers/s390/scsi/zfcp_sysfs_driver.c
index 6622d55..005e62f 100644
--- a/drivers/s390/scsi/zfcp_sysfs_driver.c
+++ b/drivers/s390/scsi/zfcp_sysfs_driver.c
@@ -1,16 +1,8 @@
 /*
- * linux/drivers/s390/scsi/zfcp_sysfs_driver.c
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * FCP adapter driver for IBM eServer zSeries
- *
- * sysfs driver related routines
- *
- * (C) Copyright IBM Corp. 2003, 2004
- *
- * Authors:
- *      Martin Peschke <mpeschke@de.ibm.com>
- *	Heiko Carstens <heiko.carstens@de.ibm.com>
- *      Andreas Herrmann <aherrman@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_sysfs_port.c b/drivers/s390/scsi/zfcp_sysfs_port.c
index f401d42..1320c05 100644
--- a/drivers/s390/scsi/zfcp_sysfs_port.c
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c
@@ -1,17 +1,8 @@
 /*
- * linux/drivers/s390/scsi/zfcp_sysfs_port.c
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * FCP adapter driver for IBM eServer zSeries
- *
- * sysfs port related routines
- *
- * (C) Copyright IBM Corp. 2003, 2004
- *
- * Authors:
- *      Martin Peschke <mpeschke@de.ibm.com>
- *	Heiko Carstens <heiko.carstens@de.ibm.com>
- *      Andreas Herrmann <aherrman@de.ibm.com>
- *      Volker Sameske <sameske@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/s390/scsi/zfcp_sysfs_unit.c b/drivers/s390/scsi/zfcp_sysfs_unit.c
index ad5dfb8..81a4841 100644
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c
+++ b/drivers/s390/scsi/zfcp_sysfs_unit.c
@@ -1,17 +1,8 @@
 /*
- * linux/drivers/s390/scsi/zfcp_sysfs_unit.c
+ * This file is part of the zfcp device driver for
+ * FCP adapters for IBM System z9 and zSeries.
  *
- * FCP adapter driver for IBM eServer zSeries
- *
- * sysfs unit related routines
- *
- * (C) Copyright IBM Corp. 2003, 2004
- *
- * Authors:
- *      Martin Peschke <mpeschke@de.ibm.com>
- *	Heiko Carstens <heiko.carstens@de.ibm.com>
- *      Andreas Herrmann <aherrman@de.ibm.com>
- *      Volker Sameske <sameske@de.ibm.com>
+ * (C) Copyright IBM Corp. 2002, 2006
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.3.3.gd5e3d

