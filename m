From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] dmx3191d: Coding style police
Date: Fri, 22 Jun 2007 14:58:46 +0100
Message-ID: <20070622145846.7da9bd4e@the-village.bc.nu>
References: <20070622142456.0dff942f@the-village.bc.nu>
	<20070622132623.GA22063@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51726 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752293AbXFVNw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 09:52:58 -0400
In-Reply-To: <20070622132623.GA22063@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Fri, 22 Jun 2007 07:26:23 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Jun 22, 2007 at 02:24:56PM +0100, Alan Cox wrote:
> > - out_free_irq:
> > +out_free_irq:
> 
> Which CodingStyle mandates that goto labels start in column 0?  It
> screws up diff -p to do this.

The style being the fact almost all of the kernel keeps the label in
column zero ? I'm not greatly fussed by the indent for goto labels, its
the other stuff like missing printk labels that actually matters. However
if your diff -p is buggy how about fixing your diff instead ?

Alan
