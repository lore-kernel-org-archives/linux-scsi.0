From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 21/24] advansys: Delete some I/O address defines
Date: Fri, 27 Jul 2007 07:42:30 -0600
Message-ID: <11855437532066-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50067 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001AbXG0Nmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:36 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Move the ASC_IOADR_* defines into their one user; the _asc_def_iop_base
array.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 12e714a..02188ee 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1298,18 +1298,6 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_MAX_INRAM_TAG_QNG   16
 #define ASC_IOADR_TABLE_MAX_IX  11
 #define ASC_IOADR_GAP   0x10
-#define ASC_SEARCH_IOP_GAP 0x10
-#define ASC_MIN_IOP_ADDR   (PortAddr)0x0100
-#define ASC_MAX_IOP_ADDR   (PortAddr)0x3F0
-#define ASC_IOADR_1     (PortAddr)0x0110
-#define ASC_IOADR_2     (PortAddr)0x0130
-#define ASC_IOADR_3     (PortAddr)0x0150
-#define ASC_IOADR_4     (PortAddr)0x0190
-#define ASC_IOADR_5     (PortAddr)0x0210
-#define ASC_IOADR_6     (PortAddr)0x0230
-#define ASC_IOADR_7     (PortAddr)0x0250
-#define ASC_IOADR_8     (PortAddr)0x0330
-#define ASC_IOADR_DEF   ASC_IOADR_8
 #define ASC_LIB_SCSIQ_WK_SP        256
 #define ASC_MAX_SYN_XFER_NO        16
 #define ASC_SYN_MAX_OFFSET         0x0F
@@ -8089,8 +8077,8 @@ static int AscFindSignature(PortAddr iop_base)
 }
 
 static PortAddr _asc_def_iop_base[ASC_IOADR_TABLE_MAX_IX] __initdata = {
-	0x100, ASC_IOADR_1, 0x120, ASC_IOADR_2, 0x140, ASC_IOADR_3, ASC_IOADR_4,
-	ASC_IOADR_5, ASC_IOADR_6, ASC_IOADR_7, ASC_IOADR_8
+	0x100, 0x0110, 0x120, 0x0130, 0x140, 0x0150, 0x0190,
+	0x0210, 0x0230, 0x0250, 0x0330
 };
 
 #ifdef CONFIG_ISA
-- 
1.4.4.4

