From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/11] mpt2sas: Copyright 2010.
Date: Wed, 17 Mar 2010 16:28:04 +0530
Message-ID: <20100317105753.GK21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:58378 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab0CQL3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:29:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Copyright changes for year 2010.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/Kconfig b/drivers/scsi/mpt2sas/Kconfig
index ba8e128..bbb7e4b 100644
--- a/drivers/scsi/mpt2sas/Kconfig
+++ b/drivers/scsi/mpt2sas/Kconfig
@@ -2,7 +2,7 @@
 # Kernel configuration file for the MPT2SAS
 #
 # This code is based on drivers/scsi/mpt2sas/Kconfig
-# Copyright (C) 2007-2009  LSI Corporation
+# Copyright (C) 2007-2010  LSI Corporation
 #  (mailto:DL-MPTFusionLinux@lsi.com)
 
 # This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2.h b/drivers/scsi/mpt2sas/mpi/mpi2.h
index 9958d84..dada0a1 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2009 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2.h
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
index cf0ac9f..d4e9d6f 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2009 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2_cnfg.h
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
index c4adf76..bd6c92b 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_history.txt
@@ -2,7 +2,7 @@
  Fusion-MPT MPI 2.0 Header File Change History
  ==============================
 
- Copyright (c) 2000-2009 LSI Corporation.
+ Copyright (c) 2000-2010 LSI Corporation.
 
  ---------------------------------------
  Header Set Release Version:    02.00.14
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_init.h b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
index 6541945..220bf65 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_init.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2009 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2_init.h
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
index 7549384..f18f114 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_ioc.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2009 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2_ioc.h
diff --git a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
index 73fcdbf..686b09b 100644
--- a/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
+++ b/drivers/scsi/mpt2sas/mpi/mpi2_tool.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2009 LSI Corporation.
+ *  Copyright (c) 2000-2010 LSI Corporation.
  *
  *
  *           Name:  mpi2_tool.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bda017b..42d00dd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 92caab6..0517a5b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -3,7 +3,7 @@
  * for access to MPT (Message Passing Technology) firmware.
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.h
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 360f64b..a1804ca 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -2,7 +2,7 @@
  * This module provides common API for accessing firmware configuration pages
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index d2a4254..1dee350 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.c
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
index 8a5eeb1..69916e4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
@@ -3,7 +3,7 @@
  * controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_ctl.h
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mpt2sas_debug.h
index 5308a25..3dcddfe 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_debug.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_debug.h
@@ -2,7 +2,7 @@
  * Logging Support for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_debug.c
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6318951..b1ac9f1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2,7 +2,7 @@
  * Scsi Host Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_scsih.c
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index bdbc8f7..87827fd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -2,7 +2,7 @@
  * SAS Transport Layer for MPT (Message Passing Technology) based controllers
  *
  * This code is based on drivers/scsi/mpt2sas/mpt2_transport.c
- * Copyright (C) 2007-2009  LSI Corporation
+ * Copyright (C) 2007-2010  LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  * This program is free software; you can redistribute it and/or
