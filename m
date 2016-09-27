From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH] scsi: be2iscsi: mark symbols static where possible
Date: Tue, 27 Sep 2016 09:49:10 +0530
Message-ID: <8ab58b4a55f6cc0213156d536c6b15c9@mail.gmail.com>
References: <1474891259-20031-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33909 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbcI0ETN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 00:19:13 -0400
Received: by mail-vk0-f50.google.com with SMTP id v205so2080914vke.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 21:19:12 -0700 (PDT)
In-Reply-To: <1474891259-20031-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn, han.fei@zte.com.cn, tang.qiang007@zte.com.cn

> -----Original Message-----
> From: Baoyou Xie [mailto:baoyou.xie@linaro.org]
> Sent: Monday, September 26, 2016 5:31 PM
> To: subbu.seetharaman@broadcom.com; ketan.mukadam@broadcom.com;
> jitendra.bhivare@broadcom.com; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
arnd@arndb.de;
> baoyou.xie@linaro.org; xie.baoyou@zte.com.cn; han.fei@zte.com.cn;
> tang.qiang007@zte.com.cn
> Subject: [PATCH] scsi: be2iscsi: mark symbols static where possible
>
> We get 6 warnings when building kernel with W=1:
> drivers/scsi/be2iscsi/be_main.c:65:1: warning: no previous prototype for
> 'beiscsi_log_enable_disp' [-Wmissing-prototypes]
> drivers/scsi/be2iscsi/be_main.c:78:1: warning: no previous prototype for
> 'beiscsi_log_enable_change' [-Wmissing-prototypes]
> drivers/scsi/be2iscsi/be_main.c:97:1: warning: no previous prototype for
> 'beiscsi_log_enable_store' [-Wmissing-prototypes]
> drivers/scsi/be2iscsi/be_main.c:116:1: warning: no previous prototype
for
> 'beiscsi_log_enable_init' [-Wmissing-prototypes]
> drivers/scsi/be2iscsi/be_main.c:4587:5: warning: no previous prototype
for
> 'beiscsi_iotask_v2' [-Wmissing-prototypes]
> drivers/scsi/be2iscsi/be_main.c:4976:6: warning: no previous prototype
for
> 'beiscsi_hba_attrs_init' [-Wmissing-prototypes]
>
> In fact, these functions are only used in the file in which they are
declared and
> don't need a declaration, but can be made static.
>
> So this patch marks these functions with 'static'.
>
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> ---
[JB] Looks good.
Reviewed by: Jitendra Bhivare <Jitendra.bhivare@broadcom>
