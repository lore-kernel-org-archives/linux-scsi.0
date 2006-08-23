From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/3] qla2xxx: Update version number to 8.01.07-k1.
Date: Wed, 23 Aug 2006 14:54:56 -0700
Message-ID: <11563700962050-git-send-email-andrew.vasquez@qlogic.com>
References: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:45555 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965232AbWHWVzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Aug 2006 17:55:00 -0400
In-Reply-To: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index f5826bf..9712590 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.05-k4"
+#define QLA2XXX_VERSION      "8.01.07-k1"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-#define QLA_DRIVER_PATCH_VER	5
+#define QLA_DRIVER_PATCH_VER	7
 #define QLA_DRIVER_BETA_VER	0
-- 
1.4.2.g44c10

