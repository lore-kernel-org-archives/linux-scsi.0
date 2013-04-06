From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 14/18] be2scsi: Fix the copyright information
Date: Fri,  5 Apr 2013 20:38:34 -0700
Message-ID: <1365219519-3457-14-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42900 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422650Ab3DFDjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:09 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so2335345pbc.16
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:09 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

        This patch fixes the copyright information in all files

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
index f1733df..777e7c0 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index efd29ab..e66aa7c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 97871cc..9907308 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 531d4a6..09265ec 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 38eab72..31ddc84 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 01439a5..228d331 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 6d83ad8..23be676 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 8662f73..a601597 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 4c7e0a2..04af7e7 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2012 Emulex
+ * Copyright (C) 2005 - 2013 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
-- 
1.7.10.4

