From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: add missing header dependencies for tc-dwc-g210
Date: Fri, 02 Sep 2016 07:08:10 -0400
Message-ID: <yq1zinqsgo5.fsf@sermon.lab.mkp.net>
References: <1472465940-18570-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:32168 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753594AbcIBLKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 07:10:08 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u82BA1Bp018508
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2016 11:10:02 GMT
In-Reply-To: <1472465940-18570-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Mon, 29 Aug 2016 18:19:00 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: Joao.Pinto@synopsys.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 2 warnings when build kernel with W=1:
Baoyou> drivers/scsi/ufs/tc-dwc-g210.c:261:5: warning: no previous
Baoyou> prototype for 'tc_dwc_g210_config_40_bit' [-Wmissing-prototypes]
Baoyou> drivers/scsi/ufs/tc-dwc-g210.c:293:5: warning: no previous
Baoyou> prototype for 'tc_dwc_g210_config_20_bit' [-Wmissing-prototypes]

Baoyou> In fact, these functions are declared in ufs/tc-dwc-g210.h, so
Baoyou> this patch add missing header dependencies

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
