From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 15/16] lpfc: Update copyrights
Date: Sun, 12 Feb 2017 13:52:39 -0800
Message-ID: <58a0d927.Lc7/+JzyheHf2blh%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35769 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdBLVwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:43 -0500
Received: by mail-ot0-f193.google.com with SMTP id 65so9206831otq.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


Update copyrights to 2017 for all files touched in this patch set

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/Makefile         | 4 +++-
 drivers/scsi/lpfc/lpfc.h           | 4 +++-
 drivers/scsi/lpfc/lpfc_attr.c      | 4 +++-
 drivers/scsi/lpfc/lpfc_attr.h      | 4 +++-
 drivers/scsi/lpfc/lpfc_bsg.c       | 4 +++-
 drivers/scsi/lpfc/lpfc_bsg.h       | 6 ++++--
 drivers/scsi/lpfc/lpfc_compat.h    | 4 +++-
 drivers/scsi/lpfc/lpfc_crtn.h      | 4 +++-
 drivers/scsi/lpfc/lpfc_ct.c        | 4 +++-
 drivers/scsi/lpfc/lpfc_debugfs.c   | 4 +++-
 drivers/scsi/lpfc/lpfc_debugfs.h   | 4 +++-
 drivers/scsi/lpfc/lpfc_disc.h      | 4 +++-
 drivers/scsi/lpfc/lpfc_els.c       | 4 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 4 +++-
 drivers/scsi/lpfc/lpfc_hw.h        | 4 +++-
 drivers/scsi/lpfc/lpfc_hw4.h       | 6 ++++--
 drivers/scsi/lpfc/lpfc_ids.h       | 4 +++-
 drivers/scsi/lpfc/lpfc_init.c      | 6 ++++--
 drivers/scsi/lpfc/lpfc_logmsg.h    | 4 +++-
 drivers/scsi/lpfc/lpfc_mbox.c      | 4 +++-
 drivers/scsi/lpfc/lpfc_mem.c       | 4 +++-
 drivers/scsi/lpfc/lpfc_nl.h        | 4 +++-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 drivers/scsi/lpfc/lpfc_nvme.c      | 4 +++-
 drivers/scsi/lpfc/lpfc_nvme.h      | 4 +++-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 6 ++++--
 drivers/scsi/lpfc/lpfc_nvmet.h     | 4 +++-
 drivers/scsi/lpfc/lpfc_scsi.c      | 4 +++-
 drivers/scsi/lpfc/lpfc_scsi.h      | 4 +++-
 drivers/scsi/lpfc/lpfc_sli.c       | 4 +++-
 drivers/scsi/lpfc/lpfc_sli.h       | 4 +++-
 drivers/scsi/lpfc/lpfc_sli4.h      | 4 +++-
 drivers/scsi/lpfc/lpfc_version.h   | 8 ++++++--
 drivers/scsi/lpfc/lpfc_vport.c     | 4 +++-
 drivers/scsi/lpfc/lpfc_vport.h     | 4 +++-
 35 files changed, 112 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index 30a6a35..cb6aa80 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -1,9 +1,11 @@
 #/*******************************************************************
 # * This file is part of the Emulex Linux Device Driver for         *
 # * Fibre Channel Host Bus Adapters.                                *
+# * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+# * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
 # * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
 # * EMULEX and SLI are trademarks of Emulex.                        *
-# * www.emulex.com                                                  *
+# * www.broadcom.com                                                *
 # *                                                                 *
 # * This program is free software; you can redistribute it and/or   *
 # * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8a4090c..0bba2e3 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 700a68f..4114cf4 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_attr.h b/drivers/scsi/lpfc/lpfc_attr.h
index b2bd28e..d56dafc 100644
--- a/drivers/scsi/lpfc/lpfc_attr.h
+++ b/drivers/scsi/lpfc/lpfc_attr.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 55a2270..18157d2 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index f2247aa..e7d95a4 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2010-2015 Emulex.  All rights reserved.                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
+ * Copyright (C) 2010-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_compat.h b/drivers/scsi/lpfc/lpfc_compat.h
index c88e556..6b32b0a 100644
--- a/drivers/scsi/lpfc/lpfc_compat.h
+++ b/drivers/scsi/lpfc/lpfc_compat.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f56015b..843dd73 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 53bdfe4..c22bb3f 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index de4fc4e..e06c28a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2007-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 5312e0f9..c05f56c 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index e305e97..f4ff99d9 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 57a57a3..bcc77efc 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 7bb700a..18af5d2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index c2221377..15ca214 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 0fddb23..cfdb068 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009-2016 Emulex.  All rights reserved.                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
+ * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 5733fea..0ba3733 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ad9d1c5..492fcd0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
@@ -12118,5 +12120,5 @@ module_init(lpfc_init);
 module_exit(lpfc_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(LPFC_MODULE_DESC);
-MODULE_AUTHOR("Emulex Corporation - tech.support@emulex.com");
+MODULE_AUTHOR("Broadcom");
 MODULE_VERSION("0:" LPFC_DRIVER_VERSION);
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 3faf7a0..3b654ad 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 8f4bfdf..a928f518 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 2437ec5..c61d8d6 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_nl.h b/drivers/scsi/lpfc/lpfc_nl.h
index f2b1bbc..b93e78f 100644
--- a/drivers/scsi/lpfc/lpfc_nl.h
+++ b/drivers/scsi/lpfc/lpfc_nl.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2010 Emulex.  All rights reserved.                *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 0716818..061626b 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,9 +1,11 @@
  /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 56b4b94..625b658 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 85961c1..b2fae5e 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index ffb3e4b..8bdee46 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
- * Fibre Channsel Host Bus Adapters.                                *
+ * Fibre Channsel Host Bus Adapters.                               *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index ca63677..3f7184a 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4ba4644..cfa15c9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index def0c0a5..5da7e15 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 70a3f67..3dbd027 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index f6cea02..9085306d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 3bfdff1..91153c9 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 0ee0623..0d93535 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
  * modify it under the terms of version 2 of the GNU General       *
@@ -30,4 +32,6 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright(c) 2004-2016 Emulex.  All rights reserved."
+#define LPFC_COPYRIGHT "Copyright (C) 2017 Broadcom. All Rights Reserved. " \
+		"The term \"Broadcom\" refers to Broadcom Limited " \
+		"and/or its subsidiaries."
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index b0d94f2..c0eeea0 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
diff --git a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
index 6b2c94e..6229597 100644
--- a/drivers/scsi/lpfc/lpfc_vport.h
+++ b/drivers/scsi/lpfc/lpfc_vport.h
@@ -1,9 +1,11 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
+ * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
  * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
+ * www.broadcom.com                                                *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
  *                                                                 *
  * This program is free software; you can redistribute it and/or   *
-- 
2.5.0
