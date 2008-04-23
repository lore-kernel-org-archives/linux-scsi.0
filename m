From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next 1/2] scsi: spi transport include sysfs.h
Date: Wed, 23 Apr 2008 09:56:14 -0700
Message-ID: <20080423095614.e91488fc.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:18317 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYDWQ7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2008 12:59:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>
Cc: akpm <akpm@linux-foundation.org>, sfr@canb.auug.org.au

From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_transport_spi.c needs to #include <linux/sysfs.h>:

next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c |    1 +
 1 file changed, 1 insertion(+)

--- next-20080423.orig/drivers/scsi/scsi_transport_spi.c
+++ next-20080423/drivers/scsi/scsi_transport_spi.c
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/sysfs.h>
 #include <scsi/scsi.h>
 #include "scsi_priv.h"
 #include <scsi/scsi_device.h>
