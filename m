From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: [PATCH 5/5] stex: Version update
Date: Mon, 26 Jan 2009 02:42:11 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F01DC8304@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.2.ptr.us.xo.net ([67.111.72.2]:36552 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbZAZKzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 05:55:25 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>

Update version to 4.6.0000.1

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index d7f2623..2265d21 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1,7 +1,7 @@
 /*
  * SuperTrak EX Series Storage Controller driver for Linux
  *
- *	Copyright (C) 2005, 2006 Promise Technology Inc.
+ *	Copyright (C) 2005-2009 Promise Technology Inc.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -36,8 +36,8 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "3.6.0000.1"
-#define ST_VER_MAJOR 		3
+#define ST_DRIVER_VERSION "4.6.0000.1"
+#define ST_VER_MAJOR 		4
 #define ST_VER_MINOR 		6
 #define ST_OEM 			0
 #define ST_BUILD_VER 		1
