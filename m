From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 13/13] lpfc: Update 12.0.0.0 modified files for 2018 Copyright
Date: Tue,  6 Feb 2018 18:28:51 -0800
Message-ID: <20180207022851.11800-14-jsmart2021@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:38420 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbeBGC3K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 21:29:10 -0500
Received: by mail-ot0-f195.google.com with SMTP id h14so2989162otj.5
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 18:29:10 -0800 (PST)
In-Reply-To: <20180207022851.11800-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Updated Copyright in files updated 12.0.0.0

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c     | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h      | 2 +-
 drivers/scsi/lpfc/lpfc_ids.h     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 8b33b652226b..0f174ca80f67 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 03a7e13a049d..ebe8ac1b88e7 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 308303d501cf..fb0dc2aeed91 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2007-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 12fbf498a7ce..f32eaeb2225a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index cf83322cd4fe..08a3f1520159 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 329c8d28869c..07ee34017d88 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.13.1
