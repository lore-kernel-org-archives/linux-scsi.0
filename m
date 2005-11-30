From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 11/11] [SYM2] Version 2.2.2
Date: Tue, 29 Nov 2005 23:08:48 -0500 (EST)
Message-ID: <20051130040848.0C3C17626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:2262 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750876AbVK3EIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:51 -0500
Received: from mail4.magma.ca (mail4.magma.ca [206.191.0.222])
	by mx1.magmacom.com (8.13.0/8.13.0) with ESMTP id jAU48oEC002641
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:51 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail4.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48nkP026187
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:50 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update version number to 2.2.2

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

applies-to: b2994307e48f50543720b3e4320e87e3f55bad8d
ad290715ebb20c006171eb297de81111c5ddf348
diff --git a/drivers/scsi/sym53c8xx_2/sym_defs.h b/drivers/scsi/sym53c8xx_2/sym_defs.h
index 2d9437d..3659dd7 100644
--- a/drivers/scsi/sym53c8xx_2/sym_defs.h
+++ b/drivers/scsi/sym53c8xx_2/sym_defs.h
@@ -40,7 +40,7 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.2.1"
+#define SYM_VERSION "2.2.2"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
---
0.99.9.GIT
