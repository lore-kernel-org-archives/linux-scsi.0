From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [14/18] qla2xxx: Use proper include files
Date: Mon, 21 Jun 2004 22:58:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055847.GA8483@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:47750 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266607AbUFVFzD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:55:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1850 04/06/17 13:52:06 andrew.vasquez@apc.qlogic.com +2 -0
  Use the standard include/scsi/* headers rather than those in
  drivers/scsi/.  Slightly modified variant from initial patch sent by
  Christoph Hellwig <hch () lst !de>.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/Makefile |    2 +-
 drivers/scsi/qla2xxx/qla_os.h |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
--- a/drivers/scsi/qla2xxx/Makefile	2004-06-21 15:39:47 -07:00
+++ b/drivers/scsi/qla2xxx/Makefile	2004-06-21 15:39:47 -07:00
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -Idrivers/scsi -DUNIQUE_FW_NAME
+EXTRA_CFLAGS += -DUNIQUE_FW_NAME
 
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_rscn.o
diff -Nru a/drivers/scsi/qla2xxx/qla_os.h b/drivers/scsi/qla2xxx/qla_os.h
--- a/drivers/scsi/qla2xxx/qla_os.h	2004-06-21 15:39:47 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.h	2004-06-21 15:39:47 -07:00
@@ -58,11 +58,13 @@
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
-#include "hosts.h"
-
-#include <scsi/scsicam.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsicam.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
