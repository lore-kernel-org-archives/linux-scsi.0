From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Mon, 4 Aug 2008 16:20:35 -0600
Message-ID: <200808041620.35487.bjorn.helgaas@hp.com>
References: <1217786532.4179.24.camel@localhost.localdomain> <200808041443.20942.bjorn.helgaas@hp.com> <20080804213535.GM26461@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40257 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYHDWVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 18:21:36 -0400
In-Reply-To: <20080804213535.GM26461@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org

On Monday 04 August 2008 03:35:35 pm Matthew Wilcox wrote:
> On Mon, Aug 04, 2008 at 02:43:20PM -0600, Bjorn Helgaas wrote:
> > I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.
> 
> That's unfortunately different from lspci -nn:
> 
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile PM965/GM965/GL960
> Memory Controller Hub [8086:2a00] (rev 03)
> 
> Sorry, I should have reviewed your patches ;-(

I can change those.  I just copied what seemed to be the most
prevalent.  But lspci is harder to change, so we should probably
follow that.
