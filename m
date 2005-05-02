From: brking@us.ibm.com
Subject: [PATCH 2/3] ipr: Array error logging fix
Date: Mon, 02 May 2005 14:50:59 -0500
Message-ID: <200505021951.j42Jp0jQ002499@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:52445 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261724AbVEBTvD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2005 15:51:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j42Jp1T9485860
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 15:51:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j42Jp15K068452
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 13:51:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j42Jp0oa002515
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 13:51:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bugme 4547. The following patch fixes a bug in ipr's error logging.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.12-rc3-bjking1/drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_array_error_fix drivers/scsi/ipr.c
--- linux-2.6.12-rc3/drivers/scsi/ipr.c~ipr_array_error_fix	2005-05-02 14:35:01.000000000 -0500
+++ linux-2.6.12-rc3-bjking1/drivers/scsi/ipr.c	2005-05-02 14:35:21.000000000 -0500
@@ -1054,7 +1054,7 @@ static void ipr_log_array_error(struct i
 				array_entry->dev_res_addr.lun);
 		}
 
-		if (array_entry->dev_res_addr.bus >= IPR_MAX_NUM_BUSES) {
+		if (array_entry->expected_dev_res_addr.bus >= IPR_MAX_NUM_BUSES) {
 			ipr_err("Expected Location: unknown\n");
 		} else {
 			ipr_err("Expected Location: %d:%d:%d:%d\n",
_
