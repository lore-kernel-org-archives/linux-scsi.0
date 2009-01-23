From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: add message to error table
Date: Fri, 23 Jan 2009 12:39:32 -0600
Message-ID: <497A0EE4.4020904@linux.vnet.ibm.com>
References: <20090123165823.748742817@linux.vnet.ibm.com> <4979FBB1.8050103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45632 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZAWSkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 13:40:45 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0NIdPlW020238
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 11:39:25 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0NIejOI155240
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 11:40:45 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0NIeipB025743
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2009 11:40:45 -0700
In-Reply-To: <4979FBB1.8050103@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

Acked by: Brian King <brking@linux.vnet.ibm.com>

Wayne Boyer wrote:
> Adds a message to the error table for an error that wasn't previously handled.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/scsi/ipr.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-22 15:50:59.000000000 -0800
> +++ linux-2.6/drivers/scsi/ipr.c	2009-01-23 08:55:23.000000000 -0800
> @@ -354,6 +354,8 @@
>  	"9076: Configuration error, missing remote IOA"},
>  	{0x06679100, 0, IPR_DEFAULT_LOG_LEVEL,
>  	"4050: Enclosure does not support a required multipath function"},
> +	{0x06690000, 0, IPR_DEFAULT_LOG_LEVEL,
> +	"4070: Logically bad written to device"},
>  	{0x06690200, 0, IPR_DEFAULT_LOG_LEVEL,
>  	"9041: Array protection temporarily suspended"},
>  	{0x06698200, 0, IPR_DEFAULT_LOG_LEVEL,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


