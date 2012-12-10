From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH] [SCSI] Remove reference to dropped scsi_wait_scan module
Date: Mon, 10 Dec 2012 14:26:47 +0100
Message-ID: <1355146007-20138-1-git-send-email-petr.uzel@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

scsi_wait_scan module has been dropped by commit 6072609d9bb91ff54aee.
Don't reference it in Kconfig.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/scsi/Kconfig |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 74bf1aa..a392ca4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -255,10 +255,9 @@ config SCSI_SCAN_ASYNC
 
 	  If you have built SCSI as modules, enabling this option can
 	  be a problem as the devices may not have been found by the
-	  time your system expects them to have been.  You can load the
-	  scsi_wait_scan module to ensure that all scans have completed.
-	  If you build your SCSI drivers into the kernel, then everything
-	  will work fine if you say Y here.
+	  time your system expects them to have been.  If you build your 
+	  SCSI drivers into the kernel, then everything will work fine 
+	  if you say Y here.
 
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
-- 
1.7.7
