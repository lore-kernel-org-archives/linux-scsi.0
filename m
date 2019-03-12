From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] scsi: qla2xxx: Fix a small typo in qla_bsg.c
Date: Tue, 12 Mar 2019 13:06:09 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1903121305220.4097@hadrien>
References: <20190312115313.GA12695@machine1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190312115313.GA12695@machine1>
Sender: linux-kernel-owner@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: kernel-janitors@vger.kernel.org, qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Tue, 12 Mar 2019, Milan P. Gandhi wrote:

> This patch fixes a minor formatting issue with comment section and a
> typo for 'iiDMA' cmd in drivers/scsi/qla2xxx/qla_bsg.c

This seems to be two completely unrelated changes.  The subject line
promises only one change, and indeed only one change per patch would have
been better.  You should make a series.

julia

>
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 17d42658ad9a..2353be988907 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1,4 +1,4 @@
> -	/*
> +/*
>   * QLogic Fibre Channel HBA Driver
>   * Copyright (c)  2003-2014 QLogic Corporation
>   *
> @@ -1354,7 +1354,7 @@ qla24xx_iidma(struct bsg_job *bsg_job)
>
>  	if (rval) {
>  		ql_log(ql_log_warn, vha, 0x704c,
> -		    "iIDMA cmd failed for %8phN -- "
> +		    "iiDMA cmd failed for %8phN -- "
>  		    "%04x %x %04x %04x.\n", fcport->port_name,
>  		    rval, fcport->fp_speed, mb[0], mb[1]);
>  		rval = (DID_ERROR << 16);
>
