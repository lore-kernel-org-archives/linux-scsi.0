From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH 1/3] scsi: qedf: Fix a return value in case of error in
 'qedf_alloc_global_queues'
Date: Sun, 11 Jun 2017 10:33:11 +0200
Message-ID: <593D0047.1040306@bfs.de>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr> <7674c3a305022d1e30b7e7b744b673713fd50117.1497160148.git.christophe.jaillet@wanadoo.fr>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:12435 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdFKIdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 11 Jun 2017 04:33:17 -0400
In-Reply-To: <7674c3a305022d1e30b7e7b744b673713fd50117.1497160148.git.christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 11.06.2017 08:16, schrieb Christophe JAILLET:
> We should return -ENOMEM in case of memory allocation error, as done
> elsewhere in this function.
> 
> Fixes: 61d8658b4a435 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/qedf/qedf_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index aab3e2bd26a0..52a27100ca6d 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2673,6 +2673,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
>  		if (!qedf->global_queues[i]) {
>  			QEDF_WARN(&(qedf->dbg_ctx), "Unable to allocation "
>  				   "global queue %d.\n", i);
> +			status = -ENOMEM;
>  			goto mem_alloc_failure;
>  		}
>  

I am not native english but the error msg sounds strange ...

re,
 wh
