From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add .module to qla1280 template
Date: 21 Sep 2004 17:27:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095802062.2467.629.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:960 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268074AbUIUV2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:28:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This was missing.  It needs to be added so the module tracking actually
works correctly for the driver.

James

===== drivers/scsi/qla1280.c 1.65 vs edited =====
--- 1.65/drivers/scsi/qla1280.c	2004-07-28 23:59:10 -04:00
+++ edited/drivers/scsi/qla1280.c	2004-09-21 17:25:39 -04:00
@@ -4641,6 +4641,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020600
 static struct scsi_host_template qla1280_driver_template = {
+	.module			= THIS_MODULE,
 	.proc_name		= "qla1280",
 	.name			= "Qlogic ISP 1280/12160",
 	.info			= qla1280_info,

