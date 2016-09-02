From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] qla4xxx: mark symbols static where possible
Date: Fri, 02 Sep 2016 06:08:36 -0400
Message-ID: <yq137livckb.fsf@sermon.lab.mkp.net>
References: <1472467611-8574-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41713 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbcIBKIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 06:08:54 -0400
In-Reply-To: <1472467611-8574-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Mon, 29 Aug 2016 18:46:51 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 1 warning when build kernel with W=1:
Baoyou> drivers/scsi/qla4xxx/ql4_nx.c:1846:10: warning: no previous
Baoyou> prototype for 'ql4_84xx_ipmdio_rd_reg' [-Wmissing-prototypes]

Baoyou> In fact, this function is only used in the file in which it is
Baoyou> declared and don't need a declaration, but can be made static.
Baoyou> so this patch marks this function with 'static'.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
