From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] megaraid_sas: mark symbols static where possible
Date: Mon, 26 Sep 2016 21:19:05 -0400
Message-ID: <yq1a8eu2l86.fsf@sermon.lab.mkp.net>
References: <1474782672-32146-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34360 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756070AbcI0BTS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 21:19:18 -0400
In-Reply-To: <1474782672-32146-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 25 Sep 2016 13:51:12 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get a few warnings when building kernel with W=1:
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:94:5: warning: no
Baoyou> previous prototype for 'mega_mod64' [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:112:5: warning: no
Baoyou> previous prototype for 'mega_div64_32' [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:177:6: warning: no
Baoyou> previous prototype for 'MR_PopulateDrvRaidMap'
Baoyou> [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:315:5: warning: no
Baoyou> previous prototype for 'MR_GetSpanBlock' [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:451:5: warning: no
Baoyou> previous prototype for 'mr_spanset_get_span_block'
Baoyou> [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:692:4: warning: no
Baoyou> previous prototype for 'get_arm' [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:815:4: warning: no
Baoyou> previous prototype for 'MR_GetPhyParams' [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fp.c:1293:4: warning: no
Baoyou> previous prototype for 'megasas_get_best_arm_pd'
Baoyou> [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fusion.c:106:1: warning: no
Baoyou> previous prototype for 'megasas_enable_intr_fusion'
Baoyou> [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fusion.c:127:1: warning: no
Baoyou> previous prototype for 'megasas_disable_intr_fusion'
Baoyou> [-Wmissing-prototypes] ....

Does not apply. Please make sure your patches are against my for-next
branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
