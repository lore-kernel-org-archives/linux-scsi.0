From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] scsi: qla2xxx: print MAC via %pMR
Date: Thu, 12 Jul 2012 10:51:30 +0300
Message-ID: <1342079490-20191-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342079490-20191-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6164 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139Ab2GLHvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2012 03:51:53 -0400
In-Reply-To: <1342079490-20191-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, iscsi-driver@qlogic.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5ab9530..095ba85 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1193,10 +1193,7 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
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
1.7.10.4

