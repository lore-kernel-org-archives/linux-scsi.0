From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Rename ipr's state scsi host attribute to
	prevent collisions
Date: Mon, 28 Apr 2008 15:47:49 -0700
Message-ID: <1209422869.23575.24.camel@badari-desktop>
References: <12094221802009-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36516 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967397AbYD1Wrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 18:47:43 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3SMlg54006191
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 18:47:42 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3SMlghu218254
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 16:47:42 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3SMlfkI007227
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2008 16:47:41 -0600
In-Reply-To: <12094221802009-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, wayneb@linux.vnet.ibm.com, pbadari@linux.vnet.ibm.com

On Mon, 2008-04-28 at 17:36 -0500, Brian King wrote:
> Due to recent SCSI core changes which add a scsi host attribute
> named "state", this now collides with an ipr driver scsi host attribute
> with the same name, preventing ipr from loading. Rename the ipr driver
> attribute to be more specific.
> 
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6-bjking1/drivers/scsi/ipr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/ipr.c~ipr_host_state_rename drivers/scsi/ipr.c
> --- linux-2.6/drivers/scsi/ipr.c~ipr_host_state_rename	2008-04-28 17:30:54.000000000 -0500
> +++ linux-2.6-bjking1/drivers/scsi/ipr.c	2008-04-28 17:31:21.000000000 -0500
> @@ -2791,7 +2791,7 @@ static ssize_t ipr_store_adapter_state(s
> 
>  static struct device_attribute ipr_ioa_state_attr = {
>  	.attr = {
> -		.name =		"state",
> +		.name =		"online_state",
>  		.mode =		S_IRUGO | S_IWUSR,
>  	},
>  	.show = ipr_show_adapter_state,
> _

With this patch, I am able to boot 2.6.25-git12 on my ppc64 box.

Thanks,
Badari

