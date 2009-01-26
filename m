From: "ed.lin" <ed.lin@promise.com>
Subject: [PATCH 5/5][resend 2] stex: Version update
Date: Tue, 27 Jan 2009 06:36:19 +0800
Message-ID: <200901270636.19163.ed.lin@promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:19128 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbZA0GgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 01:36:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

Update version to 4.6.0000.1

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index c1a79c3..47b614e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1,7 +1,7 @@
 /*
  * SuperTrak EX Series Storage Controller driver for Linux
  *
- * Copyright (C) 2005, 2006 Promise Technology Inc.
+ * Copyright (C) 2005-2009 Promise Technology Inc.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -36,8 +36,8 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "3.6.0000.1"
-#define ST_VER_MAJOR   3
+#define ST_DRIVER_VERSION "4.6.0000.1"
+#define ST_VER_MAJOR   4
 #define ST_VER_MINOR   6
 #define ST_OEM    0
 #define ST_BUILD_VER   1
