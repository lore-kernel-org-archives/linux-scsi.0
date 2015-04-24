From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/22] advansys: Remove obsolete virtual memory mapping comment
Date: Fri, 24 Apr 2015 10:32:53 +0200
Message-ID: <1429864377-67002-19-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966441AbbDXIdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:14 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 98efd41..424a08d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -884,16 +884,6 @@ typedef struct asc_mc_saved {
 #define AscReadChipDvcID(port)            (uchar)inp((port)+IOP_REG_ID)
 #define AscWriteChipDvcID(port, data)     outp((port)+IOP_REG_ID, data)
 
-/*
- * These macros are used to convert a virtual address to a
- * 32-bit value. This currently can be used on Linux Alpha
- * which uses 64-bit virtual address but a 32-bit bus address.
- * This is likely to break in the future, but doing this now
- * will give us time to change the HW and FW to handle 64-bit
- * addresses.
- */
-#define ADV_U32_TO_VADDR   bus_to_virt
-
 #define AdvPortAddr  void __iomem *	/* Virtual memory address size */
 
 /*
-- 
1.8.5.2

