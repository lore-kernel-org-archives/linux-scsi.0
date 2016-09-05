From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [SCSI] bnx2fc: mark symbols static where possible
Date: Mon, 05 Sep 2016 13:17:23 +0200
Message-ID: <5444175.V8HzkfLa1x@wuerfel>
References: <1472971941-4882-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472971941-4882-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

On Sunday, September 4, 2016 2:52:21 PM CEST Baoyou Xie wrote:
> We get a few warnings when building kernel with W=1:
> drivers/scsi/bnx2fc/bnx2fc_els.c:257:6: warning: no previous prototype for 'bnx2fc_srr_compl' [-Wmissing-prototypes]
> drivers/scsi/bnx2fc/bnx2fc_els.c:367:6: warning: no previous prototype for 'bnx2fc_rec_compl' [-Wmissing-prototypes]
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:628:5: warning: no previous prototype for 'bnx2fc_percpu_io_thread' [-Wmissing-prototypes]
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1413:26: warning: no previous prototype for 'bnx2fc_interface_create' [-Wmissing-prototypes]
> drivers/scsi/bnx2fc/bnx2fc_hwi.c:997:21: warning: no previous prototype for 'bnx2fc_alloc_work' [-Wmissing-prototypes]
> drivers/scsi/bnx2fc/bnx2fc_io.c:1082:5: warning: no previous prototype for 'bnx2fc_abts_cleanup' [-Wmissing-prototypes]
> ....
> 
> In fact, these functions are only used in the file in which they are
> declared and don't need a declaration, but can be made static.
> so this patch marks these functions with 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
