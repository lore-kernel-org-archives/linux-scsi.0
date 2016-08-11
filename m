From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 08/14] lpfc: Code cleanup for lpfc_topology parameter
Date: Thu, 11 Aug 2016 11:35:55 -0700
Message-ID: <57acc58b.H4BGalpVbm0V4422%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34724 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbcHKSf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:58 -0400
Received: by mail-qk0-f172.google.com with SMTP id p186so4256252qkd.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:58 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id v126sm946791qkh.30.2016.08.11.11.35.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_topology parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
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

