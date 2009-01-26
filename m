From: Ed Lin <ed.lin@promise.com>
Subject: [PATCH 5/5][resend] stex: Version update
Date: Mon, 26 Jan 2009 15:34:38 -0800
Message-ID: <f60baa940901261534m33551d7cle5d05b2b642c6e32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:44124 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZAZXei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 18:34:38 -0500
Received: by mail-gx0-f21.google.com with SMTP id 14so5394223gxk.13
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 15:34:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: promise_linux <promise_linux@promise.com>, linux-scsi@vger.kernel.org

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
