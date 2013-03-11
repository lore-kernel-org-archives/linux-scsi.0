From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] qla2xxx: remove duplicated include from qla_isr.c
Date: Mon, 11 Mar 2013 22:23:09 +0800
Message-ID: <CAPgLHd_8XvGmK_YCXWcM0xTEo0z=ptWR40gfVxW5AK=92m2GPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34880 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3CKOXL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Mar 2013 10:23:11 -0400
Received: by mail-bk0-f44.google.com with SMTP id j4so1740395bkw.31
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 07:23:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 26a3086..cb7a1c1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -13,8 +13,6 @@
 #include <scsi/scsi_bsg_fc.h>
 #include <scsi/scsi_eh.h>
 
-#include "qla_target.h"
-
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_process_completed_request(struct scsi_qla_host *,
 	struct req_que *, uint32_t);

