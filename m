From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] bnx2fc: mark symbols static where possible
Date: Fri, 09 Sep 2016 07:12:25 -0400
Message-ID: <yq18tv1gwdi.fsf@sermon.lab.mkp.net>
References: <1472971941-4882-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472971941-4882-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 4 Sep 2016 14:52:21 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get a few warnings when building kernel with W=1:
Baoyou> drivers/scsi/bnx2fc/bnx2fc_els.c:257:6: warning: no previous
Baoyou> prototype for 'bnx2fc_srr_compl' [-Wmissing-prototypes]
Baoyou> drivers/scsi/bnx2fc/bnx2fc_els.c:367:6: warning: no previous
Baoyou> prototype for 'bnx2fc_rec_compl' [-Wmissing-prototypes]
Baoyou> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:628:5: warning: no previous
Baoyou> prototype for 'bnx2fc_percpu_io_thread' [-Wmissing-prototypes]
Baoyou> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1413:26: warning: no previous
Baoyou> prototype for 'bnx2fc_interface_create' [-Wmissing-prototypes]
Baoyou> drivers/scsi/bnx2fc/bnx2fc_hwi.c:997:21: warning: no previous
Baoyou> prototype for 'bnx2fc_alloc_work' [-Wmissing-prototypes]
Baoyou> drivers/scsi/bnx2fc/bnx2fc_io.c:1082:5: warning: no previous
Baoyou> prototype for 'bnx2fc_abts_cleanup' [-Wmissing-prototypes] ....

Baoyou> In fact, these functions are only used in the file in which they
Baoyou> are declared and don't need a declaration, but can be made
Baoyou> static.  so this patch marks these functions with 'static'.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
