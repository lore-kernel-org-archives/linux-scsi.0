From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATHC 2.5.62] missing include for sim710
Date: Tue, 18 Feb 2003 13:32:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302181332.42349@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

diff -Naur linux-2.5.62/drivers/scsi/sim710.c linux-2.5.62-eike/drivers/scsi/sim710.c
--- linux-2.5.62/drivers/scsi/sim710.c	Mon Feb 17 23:56:49 2003
+++ linux-2.5.62-eike/drivers/scsi/sim710.c	Tue Feb 18 12:56:02 2003
@@ -32,6 +32,7 @@
 #include <linux/blk.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #ifdef CONFIG_MCA
 #include <linux/mca.h>
 #endif
