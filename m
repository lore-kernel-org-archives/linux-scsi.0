From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: clean function declarations in megaraid_sas_base.c up
Date: Mon, 19 Sep 2016 12:00:21 -0400
Message-ID: <yq11t0fanhm.fsf@sermon.lab.mkp.net>
References: <1474200479-32042-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474200479-32042-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 18 Sep 2016 20:07:59 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get a few warnings when building kernel with W=1:
Baoyou> drivers/scsi/megaraid/megaraid_sas_fusion.c:281:1: warning: no
Baoyou> previous prototype for 'megasas_free_cmds_fusion'
Baoyou> [-Wmissing-prototypes]
Baoyou> drivers/scsi/megaraid/megaraid_sas_fusion.c:714:1: warning: no
Baoyou> previous prototype for 'megasas_ioc_init_fusion'
Baoyou> [-Wmissing-prototypes] ....

Baoyou> In fact, these functions are declared in
Baoyou> drivers/scsi/megaraid/megaraid_sas_base.c, but should be
Baoyou> declared in a header file, thus can be recognized in other file.

Baoyou> So this patch adds the declarations into
Baoyou> drivers/scsi/megaraid/megaraid_sas_fusion.h.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
