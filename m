From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 5/5] stex:update version
Date: Tue, 31 Mar 2009 17:30:41 -0800
Message-ID: <200903311730410567804@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:21550 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbZDAApj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 20:45:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

Update version to 4.6.0000.3

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 4e2b2af..df7f96c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -36,11 +36,11 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "4.6.0000.1"
-#define ST_VER_MAJOR 		4
-#define ST_VER_MINOR 		6
-#define ST_OEM 			0
-#define ST_BUILD_VER 		1
+#define ST_DRIVER_VERSION "4.6.0000.3"
+#define ST_VER_MAJOR		4
+#define ST_VER_MINOR		6
+#define ST_OEM			0
+#define ST_BUILD_VER		3
 
 enum {
 	/* MU register offset */


