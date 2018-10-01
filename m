From: "Matthew R. Ochs" <mrochs@linux.ibm.com>
Subject: [PATCH] MAINTAINERS: Fix typo in cxlflash stanza
Date: Mon,  1 Oct 2018 11:26:10 -0500
Message-ID: <1538411170-1977-1-git-send-email-mrochs@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Uma Krishnan <ukrishn@linux.ibm.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The uapi header file listed in the cxlflash stanza has a typo.

Removed the trailing 's' from the filename.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Matthew R. Ochs <mrochs@linux.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b22e7fd..1038857 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4032,7 +4032,7 @@ M:	Uma Krishnan <ukrishn@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/cxlflash/
-F:	include/uapi/scsi/cxlflash_ioctls.h
+F:	include/uapi/scsi/cxlflash_ioctl.h
 F:	Documentation/powerpc/cxlflash.txt
 
 CYBERPRO FB DRIVER
-- 
2.1.0
