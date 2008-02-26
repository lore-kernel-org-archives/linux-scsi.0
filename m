From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Tue, 26 Feb 2008 04:44:02 +0100
Message-ID: <20080226034402.GD21577@one.firstfloor.org>
References: <200802251235.889863872@firstfloor.org> <20080224233516.0657F1B4183@basil.firstfloor.org> <20080225214746.GA11382@parisc-linux.org> <20080225224035.GB21577@one.firstfloor.org> <20080225225022.GD20273@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:45438 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYBZDnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 22:43:25 -0500
Content-Disposition: inline
In-Reply-To: <20080225225022.GD20273@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, Feb 25, 2008 at 03:50:22PM -0700, Matthew Wilcox wrote:
> On Mon, Feb 25, 2008 at 11:40:35PM +0100, Andi Kleen wrote:
> > > (I must have fixed it somehow because it works on parisc, which is most
> > > unforgiving of drivers which do DMA without the DMA API).
> > 
> > At least on x86 the DMA API cannot do ISA bouncing.
> 
> You're saying that if I set a 24-bit DMA mask, and then do a
> pci_alloc_coherent(), x86 might hand me back something that's not
> accessible?  That would be just broken.

No pci_alloc_coherent works, but pci_map_* will not.

-Andi
