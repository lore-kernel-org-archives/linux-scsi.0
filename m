From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 7/8] stex: version update
Date: Fri, 1 Dec 2006 20:44:13 -0800
Message-ID: <NONAMEBpHeGsstsJXZS0000149d@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:32297 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S1162791AbWLBEnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Dec 2006 23:43:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index ce7edf5..9cbc047 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -11,8 +11,6 @@
  *	Written By:
  *		Ed Lin <promise_linux@promise.com>
  *
- *	Version: 3.0.0.1
- *
  */
 
 #include <linux/init.h>
@@ -37,9 +35,9 @@ #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "3.0.0.1"
+#define ST_DRIVER_VERSION "3.1.0.1"
 #define ST_VER_MAJOR 		3
-#define ST_VER_MINOR 		0
+#define ST_VER_MINOR 		1
 #define ST_OEM 			0
 #define ST_BUILD_VER 		1
 


