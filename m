From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 4/6] ipr: Re-enable write same
Date: Fri, 27 Mar 2015 12:50:30 -0400
Message-ID: <20150327125030.Horde.hkqX8HThFv4xyHi3hVkpVA2@ltc.linux.ibm.com>
References: <201503261623.t2QGNvgx032081@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58193 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbbC0Que (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 12:50:34 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 27 Mar 2015 12:50:33 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id B0DD1C9003E
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 12:41:40 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2RGoUHK24641562
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 16:50:30 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2RGoUOr005045
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 12:50:30 -0400
In-Reply-To: <201503261623.t2QGNvgx032081@d03av01.boulder.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> Re-enable write same support for ipr RAID adapters.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff -puN drivers/scsi/ipr.c~ipr_write_same drivers/scsi/ipr.c
> --- linux/drivers/scsi/ipr.c~ipr_write_same	2015-03-12  
> 16:26:04.036892977 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2015-03-12 16:26:04.044892894 -0500
> @@ -6404,7 +6404,6 @@ static struct scsi_host_template driver_
>  	.shost_attrs = ipr_ioa_attrs,
>  	.sdev_attrs = ipr_dev_attrs,
>  	.proc_name = IPR_NAME,
> -	.no_write_same = 1,
>  	.use_blk_tags = 1,
>  };
>
> _


