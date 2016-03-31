From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 8/9] lpfc: Update modified file copyrights
Date: Thu, 31 Mar 2016 14:12:34 -0700
Message-ID: <56fd92c2.VOu7AbqMVwvejINj%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33341 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbcCaVMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:39 -0400
Received: by mail-pf0-f173.google.com with SMTP id 4so77811174pfd.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:38 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id 85sm15532054pfq.6.2016.03.31.14.12.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update modified file copyrights

Update modified file copyrights

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc.h           | 2 +-
 drivers/scsi/lpfc/lpfc_attr.c      | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h        | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h       | 2 +-
 drivers/scsi/lpfc/lpfc_init.c      | 2 +-
 drivers/scsi/lpfc/lpfc_mbox.c      | 2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 2 +-
 drivers/scsi/lpfc/lpfc_version.h   | 4 ++--
 drivers/scsi/lpfc/lpfc_vport.c     | 2 +-
 13 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 283942a..d5bd420 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 9528f86..cfec2ec 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 982039e..a38816e 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6cc1af4..0498f57 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b3bf230..ed22393 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 41a961e..39f0fd0 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 634c9b1..0c7070b 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009-2015 Emulex.  All rights reserved.                *
+ * Copyright (C) 2009-2016 Emulex.  All rights reserved.                *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c922a2b..b43f7ac 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 1e34b54..12dbe99 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9b539e2..56a3df4 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,7 +1,7 @@
  /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9c8368a..6b267b6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 4dc2256..6b57e0c 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2015 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -30,4 +30,4 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2015 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright(c) 2004-2016 Emulex.  All rights reserved."
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 9b7adca..c27f4b7 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
-- 
2.5.0

