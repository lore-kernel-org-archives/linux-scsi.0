From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] [Update #2] suspending I/Os to a device
Date: Fri, 1 Oct 2004 09:02:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001160208.GA22903@beaverton.ibm.com>
References: <0B1E13B586976742A7599D71A6AC733C02F1EA@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:42137 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261405AbUJAQDn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 12:03:43 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1EA@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org, andmike@us.ibm.com, mort@wildopensource.com, andrew.vasquez@qlogic.com

On Fri, Oct 01, 2004 at 09:54:53AM -0400, James.Smart@Emulex.Com wrote:

> +/**
> + * fc_host_block - block all scsi devices managed by the calling host temporarily 
> + *		by putting each device in the SDEV_BLOCK state.
> + * @shost:	scsi host pointer that contains all scsi device siblings.
> + *
> + * scsi lld's with a FC transport call this routine to temporarily stop all
> + * scsi commands to all devices managed by this host.  Called 
> + * from interrupt or normal process context.
> + *
> + * Returns zero if successful or error if not
> + *
> + * Notes:
> + *	The timeout and timer types are extracted from the fc transport 
> + *	attributes from the caller's host pointer.  This routine assumes no
> + *	locks are held on entry.
> + **/
> +int
> +fc_host_block(struct Scsi_Host *shost)

What is the difference between these new fc_host_block/unblock and
the current scsi_block/unblock_requests?

-- Patrick Mansfield
