From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/qla1280.c: remove version check
Date: Thu, 17 Apr 2008 12:37:01 +0300
Message-ID: <20080417093701.GD1677@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42635 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbYDQJhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 05:37:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

There's no point for an in-kernel driver to check whether it's compiled 
under kernel < 2.6.0 .

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qla1280.c |    5 -----
 1 file changed, 5 deletions(-)

d2883d88ddcb95bf89eb41b00fa4638fd77f6147 diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 68c0d09..09ab3ea 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -333,7 +333,6 @@
 
 #include <linux/module.h>
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/errno.h>
@@ -367,10 +366,6 @@
 #include <asm/sn/io.h>
 #endif
 
-#if LINUX_VERSION_CODE < 0x020600
-#error "Kernels older than 2.6.0 are no longer supported"
-#endif
-
 
 /*
  * Compile time Options:

