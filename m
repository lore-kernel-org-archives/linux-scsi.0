From: John Stoffel <john@stoffel.org>
Subject: [PATCH] Make SCSI SG v4 driver enabled by default now since udev depends on it.
Date: Tue,  7 Jul 2009 10:50:55 -0400
Message-ID: <1246978255-19407-1-git-send-email-john@stoffel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759105AbZGGOvX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Stoffel <john@stoffel.org>
---
 block/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index e7d1278..22bf6eb 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -46,8 +46,8 @@ config LBD
 
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	---help---
+	default y
+	help
 	  Saying Y here will enable generic SG (SCSI generic) v4 support
 	  for any block device.
 
@@ -57,7 +57,7 @@ config BLK_DEV_BSG
 	  protocols (e.g. Task Management Functions and SMP in Serial
 	  Attached SCSI).
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
-- 
1.6.3.3
