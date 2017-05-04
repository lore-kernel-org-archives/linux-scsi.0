From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: properly update arguments position in function
 call
Date: Thu, 4 May 2017 11:06:40 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1705041106140.1192@n6024mn968stm1.qlogic.org>
References: <20170503191754.GA590@embeddedgus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170503191754.GA590@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 3 May 2017, 3:17pm, Gustavo A. R. Silva wrote:

> Properly update the position of the arguments in function call.
> 
> Addresses-Coverity-ID: 1402010
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/scsi/qedf/qedf_els.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
> index 59f3e5c..107ed2b 100644
> --- a/drivers/scsi/qedf/qedf_els.c
> +++ b/drivers/scsi/qedf/qedf_els.c
> @@ -106,7 +106,7 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
>  	did = fcport->rdata->ids.port_id;
>  	sid = fcport->sid;
>  
> -	__fc_fill_fc_hdr(fc_hdr, FC_RCTL_ELS_REQ, sid, did,
> +	__fc_fill_fc_hdr(fc_hdr, FC_RCTL_ELS_REQ, did, sid,
>  			   FC_TYPE_ELS, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
>  			   FC_FC_SEQ_INIT, 0);
>  
> 

Thanks.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
