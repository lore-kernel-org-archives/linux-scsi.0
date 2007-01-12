From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] megaraid: more kernel-doc fixes
Date: Fri, 12 Jan 2007 16:30:16 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229891381@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52500 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161167AbXALXa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2007 18:30:27 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>, scsi <linux-scsi@vger.kernel.org>

ACK.

--Sumant
 

-----Original Message-----
From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
Sent: Tuesday, January 09, 2007 9:41 PM
To: Patro, Sumant
Cc: jejb; akpm; scsi
Subject: [PATCH] megaraid: more kernel-doc fixes

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
