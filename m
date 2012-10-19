From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 16/19] be2iscsi: Fix the copyright information
Date: Sat, 20 Oct 2012 04:45:27 +0530
Message-ID: <b59b516f-62a9-484f-8d33-ab71b1748b92@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38793 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2JSXQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:16:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h       |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c  |    2 +-
 drivers/scsi/be2iscsi/be_cmds.h  |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c  |    2 +-
 drivers/scsi/be2iscsi/be_main.h  |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.c  |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.h  |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 36777ef..f1733df 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 3913e26..977b753 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 135c096..37f2bb5 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2c458b3..38dea43 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 8b826fc..38eab72 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ea510ef..d3632d5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 2b722c8..5f346d2 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ee130bc..f18dc3e 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index e2c222a..88a8ed2 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2011 Emulex
+ * Copyright (C) 2005 - 2012 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
-- 
1.7.2

