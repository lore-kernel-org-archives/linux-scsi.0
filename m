From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 2/5] be2iscsi: Fix the copyright year
Date: Fri,  8 Aug 2014 00:59:59 -0400
Message-ID: <1407474003-26220-2-git-send-email-jkallickal@emulex.com>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56367 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaHHFAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 01:00:17 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so6318294pde.23
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2014 22:00:16 -0700 (PDT)
In-Reply-To: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Change the copyright year to 2014

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h       | 2 +-
 drivers/scsi/be2iscsi/be_cmds.c  | 2 +-
 drivers/scsi/be2iscsi/be_cmds.h  | 2 +-
 drivers/scsi/be2iscsi/be_iscsi.c | 2 +-
 drivers/scsi/be2iscsi/be_iscsi.h | 2 +-
 drivers/scsi/be2iscsi/be_main.c  | 2 +-
 drivers/scsi/be2iscsi/be_main.h  | 2 +-
 drivers/scsi/be2iscsi/be_mgmt.c  | 2 +-
 drivers/scsi/be2iscsi/be_mgmt.h  | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 860f527..81e83a6 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1432ed5..ea4477f 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 4e8cb61..ccda0b6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 8616281..e25203e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 31ddc84..e0b3b2d 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 56467df..d6465ed 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 9ceab42..0ca9d2d 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a3e5648..785deb3 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 24a8fc5..bd81446 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2013 Emulex
+ * Copyright (C) 2005 - 2014 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
-- 
1.8.5.3

