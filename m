From: brking@us.ibm.com
Subject: [PATCH 1/1] ipr: Handle new RAID 6 errors
Date: Thu, 24 Feb 2005 10:40:18 -0600
Message-ID: <200502241640.j1OGeJlm016789@d03av02.boulder.ibm.com>
Received: from e31.co.us.ibm.com ([32.97.110.129]:64682 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262349AbVBXQkW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 11:40:22 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1OGeKua228112
	for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 11:40:20 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1OGeKXW158370
	for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 09:40:20 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1OGeJSx016823
	for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 09:40:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


This patch allows ipr to properly log 2 new RAID 6 related
errors.

Please apply with along the previous batch of ipr patches I sent.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_raid6_errors drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_raid6_errors	2005-02-23 17:16:05.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-23 17:18:43.000000000 -0600
@@ -323,10 +323,12 @@ struct ipr_error_table_t ipr_error_table
 	"3150: SCSI bus configuration error"},
 	{0x06690200, 0, 1,
 	"9041: Array protection temporarily suspended"},
+	{0x06698200, 0, 1,
+	"9042: Corrupt array parity detected on specified device"},
 	{0x066B0200, 0, 1,
 	"9030: Array no longer protected due to missing or failed disk unit"},
 	{0x066B8200, 0, 1,
-	"9042: Corrupt array parity detected on specified device"},
+	"9032: Array exposed but still protected"},
 	{0x07270000, 0, 0,
 	"Failure due to other device"},
 	{0x07278000, 0, 1,
_
