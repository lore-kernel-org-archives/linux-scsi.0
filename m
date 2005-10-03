From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] NCR5380: fix undefined preprocessor identifier
Date: Sun, 2 Oct 2005 17:15:29 -0700
Message-ID: <20051002171529.7a328d30.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44752 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751162AbVJCAPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2005 20:15:31 -0400
Received: from midway ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 2 Oct 2005 17:15:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix 12 undefined preprocessor identifier warnings (4 each in 3 driver builds):
drivers/scsi/NCR5380.c:2744:16: warning: undefined preprocessor identifier 'NDEBUG_ABORT'
drivers/scsi/NCR5380.c:2744:16: warning: "NDEBUG_ABORT" is not defined

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---

 drivers/scsi/NCR5380.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp linux-2614-rc2-git6/drivers/scsi/NCR5380.c~scsi_ncr_define linux-2614-rc2-git6/drivers/scsi/NCR5380.c
--- linux-2614-rc2-git6/drivers/scsi/NCR5380.c~scsi_ncr_define	2005-09-27 21:36:10.000000000 -0700
+++ linux-2614-rc2-git6/drivers/scsi/NCR5380.c	2005-10-02 16:38:29.000000000 -0700
@@ -91,7 +91,7 @@
 #ifndef NDEBUG
 #define NDEBUG 0
 #endif
-#ifndef NDEBUG
+#ifndef NDEBUG_ABORT
 #define NDEBUG_ABORT 0
 #endif
 


---
