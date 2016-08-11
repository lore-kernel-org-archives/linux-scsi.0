From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 05/14] lpfc: Code clean up for lpfc_iocb_cnt parameter
Date: Thu, 11 Aug 2016 11:35:52 -0700
Message-ID: <57acc588.Himk6pXv+J4tzIXx%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33212 "EHLO
	mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbcHKSfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:55 -0400
Received: by mail-qt0-f170.google.com with SMTP id w38so2191483qtb.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:55 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id t42sm2219430qte.24.2016.08.11.11.35.53
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code clean up for lpfc_iocb_cnt parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
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

