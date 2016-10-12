From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 06/17 v2] lpfc: Code clean up for lpfc_iocb_cnt parameter
Date: Wed, 12 Oct 2016 13:14:09 -0700
Message-ID: <57fe9991.HMI/OHvxrN4ooqRz%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.61]:53786 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755983AbcJLUOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:41 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 886E6100707
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code clean up for lpfc_iocb_cnt parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index be81e61..e5092dc 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2827,14 +2827,8 @@ lpfc_txcmplq_hw_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
 			 lpfc_txcmplq_hw_show, NULL);
 
-int lpfc_iocb_cnt = 2;
-module_param(lpfc_iocb_cnt, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_iocb_cnt,
+LPFC_ATTR_R(iocb_cnt, 2, 1, 5,
 	"Number of IOCBs alloc for ELS, CT, and ABTS: 1k to 5k IOCBs");
-lpfc_param_show(iocb_cnt);
-lpfc_param_init(iocb_cnt, 2, 1, 5);
-static DEVICE_ATTR(lpfc_iocb_cnt, S_IRUGO,
-			 lpfc_iocb_cnt_show, NULL);
 
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
-- 
2.5.0


