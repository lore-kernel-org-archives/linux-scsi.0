From: malahal@us.ibm.com
Subject: [PATCH] aic94xx: Fix for a typo in aic94xx_init()
Date: Thu, 7 Sep 2006 15:12:42 -0700
Message-ID: <20060907221242.GA19218@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:33923 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1422633AbWIGWMp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 18:12:45 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k87MCiva000840
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 18:12:44 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k87MCiTE207218
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 16:12:44 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k87MCi2n020340
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 16:12:44 -0600
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k87MCiLs020316
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 16:12:44 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>


diff -r 134012c83658 drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c	Thu Aug 31 13:03:38 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_init.c	Thu Sep 07 15:05:39 2006 -0700
@@ -822,7 +822,7 @@ static int __init aic94xx_init(void)
 
 	aic94xx_transport_template =
 		sas_domain_attach_transport(&aic94xx_transport_functions);
-	if (err)
+	if (!aic94xx_transport_template)
 		goto out_destroy_caches;
 
 	err = pci_register_driver(&aic94xx_pci_driver);
