From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Kconfig: remove comment about scsi_wait_scan module
Date: Fri, 04 Sep 2015 20:52:45 +0200
Message-ID: <3021629.5U3fOPAHj2@caliban.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: Trivial patch monkey <trivial@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This module has been removed in commit 6072609d9bb91ff54aee3ef29304bd5b4fc88aae
([SCSI] Remove scsi_wait_scan module), so this module is gone since 3.6.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/scsi/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 95f7a76..d2f480b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -242,13 +242,6 @@ config SCSI_SCAN_ASYNC
 	  system continues booting, and even probe devices on different
 	  busses in parallel, leading to a significant speed-up.
 
-	  If you have built SCSI as modules, enabling this option can
-	  be a problem as the devices may not have been found by the
-	  time your system expects them to have been.  You can load the
-	  scsi_wait_scan module to ensure that all scans have completed.
-	  If you build your SCSI drivers into the kernel, then everything
-	  will work fine if you say Y here.
-
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
 
-- 
2.5.1
