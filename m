From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] megaraid: more kernel-doc fixes
Date: Tue, 9 Jan 2007 21:40:52 -0800
Message-ID: <20070109214052.23d47976.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:55226 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbXAJFlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2007 00:41:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant.Patro@lsi.com
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>, scsi <linux-scsi@vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

More megaraid kernel-doc fixes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/megaraid/mbox_defs.h   |    2 +-
 drivers/scsi/megaraid/mega_common.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20-rc3-mm1.orig/drivers/scsi/megaraid/mbox_defs.h
+++ linux-2.6.20-rc3-mm1/drivers/scsi/megaraid/mbox_defs.h
@@ -748,7 +748,7 @@ typedef struct {
 
 
 /**
- * private_bios_data - bios private data for boot devices
+ * struct private_bios_data - bios private data for boot devices
  * @geometry	: bits 0-3 - BIOS geometry, 0x0001 - 1GB, 0x0010 - 2GB,
  *		0x1000 - 8GB, Others values are invalid
  * @unused	: bits 4-7 are unused
--- linux-2.6.20-rc3-mm1.orig/drivers/scsi/megaraid/mega_common.h
+++ linux-2.6.20-rc3-mm1/drivers/scsi/megaraid/mega_common.h
@@ -271,7 +271,7 @@ typedef struct {
 #define ASSERT(expression)
 #endif
 
-/*
+/**
  * struct mraid_pci_blk - structure holds DMA memory block info
  * @vaddr		: virtual address to a memory block
  * @dma_addr		: DMA handle to a memory block


---
