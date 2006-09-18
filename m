From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 1/6] zfcp: remove zfcp_ccw_unregister function
Date: Mon, 18 Sep 2006 22:28:04 +0200
Message-ID: <20060918202804.GA10480@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39458 "EHLO
	mtagate6.de.ibm.com") by vger.kernel.org with ESMTP id S964929AbWIRUcu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 16:32:50 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.8/8.13.8) with ESMTP id k8IKWnqh121094
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 20:32:49 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8IKbXBY2588792
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:37:33 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8IKWmEc013660
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:32:48 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

zfcp: remove zfcp_ccw_unregister function

Remove unused zfcp_ccw_unregister function (leftover from zfcp's
module_exit era).

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c |   13 -------------
 drivers/s390/scsi/zfcp_ext.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index fdabade..81680ef 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -275,19 +275,6 @@ zfcp_ccw_register(void)
 }
 
 /**
- * zfcp_ccw_unregister - ccw unregister function
- *
- * Unregisters the driver from common i/o layer. Function will be called at
- * module unload/system shutdown.
- */
-void __exit
-zfcp_ccw_unregister(void)
-{
-	zfcp_sysfs_driver_remove_files(&zfcp_ccw_driver.driver);
-	ccw_driver_unregister(&zfcp_ccw_driver);
-}
-
-/**
  * zfcp_ccw_shutdown - gets called on reboot/shutdown
  *
  * Makes sure that QDIO queues are down when the system gets stopped.
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 146d7a2..b45d1bf 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -55,7 +55,6 @@ extern void   zfcp_unit_dequeue(struct z
 
 /******************************* S/390 IO ************************************/
 extern int  zfcp_ccw_register(void);
-extern void zfcp_ccw_unregister(void);
 
 extern void zfcp_qdio_zero_sbals(struct qdio_buffer **, int, int);
 extern int  zfcp_qdio_allocate(struct zfcp_adapter *);
-- 
1.4.2.1.g80823

