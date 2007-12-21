From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
Date: Fri, 21 Dec 2007 14:30:28 +0100
Message-ID: <20071221133027.GA11495@alpha.franken.de>
References: <20071221023011.4C4BADDDFA@ozlabs.org> <20071221103326.7ce1bc4f@the-village.bc.nu> <20071221131640.GN29690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:58273 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXLUNo5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 08:44:57 -0500
Content-Disposition: inline
In-Reply-To: <20071221131640.GN29690@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

On Fri, Dec 21, 2007 at 06:16:41AM -0700, Matthew Wilcox wrote:
> On Fri, Dec 21, 2007 at 10:33:26AM +0000, Alan Cox wrote:
> > On Fri, 21 Dec 2007 13:30:08 +1100
> > Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > The sense buffer ins scsi_cmnd can nowadays be DMA'ed into directly
> > > by some low level drivers (that typically happens with USB mass
> > > storage).
> > 
> > Should that not be fixed in USB storage by using pci_alloc_coherent on the
> > PCI device of the hub not peeing directly into kernel space ?
> 
> That's what I said, but Ben seems fixated on this particular fix.

there are SCSI host drivers, which also DMA to the sense buffer like
sgiwd93.c for example.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
