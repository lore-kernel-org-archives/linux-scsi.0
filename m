From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] mvsas: mark symbols static where possible
Date: Mon, 26 Sep 2016 21:16:41 -0400
Message-ID: <yq1eg462lc6.fsf@sermon.lab.mkp.net>
References: <1474782530-17964-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33875 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753802AbcI0BRG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 21:17:06 -0400
In-Reply-To: <1474782530-17964-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 25 Sep 2016 13:48:50 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Wilfried.Weissmann@gmx.at, hare@suse.de, jthumshirn@suse.de, tj@kernel.org, davispuh@gmail.com, luisbg@osg.samsung.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get a few warnings when building kernel with W=1:
Baoyou> drivers/scsi/mvsas/mv_sas.c:77:18: warning: no previous
Baoyou> prototype for 'mvs_find_dev_mvi' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:105:5: warning: no previous
Baoyou> prototype for 'mvs_find_dev_phyno' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:1161:20: warning: no previous
Baoyou> prototype for 'mvs_alloc_dev' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:1178:6: warning: no previous
Baoyou> prototype for 'mvs_free_dev' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:1188:5: warning: no previous
Baoyou> prototype for 'mvs_dev_found_notify' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:1244:6: warning: no previous
Baoyou> prototype for 'mvs_dev_gone_notify' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:1614:6: warning: no previous
Baoyou> prototype for 'mvs_set_sense' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_sas.c:1653:6: warning: no previous
Baoyou> prototype for 'mvs_fill_ssp_resp_iu' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_64xx.c:139:6: warning: no previous
Baoyou> prototype for 'mvs_64xx_clear_srs_irq' [-Wmissing-prototypes]
Baoyou> drivers/scsi/mvsas/mv_64xx.c:566:6: warning: no previous
Baoyou> prototype for 'mvs_64xx_make_prd' [-Wmissing-prototypes] ....

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
