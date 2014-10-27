From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: Disable async aborts
Date: Mon, 27 Oct 2014 09:37:46 -0500
Message-ID: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52525 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaJ0Ojy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 10:39:54 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 27 Oct 2014 10:39:53 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTPS id 2652DC90043
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 10:28:33 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9REdnmJ58196172
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 14:39:49 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9REdmuA017585
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2014 10:39:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


The ipr driver does not yet support async aborts, so disable this
for now.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_no_async_eh drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_no_async_eh	2014-10-24 08:57:53.169169509 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2014-10-24 08:57:53.175169579 -0500
@@ -6357,6 +6357,7 @@ static struct scsi_host_template driver_
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME,
 	.no_write_same = 1,
+	.no_async_abort = 1,
 };
 
 /**
_

