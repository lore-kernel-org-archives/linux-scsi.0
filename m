From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 26/28] be2iscsi: Update copyright information
Date: Thu, 21 Jul 2016 14:38:03 +0530
Message-ID: <1469092085-14311-27-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35107 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbcGUJJs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:09:48 -0400
Received: by mail-wm0-f51.google.com with SMTP id f65so14868169wmi.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:09:47 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Change the copyright to:
Copyright =C2=A9 xxxx - 2016 Broadcom

Update email.ids:
@avagotech.com - @broadcom.com

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be.h       | 4 ++--
 drivers/scsi/be2iscsi/be_cmds.c  | 4 ++--
 drivers/scsi/be2iscsi/be_cmds.h  | 4 ++--
 drivers/scsi/be2iscsi/be_iscsi.c | 6 +++---
 drivers/scsi/be2iscsi/be_iscsi.h | 6 +++---
 drivers/scsi/be2iscsi/be_main.c  | 6 +++---
 drivers/scsi/be2iscsi/be_main.h  | 6 +++---
 drivers/scsi/be2iscsi/be_mgmt.c  | 6 +++---
 drivers/scsi/be2iscsi/be_mgmt.h  | 6 +++---
 9 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index bb4042c..b1d0fdc 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,7 +8,7 @@
  * Public License is included in this distribution in the file called =
COPYING.
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be=
_cmds.c
index 5fe1610..be65da2 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,7 +8,7 @@
  * Public License is included in this distribution in the file called =
COPYING.
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be=
_cmds.h
index 8283344..328fb5b 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,7 +8,7 @@
  * Public License is included in this distribution in the file called =
COPYING.
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/b=
e_iscsi.c
index 35f7d3a..ba25821 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,10 +7,10 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called =
COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/b=
e_iscsi.h
index 2a4097a..e4d67df 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,10 +7,10 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called =
COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Avago Technologies
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 48bfc51..d382537 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,10 +7,10 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called =
COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be=
_main.h
index e5e3154..7173c03 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,10 +7,10 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called =
COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be=
_mgmt.c
index 736eca3..d402988 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,10 +7,10 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called =
COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be=
_mgmt.h
index ee6fd7e..b897cfd 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Emulex
+ * Copyright (C) 2005 - 2016 Broadcom
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,10 +7,10 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called =
COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@broadcom.com)
  *
  * Contact Information:
- * linux-drivers@avagotech.com
+ * linux-drivers@broadcom.com
  *
  * Emulex
  * 3333 Susan Street
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
