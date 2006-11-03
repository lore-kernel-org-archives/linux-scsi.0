From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] st.c : fix up log messages format
Date: Fri, 3 Nov 2006 06:32:17 -0700
Message-ID: <20061103133217.GC27140@parisc-linux.org>
References: <20061103092512.88130.qmail@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49571 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751676AbWKCNcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Nov 2006 08:32:18 -0500
Content-Disposition: inline
In-Reply-To: <20061103092512.88130.qmail@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Nov 03, 2006 at 01:25:12AM -0800, Luben Tuikov wrote:
>  	sdev_printk(KERN_WARNING, SDp,
> -		    "Attached scsi tape %s", tape_name(tpnt));
> -	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B)\n",
> -	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
> -	       queue_dma_alignment(SDp->request_queue) + 1);
> +		    "Attached scsi tape %s\n", tape_name(tpnt));
> +	sdev_printk(KERN_WARNING, SDp,
> +		    "%s: try direct i/o: %s (alignment %d bytes)\n",
> +		    tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
> +		    queue_dma_alignment(SDp->request_queue) + 1);
>  

I know you didn't change this ... but why are these KERN_WARNING?
Surely KERN_INFO is more appropriate here?
