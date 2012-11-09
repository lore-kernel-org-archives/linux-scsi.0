From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Update copyright ownership to 2012
Date: Fri,  9 Nov 2012 23:00:14 +0000
Message-ID: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hello everyone,

This patch to update copyright year to current for principal target core
ownership is now being pushed into target-pending/for-next.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c            |    5 +++--
 drivers/target/target_core_configfs.c        |    5 +++--
 drivers/target/target_core_device.c          |    7 +++----
 drivers/target/target_core_fabric_configfs.c |    7 ++++---
 drivers/target/target_core_fabric_lib.c      |    5 +++--
 drivers/target/target_core_file.c            |    7 +++----
 drivers/target/target_core_hba.c             |    7 +++----
 drivers/target/target_core_iblock.c          |    7 +++----
 drivers/target/target_core_pr.c              |    5 +++--
 drivers/target/target_core_pscsi.c           |    7 +++----
 drivers/target/target_core_rd.c              |    7 +++----
 drivers/target/target_core_sbc.c             |    7 +++----
 drivers/target/target_core_spc.c             |    7 +++----
 drivers/target/target_core_stat.c            |    7 +++----
 drivers/target/target_core_tmr.c             |    5 +++--
 drivers/target/target_core_tpg.c             |    7 +++----
 drivers/target/target_core_transport.c       |    7 +++----
 drivers/target/target_core_ua.c              |    5 +++--
 18 files changed, 55 insertions(+), 59 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 4c8eea2..035c606 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -3,8 +3,9 @@
  *
  * This file contains SPC-3 compliant asymmetric logical unit assigntment (ALUA)
  *
- * Copyright (c) 2009-2010 Rising Tide Systems
- * Copyright (c) 2009-2010 Linux-iSCSI.org
+ * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b14164..72881cc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3,8 +3,9 @@
  *
  * This file contains ConfigFS logic for the Generic Target Engine project.
  *
- * Copyright (c) 2008-2011 Rising Tide Systems
- * Copyright (c) 2008-2011 Linux-iSCSI.org
+ * (c) Copyright 2008-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 54439bc..a9634aa 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -4,10 +4,9 @@
  * This file contains the TCM Virtual Device and Disk Transport
  * agnostic related functions.
  *
- * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005-2006 SBE, Inc.  All Rights Reserved.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index aa67313..4baac62 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -4,10 +4,11 @@
  * This file contains generic fabric module configfs infrastructure for
  * TCM v4.x code
  *
- * Copyright (c) 2010,2011 Rising Tide Systems
- * Copyright (c) 2010,2011 Linux-iSCSI.org
+ * (c) Copyright 2010-2012 RisingTide Systems LLC.
  *
- * Copyright (c) Nicholas A. Bellinger <nab@linux-iscsi.org>
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ *
+ * Nicholas A. Bellinger <nab@linux-iscsi.org>
 *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index e460d62..6ec5814 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -4,8 +4,9 @@
  * This file contains generic high level protocol identifier and PR
  * handlers for TCM fabric modules
  *
- * Copyright (c) 2010 Rising Tide Systems, Inc.
- * Copyright (c) 2010 Linux-iSCSI.org
+ * (c) Copyright 2010-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 3ccef83..421da5c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -3,10 +3,9 @@
  *
  * This file contains the Storage Engine <-> FILEIO transport specific functions
  *
- * Copyright (c) 2005 PyX Technologies, Inc.
- * Copyright (c) 2005-2006 SBE, Inc.  All Rights Reserved.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2005-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 048b7b4..d597d61 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -3,10 +3,9 @@
  *
  * This file contains the TCM HBA Transport related functions.
  *
- * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 33a5248..b5240bc 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -4,10 +4,9 @@
  * This file contains the Storage Engine  <-> Linux BlockIO transport
  * specific functions.
  *
- * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d7101a4..6ed3dc5 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4,8 +4,9 @@
  * This file contains SPC-3 compliant persistent reservations and
  * legacy SPC-2 reservations with compatible reservation handling (CRH=1)
  *
- * Copyright (c) 2009, 2010 Rising Tide Systems
- * Copyright (c) 2009, 2010 Linux-iSCSI.org
+ * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b5c722b..8c5fb93 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -3,10 +3,9 @@
  *
  * This file contains the generic target mode <-> Linux SCSI subsystem plugin.
  *
- * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 126529c..7f4deb9 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -4,10 +4,9 @@
  * This file contains the Storage Engine <-> Ramdisk transport
  * specific functions.
  *
- * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2003-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ee9fa52..941092e 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1,10 +1,9 @@
 /*
  * SCSI Block Commands (SBC) parsing and emulation.
  *
- * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index cf1b8bb..075842f 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1,10 +1,9 @@
 /*
  * SCSI Primary Commands (SPC) parsing and emulation.
  *
- * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 9bbb017..bf7a619 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1,13 +1,12 @@
 /*******************************************************************************
  * Filename:  target_core_stat.c
  *
- * Copyright (c) 2011 Rising Tide Systems
- * Copyright (c) 2011 Linux-iSCSI.org
- *
  * Modern ConfigFS group context specific statistics based on original
  * target_core_mib.c code
  *
- * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
+ * (c) Copyright 2011-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2aaceae..5b57039 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -3,8 +3,9 @@
  *
  * This file contains SPC-3 task management infrastructure
  *
- * Copyright (c) 2009,2010 Rising Tide Systems
- * Copyright (c) 2009,2010 Linux-iSCSI.org
+ * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index a531fe2..a368329 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -3,10 +3,9 @@
  *
  * This file contains generic Target Portal Group related functions.
  *
- * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 63d7848..b7f545b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3,10 +3,9 @@
  *
  * This file contains the Generic Target Engine Core.
  *
- * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
+ * (c) Copyright 2002-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 60c8f41..483ac72 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -3,8 +3,9 @@
  *
  * This file contains logic for SPC-3 Unit Attention emulation
  *
- * Copyright (c) 2009,2010 Rising Tide Systems
- * Copyright (c) 2009,2010 Linux-iSCSI.org
+ * (c) Copyright 2009-2012 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
  *
  * Nicholas A. Bellinger <nab@kernel.org>
  *
-- 
1.7.2.5
