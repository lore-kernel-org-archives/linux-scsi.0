From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] scsi: csiostor: remove unneeded DRIVER_LICENSE #define
Date: Fri, 17 Nov 2017 15:21:22 +0100
Message-ID: <20171117142122.GF17880@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933834AbdKQOVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 09:21:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>
Cc: linux-kernel@vger.kernel.org, Philippe Ombredanne <pombredanne@nexb.com>, linux-scsi@vger.kernel.org

There is no need to #define the license of the driver, just put it in
the MODULE_LICENSE() line directly as a text string.

This allows tools that check that the module license matches the source
code license to work properly, as there is no need to unwind the
unneeded dereference, especially when the string is defined in a .h file
far away from the .c file it is used in.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Varun Prakash <varun@chelsio.com>
Reported-by: Philippe Ombredanne <pombredanne@nexb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/csiostor/csio_init.c | 2 +-
 drivers/scsi/csiostor/csio_init.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 28a9c7d706cb..abd71379bce3 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1255,7 +1255,7 @@ module_init(csio_init);
 module_exit(csio_exit);
 MODULE_AUTHOR(CSIO_DRV_AUTHOR);
 MODULE_DESCRIPTION(CSIO_DRV_DESC);
-MODULE_LICENSE(CSIO_DRV_LICENSE);
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
diff --git a/drivers/scsi/csiostor/csio_init.h b/drivers/scsi/csiostor/csio_init.h
index 96b31e5af91e..20244254325a 100644
--- a/drivers/scsi/csiostor/csio_init.h
+++ b/drivers/scsi/csiostor/csio_init.h
@@ -48,7 +48,6 @@
 #include "csio_hw.h"
 
 #define CSIO_DRV_AUTHOR			"Chelsio Communications"
-#define CSIO_DRV_LICENSE		"Dual BSD/GPL"
 #define CSIO_DRV_DESC			"Chelsio FCoE driver"
 #define CSIO_DRV_VERSION		"1.0.0-ko"
 
-- 
2.15.0
