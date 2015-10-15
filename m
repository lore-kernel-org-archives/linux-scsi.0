From: sumit.saxena@avagotech.com
Subject: [PATCH 12/12] megaraid_sas : Remove debug print from function
 megasas_update_span_set
Date: Thu, 15 Oct 2015 13:41:14 +0530
Message-ID: <201510150818.t9F8IXDU029685@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rndsmtp1.avagotech.com ([202.86.248.48]:60963 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbbJOIUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com


Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index ce5b832..741509b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -1198,10 +1198,6 @@ void mr_update_span_set(struct MR_DRV_RAID_MAP_ALL *map,
 						span_row_width +=
 							MR_LdSpanPtrGet
 							(ld, count, map)->spanRowDataSize;
-						printk(KERN_INFO "megasas:"
-							"span %x rowDataSize %x\n",
-							count, MR_LdSpanPtrGet
-							(ld, count, map)->spanRowDataSize);
 					}
 				}
 
-- 
1.7.1

