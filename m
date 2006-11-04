From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sat, 4 Nov 2006 20:13:20 +0000
Message-ID: <20061104201320.GB32205@infradead.org>
References: <335122.2750.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20633 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965624AbWKDUNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 15:13:21 -0500
Content-Disposition: inline
In-Reply-To: <335122.2750.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> -		ct =  sdkp->RCD + 2*sdkp->WCE;
> -
> -		printk(KERN_NOTICE "SCSI device %s: drive cache: %s%s\n",
> -		       diskname, types[ct],
> -		       sdkp->DPOFUA ? " w/ FUA" : "");
> +		printk(KERN_NOTICE "SCSI device %s: "
> +		       "write cache: %s, read cache: %s, %s\n",
> +		       diskname,
> +		       sdkp->WCE ? "enabled" : "disabled",
> +		       sdkp->RCD ? "disabled" : "enabled",
> +		       sdkp->DPOFUA ? "supports DPO and FUA"
> +		       : "doesn't support DPO or FUA");

Looks good to me.
