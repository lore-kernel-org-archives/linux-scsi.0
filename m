From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: increase dump size in ipr driver
Date: Wed, 04 Dec 2013 15:22:47 -0600
Message-ID: <20131204212353.537548369@linux.vnet.ibm.com>
References: <20131204212246.280069823@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60078 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754853Ab3LDV0o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 16:26:44 -0500
Content-Disposition: inline; filename=incr_dump_size
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

To help debugging several new SAS controllers, increase the dump size in ipr driver.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-11-19 10:13:31.000000000 -0600
+++ b/drivers/scsi/ipr.h	2013-11-19 10:15:14.347765463 -0600
@@ -301,7 +301,7 @@ IPR_PCII_NO_HOST_RRQ | IPR_PCII_IOARRIN_
  * Dump literals
  */
 #define IPR_FMT2_MAX_IOA_DUMP_SIZE			(4 * 1024 * 1024)
-#define IPR_FMT3_MAX_IOA_DUMP_SIZE			(32 * 1024 * 1024)
+#define IPR_FMT3_MAX_IOA_DUMP_SIZE			(80 * 1024 * 1024)
 #define IPR_FMT2_NUM_SDT_ENTRIES			511
 #define IPR_FMT3_NUM_SDT_ENTRIES			0xFFF
 #define IPR_FMT2_MAX_NUM_DUMP_PAGES	((IPR_FMT2_MAX_IOA_DUMP_SIZE / PAGE_SIZE) + 1)

-- 
