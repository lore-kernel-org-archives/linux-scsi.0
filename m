From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 08/22] [SCSI] mpt2sas, mpt3sas: Update Attribution Language to Avago
Date: Mon, 12 Jan 2015 11:39:02 +0530
Message-ID: <1421042944-14988-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:46714 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbALGKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 01:10:06 -0500
Received: by mail-pd0-f170.google.com with SMTP id v10so28717417pde.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Jan 2015 22:10:05 -0800 (PST)
In-Reply-To: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Copyright, Trademark & Confidentiality legal statements throughout source code changed from LSI to Avago.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c         | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.h         | 5 +++--
 drivers/scsi/mpt2sas/mpt2sas_config.c       | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h          | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_debug.h        | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h         | 5 +++--
 drivers/scsi/mpt3sas/mpt3sas_config.c       | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h | 3 ++-
 18 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index dc088ac..137862c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 3faad45..72bffec 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.h
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -67,7 +68,7 @@
 
 /* driver versioning info */
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
-#define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
+#define MPT2SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
 #define MPT2SAS_DRIVER_VERSION		"19.100.00.00"
 #define MPT2SAS_MAJOR_VERSION		19
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 41a8f84..c43815b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index ca4e563..4e50960 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.c
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
index 7f842c8..46b2fc5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.h
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mpt2sas_debug.h
index cc57ef3..277120d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_debug.c
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index bbbec9d..5950731 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_scsih.c
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index e689bf2..ff2500a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_transport.c
  * Copyright (C) 2007-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 20013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0b8210b..961bd9d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4fef8f3..7e9f55b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.h
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -68,7 +69,7 @@
 
 /* driver versioning info */
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
-#define MPT3SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
+#define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
 #define MPT3SAS_DRIVER_VERSION		"04.100.00.00"
 #define MPT3SAS_MAJOR_VERSION		4
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 6582193..e45c461 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index dca1487..080c8a7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_ctl.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 5f3d7fd..aee99ce 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_ctl.h
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_debug.h b/drivers/scsi/mpt3sas/mpt3sas_debug.h
index 4778e7d..4e8a63f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debug.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_debug.h
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_debug.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8cbd078..e8e6bd4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_scsih.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 3637ae6..efb98af 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -3,7 +3,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_transport.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index 8a2dd11..b60fd7a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -4,7 +4,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
index f681db5..6586a46 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
@@ -5,7 +5,8 @@
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.h
  * Copyright (C) 2012-2014  LSI Corporation
- *  (mailto:DL-MPTFusionLinux@lsi.com)
+ * Copyright (C) 2013-2014 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
-- 
2.0.2

