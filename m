From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/8] ipr: Allow driver_data to be passed for dynamic ids
Date: Thu, 26 Apr 2007 16:00:07 -0500
Message-ID: <200704262101.l3QL1JIM010380@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40200 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031491AbXDZVBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 17:01:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QL1Kg1026270
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:20 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1Kvk519386
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:20 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1JYQ010411
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Since driver_data for pci ids in the ipr driver is now
just flags, we can allow these to be passed in from userspace
for dynamic ids.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_dynids_driver_data drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dynids_driver_data	2007-04-26 09:17:24.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:17:24.000000000 -0500
@@ -7655,6 +7655,7 @@ static struct pci_driver ipr_driver = {
 	.remove = ipr_remove,
 	.shutdown = ipr_shutdown,
 	.err_handler = &ipr_err_handler,
+	.dynids.use_driver_data = 1
 };
 
 /**
_
