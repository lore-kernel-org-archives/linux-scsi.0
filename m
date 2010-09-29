From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Tue, 28 Sep 2010 17:42:14 -0700
Message-ID: <20100929004213.GA9978@us.ibm.com>
References: <4ca2688f17705a0195@agluck-desktop.sc.intel.com>
 <20100928225936.GA8993@us.ibm.com>
 <987664A83D2D224EAE907B061CE93D5301605546A7@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50058 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0I2AmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 20:42:16 -0400
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301605546A7@orsmsx505.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>

Luck, Tony [tony.luck@intel.com] wrote:
> > Let me know if this fixes the problem. Thank you very much.
> 
> No it doesn't :-(
> 
> I still end up with 0xffffffff from the *host_dev->dma_mask
> later in that function.
> 
> Just for two devices though ... stack traces lead back to
> usb_stor_scan_thread() for these two.

What is the USB host controller's PCI device and vendor IDs? I see
ehci-ps3.c  and ohci-ps3.c setting it to DMA_BIT_MASK(32). That may
present another bug???

I don't know USB much, but someone seems to be lying that they can't do DMA
beyond 4GB!

How much memory you have on the system? This probably doesn't matter but
good to know.

Thanks, Malahal.
