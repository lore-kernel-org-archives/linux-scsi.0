From: brking@us.ibm.com
Subject: [PATCH 5/6] ipr: whitespace fixes
Date: Tue, 14 Dec 2004 17:10:09 -0600
Message-ID: <200412142310.iBENA9YH001536@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:31114 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261760AbULNXKe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:10:34 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBENALet319738
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:10:23 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBENAFpA013592
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:10:15 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBENAB71001758
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:10:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Whitespace fixes.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_whitespace_fixes drivers/scsi/ipr.h
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.h~ipr_whitespace_fixes	2004-12-14 17:06:41.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h	2004-12-14 17:06:41.000000000 -0600
@@ -1057,20 +1057,20 @@ struct ipr_error_table_t {
 };
 
 struct ipr_software_inq_lid_info {
-    u32  load_id;
-    u32  timestamp[3];
+	u32 load_id;
+	u32 timestamp[3];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ucode_image_header {
-    u32 header_length;
-    u32 lid_table_offset;
-    u8 major_release;
-    u8 card_type;
-    u8 minor_release[2];
-    u8 reserved[20];
-    char eyecatcher[16];
-    u32 num_lids;
-    struct ipr_software_inq_lid_info lid[1];
+	u32 header_length;
+	u32 lid_table_offset;
+	u8 major_release;
+	u8 card_type;
+	u8 minor_release[2];
+	u8 reserved[20];
+	char eyecatcher[16];
+	u32 num_lids;
+	struct ipr_software_inq_lid_info lid[1];
 }__attribute__((packed, aligned (4)));
 
 /*
_
