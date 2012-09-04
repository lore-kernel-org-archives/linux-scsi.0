From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 1/2] scsi_dh_rdac : minor return fix for rdac
Date: Tue, 4 Sep 2012 17:03:59 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0BCCAEFA@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:42977 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab2IDREZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 13:04:25 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>

Minor return fix.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.6-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2012-09-04 12:13:40.000000000 -0500
+++ linux-3.6-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c	2012-09-04 12:15:26.000000000 -0500
@@ -863,7 +863,7 @@ static int rdac_bus_attach(struct scsi_d
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    RDAC_NAME);
-		return 0;
+		return -ENOMEM;
 	}
 
 	scsi_dh_data->scsi_dh = &rdac_dh;


