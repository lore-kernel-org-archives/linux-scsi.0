From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer
	in scsi_cmnd
Date: Sat, 22 Dec 2007 08:29:07 +1100
Message-ID: <1198272547.6737.18.camel@pasglop>
References: <20071221023011.4C4BADDDFA@ozlabs.org>
	 <20071221103326.7ce1bc4f@the-village.bc.nu>
	 <20071221131640.GN29690@parisc-linux.org>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55465 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbXLUV3n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 16:29:43 -0500
In-Reply-To: <20071221131640.GN29690@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org


On Fri, 2007-12-21 at 06:16 -0700, Matthew Wilcox wrote:
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

That means more understanding of the SCSI code than I have right now
and a _lot_ more time than I have right now. It's not only USB storage,
it's anything that does DMA and uses the generic error handling.

Ben.


