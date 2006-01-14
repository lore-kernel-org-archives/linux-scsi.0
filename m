From: andrew.vasquez@qlogic.com
Subject: [PATCH 15/15] qla2xxx: Update version number to 8.01.04-k.
Date: Fri, 13 Jan 2006 17:06:04 -0800
Message-ID: <11372007592552-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26662 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945940AbWANBGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:06:05 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

3a44fdacddcc718d635e5cf9cb80f8afc428a485
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index f7937f7..d537192 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.03-k"
+#define QLA2XXX_VERSION      "8.01.04-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-#define QLA_DRIVER_PATCH_VER	3
+#define QLA_DRIVER_PATCH_VER	4
 #define QLA_DRIVER_BETA_VER	0
-- 
1.1.1-g4c34


