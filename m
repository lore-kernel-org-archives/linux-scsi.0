From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/15] qla2xxx: Update version number to 8.01.05-k2.
Date: Wed, 17 May 2006 15:10:01 -0700
Message-ID: <11479037963088-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28604 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1751232AbWEQWKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:10:02 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

0d912f59f2253ac9b27d131c895bcede0961fdc0
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

0d912f59f2253ac9b27d131c895bcede0961fdc0
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index d537192..6b31552 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.04-k"
+#define QLA2XXX_VERSION      "8.01.05-k2"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-#define QLA_DRIVER_PATCH_VER	4
+#define QLA_DRIVER_PATCH_VER	5
 #define QLA_DRIVER_BETA_VER	0
-- 
1.3.3.g63df


