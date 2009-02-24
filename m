From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 (resend) ] ipr: Expose debug and fastfail parameters
Date: Tue, 24 Feb 2009 14:23:44 -0600
Message-ID: <49A45750.7080606@linux.vnet.ibm.com>
References: <20090130162631.970634030@linux.vnet.ibm.com> <49A44C20.1000702@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50638 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584AbZBXUZl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 15:25:41 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n1OKNJ60005596
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2009 15:23:19 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1OKPd9R198556
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2009 15:25:39 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1OKPdia025003
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2009 15:25:39 -0500
In-Reply-To: <49A44C20.1000702@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

Acked by: Brian King <brking@linux.vnet.ibm.com>

Wayne Boyer wrote:
> Resending this patch that was originally sent on 1/30.
> 
> Brian, the driver version number was bumped with the MSI changes.  So,
> there's no need to bump it here.
> 
> Wayne
> 
> ---
> 
> Expose the debug and fastfail parameters to /sys/module/ipr/parameters such
> that they can be enabled/disabled at run time.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/scsi/ipr.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-30 08:14:51.000000000 -0800
> +++ linux-2.6/drivers/scsi/ipr.c	2009-01-30 08:14:41.000000000 -0800
> @@ -152,13 +152,13 @@
>  MODULE_PARM_DESC(log_level, "Set to 0 - 4 for increasing verbosity of device driver");
>  module_param_named(testmode, ipr_testmode, int, 0);
>  MODULE_PARM_DESC(testmode, "DANGEROUS!!! Allows unsupported configurations");
> -module_param_named(fastfail, ipr_fastfail, int, 0);
> +module_param_named(fastfail, ipr_fastfail, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(fastfail, "Reduce timeouts and retries");
>  module_param_named(transop_timeout, ipr_transop_timeout, int, 0);
>  MODULE_PARM_DESC(transop_timeout, "Time in seconds to wait for adapter to come operational (default: 300)");
>  module_param_named(enable_cache, ipr_enable_cache, int, 0);
>  MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
> -module_param_named(debug, ipr_debug, int, 0);
> +module_param_named(debug, ipr_debug, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Enable device driver debugging logging. Set to 1 to enable. (default: 0)");
>  module_param_named(dual_ioa_raid, ipr_dual_ioa_raid, int, 0);
>  MODULE_PARM_DESC(dual_ioa_raid, "Enable dual adapter RAID support. Set to 1 to enable. (default: 1)");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


