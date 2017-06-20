From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: csiostor: update module version
Date: Tue, 20 Jun 2017 19:41:21 +0530
Message-ID: <1497967881-4378-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:62290 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbdFTOLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jun 2017 10:11:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com, rajesh.kumar@chelsio.com

Add -ko to the module version similar to module version of
other Chelsio drivers.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/csiostor/csio_init.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.h b/drivers/scsi/csiostor/csio_init.h
index 5cc5d31..96b31e5 100644
--- a/drivers/scsi/csiostor/csio_init.h
+++ b/drivers/scsi/csiostor/csio_init.h
@@ -50,7 +50,7 @@
 #define CSIO_DRV_AUTHOR			"Chelsio Communications"
 #define CSIO_DRV_LICENSE		"Dual BSD/GPL"
 #define CSIO_DRV_DESC			"Chelsio FCoE driver"
-#define CSIO_DRV_VERSION		"1.0.0"
+#define CSIO_DRV_VERSION		"1.0.0-ko"
 
 extern struct fc_function_template csio_fc_transport_funcs;
 extern struct fc_function_template csio_fc_transport_vport_funcs;
-- 
2.0.2
