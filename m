From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/3] scsi: qla2xxx: print MAC via %pMR
Date: Thu, 25 Jul 2013 12:10:24 +0300
Message-ID: <1374743425-13828-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1374743425-13828-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3GYJKi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 05:10:38 -0400
In-Reply-To: <1374743425-13828-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d7a99ae..f925f07 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1265,10 +1265,7 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
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
1.8.3.2

