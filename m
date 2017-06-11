From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH 1/2] scsi: qedi: Fix a return value in case of error in
 'qedi_alloc_global_queues'
Date: Sun, 11 Jun 2017 10:34:47 +0200
Message-ID: <593D00A7.1090507@bfs.de>
References: <cover.1497162751.git.christophe.jaillet@wanadoo.fr> <aafc9e362592524150d11f61dc7ab0b49e75f698.1497162751.git.christophe.jaillet@wanadoo.fr>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:36362 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdFKIeu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 11 Jun 2017 04:34:50 -0400
In-Reply-To: <aafc9e362592524150d11f61dc7ab0b49e75f698.1497162751.git.christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 11.06.2017 08:40, schrieb Christophe JAILLET:
> We should return -ENOMEM in case of memory allocation error, as done
> elsewhere in this function.
> 
> Fixes: ace7f46ba5fde ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/qedi/qedi_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index f46880315ba8..c81e494a9067 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1319,6 +1319,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
>  		if (!qedi->global_queues[i]) {
>  			QEDI_ERR(&qedi->dbg_ctx,
>  				 "Unable to allocation global queue %d.\n", i);
> +			status = -ENOMEM;
>  			goto mem_alloc_failure;
>  		}
>  

copy of  "[PATCH 1/3] scsi: qedf: Fix a return value in case ..." ?

same strange error message
re,
 wh
