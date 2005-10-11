From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: support link error attributes
Date: Tue, 11 Oct 2005 11:00:00 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C046A718D@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46013 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751459AbVJKRAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2005 13:00:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Monday, September 19, 2005 2:01 PM, Christoph Hellwig wrote:

> +#endif
> +
> +
>  /*
>   * This is pretty ugly.  We will be able to seriously clean it up
>   * once the DV code in mptscsih goes away and we can 
> properly @@ -200,91 +295,76 @@
>  	.use_clustering			= ENABLE_CLUSTERING,
>  };
>  


Christoph:  I'm unable to apply this patch due to this
section of the patch above.   Can you resend patch versus
the 2.6.14-rc4 kernel stream.  That comment "this is pretty
ugly" isn't there in kernel tree.

Eric Moore 
