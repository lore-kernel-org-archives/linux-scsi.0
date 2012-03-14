From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: [PATCH] mpt2sas: Fix hex/decimal typo in _base_sas_log_info()
Date: Thu, 15 Mar 2012 05:08:22 +1100
Message-ID: <20120314180822.GA29954@onthe.net.au>
References: <20120314035610.GA21520@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120314035610.GA21520@onthe.net.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, sathisha.nanjappa@hp.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 14, 2012 at 02:56:10PM +1100, Chris Dunlop wrote:
> The log_info constant is supposed to be IOP_LOGINFO_CODE_TASK_TERMINATED
> (see drivers/message/fusion/lsi/mpi_log_sas.h) rather than the
> non-sensical 0x1CA86D0.

Oops, I see Sathisha Nanjappa has already submitted this fix:

http://article.gmane.org/gmane.linux.scsi/73446


> Signed-off-by: Chris Dunlop <chris@onthe.net.au>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index a78036f..224ed29 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -657,7 +657,7 @@ _base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
>  		return;
>  
>  	/* eat the loginfos associated with task aborts */
> -	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
> +	if (ioc->ignore_loginfos && (log_info == 0x30050000 || log_info ==
>  	    0x31140000 || log_info == 0x31130000))
>  		return;
>  
> -- 
> 1.7.0.4
> 
