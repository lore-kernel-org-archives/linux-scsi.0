From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v3 09/10] be2iscsi: Update Copyright
Date: Fri, 24 Mar 2017 14:11:48 +0530
Message-ID: <1490344909-29541-10-git-send-email-jitendra.bhivare@broadcom.com>
References: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:32930 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753396AbdCXImg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 04:42:36 -0400
Received: by mail-qk0-f179.google.com with SMTP id f11so5677974qkb.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 01:42:35 -0700 (PDT)
In-Reply-To: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, cleech@redhat.com, lduncan@suse.com
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
index bad6b5e..97dca46 100644
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
