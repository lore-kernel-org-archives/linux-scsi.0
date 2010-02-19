From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list
Date: Fri, 19 Feb 2010 10:08:31 -0600
Message-ID: <201002191610.o1JGAgdW025950@d03av06.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35588 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0BSQJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 11:09:16 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1JG5at4027807
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 09:05:36 -0700
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o1JG9CpF189730
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 09:09:12 -0700
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1JGAhWR025982
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 09:10:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds IBM Power Virtual SCSI ALUA devices to the ALUA device handler.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/device_handler/scsi_dh_alua.c~scsi_dh_alua_nvdisk drivers/scsi/device_handler/scsi_dh_alua.c
--- linux-2.6/drivers/scsi/device_handler/scsi_dh_alua.c~scsi_dh_alua_nvdisk	2010-02-18 21:49:47.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/device_handler/scsi_dh_alua.c	2010-02-18 21:50:22.000000000 -0600
@@ -717,6 +717,7 @@ static const struct scsi_dh_devlist alua
 	{"IBM", "2145" },
 	{"Pillar", "Axiom" },
 	{"Intel", "Multi-Flex"},
+	{"AIX", "NVDISK"},
 	{NULL, NULL}
 };
 
_
