From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [3/22] Remove unchecked_isa_dma in advansys.c
Date: Mon, 25 Feb 2008 23:40:35 +0100
Message-ID: <20080225224035.GB21577@one.firstfloor.org>
References: <200802251235.889863872@firstfloor.org> <20080224233516.0657F1B4183@basil.firstfloor.org> <20080225214746.GA11382@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:38033 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbYBYWj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 17:39:58 -0500
Content-Disposition: inline
In-Reply-To: <20080225214746.GA11382@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, Feb 25, 2008 at 02:47:46PM -0700, Matthew Wilcox wrote:
> On Mon, Feb 25, 2008 at 12:35:16AM +0100, Andi Kleen wrote:
> > That patch is a little more complicated than the others. advansys
> > was the only ISA driver who actually passed ->cmnd to the firmware.
> > So I implemented a simple own bounce buffer scheme for this case.
> > Also did sense_buffer bouncing in the driver while I was at it;
> > which means it doesn't require the mid layer to do this anymore.
> 
> I have to say I really don't like this patch.  I'll look up my current

Why do you not like it? What would you do better?

> patch queue for this driver next week -- I think I fixed this differently.
> (I must have fixed it somehow because it works on parisc, which is most
> unforgiving of drivers which do DMA without the DMA API).

At least on x86 the DMA API cannot do ISA bouncing.

-Andi
