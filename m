From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v5 PATCH 1/4] bnx2fc: Header files
Date: Wed, 02 Feb 2011 02:03:48 -0600
Message-ID: <4D490FE4.5080307@cs.wisc.edu>
References: <1296266426.268.50.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57963 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1BBIEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 03:04:06 -0500
In-Reply-To: <1296266426.268.50.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, devel@open-fcoe.org, mchan@broadcom.com

On 01/28/2011 08:00 PM, Bhanu Gollapudi wrote:
> +
> +#define BNX2FC_IO_DBG(io_req, fmt, arg...)				\
> +	do {								\
> +		if (!io_req || !io_req->port || !io_req->port->lport ||	\
> +		    !io_req->port->lport->host)				\
> +			BNX2FC_CHK_LOGGING(LOG_IO,			\
> +			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
> +		else							\
> +			BNX2FC_CHK_LOGGING(LOG_IO,			\
> +			   printk(KERN_ALERT PFX "host%u: xid:0x%x " fmt,\
> +				  (io_req)->port->lport->host->host_no,	\
> +				  (io_req)->xid, ##arg));		\

For host logging we have shost_printk().
