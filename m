From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ipr: Driver version 2.6.4
Date: Wed, 15 Mar 2017 16:58:42 -0500
Message-ID: <20170315215840.E92E82805A@b01ledav001.gho.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38437 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753895AbdCOV6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 17:58:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2FLsT0k046681
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:47 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 296nfx3xax-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:47 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 15 Mar 2017 17:58:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_4 drivers/scsi/ipr.h
--- linux-2.6.git/drivers/scsi/ipr.h~ipr_version_2_6_4	2017-03-14 16:31:59.381210940 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.h	2017-03-14 16:32:13.630137789 -0500
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.3"
-#define IPR_DRIVER_DATE "(October 17, 2015)"
+#define IPR_DRIVER_VERSION "2.6.4"
+#define IPR_DRIVER_DATE "(March 14, 2017)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
