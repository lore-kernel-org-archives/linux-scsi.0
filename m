From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/2] bfa: Fix indentation
Date: Thu, 03 Sep 2015 10:31:48 -0400
Message-ID: <1441290708.23183.322.camel@localhost.localdomain>
References: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
	 <1439462512-1911-2-git-send-email-anil.gurumurthy@qlogic.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbbICObu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2015 10:31:50 -0400
In-Reply-To: <1439462512-1911-2-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com

On Thu, 2015-08-13 at 06:41 -0400, anil.gurumurthy@qlogic.com wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> 
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> Tested-by : Sudarasana Kalluru <sudarsana.kalluru@qlogic.com>
> ---
>  drivers/scsi/bfa/bfa_ioc.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
> index 315d6d6..4e71044 100644
> --- a/drivers/scsi/bfa/bfa_ioc.c
> +++ b/drivers/scsi/bfa/bfa_ioc.c
> @@ -3665,19 +3665,19 @@ bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
>  		if (sfp->state_query_cbfn)
>  			sfp->state_query_cbfn(sfp->state_query_cbarg,
>  					sfp->status);
> -			sfp->media = NULL;
> -		}
> +		sfp->media = NULL;
> +	}
>  
> -		if (sfp->portspeed) {
> -			sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
> -			if (sfp->state_query_cbfn)
> -				sfp->state_query_cbfn(sfp->state_query_cbarg,
> -						sfp->status);
> -				sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
> -		}
> +	if (sfp->portspeed) {
> +		sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
> +		if (sfp->state_query_cbfn)
> +			sfp->state_query_cbfn(sfp->state_query_cbarg,
> +					sfp->status);
> +		sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
> +	}
>  
> -		sfp->state_query_lock = 0;
> -		sfp->state_query_cbfn = NULL;
> +	sfp->state_query_lock = 0;
> +	sfp->state_query_cbfn = NULL;
>  }
>  
>  /*

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


