From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] scsi: ibmvfc: fix typo in parameter description
Date: Thu,  8 Sep 2016 15:04:41 +0000
Message-ID: <1473347081-25953-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35740 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbcIHPEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2016 11:04:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id n24so2628099pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2016 08:04:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix typo in parameter description.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6b92169..56b9f45 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -88,7 +88,7 @@ module_param_named(log_level, log_level, uint, 0);
 MODULE_PARM_DESC(log_level, "Set to 0 - 4 for increasing verbosity of device driver. "
 		 "[Default=" __stringify(IBMVFC_DEFAULT_LOG_LEVEL) "]");
 module_param_named(cls3_error, cls3_error, uint, 0);
-MODULE_PARM_DESC(log_level, "Enable FC Class 3 Error Recovery. "
+MODULE_PARM_DESC(cls3_error, "Enable FC Class 3 Error Recovery. "
 		 "[Default=" __stringify(IBMVFC_CLS3_ERROR) "]");
 
 static const struct {

