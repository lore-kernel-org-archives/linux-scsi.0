From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: mpt sets 64bit consistent mask yet requires mapping in same 4 GB chunk?!?
Date: Thu, 19 Feb 2004 22:30:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220063030.GB530179@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF9453@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:8333 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S267773AbUBTGam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 01:30:42 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703EF9453@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Alex Williamson <alex.williamson@hp.com>, jbarnes@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Feb 19, 2004 at 12:18:07PM -0500, Moore, Eric Dean wrote:
> My comments <EDM> are embedded below.
> 
> > I don't think so, for two reasons.
> > 
> > The first is that we require 64 bit PCI addresses for all 
> > PCI-X devices.
> 
> <EDM> 
> I'm not sure what you mean? 
> For PCI-X devices - are you saying passing something other than
> 0xFFFFFFFFFFFFFFFF for the mask in pci_set_consistent_dma_mask()
> fails? 

Correct.  We require PCI-X devices to use the entire 64 address
bits.

jeremy
