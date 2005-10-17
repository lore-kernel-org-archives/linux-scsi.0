From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fix implicit declaration compile warning in qla2xxx
Date: Mon, 17 Oct 2005 19:59:23 +0200
Message-ID: <200510171959.23585.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751074AbVJQR4Y@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Fix warning about implicitly declared function in qla_rscn.c
  drivers/scsi/qla2xxx/qla_rscn.c:334: warning: implicit declaration of function `fc_remote_port_unblock'

From: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/qla2xxx/qla_rscn.c |    1 +
 1 files changed, 1 insertion(+)

--- linux-2.6.14-rc4-mm1-orig/drivers/scsi/qla2xxx/qla_rscn.c	2005-10-11 22:41:20.000000000 +0200
+++ linux-2.6.14-rc4-mm1/drivers/scsi/qla2xxx/qla_rscn.c	2005-10-17 19:53:50.000000000 +0200
@@ -17,6 +17,7 @@
  *
  */
 #include "qla_def.h"
+#include <scsi/scsi_transport_fc.h>
 
 /**
  * IO descriptor handle definitions.





/Jesper Juhl


PS. 
 Please CC me on replies.
