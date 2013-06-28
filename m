From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 1/7][SCSI] mpt3sas: 2013 source code copyright
Date: Sat, 29 Jun 2013 03:50:34 +0530
Message-ID: <20130628222034.GA5041@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:42354
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447Ab3F1LZQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 07:25:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com


The Copyright String in all mpt3sas files are changed to 2012-2013.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/Kconfig                |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 81471bf..d53e1b0 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -2,7 +2,7 @@
 # Kernel configuration file for the MPT3SAS
 #
 # This code is based on drivers/scsi/mpt3sas/Kconfig
-# Copyright (C) 2012  LSI Corporation
+# Copyright (C) 2012-2013  LSI Corporation
 #  (mailto:DL-MPTFusionLinux@lsi.com)
 
 # This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1836003..673a1b5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 994656c..3610647 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.h
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 1df9ed4..17312c7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2,7 +2,7 @@
  * This module provides common API for accessing firmware configuration pages
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 054d523..5afb9f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_ctl.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index bd89f4f..53b0c48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_ctl.h
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_debug.h b/drivers/scsi/mpt3sas/mpt3sas_debug.h
index 35405e7..545b22d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debug.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_debug.h
@@ -2,7 +2,7 @@
  * Logging Support for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_debug.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index dcbf7c8..73d3b81 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2,7 +2,7 @@
  * Scsi Host Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_scsih.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 87ca2b7..dcadd56 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -2,7 +2,7 @@
  * SAS Transport Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_transport.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index 6f8d621..f6533ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -3,7 +3,7 @@
  * (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
index a10c309..bb69392 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h
@@ -4,7 +4,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.h
- * Copyright (C) 2012  LSI Corporation
+ * Copyright (C) 2012-2013  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
-- 
1.7.3


