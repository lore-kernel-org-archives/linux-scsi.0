From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
Date: Fri, 21 Dec 2007 06:16:41 -0700
Message-ID: <20071221131640.GN29690@parisc-linux.org>
References: <20071221023011.4C4BADDDFA@ozlabs.org> <20071221103326.7ce1bc4f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37112 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbXLUNQn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Dec 2007 08:16:43 -0500
Content-Disposition: inline
In-Reply-To: <20071221103326.7ce1bc4f@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

On Fri, Dec 21, 2007 at 10:33:26AM +0000, Alan Cox wrote:
> On Fri, 21 Dec 2007 13:30:08 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > The sense buffer ins scsi_cmnd can nowadays be DMA'ed into directly
> > by some low level drivers (that typically happens with USB mass
> > storage).
> 
> Should that not be fixed in USB storage by using pci_alloc_coherent on the
> PCI device of the hub not peeing directly into kernel space ?

That's what I said, but Ben seems fixated on this particular fix.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
