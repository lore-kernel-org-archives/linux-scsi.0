From: brking@us.ibm.com
Subject: [PATCH 3/6] ipr: new RAID error
Date: Tue, 14 Dec 2004 17:09:56 -0600
Message-ID: <200412142309.iBEN9vx2001938@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:6330 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261753AbULNXKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:10:04 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBEN9wDP327202
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:09:58 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBEN9wrC160266
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:09:58 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBEN9veH001983
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:09:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds support for logging a new RAID error that can be returned on
new ipr adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_new_error drivers/scsi/ipr.c
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.c~ipr_new_error	2004-12-14 17:06:35.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.c	2004-12-14 17:06:35.000000000 -0600
@@ -312,6 +312,8 @@ struct ipr_error_table_t ipr_error_table
 	"9041: Array protection temporarily suspended"},
 	{0x066B0200, 0, 1,
 	"9030: Array no longer protected due to missing or failed disk unit"},
+	{0x066B8200, 0, 1,
+	"9042: Corrupt array parity detected on specified device"},
 	{0x07270000, 0, 0,
 	"Failure due to other device"},
 	{0x07278000, 0, 1,
_
