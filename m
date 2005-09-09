From: viro@ZenIV.linux.org.uk
Subject: [PATCH] trivial iomem annotations in qla2xxx/qla_dbg.c
Date: Fri, 9 Sep 2005 21:42:25 +0100
Message-ID: <20050909204225.GD9623@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030508AbVIIUmf@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
----
diff -urN RC13-git8-base/drivers/scsi/qla2xxx/qla_dbg.c current/drivers/scsi/qla2xxx/qla_dbg.c
--- RC13-git8-base/drivers/scsi/qla2xxx/qla_dbg.c	2005-08-28 23:09:45.000000000 -0400
+++ current/drivers/scsi/qla2xxx/qla_dbg.c	2005-09-08 23:53:33.000000000 -0400
@@ -1334,7 +1334,7 @@
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
 		WRT_REG_DWORD(dmp_reg, 0xB0200000);
-		dmp_reg = (uint32_t *)((uint8_t *)reg + 0xFC);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
 		fw->shadow_reg[2] = RD_REG_DWORD(dmp_reg);
 
 		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
