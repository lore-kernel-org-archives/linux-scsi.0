From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH -next] [SCSI] qla2xxx: remove duplicated include from
 qla_isr.c
Date: Tue, 12 Mar 2013 06:08:47 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D2AB615@AVMB1.qlogic.org>
References: <CAPgLHd_8XvGmK_YCXWcM0xTEo0z=ptWR40gfVxW5AK=92m2GPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:19115
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab3CLGYA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Mar 2013 02:24:00 -0400
In-Reply-To: <CAPgLHd_8XvGmK_YCXWcM0xTEo0z=ptWR40gfVxW5AK=92m2GPw@mail.gmail.com>
Content-Language: en-US
Content-ID: <5DE0AB132C667C45A77B32E0688E549B@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav


>From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
>Remove duplicated include.
>
>Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>---
> drivers/scsi/qla2xxx/qla_isr.c | 2 --
> 1 file changed, 2 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_isr.c
>b/drivers/scsi/qla2xxx/qla_isr.c
>index 26a3086..cb7a1c1 100644
>--- a/drivers/scsi/qla2xxx/qla_isr.c
>+++ b/drivers/scsi/qla2xxx/qla_isr.c
>@@ -13,8 +13,6 @@
> #include <scsi/scsi_bsg_fc.h>
> #include <scsi/scsi_eh.h>
>
>-#include "qla_target.h"
>-
> static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
> static void qla2x00_process_completed_request(struct scsi_qla_host *,
>       struct req_que *, uint32_t);
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

