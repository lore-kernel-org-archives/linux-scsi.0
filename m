From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH][V2] scsi: qedf: fix spelling mistake: "offlading" ->
 "offloading"
Date: Wed, 5 Jul 2017 11:41:22 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1707051140560.1058@n7013co5221kk4.qlogic.org>
References: <20170703192139.24314-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170703192139.24314-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 3 Jul 2017, 3:21pm, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in QEDF_INFO message and 
> remove duplicated "since" (thanks to Tyrel Datwyler for spotting
> the latter issue).
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index b58bba4604e8..7786c97e033f 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1227,7 +1227,7 @@ static void qedf_rport_event_handler(struct fc_lport *lport,
>  
>  		if (rdata->spp_type != FC_TYPE_FCP) {
>  			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
> -			    "Not offlading since since spp type isn't FCP\n");
> +			    "Not offloading since spp type isn't FCP\n");
>  			break;
>  		}
>  		if (!(rdata->ids.roles & FC_RPORT_ROLE_FCP_TARGET)) {
> 

Thanks.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
