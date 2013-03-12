From: jayamohank@gmail.com
Subject: [PATCH 14/15] be2iscsi: Fix the copyright information
Date: Mon, 11 Mar 2013 21:39:44 -0700
Message-ID: <1363063186-4902-14-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:43835 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3CLEkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:19 -0400
Received: by mail-da0-f50.google.com with SMTP id t1so745014dae.23
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:18 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

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
index 48ad4ea..eabee82 100644
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
index 24519a7..ffd3b58 100644
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
index ed5aa0f..a67dc49 100644
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

