From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/4] stex: minor cleanup and version update
Date: Thu, 10 May 2007 17:04:42 -0400
Message-ID: <464388EA.8030702@garzik.org>
References: <NONAMEBh4Ghj7cki6Gc00001144@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60353 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762406AbXEJVEo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2007 17:04:44 -0400
In-Reply-To: <NONAMEBh4Ghj7cki6Gc00001144@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> @@ -1196,7 +1206,7 @@ stex_probe(struct pci_dev *pdev, const s
>  		goto out_scsi_host_put;
>  	}
>  
> -	hba->mmio_base = ioremap(pci_resource_start(pdev, 0),
> +	hba->mmio_base = ioremap_nocache(pci_resource_start(pdev, 0),
>  		pci_resource_len(pdev, 0));
>  	if ( !hba->mmio_base) {


I would suggest using pci_iomap(), which would accomplish the same thing 
in a slightly more clean manner.

	Jeff


