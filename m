From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 09/12] ipr: Disrupt device error
Date: Thu, 29 Mar 2007 12:43:37 -0500
Message-ID: <200703291743.l2THhbJk012637@d01av04.pok.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44196 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934307AbXC2Rnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2007 13:43:41 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THhcTZ005645
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:38 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhc0U270018
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:38 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhc1C012673
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:38 -0400
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Add entry in ipr error translation table for an error
received when a device is forced into the failed state
by the user.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_disrupt_error drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_disrupt_error	2007-03-23 11:17:25.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-23 11:18:05.000000000 -0500
@@ -360,6 +360,8 @@ struct ipr_error_table_t ipr_error_table
 	"9072: Link not operational transition"},
 	{0x066B8200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9032: Array exposed but still protected"},
+	{0x066B8300, 0, IPR_DEFAULT_LOG_LEVEL + 1,
+	"70DD: Device forced failed by disrupt device command"},
 	{0x066B9100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4061: Multipath redundancy level got better"},
 	{0x066B9200, 0, IPR_DEFAULT_LOG_LEVEL,
_
