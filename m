From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: unchecked_isa_dma and BusLogic SCSI controller
Date: Thu, 2 Nov 2006 13:04:12 +0000 (GMT)
Message-ID: <Pine.LNX.4.64N.0611021302340.7700@blysk.ds.pg.gda.pl>
References: <20061101235330.GA30843@srv.junsun.net>
 <20061101173358.7b027d13.randy.dunlap@oracle.com> <20061102124128.GC31830@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:30212 "EHLO
	pollux.ds.pg.gda.pl") by vger.kernel.org with ESMTP
	id S1752553AbWKBNEU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Nov 2006 08:04:20 -0500
In-Reply-To: <20061102124128.GC31830@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jun Sun <jsun@junsun.net>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

On Thu, 2 Nov 2006, Matthew Wilcox wrote:

> > > It is hard for me to see why BusLogic controller would only do DMA
> > > in low 16MB.  Is there a fix for this?
> > 
> > Does anyone know that controller hardware and its limitations?
> 
> I don't, but:
> 
> 		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK ))
> 			continue;
> 
> So somebody thinks the device can do 32-bit addressing.  I would expect
> that setting unchecked_isa_dma is a historical mistake.  However, I
> don't have any cards of this type to test.

 It could be related to the non-PCI variations of the board.

  Maciej
