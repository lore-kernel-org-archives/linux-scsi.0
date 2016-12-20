From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] scsi: qedi: fix build, depends on UIO
Date: Tue, 20 Dec 2016 08:43:30 -0800
Message-ID: <26cb8213-7474-0563-67f8-c6b85ee0f024@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57918 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935973AbcLTQni (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 11:43:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.or>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build of SCSI qedi driver. It uses uio interfaces so it
should depend on UIO.

ERROR: "uio_unregister_device" [drivers/scsi/qedi/qedi.ko] undefined!
ERROR: "uio_event_notify" [drivers/scsi/qedi/qedi.ko] undefined!
ERROR: "__uio_register_device" [drivers/scsi/qedi/qedi.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: QLogic-Storage-Upstream@cavium.com
---
 drivers/scsi/qedi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20161220.orig/drivers/scsi/qedi/Kconfig
+++ linux-next-20161220/drivers/scsi/qedi/Kconfig
@@ -1,6 +1,6 @@
 config QEDI
 	tristate "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver Support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && UIO
 	depends on QED
 	select SCSI_ISCSI_ATTRS
 	select QED_LL2
