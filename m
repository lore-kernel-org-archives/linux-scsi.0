From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] mpt3sas: tidy up output slightly
Date: Tue, 29 Apr 2014 15:45:22 +0300
Message-ID: <20140429124522.GR4963@mwanda>
References: <20140328083901.GQ25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140328083901.GQ25192@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Nagalakshmi,

Welcome back from vacation.  Please Ack this patch because output is
still badly fromatted in linux-next.

regards,
dan carpenter

On Fri, Mar 28, 2014 at 11:39:01AM +0300, Dan Carpenter wrote:
> The indenting here for "pr_info("\n");" is not correct.  It's not part
> of the if condition.
> 
> Also using pr_info() would put extra characters in the middle of the
> line.  I suppose that people could complain that pr_cont() is racy but
> at least it's better than the original code.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 0cf4f70..aa0e042 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -585,9 +585,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
>  		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
>  		    "start" : "stop");
>  		if (event_data->DiscoveryStatus)
> -			pr_info("discovery_status(0x%08x)",
> +			pr_cont("discovery_status(0x%08x)",
>  			    le32_to_cpu(event_data->DiscoveryStatus));
> -			pr_info("\n");
> +		pr_cont("\n");
>  		return;
>  	}
>  	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
