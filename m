From: brking@us.ibm.com
Subject: [PATCH 08/16] ipr: Don't log adapter shutdown error response code
Date: Wed, 04 Aug 2004 17:32:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042233.i74MXVCu084422@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:25552 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267473AbUHDWcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:32:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The following patch adds an adapter response code to the
table in the driver to prevent an error from being logged
when this response is received.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_ioa_shutdown_response drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_ioa_shutdown_response	2004-08-04 17:17:32.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:32.000000000 -0500
@@ -208,6 +208,8 @@ struct ipr_error_table_t ipr_error_table
 	"Synchronization required"},
 	{0x024E0000, 0, 0,
 	"No ready, IOA shutdown"},
+	{0x025A0000, 0, 0,
+	"Not ready, IOA has been shutdown"},
 	{0x02670100, 0, 1,
 	"3020: Storage subsystem configuration error"},
 	{0x03110B00, 0, 0,
_
