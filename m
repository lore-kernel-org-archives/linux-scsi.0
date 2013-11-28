From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [SCSI] Update kernel size increase for SCSI_CONSTANTS
Date: Thu, 28 Nov 2013 14:00:43 +0100
Message-ID: <1385643643-6220-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Many error messages have been added since Linux-0.99.12 (August 14, 1993)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index fe25677a5511..8024add2375f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -212,12 +212,12 @@ config SCSI_MULTI_LUN
 	  multiple LUNs.
 
 config SCSI_CONSTANTS
-	bool "Verbose SCSI error reporting (kernel size +=12K)"
+	bool "Verbose SCSI error reporting (kernel size +=34K)"
 	depends on SCSI
 	help
 	  The error messages regarding your SCSI hardware will be easier to
 	  understand if you say Y here; it will enlarge your kernel by about
-	  12 KB. If in doubt, say Y.
+	  34 KB. If in doubt, say Y.
 
 config SCSI_LOGGING
 	bool "SCSI logging facility"
-- 
1.7.9.5
