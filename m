From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Mon, 25 Feb 2008 15:50:22 -0700
Message-ID: <20080225225022.GD20273@parisc-linux.org>
References: <200802251235.889863872@firstfloor.org> <20080224233516.0657F1B4183@basil.firstfloor.org> <20080225214746.GA11382@parisc-linux.org> <20080225224035.GB21577@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42351 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185AbYBYWuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 17:50:24 -0500
Content-Disposition: inline
In-Reply-To: <20080225224035.GB21577@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, Feb 25, 2008 at 11:40:35PM +0100, Andi Kleen wrote:
> > (I must have fixed it somehow because it works on parisc, which is most
> > unforgiving of drivers which do DMA without the DMA API).
> 
> At least on x86 the DMA API cannot do ISA bouncing.

You're saying that if I set a 24-bit DMA mask, and then do a
pci_alloc_coherent(), x86 might hand me back something that's not
accessible?  That would be just broken.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
