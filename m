From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 42/54] MAINTAINERS: Add file patterns for scsi device tree bindings
Date: Sun, 22 May 2016 11:06:19 +0200
Message-ID: <1463907991-7916-43-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 327e1d5a501340ac..139824579fa97c2c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10141,6 +10141,7 @@ M:	"Martin K. Petersen" <martin.petersen@oracle.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/scsi/
 F:	drivers/scsi/
 F:	include/scsi/
 
-- 
1.9.1
