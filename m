From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptscsih: MODULE_PARM() -> module_param()
Date: Tue, 5 Apr 2005 14:30:21 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C01DBBC2C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52374 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262086AbVDEUar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2005 16:30:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Magnus Damm <damm@opensource.se>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: mpt_linux_developer@lsil.com

Ok fine - This fix is already there in the series of patches
I provided a week ago for splitting the mpt fusion drivers
into seperate bus type drivers.

James any word on whether those series of patches will get
approved?

In addition, Steve Ralston is no longer working in this group.
No need to copy him on this.

Eric Moore
LSI Logic.


On Tuesday, April 05, 2005 1:18 PM,  Magnus Damm wrote:
> 
> Convert obsolete MODULE_PARM() to module_param(). This also 
> fixes "mpt_factor"
> that currently is a short parameter ("h") but the actual 
> variable is an int.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> --- linux-2.6.12-rc2/drivers/message/fusion/mptscsih.c	
> 2005-04-05 16:59:53.000000000 +0200
> +++ 
> linux-2.6.12-rc2-autoparam/drivers/message/fusion/mptscsih.c	
> 2005-04-05 20:28:11.459725880 +0200
> @@ -98,23 +98,23 @@
>  
>  /* Command line args */
>  static int mpt_dv = MPTSCSIH_DOMAIN_VALIDATION;
> -MODULE_PARM(mpt_dv, "i");
> +module_param(mpt_dv, int, 0);
>  MODULE_PARM_DESC(mpt_dv, " DV Algorithm: enhanced=1, basic=0 
> (default=MPTSCSIH_DOMAIN_VALIDATION=1)");
>  
>  static int mpt_width = MPTSCSIH_MAX_WIDTH;
> -MODULE_PARM(mpt_width, "i");
> +module_param(mpt_width, int, 0);
>  MODULE_PARM_DESC(mpt_width, " Max Bus Width: wide=1, 
> narrow=0 (default=MPTSCSIH_MAX_WIDTH=1)");
>  
>  static int mpt_factor = MPTSCSIH_MIN_SYNC;
> -MODULE_PARM(mpt_factor, "h");
> +module_param(mpt_factor, int, 0);
>  MODULE_PARM_DESC(mpt_factor, " Min Sync Factor 
> (default=MPTSCSIH_MIN_SYNC=0x08)");
>  
>  static int mpt_saf_te = MPTSCSIH_SAF_TE;
> -MODULE_PARM(mpt_saf_te, "i");
> +module_param(mpt_saf_te, int, 0);
>  MODULE_PARM_DESC(mpt_saf_te, " Force enabling SEP Processor: 
> enable=1  (default=MPTSCSIH_SAF_TE=0)");
>  
>  static int mpt_pq_filter = 0;
> -MODULE_PARM(mpt_pq_filter, "i");
> +module_param(mpt_pq_filter, int, 0);
>  MODULE_PARM_DESC(mpt_pq_filter, " Enable peripheral 
> qualifier filter: enable=1  (default=0)");
>  
>  
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=-=-=-=-=*/
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
