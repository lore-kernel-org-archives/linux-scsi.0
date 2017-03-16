From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 09/10] be2iscsi: Update Copyright
Date: Thu, 16 Mar 2017 08:54:44 +0530
Message-ID: <1489634685-4975-10-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:35785 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wr0-f175.google.com with SMTP id g10so23127500wrg.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:43 -0700 (PDT)
In-Reply-To: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Update Broadcom Copyright markings in all files.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be.h       | 11 ++++-------
 drivers/scsi/be2iscsi/be_cmds.c  | 11 ++++-------
 drivers/scsi/be2iscsi/be_cmds.h  | 11 ++++-------
 drivers/scsi/be2iscsi/be_iscsi.c | 13 ++++---------
 drivers/scsi/be2iscsi/be_iscsi.h | 13 ++++---------
 drivers/scsi/be2iscsi/be_main.c  | 13 ++++---------
 drivers/scsi/be2iscsi/be_main.h  | 13 ++++---------
 drivers/scsi/be2iscsi/be_mgmt.c  | 13 ++++---------
 drivers/scsi/be2iscsi/be_mgmt.h  | 13 ++++---------
 9 files changed, 36 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 4dd8de4..55e3f8b 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,18 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #ifndef BEISCSI_H
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index d14ddb2..a79a5e7 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,18 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #include <scsi/iscsi_proto.h>
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 88fe731..d9b6773 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,18 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #ifndef BEISCSI_CMDS_H
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2af714f..2e47b49 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,20 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
- *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #include <scsi/libiscsi.h>
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index e4d67df..b9d459a 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,20 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
- *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Avago Technologies
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #ifndef _BE_ISCSI_
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4b668c4..61b7f5b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,20 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
- *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #include <linux/reboot.h>
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 9883a85..c6b95dc 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,20 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
- *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #ifndef _BEISCSI_MAIN_
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 3198c84..c737753 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,20 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
- *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #include <linux/bsg-lib.h>
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 1ad6c40..06ddc5a 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,20 +1,15 @@
-/**
- * Copyright (C) 2005 - 2016 Broadcom
- * All rights reserved.
+/*
+ * Copyright 2017 Broadcom. All Rights Reserved.
+ * The term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.  The full GNU General
+ * as published by the Free Software Foundation. The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
- *
  * Contact Information:
  * linux-drivers@broadcom.com
  *
- * Emulex
- * 3333 Susan Street
- * Costa Mesa, CA 92626
  */
 
 #ifndef _BEISCSI_MGMT_
-- 
2.7.4
