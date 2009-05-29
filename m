From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Add 16 byte CDB support
Date: Fri, 29 May 2009 14:10:49 -0500
Message-ID: <200905291910.n4TJAobp017691@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54994 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZE2TKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 May 2009 15:10:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4TJDNsk004552
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2009 15:13:23 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4TJAona223584
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2009 15:10:50 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4TJAowl017704
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2009 15:10:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Adds support for 16 byte CDBs to the ibmvscsi driver.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_max_cmd_len drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_max_cmd_len	2009-05-29 14:09:20.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-05-29 14:09:20.000000000 -0500
@@ -1687,6 +1687,7 @@ static int ibmvscsi_probe(struct vio_dev
 	host->max_lun = 8;
 	host->max_id = max_id;
 	host->max_channel = max_channel;
+	host->max_cmd_len = 16;
 
 	if (scsi_add_host(hostdata->host, hostdata->dev))
 		goto add_host_failed;
_
