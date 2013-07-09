From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 4/8] libfc: Remove extra space in fc_exch_timer_cancel
 definition
Date: Tue, 9 Jul 2013 15:53:27 -0400
Message-ID: <20130709195327.GC955@hmsreliant.think-freely.org>
References: <20130709194705.10724.64013.stgit@fritz>
 <20130709194726.10724.90924.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43641 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3GITxb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 15:53:31 -0400
Content-Disposition: inline
In-Reply-To: <20130709194726.10724.90924.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Jack Morgan <jack.morgan@intel.com>

On Tue, Jul 09, 2013 at 12:47:26PM -0700, Robert Love wrote:
> Simply remove an extra space that violates coding style.
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Tested-by: Jack Morgan <jack.morgan@intel.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  drivers/scsi/libfc/fc_exch.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index 8b928c6..e98ea6a 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -337,7 +337,7 @@ static void fc_exch_release(struct fc_exch *ep)
>   * fc_exch_timer_cancel() - cancel exch timer
>   * @ep:		The exchange whose timer to be canceled
>   */
> -static inline  void fc_exch_timer_cancel(struct fc_exch *ep)
> +static inline void fc_exch_timer_cancel(struct fc_exch *ep)
>  {
>  	if (cancel_delayed_work(&ep->timeout_work)) {
>  		FC_EXCH_DBG(ep, "Exchange timer canceled\n");
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

