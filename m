From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 09/17] lpfc: Code cleanup for lpfc_topology parameter
Date: Thu, 13 Oct 2016 15:06:10 -0700
Message-ID: <58000552.hYxc6PG8Hb2SOW8o%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([202.86.248.61]:55284 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757018AbcJMWQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:16:36 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 79018100730
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:12 -0700 (PDT)
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


