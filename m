From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 09/17 v2] lpfc: Code cleanup for lpfc_topology parameter
Date: Wed, 12 Oct 2016 13:14:12 -0700
Message-ID: <57fe9994.uJe+lX0DsK/dPNA2%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:59041 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755992AbcJLUOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:40 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id 7E0FB120995
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_topology parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ae76aaa..81b1faf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3194,6 +3194,8 @@ LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
 # Set loop mode if you want to run as an NL_Port. Value range is [0,0x6].
 # Default value is 0.
 */
+LPFC_ATTR(topology, 0, 0, 6,
+	"Select Fibre Channel topology");
 
 /**
  * lpfc_topology_set - Set the adapters topology field
@@ -3271,11 +3273,8 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 		phba->brd_no, val);
 	return -EINVAL;
 }
-static int lpfc_topology = 0;
-module_param(lpfc_topology, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_topology, "Select Fibre Channel topology");
+
 lpfc_param_show(topology)
-lpfc_param_init(topology, 0, 0, 6)
 static DEVICE_ATTR(lpfc_topology, S_IRUGO | S_IWUSR,
 		lpfc_topology_show, lpfc_topology_store);
 
-- 
2.5.0


