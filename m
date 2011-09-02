From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH]scsi_dh_rdac: Adding NetApp as a brand name for rdac
Date: Fri, 2 Sep 2011 12:43:50 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D05D03C62@BTCMVEXC2-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:20229 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab1IBHN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 03:13:57 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>, "Moger, Babu" <Babu.Moger@netapp.com>

Adding NetApp as brand name for RDAC.

Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
Reviewed-by: Bob Stankey <Robert.stankey@netapp.com>
Reviewed-by: Babu Moger <Babu.moger@netapp.com>

---
--- linux-3.0.3-orig/drivers/scsi/device_handler/scsi_dh_rdac.c
2011-08-17 23:27:16.000000000 +0530
+++ linux-3.0.3-compiled/drivers/scsi/device_handler/scsi_dh_rdac.c
2011-08-30 19:10:49.000000000 +0530
@@ -1,5 +1,5 @@
 /*
- * Engenio/LSI RDAC SCSI Device Handler
+ * LSI/Engenio/NetApp E-Series RDAC SCSI Device Handler
  *
  * Copyright (C) 2005 Mike Christie. All rights reserved.
  * Copyright (C) Chandra Seetharaman, IBM Corp. 2007
@@ -941,7 +941,7 @@ static void __exit rdac_exit(void)
 module_init(rdac_init);
 module_exit(rdac_exit);
 
-MODULE_DESCRIPTION("Multipath LSI/Engenio RDAC driver");
+MODULE_DESCRIPTION("Multipath LSI/Engenio/NetApp E-Series RDAC
driver");
 MODULE_AUTHOR("Mike Christie, Chandra Seetharaman");
 MODULE_VERSION("01.00.0000.0000");
 MODULE_LICENSE("GPL");
--
