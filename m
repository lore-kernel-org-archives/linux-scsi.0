From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 5/8] libfc: Differentiate echange timer cancellation
 debug statements
Date: Tue, 9 Jul 2013 15:54:13 -0400
Message-ID: <20130709195413.GD955@hmsreliant.think-freely.org>
References: <20130709194705.10724.64013.stgit@fritz>
 <20130709194731.10724.49186.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43664 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3GITyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 15:54:17 -0400
Content-Disposition: inline
In-Reply-To: <20130709194731.10724.49186.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Jack Morgan <jack.morgan@intel.com>

On Tue, Jul 09, 2013 at 12:47:31PM -0700, Robert Love wrote:
> There are two debug statements with the same output string regarding
> echange timer cancellation. This patch simply changes the output of
> one string so that they can be differentiated.
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Tested-by: Jack Morgan <jack.morgan@intel.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  drivers/scsi/libfc/fc_exch.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index e98ea6a..5879929 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -1567,7 +1567,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
>  		    fc_exch_rctl_name(fh->fh_r_ctl));
>  
>  	if (cancel_delayed_work_sync(&ep->timeout_work)) {
> -		FC_EXCH_DBG(ep, "Exchange timer canceled\n");
> +		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
>  		fc_exch_release(ep);	/* release from pending timer hold */
>  	}
>  
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
