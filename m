From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: move function declarations to scsi_priv.h
Date: Wed, 31 Aug 2016 00:29:06 -0400
Message-ID: <yq1vayh5zot.fsf@sermon.lab.mkp.net>
References: <1472556360-22313-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23971 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbcHaE3X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2016 00:29:23 -0400
In-Reply-To: <1472556360-22313-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Tue, 30 Aug 2016 19:26:00 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 2 warnings about global functions without a declaration
Baoyou> in the scsi driver when building with W=1:
Baoyou> drivers/scsi/scsi_lib.c:467:6: warning: no previous prototype
Baoyou> for 'scsi_requeue_run_queue' [-Wmissing-prototypes]
Baoyou> drivers/scsi/scsi_lib.c:2609:6: warning: no previous prototype
Baoyou> for 'scsi_evt_thread' [-Wmissing-prototypes]

Baoyou> in fact, both functions are declared in drivers/scsi/scsi_scan.c
Baoyou> but need to move them into scsi_priv.h.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
