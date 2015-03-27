From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 6/6] ipr: Driver version 2.6.1
Date: Fri, 27 Mar 2015 12:50:57 -0400
Message-ID: <20150327125057.Horde.zThkUhny5rrrfDfjzc4uuA6@ltc.linux.ibm.com>
References: <201503261624.t2QGO0AY014263@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:44444 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbbC0QvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 12:51:02 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 27 Mar 2015 12:51:01 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 94B4138C8026
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 12:50:59 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2RGox6C28901534
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 16:50:59 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2RGowwl022883
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 12:50:58 -0400
In-Reply-To: <201503261624.t2QGO0AY014263@d01av01.pok.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> Bump driver version.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h
> --- linux/drivers/scsi/ipr.h~ipr_version_2_6_1	2015-03-12  
> 16:27:14.235168394 -0500
> +++ linux-bjking1/drivers/scsi/ipr.h	2015-03-12 16:27:38.294920049 -0500
> @@ -39,8 +39,8 @@
>  /*
>   * Literals
>   */
> -#define IPR_DRIVER_VERSION "2.6.0"
> -#define IPR_DRIVER_DATE "(November 16, 2012)"
> +#define IPR_DRIVER_VERSION "2.6.1"
> +#define IPR_DRIVER_DATE "(March 12, 2015)"
>
>  /*
>   * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
> _


