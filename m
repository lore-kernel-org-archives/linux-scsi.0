From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] MAINTAINERS: Update the file list for the NCR 5380 entry
Date: Sat, 23 Apr 2016 12:20:07 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1604221419520.4429@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


The file atari_NCR5380.c has been removed from the tree so remove it 
from the MAINTAINERS file as well.

While we are here, add the file dtc3x80.txt as it is only relevant
to the dtc driver.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

The patch which removed atari_NCR5380.c is queued in jejb-scsi/for-next
(commit c4ec6f924f06) hence this change is applicable to that tree.

diff --git a/MAINTAINERS b/MAINTAINERS
index 61a323a..a87defa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7539,10 +7539,10 @@ M:	Michael Schmitz <schmitzmic@gmail.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/g_NCR5380.txt
+F:	Documentation/scsi/dtc3x80.txt
 F:	drivers/scsi/NCR5380.*
 F:	drivers/scsi/arm/cumana_1.c
 F:	drivers/scsi/arm/oak.c
-F:	drivers/scsi/atari_NCR5380.c
 F:	drivers/scsi/atari_scsi.*
 F:	drivers/scsi/dmx3191d.c
 F:	drivers/scsi/dtc.*
