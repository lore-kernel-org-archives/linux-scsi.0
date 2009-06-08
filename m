From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 1/5] ibmvscsi: Add 16 byte CDB support
Date: Mon, 08 Jun 2009 16:19:01 -0500
Message-ID: <200906082119.n58LJ23C016418@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50477 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZFHVTB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 17:19:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n58LEHio030309
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 17:14:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58LJ34F131632
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 17:19:03 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58LJ2Nw016459
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 17:19:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds support for 16 byte CDBs to the ibmvscsi driver.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_max_cmd_len drivers/scsi/ibmvscsi/ibmvscsi.c
--- scsi-misc-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_max_cmd_len	2009-06-08 15:54:02.000000000 -0500
+++ scsi-misc-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-08 15:54:02.000000000 -0500
@@ -1684,6 +1684,7 @@ static int ibmvscsi_probe(struct vio_dev
 	host->max_lun = 8;
 	host->max_id = max_id;
 	host->max_channel = max_channel;
+	host->max_cmd_len = 16;
 
 	if (scsi_add_host(hostdata->host, hostdata->dev))
 		goto add_host_failed;
_
