From: Stephen Cameron <steve.cameron@hp.com>
Subject: [PATCH 1/1] cciss: include scsi/scsi.h unconditionally
Date: Fri, 13 Apr 2007 09:23:12 -0500
Message-ID: <20070413142312.GA24021@quandary.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:38610 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbXDMOZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Apr 2007 10:25:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jens.axboe@oracle.com, mike.miller@hp.com, james.bottomley@steeleye.com


Make cciss unconditionally include scsi/scsi.h

From: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>

---

 drivers/block/cciss.c      |    1 +
 drivers/block/cciss_scsi.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~include_scsi_h_unconditionally drivers/block/cciss.c
--- linux-2.6.21-rc6/drivers/block/cciss.c~include_scsi_h_unconditionally	2007-04-13 08:23:07.000000000 -0500
+++ linux-2.6.21-rc6-scameron/drivers/block/cciss.c	2007-04-13 08:25:05.000000000 -0500
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
+#include <scsi/scsi.h>
 #include <scsi/sg.h>
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
diff -puN drivers/block/cciss_scsi.c~include_scsi_h_unconditionally drivers/block/cciss_scsi.c
--- linux-2.6.21-rc6/drivers/block/cciss_scsi.c~include_scsi_h_unconditionally	2007-04-13 08:23:53.000000000 -0500
+++ linux-2.6.21-rc6-scameron/drivers/block/cciss_scsi.c	2007-04-13 08:24:34.000000000 -0500
@@ -35,7 +35,6 @@
 
 #include <asm/atomic.h>
 
-#include <scsi/scsi.h> 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h> 
_
