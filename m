From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] allow non-modular mptctl
Date: Tue, 7 Sep 2004 12:00:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704F6371F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60843 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268440AbUIGQBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 12:01:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

This patch is fine. Please apply.

On Monday, September 06, 2004 4:53 AM, Christoph Hellwig wrote:
> 
> There's no reason to keep people from building it into their
> kernels statically.
> 
> 
> --- 1.7/drivers/message/fusion/Kconfig	2004-07-13 
> 23:55:06 +02:00
> +++ edited/drivers/message/fusion/Kconfig	2004-09-06 
> 12:27:28 +02:00
> @@ -29,7 +29,7 @@
>  
>  config FUSION_CTL
>  	tristate "Fusion MPT misc device (ioctl) driver"
> -	depends on MODULES && FUSION && m
> +	depends on FUSION
>  	---help---
>  	  The Fusion MPT misc device driver provides specialized control
>  	  of MPT adapters via system ioctl calls.  Use of ioctl calls to
> 
