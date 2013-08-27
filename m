From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 28/29] qla2xxx: print MAC via %pMR.
Date: Tue, 27 Aug 2013 01:37:54 -0400
Message-ID: <1377581875-8574-29-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:17626 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950Ab3H0GGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:54 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R65GY5019637
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:53 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690x3-8
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:53 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b1d32c4..5f174b8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1290,10 +1290,7 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
 	if (!IS_CNA_CAPABLE(vha->hw))
 		return snprintf(buf, PAGE_SIZE, "\n");
 
-	return snprintf(buf, PAGE_SIZE, "%02x:%02x:%02x:%02x:%02x:%02x\n",
-	    vha->fcoe_vn_port_mac[5], vha->fcoe_vn_port_mac[4],
-	    vha->fcoe_vn_port_mac[3], vha->fcoe_vn_port_mac[2],
-	    vha->fcoe_vn_port_mac[1], vha->fcoe_vn_port_mac[0]);
+	return snprintf(buf, PAGE_SIZE, "%pMR\n", vha->fcoe_vn_port_mac);
 }
 
 static ssize_t
-- 
1.7.7

