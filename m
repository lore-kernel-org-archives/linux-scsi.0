From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: be2iscsi: mark symbols static where possible
Date: Wed, 28 Sep 2016 01:07:28 -0400
Message-ID: <yq1vaxgy5m7.fsf@sermon.lab.mkp.net>
References: <1474891259-20031-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17093 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbcI1FHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 01:07:43 -0400
In-Reply-To: <1474891259-20031-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Mon, 26 Sep 2016 20:00:59 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn, han.fei@zte.com.cn, tang.qiang007@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 6 warnings when building kernel with W=1:
Baoyou> drivers/scsi/be2iscsi/be_main.c:65:1: warning: no previous
Baoyou> prototype for 'beiscsi_log_enable_disp' [-Wmissing-prototypes]
Baoyou> drivers/scsi/be2iscsi/be_main.c:78:1: warning: no previous
Baoyou> prototype for 'beiscsi_log_enable_change' [-Wmissing-prototypes]
Baoyou> drivers/scsi/be2iscsi/be_main.c:97:1: warning: no previous
Baoyou> prototype for 'beiscsi_log_enable_store' [-Wmissing-prototypes]
Baoyou> drivers/scsi/be2iscsi/be_main.c:116:1: warning: no previous
Baoyou> prototype for 'beiscsi_log_enable_init' [-Wmissing-prototypes]
Baoyou> drivers/scsi/be2iscsi/be_main.c:4587:5: warning: no previous
Baoyou> prototype for 'beiscsi_iotask_v2' [-Wmissing-prototypes]
Baoyou> drivers/scsi/be2iscsi/be_main.c:4976:6: warning: no previous
Baoyou> prototype for 'beiscsi_hba_attrs_init' [-Wmissing-prototypes]

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
