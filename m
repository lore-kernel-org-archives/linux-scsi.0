From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH] scsi_dh_rdac: Add new IBM 1813 product id to rdac devlist
Date: Wed, 21 Aug 2013 20:34:30 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF23DEAB649@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx11.netapp.com ([216.240.18.76]:33626 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab3HUUec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 16:34:32 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

Add new IBM product id to the RDAC devlist

Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
---
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 69c915a..4b9cf93 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -786,6 +786,7 @@ static const struct scsi_dh_devlist rdac_dev_list[] = {
 	{"IBM", "1742"},
 	{"IBM", "1745"},
 	{"IBM", "1746"},
+	{"IBM", "1813"},
 	{"IBM", "1814"},
 	{"IBM", "1815"},
 	{"IBM", "1818"},
--
