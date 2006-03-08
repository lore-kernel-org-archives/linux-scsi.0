From: akpm@osdl.org
Subject: [patch 13/28] drivers/scsi/FlashPoint.c: use standard fixed size types
Date: Wed, 08 Mar 2006 00:14:28 -0800
Message-ID: <200603080816.k288GHf6002191@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:26540 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752105AbWCHIQU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-use-standard-fixed-size-types drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-use-standard-fixed-size-types	Mon Feb  6 14:50:08 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:08 2006
@@ -44,13 +44,7 @@
 
 
 
-#define s08bits	char
-#define s16bits 	short
-#define s32bits	long
-
-#define u08bits	unsigned s08bits
-#define u16bits	unsigned s16bits
-#define u32bits	unsigned s32bits
+
 
 
 
@@ -245,12 +239,12 @@ typedef struct _SCCB {
 #define SG_ELEMENT_SIZE 8              /*Eight byte per element. */
 
 
-#define RD_HARPOON(ioport)          inb((u32bits)ioport)
-#define RDW_HARPOON(ioport)         inw((u32bits)ioport)
-#define RD_HARP32(ioport,offset,data) (data = inl((u32bits)(ioport + offset)))
-#define WR_HARPOON(ioport,val)      outb((u08bits) val, (u32bits)ioport)
-#define WRW_HARPOON(ioport,val)       outw((u16bits)val, (u32bits)ioport)
-#define WR_HARP32(ioport,offset,data)  outl(data, (u32bits)(ioport + offset))
+#define RD_HARPOON(ioport)          inb((u32)ioport)
+#define RDW_HARPOON(ioport)         inw((u32)ioport)
+#define RD_HARP32(ioport,offset,data) (data = inl((u32)(ioport + offset)))
+#define WR_HARPOON(ioport,val)      outb((u8) val, (u32)ioport)
+#define WRW_HARPOON(ioport,val)       outw((u16)val, (u32)ioport)
+#define WR_HARP32(ioport,offset,data)  outl(data, (u32)(ioport + offset))
 
 
 #define  TAR_SYNC_MASK     (BIT(7)+BIT(6))
_
