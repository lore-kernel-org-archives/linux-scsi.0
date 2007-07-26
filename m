From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/21] advansys: Clean up proc_info implementation
Date: Thu, 26 Jul 2007 14:51:51 -0400
Message-ID: <46A8ED47.6030909@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <1185470577359-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50553 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602AbXGZSvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 14:51:52 -0400
In-Reply-To: <1185470577359-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> @@ -4653,7 +4641,7 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
>  }
>  
>  static int __init advansys_detect(struct scsi_host_template *tpnt);
> -static int advansys_release(struct Scsi_Host *shp);
> +static int advansys_release(struct Scsi_Host *shost);
>  
>  static struct scsi_host_template driver_template = {
>  	.proc_name = "advansys",

Not a _bug_ per se, but the above useless patch chunk seems to have 
leaked into this patch.

	Jeff


