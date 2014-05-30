From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] ncr53c8xx: remove remnants of integrity checking
Date: Fri, 30 May 2014 09:27:46 +0200
Message-ID: <1401434866.6101.3.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The code for integrity checking was removed in v2.6.10. Remove its
remnants now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/scsi/ncr53c8xx.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index 0e008dacf679..736a9df68d58 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -63,14 +63,6 @@
 #define SCSI_NCR_BOOT_COMMAND_LINE_SUPPORT
 #define SCSI_NCR_DEBUG_INFO_SUPPORT
 
-/*
-**	To disable integrity checking, do not define the 
-**	following option.
-*/
-#ifdef	CONFIG_SCSI_NCR53C8XX_INTEGRITY_CHECK
-#	define SCSI_NCR_ENABLE_INTEGRITY_CHECK
-#endif
-
 /* ---------------------------------------------------------------------
 ** Take into account kernel configured parameters.
 ** Most of these options can be overridden at startup by a command line.
-- 
1.9.3
