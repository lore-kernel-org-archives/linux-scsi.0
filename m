From: scott.ashcroft@talk21.com
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Date: Thu, 22 Feb 2007 21:50:12 +0000
Message-ID: <45DE1014.8060309@talk21.com>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userbg049.dsl.pipex.com ([62.190.246.49]:1169 "EHLO
	homer.intra.qzxyz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbXBVWSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 17:18:52 -0500
In-Reply-To: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com, hch@infradead.org

Mike Miller (OS Dev) wrote:
> +	if (return_code = IO_OK) {

Shouldn't that be ==

> +		printk(KERN_WARNING "Completed cache flush on controller %d\n", i);
> +	} else {
> +		printk(KERN_WARNING "Error Flushing cache on controller %d\n", i);
>  	}
>  	free_irq(hba[i]->intr[2], hba[i]);

