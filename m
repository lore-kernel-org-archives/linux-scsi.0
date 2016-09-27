From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] pm8001: mark symbols static where possible
Date: Mon, 26 Sep 2016 21:12:24 -0400
Message-ID: <yq1inti2ljb.fsf@sermon.lab.mkp.net>
References: <1474638862-22595-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27897 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754904AbcI0BNE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 21:13:04 -0400
In-Reply-To: <1474638862-22595-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Fri, 23 Sep 2016 21:54:22 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: jinpu.wang@profitbricks.com, lindar_liu@usish.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, pmchba@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 2 warnings when building kernel with W=1:
Baoyou> drivers/scsi/pm8001/pm8001_sas.c:530:23: warning: no previous
Baoyou> prototype for 'pm8001_alloc_dev' [-Wmissing-prototypes]
Baoyou> drivers/scsi/pm8001/pm8001_hwi.c:4495:5: warning: no previous
Baoyou> prototype for 'pm8001_chip_phy_stop_req' [-Wmissing-prototypes]

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
