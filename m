From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ipr: Re-enable write same
Date: Thu, 26 Mar 2015 11:23:56 -0500
Message-ID: <201503261623.t2QGNvgx032081@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:51522 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbbCZQYC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 12:24:02 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 26 Mar 2015 10:24:01 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 28A6D19D803E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 10:15:06 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2QGMFOk35258494
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 09:22:15 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2QGNwon032173
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 10:23:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Re-enable write same support for ipr RAID adapters.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_write_same drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_write_same	2015-03-12 16:26:04.036892977 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-03-12 16:26:04.044892894 -0500
@@ -6404,7 +6404,6 @@ static struct scsi_host_template driver_
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME,
-	.no_write_same = 1,
 	.use_blk_tags = 1,
 };
 
_

